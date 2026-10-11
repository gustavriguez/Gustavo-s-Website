import * as THREE from 'three';
import {STLLoader} from './vendor--STLLoader.js';
import {OrbitControls} from './vendor--OrbitControls.js';

// Each STL contains the whole assembly, already transformed into world coordinates.
let cleanup=null;
export function disposeViewer(){cleanup?.();cleanup=null}
export async function startViewer(){
 disposeViewer();
 const stage=document.querySelector('#viewer-stage'),status=document.querySelector('#viewer-status'),select=document.querySelector('#model-select');
 const scene=new THREE.Scene(),camera=new THREE.PerspectiveCamera(35,1,.1,10000);
 const renderer=new THREE.WebGLRenderer({antialias:true,alpha:true});renderer.setPixelRatio(Math.min(window.devicePixelRatio,1.5));renderer.outputColorSpace=THREE.SRGBColorSpace;
 renderer.domElement.tabIndex=0;renderer.domElement.setAttribute('role','img');renderer.domElement.setAttribute('aria-label','Complete assembly in 3D. Drag to orbit, pinch to zoom. Arrow keys rotate.');
 const controls=new OrbitControls(camera,renderer.domElement);controls.enableDamping=false;controls.enablePan=false;
 scene.add(new THREE.HemisphereLight(0xf3fbff,0x566b85,2));
 for(const [color,strength,position]of [[0xffffff,3,[6,9,5]],[0xc2e6ff,1.8,[-5,1,-5]]]){const light=new THREE.DirectionalLight(color,strength);light.position.set(...position);scene.add(light)}
 const material=new THREE.MeshStandardMaterial({vertexColors:true,roughness:.48,metalness:.16,side:THREE.DoubleSide});
 let mesh=null,radius=30,ticket=0,alive=true;const loader=new STLLoader();
 const draw=()=>{if(alive)renderer.render(scene,camera)};
 function size(){const width=stage.clientWidth,height=stage.clientHeight;renderer.setSize(width,height);camera.aspect=width/height;camera.updateProjectionMatrix();draw()}
 function reset(){if(!mesh)return;mesh.rotation.set(-Math.PI/2,0,0);const fov=Math.min(THREE.MathUtils.degToRad(35),2*Math.atan(Math.tan(THREE.MathUtils.degToRad(17.5))*camera.aspect));const distance=radius/Math.sin(fov/2)*1.15;camera.position.set(distance*.5,distance*.32,distance*.83);camera.near=distance/1000;camera.far=distance*100;camera.updateProjectionMatrix();controls.target.set(0,0,0);controls.minDistance=radius*.8;controls.maxDistance=radius*15;controls.update();draw()}
 function colorFor(name){if(/servo|motor|battery|gear/i.test(name))return 0x3a4d62;if(/PCB|electronics|Populated/i.test(name))return 0x537f7c;if(/spring|screw|pin|rod|shaft/i.test(name))return 0xb4c3ce;if(/cover|slider|housing|chassis|cartridge/i.test(name))return 0x799eb3;return 0xa3b9c8}
 async function load(){const request=++ticket,option=select.selectedOptions[0];status.textContent='Loading complete assembly…';let geometry;
  try{geometry=await loader.loadAsync(option.value);const response=await fetch(option.dataset.meta);if(!response.ok)throw new Error('Assembly metadata unavailable');const meta=await response.json();if(!alive||request!==ticket){geometry.dispose();return false}
   const colors=new Float32Array(geometry.attributes.position.count*3),color=new THREE.Color();for(const group of meta.groups){color.setHex(colorFor(group.name));for(let i=group.start*3;i<(group.start+group.count)*3;i++){colors[i*3]=color.r;colors[i*3+1]=color.g;colors[i*3+2]=color.b}}
   geometry.setAttribute('color',new THREE.BufferAttribute(colors,3));geometry.center();geometry.computeVertexNormals();geometry.computeBoundingSphere();radius=Math.max(.1,geometry.boundingSphere.radius);
   if(mesh){scene.remove(mesh);mesh.geometry.dispose()}mesh=new THREE.Mesh(geometry,material);scene.add(mesh);reset();document.querySelector('#assembly-label').textContent=option.dataset.name;renderer.domElement.setAttribute('aria-label',option.dataset.name+'. Drag to orbit, pinch to zoom, or use arrow keys.');status.textContent=option.dataset.name+' · '+meta.groups.length+' components · Drag to orbit.';return true;
  }catch(error){geometry?.dispose();if(request===ticket)status.textContent='Assembly could not load. Choose another assembly or download its STL.';throw error}
 }
 const selectedId=new URLSearchParams(location.search).get('assembly');if(selectedId){const match=[...select.options].find(o=>o.value.endsWith('/'+selectedId+'.stl'));if(match)select.value=match.value}
 try{size();await load()}catch(error){controls.dispose();renderer.dispose();material.dispose();throw error}
 stage.replaceChildren(renderer.domElement);size();reset();controls.addEventListener('change',draw);const observer=new ResizeObserver(()=>{size()});observer.observe(stage);
 select.addEventListener('change',()=>load().catch(()=>{}));document.querySelector('#viewer-reset').addEventListener('click',reset);
 document.querySelector('#viewer-wire').addEventListener('click',e=>{material.wireframe=!material.wireframe;e.currentTarget.setAttribute('aria-pressed',String(material.wireframe));draw()});
 renderer.domElement.addEventListener('keydown',e=>{if(!mesh||!['ArrowLeft','ArrowRight','ArrowUp','ArrowDown'].includes(e.key))return;e.preventDefault();if(e.key==='ArrowLeft')mesh.rotation.z-=.15;if(e.key==='ArrowRight')mesh.rotation.z+=.15;if(e.key==='ArrowUp')mesh.rotation.x-=.15;if(e.key==='ArrowDown')mesh.rotation.x+=.15;draw()});
 cleanup=()=>{alive=false;++ticket;observer.disconnect();controls.dispose();mesh?.geometry.dispose();material.dispose();renderer.dispose()};
}
window.addEventListener('pagehide',disposeViewer);
