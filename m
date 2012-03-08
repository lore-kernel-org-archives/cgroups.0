From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch] mm, memcg: do not allow tasks to be attached with zero
 limit
Date: Wed, 7 Mar 2012 19:14:49 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1203071914150.15244@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        bh=Un2fTCFWU3O4D9oIXbxkMKwZl08gkjcFvEOv4hcFKBs=;
        b=Pv2ic0dGtmcC8QLZgLWFgv9QHSuIxBHCszm68xXkcLaqhx/tcU1w64MHnnmzxbppey
         b31SrU/FJcb+pZ0UZ7UP3518pCYZh9Ym/gus6Q46/44ToiJ/53Jd6W5oG697j0E+sMca
         jq9O0kXe4cer2e2j6kTtkrKlzKmH+bCQMMyJKpmGG2Ont8V0O9U6hC2dzBgMFQcX1YNW
         g5/ObmPltCgrIF4Ac78m0cowV9Nn2cGZY4MLu0g+93XPOmB8lVAGE2wHuUXAfFIs5DIU
         dtkE4nLnZ9xpyrwUfNQsMESsE76W+i9s1rnlhYjuFuB5cYdWADKBh7nSmi1989+KugA6
         xHiw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

This patch prevents tasks from being attached to a memcg if there is a
hard limit of zero.  Additionally, the hard limit may not be changed to
zero if there are tasks attached.

This is consistent with cpusets which do not allow tasks to be attached
if there are no mems and prevents all mems from being removed if there
are tasks attached.

Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3868,9 +3868,14 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 		ret = res_counter_memparse_write_strategy(buffer, &val);
 		if (ret)
 			break;
-		if (type == _MEM)
+		if (type == _MEM) {
+			/* Don't allow zero limit with tasks attached */
+			if (!val && cgroup_task_count(cont)) {
+				ret = -ENOSPC;
+				break;
+			}
 			ret = mem_cgroup_resize_limit(memcg, val);
-		else
+		} else
 			ret = mem_cgroup_resize_memsw_limit(memcg, val);
 		break;
 	case RES_SOFT_LIMIT:
@@ -5306,6 +5311,10 @@ static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
 	int ret = 0;
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
 
+	/* Don't allow tasks attached with a zero limit */
+	if (!res_counter_read_u64(&memcg->res, RES_LIMIT))
+		return -ENOSPC;
+
 	if (memcg->move_charge_at_immigrate) {
 		struct mm_struct *mm;
 		struct mem_cgroup *from = mem_cgroup_from_task(p);
