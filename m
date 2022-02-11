From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/4] memcg: unify force charging conditions
Date: Thu, 10 Feb 2022 22:49:15 -0800
Message-ID: <20220211064917.2028469-3-shakeelb@google.com>
References: <20220211064917.2028469-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Gp3MzKjywklApxzwU7bA0E+IdrMiraVuIp3bbtkpPwY=;
        b=pZFidtCwL5VMsnJRP/9b9wHwk02Whf8q/difXoIKsdZUTOmtfykRIOjUqweW4jqnAY
         8AEQsIf7BJ3qv1w8Ny3VBvWoNOmFTRKN3MfOMCY09iJzuIfqwdWFh7mMh1dOoqJ4ANRG
         kk6Yyu5VN4IsdIxQHdbPDB8jrS384vnBeQ0zTXmINULyixuihlw86O9M7+bkOQkq5FCF
         Lrhhz8wMvYt8tbAjV4cuO7v+/OfmJKzHuP1Xt8E8P3AuoqUne3R/7i1gblDPs3CiLF4I
         Lu2aeoDUQLQNqiMdUjzemZ+fOLmEn6qSvVpIVsT10mL7z1OHdnOzDR/O/QikLdqga1Ns
         Ahuw==
In-Reply-To: <20220211064917.2028469-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently the kernel force charges the allocations which have __GFP_HIGH
flag without triggering the memory reclaim. __GFP_HIGH indicates that
the caller is high priority and since commit 869712fd3de5 ("mm:
memcontrol: fix network errors from failing __GFP_ATOMIC charges") the
kernel lets such allocations do force charging. Please note that
__GFP_ATOMIC has been replaced by __GFP_HIGH.

__GFP_HIGH does not tell if the caller can block or can trigger reclaim.
There are separate checks to determine that. So, there is no need to
skip reclaiming for __GFP_HIGH allocations. So, handle __GFP_HIGH
together with __GFP_NOFAIL which also does force charging.

Please note that this is a noop change as there are no __GFP_HIGH
allocators in the kernel which also have __GFP_ACCOUNT (or SLAB_ACCOUNT)
and does not allow reclaim for now.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
Changes since v1:
- None

 mm/memcontrol.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f12e489ba9b8..292b0b99a2c7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2564,15 +2564,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
-	/*
-	 * Memcg doesn't have a dedicated reserve for atomic
-	 * allocations. But like the global atomic pool, we need to
-	 * put the burden of reclaim on regular allocation requests
-	 * and let these go through as privileged allocations.
-	 */
-	if (gfp_mask & __GFP_HIGH)
-		goto force;
-
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
@@ -2646,7 +2637,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 nomem:
-	if (!(gfp_mask & __GFP_NOFAIL))
+	/*
+	 * Memcg doesn't have a dedicated reserve for atomic
+	 * allocations. But like the global atomic pool, we need to
+	 * put the burden of reclaim on regular allocation requests
+	 * and let these go through as privileged allocations.
+	 */
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
 	/*
-- 
2.35.1.265.g69c8d7142f-goog

