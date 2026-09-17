const {Button, Stack, TextView, contentView} = require('tabris');

const stack = new Stack({layoutData: 'stretch', padding: 16, spacing: 12}).appendTo(contentView);

const current = new TextView({font: 'bold 24px', text: 'inCall: ?'}).appendTo(stack);

new Button({text: 'Check callDetection.inCall'})
  .onSelect(() => report(callDetection.inCall, 'button'))
  .appendTo(stack);

new TextView({text: 'Polled once per second; each change is logged below and to the console.'}).appendTo(stack);

const log = new TextView({layoutData: 'stretchX', font: '14px monospace'}).appendTo(stack);

let lastPolled = null;
setInterval(() => {
  const value = callDetection.inCall;
  if (value !== lastPolled) {
    lastPolled = value;
    report(value, 'poll');
  }
}, 1000);

function report(value, source) {
  const time = new Date().toISOString().slice(11, 19);
  current.text = `inCall: ${value}`;
  log.text = `${time}  inCall = ${value}  (${source})\n${log.text}`;
  console.log(`callDetection.inCall = ${value} (${source})`);
}
