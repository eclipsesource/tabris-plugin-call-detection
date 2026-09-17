const {Button, Stack, TextView, contentView} = require('tabris');

const stack = new Stack({layoutData: 'stretch', padding: 16, spacing: 12}).appendTo(contentView);

const current = new TextView({font: 'bold 24px', text: 'inCall: ?'}).appendTo(stack);

new Button({text: 'Check callDetection.inCall'})
  .onSelect(() => {
    const value = callDetection.inCall;
    current.text = `inCall: ${value}`;
    log.text = `${new Date().toISOString().slice(11, 19)}  inCall = ${value}\n${log.text}`;
  })
  .appendTo(stack);

const log = new TextView({layoutData: 'stretchX', font: '14px monospace'}).appendTo(stack);
