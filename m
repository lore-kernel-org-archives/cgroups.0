From: lifeng68 <lifeng2221dd1@zoho.com.cn>
Subject: [PATCH] cpuset: Modify the type of use_parent_ecpus from int to bool
Date: Thu,  7 Jan 2021 11:29:16 +0800
Message-ID: <20210107032916.1097229-1-lifeng2221dd1@zoho.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, lifeng68 <lifeng2221dd1@zoho.com.cn>

Since the use_parent_ecpus in cpuset is only used as bool type, change
the type from int to bool.

Signed-off-by: lifeng68 <lifeng2221dd1@zoho.com.cn>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 53c70c470a38..c074e9f1064b 100644
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


