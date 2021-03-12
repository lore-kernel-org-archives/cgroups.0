From: Li Feng <lifeng2221dd1@zoho.com.cn>
Subject: [PATCH] cpuset: Modify the type of use_parent_ecpus from int to bool
Date: Fri, 12 Mar 2021 16:08:56 +0800
Message-ID: <20210312080856.307010-1-lifeng2221dd1@zoho.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Feng <lifeng2221dd1@zoho.com.cn>

Since the use_parent_ecpus in cpuset is only used as bool type, change
the type from int to bool.

Signed-off-by: Li Feng <lifeng2221dd1@zoho.com.cn>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5258b68153e0..ab0bf3cc7093 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -158,7 +158,7 @@ struct cpuset {
 	 * use_parent_ecpus - set if using parent's effective_cpus
 	 * child_ecpus_count - # of children with use_parent_ecpus set
 	 */
-	int use_parent_ecpus;
+	bool use_parent_ecpus;
 	int child_ecpus_count;
 };
 
-- 
2.25.1


