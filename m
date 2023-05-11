From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Thu, 11 May 2023 21:18:42 +0000
Message-ID: <20230511211338.oi4xwoueqmntsuna@google.com>
References: <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com> <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683839925; x=1686431925;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wFv5ci7ov6TO/nbE/lFV0e8LOwHUTHRp5fyIeOp00NI=;
        b=DRDZQiesqpSkMtadBPnXaSLFftLOF2tRVveccLBHVnBfk/IjvUoQA1Vknb0qgMsFbd
         ul40I6todx42bog/6ILqg96UcxIK20g7/qxVXO8QgOpBrtxjLfYfJ3yb7AbTA509nJ45
         vVEgVqAVXuEAW3i7m6KpNZ8E7yUqe9DG3mXiQ3HPPZBITzC95+Q2dKAzmolVjjK8pwj6
         a9Cs5cxJHtaEZmMYpeJlaDWPHHQqqVCMIVRPH7naWvhq4An6q1xPYDSHdHn8VQ1eQ3Qq
         1xo4xpza4/4wjkUjYkP6SbE4ymEBfN6VGHOcKr1q1VYLux/W7k50O5Jteg6uKDtjsnQ8
         c8RA==
In-Reply-To: <IA0PR11MB73557DEAB912737FD61D2873FC749-py0Qfd72Ncwkr2bXB6wcV5PPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Zhang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Srinivas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Suresh <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Chen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, You-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, May 11, 2023 at 09:26:46AM +0000, Zhang, Cathy wrote:
> 
[...]
> 
>      8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_cancel
>             |
>              --8.97%--page_counter_cancel
>                        |
>                         --8.97%--page_counter_uncharge
>                                   drain_stock
>                                   __refill_stock
>                                   refill_stock
>                                   |
>                                    --8.91%--try_charge_memcg
>                                              mem_cgroup_charge_skmem

I do want to understand for above which specific condition in
__refill_stock is causing to drain stock in the charge code path. Can
you please re-run and profile your test with following code snippet (or
use any other mechanism which can answer the question)?

From f1d91043f21f4b29717c78615b374d79fc021d1f Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date: Thu, 11 May 2023 20:00:19 +0000
Subject: [PATCH] Debug drain on charging.

---
 mm/memcontrol.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d31fb1e2cb33..4c1c3d90a4a3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2311,6 +2311,16 @@ static void drain_local_stock(struct work_struct *dummy)
 		obj_cgroup_put(old);
 }
 
+static noinline void drain_stock_1(struct memcg_stock_pcp *stock)
+{
+	drain_stock(stock);
+}
+
+static noinline void drain_stock_2(struct memcg_stock_pcp *stock)
+{
+	drain_stock(stock);
+}
+
 /*
  * Cache charges(val) to local per_cpu area.
  * This will be consumed by consume_stock() function, later.
@@ -2321,14 +2331,14 @@ static void __refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 
 	stock = this_cpu_ptr(&memcg_stock);
 	if (READ_ONCE(stock->cached) != memcg) { /* reset if necessary */
-		drain_stock(stock);
+		drain_stock_1(stock);
 		css_get(&memcg->css);
 		WRITE_ONCE(stock->cached, memcg);
 	}
 	stock->nr_pages += nr_pages;
 
 	if (stock->nr_pages > MEMCG_CHARGE_BATCH)
-		drain_stock(stock);
+		drain_stock_2(stock);
 }
 
 static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
-- 
2.40.1.606.ga4b1b128d6-goog

