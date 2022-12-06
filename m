From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 6 Dec 2022 23:10:49 +0000
Message-ID: <20221206231049.g35ltbxbk54izrie@google.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org> <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
 <Y4+RPry2tfbWFdSA@cmpxchg.org> <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
 <Y4+rNYF9WZyJyBQp@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H30kxZZAF5jNAG74FSVbdmAZx19VpCBztd5KoQzCrP8=;
        b=Jlk1MmZCRjTlJDcMa2AlTVoJLrTt+/m+1AA4uwx+MttAi+FmUNRsMX8SzhrD1HHgXX
         d81kNXOA1lGLcF+WHEmHQo1v1bFG4omVEdJD7yIqGo8TB3Yt5ZVtaZARZqYKl/9iAx5M
         Ip2C0G4UFGPZaZYJb+DSc6cmX73dTrJ37Hku2SMBzeSGOXzMKMp1vVoHaJhAsGL1m2Lo
         cKtochCKQNZ2Aat3boBLKDEdB+ibi5/spc/sAVj6Nmq2vhlYKpKSeDxMzQwvTvE+fNqK
         L6rj/E8c0TzzAExGWhtgPxUFwhopdoD46Xa10DctN43JPpt1Q266DAF3IiT5L4puAbzi
         i6hA==
In-Reply-To: <Y4+rNYF9WZyJyBQp-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Tue, Dec 06, 2022 at 09:51:01PM +0100, Johannes Weiner wrote:
> On Tue, Dec 06, 2022 at 08:13:50PM +0100, Eric Dumazet wrote:
> > On Tue, Dec 6, 2022 at 8:00 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > > @@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
> > >  void mem_cgroup_sk_free(struct sock *sk);
> > >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> > >  {
> > > -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
> > 
> > && READ_ONCE(memcg->socket_pressure))
> > 
> > >                 return true;
> > >         do {
> > > -               if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
> > > +               if (memcg->socket_pressure)
> > 
> > if (READ_ONCE(...))
> 
> Good point, I'll add those.
> 
> > > @@ -7195,10 +7194,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> > >                 struct page_counter *fail;
> > >
> > >                 if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
> > > -                       memcg->tcpmem_pressure = 0;
> > 
> > Orthogonal to your patch, but:
> > 
> > Maybe avoid touching this cache line too often and use READ/WRITE_ONCE() ?
> > 
> >     if (READ_ONCE(memcg->socket_pressure))
> >       WRITE_ONCE(memcg->socket_pressure, false);
> 
> Ah, that's a good idea.
> 
> I think it'll be fine in the failure case, since that's associated
> with OOM and total performance breakdown anyway.
> 
> But certainly, in the common case of the charge succeeding, we should
> not keep hammering false into that variable over and over.
> 
> How about the delta below? I also flipped the branches around to keep
> the common path at the first indentation level, hopefully making that
> a bit clearer too.
> 
> Thanks for taking a look, Eric!
> 

I still think we should not put a persistent state of socket pressure on
unsuccessful charge which will only get reset on successful charge. I
think the better approach would be to limit the pressure state by time
window same as today but set it on charge path. Something like below:


diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d3c8203cab6c..7bd88d443c42 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -287,7 +287,6 @@ struct mem_cgroup {

        /* Legacy tcp memory accounting */
        bool                    tcpmem_active;
-       int                     tcpmem_pressure;

 #ifdef CONFIG_MEMCG_KMEM
        int kmemcg_id;
@@ -1712,8 +1711,6 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
-               return true;
        do {
                if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
                        return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 48c44229cf47..290444bcab84 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5286,7 +5286,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
        vmpressure_init(&memcg->vmpressure);
        INIT_LIST_HEAD(&memcg->event_list);
        spin_lock_init(&memcg->event_list_lock);
-       memcg->socket_pressure = jiffies;
 #ifdef CONFIG_MEMCG_KMEM
        memcg->kmemcg_id = -1;
        INIT_LIST_HEAD(&memcg->objcg_list);
@@ -7252,10 +7251,12 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
                struct page_counter *fail;

                if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-                       memcg->tcpmem_pressure = 0;
+                       if (READ_ONCE(memcg->socket_pressure))
+                               WRITE_ONCE(memcg->socket_pressure, 0);
                        return true;
                }
-               memcg->tcpmem_pressure = 1;
+               if (READ_ONCE(memcg->socket_pressure) < jiffies + HZ)
+                       WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
                if (gfp_mask & __GFP_NOFAIL) {
                        page_counter_charge(&memcg->tcpmem, nr_pages);
                        return true;
@@ -7263,12 +7264,21 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
                return false;
        }

-       if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
-               mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
-               return true;
+       if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) < 0) {
+               if (READ_ONCE(memcg->socket_pressure) < jiffies + HZ)
+                       WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
+               if (gfp_mask & __GFP_NOFAIL) {
+                       try_charge(memcg, gfp_mask, nr_pages);
+                       goto out;
+               }
+               return false;
        }

-       return false;
+       if (READ_ONCE(memcg->socket_pressure))
+               WRITE_ONCE(memcg->socket_pressure, 0);
+out:
+       mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
+       return true;
 }

 /**
