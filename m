From: chai wen <chaiw.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] cgroup: pretty format of /proc/cgoups stats showing
Date: Wed, 2 Jul 2014 16:24:38 +0800
Message-ID: <1404289478-5554-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chai wen <chaiw.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Just make /proc/cgroups have a better appearance, the original is a little
misleading as its print format.

Before:
#subsys_name	hierarchy	num_cgroups	enabled
cpuset	0	1	1
cpu	0	1	1
cpuacct	0	1	1
devices	0	1	1
freezer	0	1	1
net_cls	0	1	1
blkio	0	1	1
perf_event	0	1	1

After:
#subsys_name       hierarchy          num_groups         enabled           
cpuset             0                  1                  1                 
cpu                0                  1                  1                 
cpuacct            0                  1                  1                 
devices            0                  1                  1                 
freezer            0                  1                  1                 
net_cls            0                  1                  1                 
blkio              0                  1                  1                 
perf_event         0                  1                  1                 


Signed-off-by: chai wen <chaiw.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 kernel/cgroup.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7868fc3..54c839e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4883,7 +4883,8 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	struct cgroup_subsys *ss;
 	int i;
 
-	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
+	seq_printf(m, "%-18s %-18s %-18s %-18s\n", "#subsys_name", "hierarchy",
+		   "num_groups", "enabled");
 	/*
 	 * ideally we don't want subsystems moving around while we do this.
 	 * cgroup_mutex is also necessary to guarantee an atomic snapshot of
@@ -4892,7 +4893,7 @@ static int proc_cgroupstats_show(struct seq_file *m, void *v)
 	mutex_lock(&cgroup_mutex);
 
 	for_each_subsys(ss, i)
-		seq_printf(m, "%s\t%d\t%d\t%d\n",
+		seq_printf(m, "%-18s %-18d %-18d %-18d\n",
 			   ss->name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps), !ss->disabled);
 
-- 
1.7.1
