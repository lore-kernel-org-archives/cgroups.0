From: liuq <liuq131-Y1hxUtIYs7aGGVEaKU10Zw@public.gmane.org>
Subject: [PATCH] cgroup: /proc/cgroups output alignment
Date: Mon, 30 Jan 2023 16:58:18 +0800
Message-ID: <20230130085818.7847-1-liuq131@chinatelecom.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: liuq131-Y1hxUtIYs7aGGVEaKU10Zw@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liuq <liuq131-Y1hxUtIYs7aGGVEaKU10Zw@public.gmane.org>

/proc/cgroups output alignment for easy read

Signed-off-by: liuq <liuq131-Y1hxUtIYs7aGGVEaKU10Zw@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 52bb5a74a23b..ff82d61ae76f 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -670,14 +670,14 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 	struct cgroup_subsys *ss;
 	int i;
 
-	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
+	seq_puts(m, "#subsys_name        hierarchy     num_cgroups   enabled\n");
 	/*
 	 * Grab the subsystems state racily. No need to add avenue to
 	 * cgroup_mutex contention.
 	 */
 
 	for_each_subsys(ss, i)
-		seq_printf(m, "%s\t%d\t%d\t%d\n",
+		seq_printf(m, "%-20s%-14d%-14d%-14d\n",
 			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps),
 			   cgroup_ssid_enabled(i));
-- 
2.27.0

