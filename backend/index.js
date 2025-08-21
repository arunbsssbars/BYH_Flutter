const express = require('express');
const http = require('http');
const { nanoid } = require('nanoid');
const cors = require('cors');
const socketio = require('socket.io');

const app = express();
app.use(cors());
app.use(express.json());

const server = http.createServer(app);
const io = socketio(server, { cors: { origin: '*' } });

let products = [
  { id: 'p1', vendorId: 'v1', name: 'Cement 50kg', description: 'Portland Cement', price: 500, imageUrl: 'https://brickcart.in/wp-content/uploads/2021/11/clay-brick-1.jpg' },
  { id: 'p2', vendorId: 'v1', name: 'Bricks (100 pcs)', description: 'Good quality', price: 200, imageUrl: 'https://brickcart.in/wp-content/uploads/2021/11/clay-brick-1.jpg' },
];
let orders = [];

io.on('connection', (socket) => {
  console.log('Socket connected:', socket.id);
  socket.on('join-vendor', (vendorId) => { socket.join(`vendor_${vendorId}`); });
  socket.on('join-order', (orderId) => { socket.join(`order_${orderId}`); });
  socket.on('disconnect', () => { console.log('Socket disconnected:', socket.id); });
});

app.get('/products', (req, res) => {
  const { vendorId } = req.query;
  if (vendorId) return res.json(products.filter(p => p.vendorId === vendorId));
  return res.json(products);
});

app.post('/products', (req, res) => {
  const { vendorId, name, description, price, imageUrl } = req.body;
  const p = { id: nanoid(), vendorId, name, description, price, imageUrl };
  products.push(p);
  io.to(`vendor_${vendorId}`).emit('product-created', p);
  io.emit('product-created', p);
  res.status(201).json(p);
});

app.put('/products/:id', (req, res) => {
  const { id } = req.params;
  const idx = products.findIndex(p => p.id === id);
  if (idx === -1) return res.status(404).json({ error: 'Not found' });
  products[idx] = { ...products[idx], ...req.body };
  io.to(`vendor_${products[idx].vendorId}`).emit('product-updated', products[idx]);
  io.emit('product-updated', products[idx]);
  res.json(products[idx]);
});

app.delete('/products/:id', (req, res) => {
  const { id } = req.params;
  const idx = products.findIndex(p => p.id === id);
  if (idx === -1) return res.status(404).json({ error: 'Not found' });
  const removed = products.splice(idx, 1)[0];
  io.to(`vendor_${removed.vendorId}`).emit('product-deleted', removed);
  io.emit('product-deleted', removed);
  res.json({ success: true });
});

app.post('/orders', (req, res) => {
  const { vendorId, customerName, items } = req.body;
  if (!vendorId || !items || items.length === 0) return res.status(400).json({ error: 'Invalid order' });
  const total = items.reduce((s, it) => s + (it.price * it.qty), 0);
  const order = { id: nanoid(), vendorId, customerName, items, total, status: 'Pending', createdAt: new Date().toISOString() };
  orders.push(order);
  io.to(`vendor_${vendorId}`).emit('new-order', order);
  io.to(`order_${order.id}`).emit('order-created', order);
  io.emit('new-order-global', order);
  res.status(201).json(order);
});

app.get('/orders', (req, res) => {
  const { vendorId } = req.query;
  if (vendorId) return res.json(orders.filter(o => o.vendorId === vendorId));
  return res.json(orders);
});

app.put('/orders/:id/status', (req, res) => {
  const { id } = req.params;
  const { status } = req.body;
  const order = orders.find(o => o.id === id);
  if (!order) return res.status(404).json({ error: 'Order not found' });
  order.status = status;
  order.updatedAt = new Date().toISOString();
  io.to(`vendor_${order.vendorId}`).emit('order-updated', order);
  io.to(`order_${order.id}`).emit('order-updated', order);
  io.emit('order-updated-global', order);
  res.json(order);
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => console.log(`Backend running on port ${PORT}`));


