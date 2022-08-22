From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for low/min
Date: Mon, 22 Aug 2022 00:17:35 +0000
Message-ID: <20220822001737.4120417-2-shakeelb@google.com>
References: <20220822001737.4120417-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=PKFRaxD4qQqEIFqu3chPSEEEaimoA7SPNFa30ZMS/uU=;
        b=HizZvrBQiCe/lTGkboVezrNH98vpHv6pPqN3AxEJH/hFrU99YqU4n2tDb7vx0BDvjD
         bQrrXzlJxZNS5VEi+6ur1985jYp1mqaVxFam9zQg29fgy4j8FDwrvk2EWIEw9zZcLyy8
         ZrbSnLWlxJzAlcK4inCb0YBuOPVU8Pf6wgn3U0AS+YKBi3N8fLf+SDkLifHnsuVpXtE9
         VW+MgYxWYsl4FT5vPrWtjoQKUyoGIDwGhmbfEnhOfVukKNjsvqjWPYthJA+lrTU4JyRJ
         Sj3VMg2YYPUcwhLJDwgqi0QQBI7r5yYyU5d+lRAwuifJcVjqGV647qwS/PzhpquTv4FZ
         z7vQ==
In-Reply-To: <20220822001737.4120417-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

For cgroups using low or min protections, the function
propagate_protected_usage() was doing an atomic xchg() operation
irrespectively. It only needs to do that operation if the new value of
protection is different from older one. This patch does that.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy with top
level having min and low setup appropriately. More specifically
memory.min equal to size of netperf binary and memory.low double of
that.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)	10482.7 Mbps
With patch		14542.5 Mbps (38.7% improvement)

With the patch, the throughput improved by 38.7%

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Reported-by: kernel test robot <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 mm/page_counter.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index eb156ff5d603..47711aa28161 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
 				      unsigned long usage)
 {
 	unsigned long protected, old_protected;
-	unsigned long low, min;
 	long delta;
 
 	if (!c->parent)
 		return;
 
-	min = READ_ONCE(c->min);
-	if (min || atomic_long_read(&c->min_usage)) {
-		protected = min(usage, min);
+	protected = min(usage, READ_ONCE(c->min));
+	old_protected = atomic_long_read(&c->min_usage);
+	if (protected != old_protected) {
 		old_protected = atomic_long_xchg(&c->min_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
 			atomic_long_add(delta, &c->parent->children_min_usage);
 	}
 
-	low = READ_ONCE(c->low);
-	if (low || atomic_long_read(&c->low_usage)) {
-		protected = min(usage, low);
+	protected = min(usage, READ_ONCE(c->low));
+	old_protected = atomic_long_read(&c->low_usage);
+	if (protected != old_protected) {
 		old_protected = atomic_long_xchg(&c->low_usage, protected);
 		delta = protected - old_protected;
 		if (delta)
-- 
2.37.1.595.g718a3a8f04-goog

