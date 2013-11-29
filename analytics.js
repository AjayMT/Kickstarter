const KS_VERSION = '1.6.2';

mixpanel.track('Page view');

function download () {
  mixpanel.track('Download');
  window.location.href = './downloads/Kickstarter-' + KS_VERSION + '.zip';
}
