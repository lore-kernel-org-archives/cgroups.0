From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm, memcg: store memcg name for oom kill log consistency
Date: Thu, 5 Sep 2013 15:52:19 +0200
Message-ID: <20130905135219.GE13666@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1308282302450.14291@chino.kir.corp.google.com>
 <20130829133032.GB12077@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130829133032.GB12077-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 29-08-13 15:30:32, Michal Hocko wrote:
> On Wed 28-08-13 23:03:54, David Rientjes wrote:
> > A shared buffer is currently used for the name of the oom memcg and the
> > memcg of the killed process.  There is no serialization of memcg oom
> > kills, so this buffer can easily be overwritten if there is a concurrent
> > oom kill in another memcg.
> 
> Right.
> 
> > This patch stores the names of the memcgs directly in struct mem_cgroup.
> 
> I do not like to make every mem_cgroup larger even if it never sees an
> OOM.
> 
> Wouldn't it be much easier to add a new lock (memcg_oom_info_lock) inside
> mem_cgroup_print_oom_info instead? This would have a nice side effect
> that parallel memcg oom kill messages wouldn't interleave.

What about the following?
---
From 4cee36f56100f5689fe1ae22f468016ce5a0cbae Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Thu, 5 Sep 2013 15:39:20 +0200
Subject: [PATCH] memcg, oom: lock mem_cgroup_print_oom_info

mem_cgroup_print_oom_info uses a static buffer (memcg_name) to store the
name of the cgroup. This is not safe as pointed out by David Rientjes
because although memcg oom is locked for its hierarchy nothing prevents
another parallel hierarchy to trigger oom as well and overwrite the
already in-use buffer.

This patch introduces oom_info_lock hidden inside mem_cgroup_print_oom_info
which is held throughout the function. It make access to memcg_name safe
and as a bonus it also prevents parallel memcg ooms to interleave their
statistics which would make the printed data hard to analyze otherwise.

Using the spinlock is OK here because this path is not hot and
meaningful data is much more important.

Reported-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 mm/memcontrol.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b73988a..d436316 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1575,13 +1575,13 @@ static void move_unlock_mem_cgroup(struct mem_cgroup *memcg,
  */
 void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 {
-	struct cgroup *task_cgrp;
-	struct cgroup *mem_cgrp;
 	/*
-	 * Need a buffer in BSS, can't rely on allocations. The code relies
-	 * on the assumption that OOM is serialized for memory controller.
-	 * If this assumption is broken, revisit this code.
+	 * protects memcg_name and makes sure that parallel ooms do not
+	 * interleave
 	 */
+	static DEFINE_SPINLOCK(oom_info_lock);
+	struct cgroup *task_cgrp;
+	struct cgroup *mem_cgrp;
 	static char memcg_name[PATH_MAX];
 	int ret;
 	struct mem_cgroup *iter;
@@ -1590,6 +1590,7 @@ void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
 	if (!p)
 		return;
 
+	spin_lock(&oom_info_lock);
 	rcu_read_lock();
 
 	mem_cgrp = memcg->css.cgroup;
@@ -1658,6 +1659,7 @@ done:
 
 		pr_cont("\n");
 	}
+	spin_unlock(&oom_info_lock);
 }
 
 /*
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
