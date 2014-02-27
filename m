From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 2/2] cpuset: fix a race condition in __cpuset_node_allowed_softwall()
Date: Thu, 27 Feb 2014 18:19:36 +0800
Message-ID: <530F1138.2090903@huawei.com>
References: <530F1117.1020605@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <530F1117.1020605@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

It's not safe to access task's cpuset after releasing task_lock().
Holding callback_mutex won't help.

Cc: <stable@vger.kernel.org>
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 5f50ec6..c63a0d9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2412,9 +2412,9 @@ int __cpuset_node_allowed_softwall(int node, gfp_t gfp_mask)
 
 	task_lock(current);
 	cs = nearest_hardwall_ancestor(task_cs(current));
+	allowed = node_isset(node, cs->mems_allowed);
 	task_unlock(current);
 
-	allowed = node_isset(node, cs->mems_allowed);
 	mutex_unlock(&callback_mutex);
 	return allowed;
 }
-- 
1.8.0.2
