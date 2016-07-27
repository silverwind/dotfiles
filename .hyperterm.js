module.exports = {
  config: {
    // default font size in pixels for all tabs
    fontSize: 18,

    // font family with optional fallbacks
    fontFamily: 'Monaco, Consolas, monospace',

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: '#ffde00',

    // `BEAM` for |, `UNDERLINE` for _, `BLOCK` for █
    cursorShape: 'BEAM',

    // color of the text
    foregroundColor: '#a59070',

    // terminal background color
    backgroundColor: '#080808',

    // border color (window, tabs)
    borderColor: '#222',

    // custom css to embed in the main window
    css: '',

    // custom css to embed in the terminal window
    termCSS: '',

    // custom padding (css format, i.e.: `top right bottom left`)
    padding: '0',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#5d5d5d',
      red: '#fe5b4b',
      green: '#00d400',
      yellow: '#ff9e03',
      blue: '#2190e0',
      magenta: '#f1499e',
      cyan: '#00c5c7',
      white: '#c7c7c7',
      lightBlack: '#767372',
      lightRed: '#ff6e67',
      lightGreen: '#5ffa68',
      lightYellow: '#fffc67',
      lightBlue: '#6871ff',
      lightMagenta: '#ff77ff',
      lightCyan: '#5ffa68',
      lightWhite: '#ffffff'
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    shell: ''

    // for advanced config flags please refer to https://hyperterm.org/#cfg
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [],

  // in development, you can create a directory under
  // `~/.hyperterm_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: []
};
