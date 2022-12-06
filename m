From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 6 Dec 2022 20:13:50 +0100
Message-ID: <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org> <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com> <Y4+RPry2tfbWFdSA@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nsGstoMegH9NCBA+9S++kT1eq+4LgLp/g5jcJesallk=;
        b=XYKeMYNurkuR6sR3Bimkf7Sn8dHGUPB/zyUAi5+51h+e/3eKyuQGNJmkMVJA2I8mIO
         CRj1XB6I+6aa93zGfB/XreNSlmTLe7W5eHZVi/gq5zyZ7EEkjk4q49HSkidWnAE7J2UZ
         yhegxEOwEF91TJJvN5JjZ1tgaxWE7Z0j3VlZWiVxWL3QhIxeqHNLGUahLLYMgnMWo6m7
         LWQBrrP98g3lSPdohibAd0RZqtMzH2ASNda0/fz+SLByFsys48P+q9qh3dZu1Okmq1jf
         RtZC+vv238QR0AXfwTzcUPRCnYQP38SscsXB3ILVgMfK8CzeVP8pxS7S6iPEzQGHWcIP
         fdBw==
In-Reply-To: <Y4+RPry2tfbWFdSA-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Tue, Dec 6, 2022 at 8:00 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Mon, Dec 05, 2022 at 04:50:46PM -0800, Ivan Babrou wrote:
> > And now I can see plenty of this:
> >
> > [  108.156707][ T5175] socket pressure[2]: 4294673429
> > [  108.157050][ T5175] socket pressure[2]: 4294673429
> > [  108.157301][ T5175] socket pressure[2]: 4294673429
> > [  108.157581][ T5175] socket pressure[2]: 4294673429
> > [  108.157874][ T5175] socket pressure[2]: 4294673429
> > [  108.158254][ T5175] socket pressure[2]: 4294673429
> >
> > I think the first result below is to blame:
> >
> > $ rg '.->socket_pressure' mm
> > mm/memcontrol.c
> > 5280: memcg->socket_pressure = jiffies;
> > 7198: memcg->socket_pressure = 0;
> > 7201: memcg->socket_pressure = 1;
> > 7211: memcg->socket_pressure = 0;
> > 7215: memcg->socket_pressure = 1;
>
> Hoo boy, that's a silly mistake indeed. Thanks for tracking it down.
>
> > While we set socket_pressure to either zero or one in
> > mem_cgroup_charge_skmem, it is still initialized to jiffies on memcg
> > creation. Zero seems like a more appropriate starting point. With that
> > change I see it working as expected with no TCP speed bumps. My
> > ebpf_exporter program also looks happy and reports zero clamps in my
> > brief testing.
>
> Excellent, now this behavior makes sense.
>
> > I also think we should downgrade socket_pressure from "unsigned long"
> > to "bool", as it only holds zero and one now.
>
> Sounds good to me!
>
> Attaching the updated patch below. If nobody has any objections, I'll
> add a proper changelog, reported-bys, sign-off etc and send it out.
>
> ---
>  include/linux/memcontrol.h |  8 +++---
>  include/linux/vmpressure.h |  7 ++---
>  mm/memcontrol.c            | 20 +++++++++----
>  mm/vmpressure.c            | 58 ++++++--------------------------------
>  mm/vmscan.c                | 15 +---------
>  5 files changed, 30 insertions(+), 78 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e1644a24009c..ef1c388be5b3 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -283,11 +283,11 @@ struct mem_cgroup {
>         atomic_long_t           memory_events[MEMCG_NR_MEMORY_EVENTS];
>         atomic_long_t           memory_events_local[MEMCG_NR_MEMORY_EVENTS];
>
> -       unsigned long           socket_pressure;
> +       /* Socket memory allocations have failed */
> +       bool                    socket_pressure;
>
>         /* Legacy tcp memory accounting */
>         bool                    tcpmem_active;
> -       int                     tcpmem_pressure;
>
>  #ifdef CONFIG_MEMCG_KMEM
>         int kmemcg_id;
> @@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
>  void mem_cgroup_sk_free(struct sock *sk);
>  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
>  {
> -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)

&& READ_ONCE(memcg->socket_pressure))

>                 return true;
>         do {
> -               if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
> +               if (memcg->socket_pressure)

if (READ_ONCE(...))

>                         return true;
>         } while ((memcg = parent_mem_cgroup(memcg)));
>         return false;
> diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
> index 6a2f51ebbfd3..20d93de37a17 100644
> --- a/include/linux/vmpressure.h
> +++ b/include/linux/vmpressure.h
> @@ -11,9 +11,6 @@
>  #include <linux/eventfd.h>
>
>  struct vmpressure {
> -       unsigned long scanned;
> -       unsigned long reclaimed;
> -
>         unsigned long tree_scanned;
>         unsigned long tree_reclaimed;
>         /* The lock is used to keep the scanned/reclaimed above in sync. */
> @@ -30,7 +27,7 @@ struct vmpressure {
>  struct mem_cgroup;
>
>  #ifdef CONFIG_MEMCG
> -extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> +extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>                        unsigned long scanned, unsigned long reclaimed);
>  extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
>
> @@ -44,7 +41,7 @@ extern int vmpressure_register_event(struct mem_cgroup *memcg,
>  extern void vmpressure_unregister_event(struct mem_cgroup *memcg,
>                                         struct eventfd_ctx *eventfd);
>  #else
> -static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
> +static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
>                               unsigned long scanned, unsigned long reclaimed) {}
>  static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
>                                    int prio) {}
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2d8549ae1b30..0d4b9dbe775a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5277,7 +5277,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
>         vmpressure_init(&memcg->vmpressure);
>         INIT_LIST_HEAD(&memcg->event_list);
>         spin_lock_init(&memcg->event_list_lock);
> -       memcg->socket_pressure = jiffies;
>  #ifdef CONFIG_MEMCG_KMEM
>         memcg->kmemcg_id = -1;
>         INIT_LIST_HEAD(&memcg->objcg_list);
> @@ -7195,10 +7194,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 struct page_counter *fail;
>
>                 if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
> -                       memcg->tcpmem_pressure = 0;

Orthogonal to your patch, but:

Maybe avoid touching this cache line too often and use READ/WRITE_ONCE() ?

    if (READ_ONCE(memcg->socket_pressure))
      WRITE_ONCE(memcg->socket_pressure, false);


> +                       memcg->socket_pressure = false;
>                         return true;
>                 }
> -               memcg->tcpmem_pressure = 1;
> +               memcg->socket_pressure = true;

Same remark.

>                 if (gfp_mask & __GFP_NOFAIL) {
>                         page_counter_charge(&memcg->tcpmem, nr_pages);
>                         return true;
> @@ -7206,12 +7205,21 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
>                 return false;
>         }
>
> -       if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
> -               mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
> -               return true;
> +       if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) == 0) {
> +               memcg->socket_pressure = false;

same remark.

> +               goto success;
> +       }
> +       memcg->socket_pressure = true;

same remark.

> +       if (gfp_mask & __GFP_NOFAIL) {
> +               try_charge(memcg, gfp_mask, nr_pages);
> +               goto success;
>         }
>
>         return false;
> +
> +success:
> +       mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
> +       return true;
>  }
>
>  /**
