From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH RFC] mm/memcg: calculate max hierarchy limit number instead of min
Date: Wed, 11 Jul 2012 21:24:41 +0800
Message-ID: <1342013081-4096-1-git-send-email-liwp.linux@gmail.com>
References: <a>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=pPpdAEiBhMV66R+esQphDwFibNx8MqmmxlvstCNHypo=;
        b=CDaON2O3H6VkOc+hhZCV8TbM1OR+LTXZWSRUY0yrJtgjX/M+iRjpGZ/PSy7HM1CGkL
         jdimPsyv1788vMFJVWL+EW/TKd9gjpV8ej7sKTpoz0RV3P59aCfa0PPPeRgstVNsnS3F
         VNVtRO5Py3TWL13cjjTJMfsOo3GXZHnrBM5u4wk3vcYYPwZwM8taVNj9Hnfhnihxj2cI
         QZxbu04aZ/UMXtqoVQcliNMD+1F6hkNwy9kfU49aB2mMzEyo5FPsd6p5sIkLSH5CYMNj
         9tsGjr6Rx/TNnGa7CPpTybtfbH0UACrWPbWAF2+M2ZSI++gG8h3INAxjtdKH8bZOesRF
         Bv8g==
In-Reply-To: <a>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

Since hierachical_memory_limit shows "of bytes of memory limit with
regard to hierarchy under which the memory cgroup is", the count should
calculate max hierarchy limit when use_hierarchy in order to show hierarchy
subtree limit. hierachical_memsw_limit is the same case.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/memcontrol.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 69a7d45..6392c0a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3929,10 +3929,10 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
 		unsigned long long *mem_limit, unsigned long long *memsw_limit)
 {
 	struct cgroup *cgroup;
-	unsigned long long min_limit, min_memsw_limit, tmp;
+	unsigned long long max_limit, max_memsw_limit, tmp;
 
-	min_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
-	min_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+	max_limit = res_counter_read_u64(&memcg->res, RES_LIMIT);
+	max_memsw_limit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
 	cgroup = memcg->css.cgroup;
 	if (!memcg->use_hierarchy)
 		goto out;
@@ -3943,13 +3943,13 @@ static void memcg_get_hierarchical_limit(struct mem_cgroup *memcg,
 		if (!memcg->use_hierarchy)
 			break;
 		tmp = res_counter_read_u64(&memcg->res, RES_LIMIT);
-		min_limit = min(min_limit, tmp);
+		max_limit = max(max_limit, tmp);
 		tmp = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
-		min_memsw_limit = min(min_memsw_limit, tmp);
+		max_memsw_limit = max(max_memsw_limit, tmp);
 	}
 out:
-	*mem_limit = min_limit;
-	*memsw_limit = min_memsw_limit;
+	*mem_limit = max_limit;
+	*memsw_limit = max_memsw_limit;
 }
 
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
-- 
1.7.5.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
