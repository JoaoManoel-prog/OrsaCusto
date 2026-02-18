#!/usr/bin/env node
/**
 * OrsaCusto - Main Entry Point
 * 
 * AI-powered task planning and cost management tool
 */

const PlanAgent = require('./planner');

console.log(`
╔═══════════════════════════════════════╗
║       🐋 OrsaCusto v0.1.0             ║
║   Task Planning & Cost Management     ║
╚═══════════════════════════════════════╝
`);

// Create a plan agent instance
const agent = new PlanAgent();

// Example usage
const taskDescription = process.argv.slice(2).join(' ') || 'Plan my task';
agent.planTask(taskDescription);

console.log(`\n📚 Usage:`);
console.log(`   npm start [task description]`);
console.log(`   npm run plan [task description]`);
console.log(`\n📖 Example:`);
console.log(`   npm start "Build a web application for inventory management"`);
console.log(`\n`);
