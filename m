From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 6/7] workingset: memcg: sleep when flushing stats in workingset_refault()
Date: Thu, 23 Mar 2023 04:00:36 +0000
Message-ID: <20230323040037.2389095-7-yosryahmed@google.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679544052;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IoeZYZryJtZ5YKLINZigwUk+eCMrWPKZYyl5pNjfs0s=;
        b=CYUJafqLeSTzFoXixoXxJfg+d8a1R4JvCUerDh64ifDjpdaxbdbWqowybN/gvJ19LK
         Og473fSzkkpOeMA58DC64BMRm6M0MCGDM/VGSfHLkAlVcw8rDdEYpMTrVbzG7kCaO9yo
         XEy99SSbQbOpczsL5Zy04pgal2f5dv+k8luu/GDpUWQB1RZl9qYQhWpR8p3p3vD98PGc
         ce78QmYoavhlvFbHk6YMCQ65CM/lnXEYztj/xUq2pBOa3UnU3uBgApeimhahme8eLkyC
         CQZkL9MM7bPQMzx+6ozclKMKwr8T8qPF+ZR71Vewcxu4v3esM5hXIWD8hj0gOLxV+qOY
         L9ww==
In-Reply-To: <20230323040037.2389095-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

In workingset_refault(), we call mem_cgroup_flush_stats_delayed() to
flush stats within an RCU read section and with sleeping disallowed.
Move the call to mem_cgroup_flush_stats_delayed() above the RCU read
section and allow sleeping to avoid unnecessarily performing a lot of
work without sleeping.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

A lot of code paths call into workingset_refault(), so I am not
generally sure at all whether it's okay to sleep in all contexts or not.
Feedback here would be very helpful.

---
 mm/workingset.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 042eabbb43f6..410bc6684ea7 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -406,6 +406,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, &workingset);
 	eviction <<= bucket_order;
 
+	/* Flush stats (and potentially sleep) before holding RCU read lock */
+	mem_cgroup_flush_stats_delayed(true);
 	rcu_read_lock();
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -461,9 +463,6 @@ void workingset_refault(struct folio *folio, void *shadow)
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
-
-	/* Do not sleep with RCU lock held */
-	mem_cgroup_flush_stats_delayed(false);
 	/*
 	 * Compare the distance to the existing workingset size. We
 	 * don't activate pages that couldn't stay resident even if
-- 
2.40.0.rc1.284.g88254d51c5-goog

