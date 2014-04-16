From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] mm: memcontrol: remove hierarchy restrictions for swappiness and oom_control
Date: Wed, 16 Apr 2014 17:13:18 -0400
Message-ID: <1397682798-22906-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=UH7/Ud+LB8wUL4eDHew2WbiE8Dd/FWT8Z/qPTvlYsW0=;
	b=safFNuKAEANEyqeiOz9FG5lxRQZwka2TKDYCtj1boLBEo7w6bfr1Fs1G7fI7m0ZrENJkjQDPYYNSoiixjHLnaO/AZOeLeIQ4F/pwTOWi78xQaTrqQ2b77iDlYAAmwZZ1TZBige8rEyGCMH1Sv9PGY3Uwn88rJk8YXA58RwNaWtU=;
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Per-memcg swappiness and oom killing can currently not be tweaked on a
memcg that is part of a hierarchy, but not the root of that hierarchy.
Users have complained that they can't configure this when they turned
on hierarchy mode.  In fact, with hierarchy mode becoming the default,
this restriction disables the tunables entirely.

But there is no good reason for this restriction.  The settings for
swappiness and OOM killing are taken from whatever memcg whose limit
triggered reclaim and OOM invocation, regardless of its position in
the hierarchy tree.

Allow setting swappiness on any group.  The knob on the root memcg
already reads the global VM swappiness, make it writable as well.

Allow disabling the OOM killer on any non-root memcg.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2a0d3986c74..edcc9513b419 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5548,22 +5548,14 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
 				       struct cftype *cft, u64 val)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
-	if (val > 100 || !parent)
+	if (val > 100)
 		return -EINVAL;
 
-	mutex_lock(&memcg_create_mutex);
-
-	/* If under hierarchy, only empty-root can set this value */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		mutex_unlock(&memcg_create_mutex);
-		return -EINVAL;
-	}
-
-	memcg->swappiness = val;
-
-	mutex_unlock(&memcg_create_mutex);
+	if (css_parent(css))
+		memcg->swappiness = val;
+	else
+		vm_swappiness = val;
 
 	return 0;
 }
@@ -5895,22 +5887,15 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	struct cftype *cft, u64 val)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
 	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!parent || !((val == 0) || (val == 1)))
+	if (!css_parent(css) || !((val == 0) || (val == 1)))
 		return -EINVAL;
 
-	mutex_lock(&memcg_create_mutex);
-	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
-		mutex_unlock(&memcg_create_mutex);
-		return -EINVAL;
-	}
 	memcg->oom_kill_disable = val;
 	if (!val)
 		memcg_oom_recover(memcg);
-	mutex_unlock(&memcg_create_mutex);
+
 	return 0;
 }
 
-- 
1.9.2
