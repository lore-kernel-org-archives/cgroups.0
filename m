From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] memcg: synchronously enforce memory.high for large overcharges
Date: Thu, 10 Feb 2022 22:49:17 -0800
Message-ID: <20220211064917.2028469-5-shakeelb@google.com>
References: <20220211064917.2028469-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+8rN+YKf6ok+x08l31cPg9Z1f+kTrw1cXJDsx6RQzpQ=;
        b=BSR393aKc6QG8wWOZWMfrPQRJdGzUlEYw+Xm72Fj+l1HA0QTOlh+tjEKyBgFzMW5dh
         yMc5fn9Y/A3FfgNSdOvbIJTLWXMoYdbIp/vvqzQXMLbWsG9nJxhfo+fKE3NGJifj+L55
         3LoH8v37N4wzh6cZ6ZelxTm1tTnyY0hKMYUvTMKIKyIycqhn6OLw7MJT5WtKpDt36DPf
         wCMwOA8QiMTaXEP2zn6vCRFegcEHws0MuunzFrr6o1UAxCnt9V9kQaR9FJs/brjoGool
         gPl1ffvPeA1Ff7JE3BrPzFA4t8pldf9Fk2M0Op9O4qxcn/XyTm8w2rz+eUBX0/iLhkxa
         f4vA==
In-Reply-To: <20220211064917.2028469-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The high limit is used to throttle the workload without invoking the
oom-killer. Recently we tried to use the high limit to right size our
internal workloads. More specifically dynamically adjusting the limits
of the workload without letting the workload get oom-killed. However due
to the limitation of the implementation of high limit enforcement, we
observed the mechanism fails for some real workloads.

The high limit is enforced on return-to-userspace i.e. the kernel let
the usage goes over the limit and when the execution returns to
userspace, the high reclaim is triggered and the process can get
throttled as well. However this mechanism fails for workloads which do
large allocations in a single kernel entry e.g. applications that
mlock() a large chunk of memory in a single syscall. Such applications
bypass the high limit and can trigger the oom-killer.

To make high limit enforcement more robust, this patch makes the limit
enforcement synchronous only if the accumulated overcharge becomes
larger than MEMCG_CHARGE_BATCH. So, most of the allocations would still
be throttled on the return-to-userspace path but only the extreme
allocations which accumulates large amount of overcharge without
returning to the userspace will be throttled synchronously. The value
MEMCG_CHARGE_BATCH is a bit arbitrary but most of other places in the
memcg codebase uses this constant therefore for now uses the same one.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
Changes since v1:
- Based on Roman's comment simply the sync enforcement and only target
  the extreme cases.

 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 292b0b99a2c7..0da4be4798e7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2703,6 +2703,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
+	    !(current->flags & PF_MEMALLOC) &&
+	    gfpflags_allow_blocking(gfp_mask)) {
+		mem_cgroup_handle_over_high();
+	}
 	return 0;
 }
 
-- 
2.35.1.265.g69c8d7142f-goog

