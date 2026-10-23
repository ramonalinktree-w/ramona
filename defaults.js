// Contenido por defecto. Se usa como semilla inicial y como fallback si Supabase
// no responde. Una vez que se guarda desde el admin, manda la versión de la base.
//
// kind: "link" (abre en pestaña) | "pdf" (abre en modal) | "heading" (título de sección, sin link)
window.LT_DEFAULTS = {
  profile: {
    name: "ramona_uruguay",
    bio: "Comida del bien",
    avatar_url: "assets/avatar.jpg",
    show_pedidosya_logo: true,
    meta_pixel_id: "",
    meta_click_event: "ClickPedidosYa"
  },
  socials: [
    { type: "instagram", url: "https://www.instagram.com/ramona_uruguay" },
    { type: "tiktok", url: "https://www.tiktok.com/@ramona_uruguay" },
    { type: "facebook", url: "https://www.facebook.com/ramonauruguay/" },
    { type: "whatsapp", url: "https://api.whatsapp.com/send?phone=59898045054" }
  ],
  links: [
    { id: "h-centro", kind: "heading", label: "Ramona Centro", enabled: true },
    {
      id: "py-centro-cafe",
      label: "PedidosYa Cafetería y Restaurante",
      url: "https://www.pedidosya.com.uy/restaurantes/montevideo/ramona-cafe-centro-gluten-free-menu",
      kind: "link", thumb_url: "", sublabel: "", enabled: true
    },
    {
      id: "py-centro-pan",
      label: "PedidosYa Panadería",
      url: "https://www.pedidosya.com.uy/restaurantes/montevideo/la-panaderia-de-ramona-centro-gluten-free-9bd2fce6-7584-45ee-b9b2-7a7c35912253-menu",
      kind: "link", thumb_url: "", sublabel: "", enabled: true
    },
    { id: "h-pocitos", kind: "heading", label: "Ramona Pocitos", enabled: true },
    {
      id: "py-pocitos-cafe",
      label: "PedidosYa Cafetería y Restaurante",
      url: "https://www.pedidosya.com.uy/restaurantes/montevideo/ramona-cafe-wtc-gluten-free-837979eb-0844-4507-a73d-177263256817-menu",
      kind: "link", thumb_url: "", sublabel: "", enabled: true
    },
    {
      id: "py-pocitos-pan",
      label: "PedidosYa Panadería",
      url: "https://www.pedidosya.com.uy/restaurantes/montevideo/la-panaderia-de-ramona-wtc-gluten-free-7315af1d-e293-46d7-814d-69380d2bdc02-menu",
      kind: "link", thumb_url: "", sublabel: "", enabled: true
    },
    { id: "h-carrasco", kind: "heading", label: "Ramona Carrasco", enabled: true },
    {
      id: "py-carrasco-pan",
      label: "PedidosYa Panadería",
      url: "https://www.pedidosya.com.uy/restaurantes/montevideo/la-panaderia-de-ramona-carrasco-glutenfree-20521c17-60a8-4b1a-a921-10e71cea9596-menu",
      kind: "link", thumb_url: "", sublabel: "", enabled: true
    }
  ]
};
