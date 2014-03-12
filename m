From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 1/8] mm: memcg: remove unnecessary preemption disabling
Date: Tue, 11 Mar 2014 21:28:27 -0400
Message-ID: <1394587714-6966-2-git-send-email-hannes@cmpxchg.org>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=AeW58hWgkcIOOfIHSgdCoxVahxCgDkDagmRBqrFQnO0=;
	b=L6PKRRwlRMR5yNedjuZDQo4io5zILiEXjonTZAqCUt/1zF6A2v6EGHRPNyqKpZ/eJaQo74xB0SeptN6Q4JVC0SYC4wafAB9fq9NnxVLnKsFiz8PZ+jFWiX0fXdamGs24nZN1Nz1VRAQxje7+K21MePzqpQrLy2144lqgFgtOiI4=;
In-Reply-To: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

lock_page_cgroup() disables preemption, remove explicit preemption
disabling for code paths holding this lock.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5b6b0039f725..393864c162ac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -921,8 +921,6 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 struct page *page,
 					 bool anon, int nr_pages)
 {
-	preempt_disable();
-
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
 	 * counted as CACHE even if it's on ANON LRU.
@@ -947,8 +945,6 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	}
 
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
-
-	preempt_enable();
 }
 
 unsigned long
@@ -3780,17 +3776,14 @@ void mem_cgroup_split_huge_fixup(struct page *head)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static inline
-void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
-					struct mem_cgroup *to,
-					unsigned int nr_pages,
-					enum mem_cgroup_stat_index idx)
+static void mem_cgroup_move_account_page_stat(struct mem_cgroup *from,
+					      struct mem_cgroup *to,
+					      unsigned int nr_pages,
+					      enum mem_cgroup_stat_index idx)
 {
 	/* Update stat data for mem_cgroup */
-	preempt_disable();
 	__this_cpu_sub(from->stat->count[idx], nr_pages);
 	__this_cpu_add(to->stat->count[idx], nr_pages);
-	preempt_enable();
 }
 
 /**
-- 
1.9.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
