From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v2 06/12] cpuset: initialize top_cpuset's configured masks
 at mount
Date: Fri, 11 Oct 2013 17:50:50 +0800
Message-ID: <5257C9FA.8080306@huawei.com>
References: <5257C9A1.1030404@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5257C9A1.1030404@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

As we now have to support both sane_behavior and !sane_behavior,
top_cpuset's configured masks need to be initialized accordingly.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 360e547..5c53ba5 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2113,8 +2113,27 @@ static void cpuset_css_free(struct cgroup_subsys_state *css)
 	kfree(cs);
 }
 
+void cpuset_bind(struct cgroup_subsys_state *root_css)
+{
+	mutex_lock(&cpuset_mutex);
+	mutex_lock(&callback_mutex);
+
+	if (cgroup_sane_behavior(root_css->cgroup)) {
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
 struct cgroup_subsys cpuset_subsys = {
 	.name = "cpuset",
+	.bind = cpuset_bind,
 	.css_alloc = cpuset_css_alloc,
 	.css_online = cpuset_css_online,
 	.css_offline = cpuset_css_offline,
-- 
1.8.0.2
