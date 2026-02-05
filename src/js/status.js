(function(){
  function setStatus(el, ok, msg){
    if(!el) return;
    el.textContent = msg || (ok? 'ok' : 'error');
    el.style.color = ok? '#065f46' : '#b91c1c';
  }
  async function check(url){
    try {
      const r = await fetch(url, {cache:'no-store'});
      if(!r.ok) return { ok:false, msg: 'HTTP '+r.status };
      const data = await r.json().catch(()=>({}));
      return { ok:true, msg: data && data.status ? data.status : 'ok' };
    } catch(e){
      return { ok:false, msg: e.message.split('\n')[0] };
    }
  }
  async function run(){
    const feEl = document.getElementById('health-frontend');
    const apiEl = document.getElementById('health-api');
    // Frontend health is local; just mark ok if DOM is ready
    setStatus(feEl, true, 'ok');
    // API health check - use configuration
    const apiUrl = window.getApiUrl ? window.getApiUrl('/api/health') : '/api/health';
    const api = await check(apiUrl);
    setStatus(apiEl, api.ok, api.msg);
  }
  function start(){ run(); setInterval(run, 5000); }
  if(document.readyState==='loading') document.addEventListener('DOMContentLoaded', start); else start();
})();
