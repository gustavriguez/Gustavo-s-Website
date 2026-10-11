(()=>{
  const form=document.getElementById('editor-unlock'),message=document.getElementById('unlock-status'),input=form.elements.password;
  form.onsubmit=async event=>{
    event.preventDefault();const button=form.querySelector('button');button.disabled=true;message.textContent='';
    try{
      const digest=await crypto.subtle.digest('SHA-256',new TextEncoder().encode(input.value));
      const hash=Array.from(new Uint8Array(digest),b=>b.toString(16).padStart(2,'0')).join('');input.value='';
      if(hash!==form.dataset.passwordHash){message.textContent='Incorrect password.';input.focus();return}
      await window.loadPortfolioEditor();document.body.classList.remove('editor-locked');document.getElementById('editor-lock').hidden=true;document.getElementById('lock-editor').hidden=false;document.getElementById('section-title').setAttribute('tabindex','-1');document.getElementById('section-title').focus();
    }catch(error){message.textContent='Unable to open the editor. '+error.message;}finally{button.disabled=false}
  };
  document.getElementById('lock-editor').onclick=()=>location.reload();
})();
