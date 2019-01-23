From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] cpuset: drop pointless static qualifier in cpuset_hotplug_workfn
Date: Wed, 23 Jan 2019 16:47:32 +0800
Message-ID: <20190123084732.15400-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

There is no need to have the 'new_mems' variable static since new
value always be assigned before use it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 843829b..df6edac 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3106,7 +3106,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 static void cpuset_hotplug_workfn(struct work_struct *work)
 {
 	static cpumask_t new_cpus;
-	static nodemask_t new_mems;
+	nodemask_t new_mems;
 	bool cpus_updated, mems_updated;
 	bool on_dfl = is_in_v2_mode();
 	struct tmpmasks tmp, *ptmp = NULL;
-- 
2.7.0


