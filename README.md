# Ramona · Links de PedidosYa + Admin

Página tipo linktree solo con los links de PedidosYa de Ramona (`index.html`) y panel
de administración con login (`admin.html`) para editar perfil, botones y secciones,
cargar el **Pixel de Meta** y ver métricas de visitas y clics.
Se publica como sitio estático (GitHub Pages) y usa **Supabase** para login, base de
datos y almacenamiento de imágenes.

```
index.html          página pública (lee la config, registra métricas, carga el Pixel)
admin.html          panel de administración (login + editor + Pixel + métricas)
config.js           URL y anon key del proyecto Supabase   ← hay que completarlo
defaults.js         contenido por defecto / respaldo
app.js              cliente Supabase + Pixel de Meta + helpers
supabase-setup.sql  tablas, políticas RLS, bucket y contenido inicial
assets/avatar.jpg   foto de perfil inicial
```

## Puesta en marcha (una vez)

1. **Proyecto de Supabase propio de Ramona** (no reutilizar el de otro cliente): supabase.com →
   New project. Idealmente dentro de una organización a nombre del cliente.
2. **Base de datos:** SQL Editor → New query → pegar todo `supabase-setup.sql` → Run
   ("Success. No rows returned" es lo esperado).
3. **Usuario admin:** Authentication → Users → Add user → Create new user (email +
   contraseña, marcar *Auto Confirm User*). Y en Authentication → Sign In / Providers →
   Email, apagar *Allow new users to sign up* para que nadie más se registre.
4. **Conectar:** Project Settings → API → copiar *Project URL* y la clave *anon public* a
   `config.js`. (La `service_role` nunca va en el sitio.)
5. **Publicar:** repo en GitHub → Settings → Pages → Deploy from branch `main` / root.
   Página: `https://<cuenta>.github.io/<repo>/` · Panel: `.../admin.html`.

Mientras `config.js` tenga `TU-PROYECTO`, la página pública funciona igual con
`defaults.js`, pero sin métricas, sin Pixel y sin login.

## Panel

- **Perfil:** nombre, descripción corta, foto (subir archivo o pegar URL) y casillero para mostrar u
  ocultar el logo de PedidosYa, que se ve entero debajo de los íconos de redes.
- **Pixel de Meta:** ver abajo.
- **Redes (opcional):** vacías por defecto; se agregan si hacen falta.
- **Botones:** texto, URL, subtítulo y miniatura opcionales, visible sí/no, orden con ↑/↓.
  Hay un tipo **Título de sección** (sin link) para agrupar por local: *Ramona Centro*,
  *Ramona Pocitos*, *Ramona Carrasco*. **Guardar cambios** publica; la página toma los cambios
  al recargar.
- **Métricas:** visitas y clics por rango, gráfico diario y clics por botón. Como varios
  botones se llaman igual ("PedidosYa Panadería"), cada clic se guarda como
  `Sección · Botón` y la tabla los separa por local.

## Pixel de Meta (medir clics)

1. En Meta Events Manager, crear o elegir el Pixel y copiar su **ID** (solo números).
2. Panel → **Pixel de Meta** → pegar el ID → **Guardar cambios**.
3. Desde ese momento la página envía `PageView` al abrirse y, en cada clic a un botón, el
   evento configurado en *Nombre del evento de clic* (por defecto `ClickPedidosYa`), con
   `content_name` = `Sección · Botón` y `link_url`.
   - Un nombre cualquiera sin espacios se crea como evento **personalizado**.
   - Los estándar `Lead`, `Contact`, `InitiateCheckout`, `ViewContent`, `FindLocation`,
     `Schedule`, `AddToCart` y `Subscribe` se envían como eventos estándar de Meta.
4. Comprobar: extensión *Meta Pixel Helper* o Events Manager → *Probar eventos*.
5. Para usarlo en campañas hay que crear una *conversión personalizada* o público a partir
   de ese evento en Events Manager.

Sin Pixel ID el Pixel no se carga. El Pixel se activa solo con la configuración real de la
base de datos, nunca con `defaults.js`.

**Privacidad:** el Pixel recopila datos de los visitantes. Conviene reflejarlo en la política
de privacidad de Ramona (Ley 18.331) y, si se hace publicidad con esos datos, revisar el
aviso/consentimiento de cookies.

## Pausa por inactividad (Supabase gratis)

El plan gratuito pausa el proyecto tras 7 días sin actividad. En un proyecto equivalente se probó
un ping programado cada 3 días y **no evitó la pausa**, por eso acá no se incluye. Opciones:
plan Pro (US$ 25/mes, sin pausas) o restaurar a mano desde el panel de Supabase (hasta 90 días
después de pausarse). Con el proyecto pausado la página pública sigue visible con el contenido de
`defaults.js` y el panel y las métricas dejan de funcionar. El Pixel viene de la base, así que
para no perder la medición de anuncios se puede cargar el mismo ID en `META_PIXEL_ID_FALLBACK`
de `config.js`: se usa solo cuando la base no responde.
