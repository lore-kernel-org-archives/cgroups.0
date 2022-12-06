From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 6 Dec 2022 21:51:01 +0100
Message-ID: <Y4+rNYF9WZyJyBQp@cmpxchg.org>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org>
 <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org>
 <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
 <Y4+RPry2tfbWFdSA@cmpxchg.org>
 <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MhNNBuU3zhWHic7xb6ZOwSKSyK5OVL6db6+6pmE+Q3M=;
        b=ew9hSEgOp7zxS5LHySeYnEzHgmaD+v212Cb4Fd4PwkYBPj5pH62iZWOulKd0ei+VIF
         hG4aPrHYGGD2WjWCwTeiUbs4eJpgiBWAD11E9kH3ukMi930ryVJILwhbma6Z6EzrMM05
         mLbvFWbLYmMuszo96rfDjQSt3bGw11HgQ5uhXrEPsPukevWYu9Se1bCczpK+/vleLV5K
         AGPm4VSO4i06JLwAL1yP1lr+XAgD8QZhihWIylphT7Vy0PwUMDgG1DNbLcgxqTsHQe/q
         icM80qePTJzH/mDe7I8K1001EPbcfyl2/qvXn1BCmCuF8HDKBXbdkhqjrLXdTuledxeF
         tJ2Q==
Content-Disposition: inline
In-Reply-To: <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team <kernel-team-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Tue, Dec 06, 2022 at 08:13:50PM +0100, Eric Dumazet wrote:
> On Tue, Dec 6, 2022 at 8:00 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > @@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
> >  void mem_cgroup_sk_free(struct sock *sk);
> >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> >  {
> > -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
> 
> && READ_ONCE(memcg->socket_pressure))
> 
> >                 return true;
> >         do {
> > -               if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
> > +               if (memcg->socket_pressure)
> 
> if (READ_ONCE(...))

Good point, I'll add those.

> > @@ -7195,10 +7194,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> >                 struct page_counter *fail;
> >
> >                 if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
> > -                       memcg->tcpmem_pressure = 0;
> 
> Orthogonal to your patch, but:
> 
> Maybe avoid touching this cache line too often and use READ/WRITE_ONCE() ?
> 
>     if (READ_ONCE(memcg->socket_pressure))
>       WRITE_ONCE(memcg->socket_pressure, false);

Ah, that's a good idea.

I think it'll be fine in the failure case, since that's associated
with OOM and total performance breakdown anyway.

But certainly, in the common case of the charge succeeding, we should
not keep hammering false into that variable over and over.

How about the delta below? I also flipped the branches around to keep
the common path at the first indentation level, hopefully making that
a bit clearer too.

Thanks for taking a look, Eric!

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ef1c388be5b3..13ae10116895 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1701,10 +1701,11 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
+	    READ_ONCE(memcg->socket_pressure))
 		return true;
 	do {
-		if (memcg->socket_pressure)
+		if (READ_ONCE(memcg->socket_pressure))
 			return true;
 	} while ((memcg = parent_mem_cgroup(memcg)));
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0d4b9dbe775a..96c4ec0f11ca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7193,31 +7193,29 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		struct page_counter *fail;
 
-		if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-			memcg->socket_pressure = false;
-			return true;
+		if (!page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+			WRITE_ONCE(memcg->socket_pressure, true);
+			if (gfp_mask & __GFP_FAIL) {
+				page_counter_charge(&memcg->tcpmem, nr_pages);
+				return true;
+			}
+			return false;
 		}
-		memcg->socket_pressure = true;
+		if (unlikely(READ_ONCE(memcg->socket_pressure)))
+			WRITE_ONCE(memcg->socket_pressure, false);
+	}
+
+	if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) < 0) {
+		WRITE_ONCE(memcg->socket_pressure, true);
 		if (gfp_mask & __GFP_NOFAIL) {
-			page_counter_charge(&memcg->tcpmem, nr_pages);
+			try_charge(memcg, gfp_mask, nr_pages);
+			mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 			return true;
 		}
 		return false;
 	}
-
-	if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) == 0) {
-		memcg->socket_pressure = false;
-		goto success;
-	}
-	memcg->socket_pressure = true;
-	if (gfp_mask & __GFP_NOFAIL) {
-		try_charge(memcg, gfp_mask, nr_pages);
-		goto success;
-	}
-
-	return false;
-
-success:
+	if (unlikely(READ_ONCE(memcg->socket_pressure)))
+		WRITE_ONCE(memcg->socket_pressure, false);
 	mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 	return true;
 }
