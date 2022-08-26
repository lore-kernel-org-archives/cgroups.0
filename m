From: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [RFC 1/2] cgroup: Introduce per-cgroup resource top show interface
Date: Fri, 26 Aug 2022 09:15:02 +0800
Message-ID: <20220826011503.103894-2-lujialin4@huawei.com>
References: <20220826011503.103894-1-lujialin4@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220826011503.103894-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

From: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

This patch introduces cgroup.top interface for each cgroup. When
accessed by userspace, cgroup.top is able to:
1. Sort cgroups by their usage on various resources(e.g. memory, cpu, etc.)
2. Display resource usage status on all child cgroups.

Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Co-developed-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup-defs.h |  1 +
 kernel/cgroup/cgroup.c      | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 4bcf56b3491c..ba11e09f8f03 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -651,6 +651,7 @@ struct cgroup_subsys {
 	int (*css_extra_stat_show)(struct seq_file *seq,
 				   struct cgroup_subsys_state *css);
 
+	void (*css_top)(struct cgroup_subsys_state *css, struct seq_file *seq);
 	int (*can_attach)(struct cgroup_taskset *tset);
 	void (*cancel_attach)(struct cgroup_taskset *tset);
 	void (*attach)(struct cgroup_taskset *tset);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ffaccd6373f1..01bd1a734a01 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3867,6 +3867,22 @@ static ssize_t cgroup_kill_write(struct kernfs_open_file *of, char *buf,
 	return ret ?: nbytes;
 }
 
+static int cgroup_top_show(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct cgroup_subsys_state *css;
+	int ssid;
+
+	rcu_read_lock();
+	for_each_css(css, ssid, cgrp) {
+		if (css->ss->css_top)
+			css->ss->css_top(css, seq);
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
 static int cgroup_file_open(struct kernfs_open_file *of)
 {
 	struct cftype *cft = of_cft(of);
@@ -5125,6 +5141,10 @@ static struct cftype cgroup_base_files[] = {
 		.release = cgroup_pressure_release,
 	},
 #endif /* CONFIG_PSI */
+	{
+		.name = "cgroup.top",
+		.seq_show = cgroup_top_show,
+	},
 	{ }	/* terminate */
 };
 
-- 
2.17.1

