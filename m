From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 06/12] cpuset: initialize top_cpuset's configured masks
 at mount
Date: Wed, 9 Jul 2014 16:48:01 +0800
Message-ID: <53BD01C1.9080308@huawei.com>
References: <53BD0174.4060002@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53BD0174.4060002-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

We now have to support different behaviors for default hierachy and
legacy hiearchy, top_cpuset's configured masks need to be initialized
accordingly.

Suppose we've offlined cpu1.

On default hierarchy:

	# mount -t cgroup -o __DEVEL__sane_behavior xxx /cpuset
	# cat /cpuset/cpuset.cpus
	0-15

On legacy hierarchy:

	# mount -t cgroup xxx /cpuset
	# cat /cpuset/cpuset.cpus
	0,2-15

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 60577cc..e4c31e6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2015,16 +2015,35 @@ static void cpuset_css_free(struct cgroup_subsys_state *css)
 	kfree(cs);
 }
 
+static void cpuset_bind(struct cgroup_subsys_state *root_css)
+{
+	mutex_lock(&cpuset_mutex);
+	mutex_lock(&callback_mutex);
+
+	if (cgroup_on_dfl(root_css->cgroup)) {
+		cpumask_copy(top_cpuset.cpus_allowed, cpu_possible_mask);
+		top_cpuset.mems_allowed = node_possible_map;
+	} else {
+		cpumask_copy(top_cpuset.cpus_allowed,
+			     top_cpuset.effective_cpus);
+		top_cpuset.mems_allowed = top_cpuset.effective_mems;
+	}
+
+	mutex_unlock(&callback_mutex);
+	mutex_unlock(&cpuset_mutex);
+}
+
 struct cgroup_subsys cpuset_cgrp_subsys = {
-	.css_alloc = cpuset_css_alloc,
-	.css_online = cpuset_css_online,
-	.css_offline = cpuset_css_offline,
-	.css_free = cpuset_css_free,
-	.can_attach = cpuset_can_attach,
-	.cancel_attach = cpuset_cancel_attach,
-	.attach = cpuset_attach,
-	.base_cftypes = files,
-	.early_init = 1,
+	.css_alloc	= cpuset_css_alloc,
+	.css_online	= cpuset_css_online,
+	.css_offline	= cpuset_css_offline,
+	.css_free	= cpuset_css_free,
+	.can_attach	= cpuset_can_attach,
+	.cancel_attach	= cpuset_cancel_attach,
+	.attach		= cpuset_attach,
+	.bind		= cpuset_bind,
+	.base_cftypes	= files,
+	.early_init	= 1,
 };
 
 /**
-- 
1.8.0.2
