From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Fri, 12 May 2023 17:17:01 +0000
Message-ID: <20230512171702.923725-1-shakeelb@google.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683911825; x=1686503825;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g/vEoaxxlidjk6ZRnVQ6vBnM5rJLiZ0SFsw4oljX9Bo=;
        b=6TzRO4dhn5IQ9F9oBlZSna42ZOqtLV1QcfYJqq0S5da4w8udY31eLcwr/E03q3nFoB
         ODjOKKPktW+57iOsHRQ94HWijxeHVRQsNCKzBtLgwx52ZLMDichW/UVkpYTYMo5c+c0W
         C37q+PaEllbmgwGvnyQiCScSGXH2VUjfY+x9RPgqiCjw/Q824wEI2tVYxRUTa5OHSyKh
         EqLwh6+KXRPctS0apgFG1m5k2fJn1Mxh+A9hEQ/vmsThZr9DgY1FQaCJ0OwDCjLGIHFI
         dzA74UjBQoyNUMFHq06ENAe24xaZNGPz8dMoD+WWJaA7alhFLNTbdqDlZ4lWEuoihrbQ
         7G+g==
In-Reply-To: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759-WQKEFoXy4NEXvLLfv6NhPJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cathy Zhang <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <Brandeburg-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Brandeburg <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Suresh Srinivas <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tim C Chen <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lizhen You <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 12, 2023 at 05:51:40AM +0000, Zhang, Cathy wrote:
> 
> 
[...]
> > 
> > Thanks a lot. This tells us that one or both of following scenarios are
> > happening:
> > 
> > 1. In the softirq recv path, the kernel is processing packets from multiple
> > memcgs.
> > 
> > 2. The process running on the CPU belongs to memcg which is different from
> > the memcgs whose packets are being received on that CPU.
> 
> Thanks for sharing the points, Shakeel! Is there any trace records you want to
> collect?
> 

Can you please try the following patch and see if there is any
improvement?


From 48eb23c8cbb5d6c6086299c8a5ae4b3485c79a8c Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date: Fri, 12 May 2023 17:04:35 +0000
Subject: [PATCH] No batch charge in irq context

---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d31fb1e2cb33..f1453a140fc8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2652,7 +2652,8 @@ void mem_cgroup_handle_over_high(void)
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 			unsigned int nr_pages)
 {
-	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
+	unsigned int batch = in_task() ?
+		max(MEMCG_CHARGE_BATCH, nr_pages) : nr_pages;
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
-- 
2.40.1.606.ga4b1b128d6-goog

