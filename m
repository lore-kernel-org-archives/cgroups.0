From: Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: remove pcp_counter_lock
Date: Tue, 22 Sep 2015 19:41:46 -0700
Message-ID: <1442976106-49685-1-git-send-email-gthelen@google.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=P4y8syGQm8oJbOTi5nmAffr81iru9GppnmXqhfqJJvg=;
        b=UbpGTKMKIQlyIqxJ5H3/qbN+m99QjQMM8C2MwiJ+QnkcOtrwPSbJZhRXHgkCEejtl9
         ZrNa2mjnDvUcny1MCzIa1IZNAXW3e4eK2RJsFJCN7dGzfHlDx08cJ7F4a2OZHOWxOaxO
         taDbYtD3Robw9vBPUrCvG3FOhQUPq5ycLjeaCQuGoJoUdEmYdjdlfe1qPT6PBa87B6sq
         DBJnkKtgKd66skQ0nDH4/OdhQbl5PAaLWzB5PXJ109MoNEJJXeUy5SOwlp4D9KC72/pq
         PeUVbT/FKJJzJ6vAv4JoAMW0hbRRq45jRVMSNtsOUy7bgeq59RUS/6IEUCJMqapxNlTe
         Idbg==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Greg Thelen <gthelen@google.com>

Commit 733a572e66d2 ("memcg: make mem_cgroup_read_{stat|event}() iterate
possible cpus instead of online") removed the last use of the per memcg
pcp_counter_lock but forgot to remove the variable.

Kill the vestigial variable.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 include/linux/memcontrol.h | 1 -
 mm/memcontrol.c            | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ad800e62cb7a..6452ff4c463f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -242,7 +242,6 @@ struct mem_cgroup {
 	 * percpu counter.
 	 */
 	struct mem_cgroup_stat_cpu __percpu *stat;
-	spinlock_t pcp_counter_lock;
 
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_INET)
 	struct cg_proto tcp_mem;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6ddaeba34e09..da21143550c0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4179,7 +4179,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
 		goto out_free_stat;
 
-	spin_lock_init(&memcg->pcp_counter_lock);
 	return memcg;
 
 out_free_stat:
-- 
2.6.0.rc0.131.gf624c3d

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
