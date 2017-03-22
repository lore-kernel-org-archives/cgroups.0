From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: rmap: fix huge file mmap accounting in the memcg stats
Date: Tue, 21 Mar 2017 20:51:11 -0400
Message-ID: <20170322005111.3156-1-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iz9iXlbKpjaFVzncHBpAExHzjlAt30Xcdgq+01Rx8oA=; b=TB0BhrjiL5C2FTyBGduebEqu4M
	hcfDrOl5bgLRFhJg7W5YyzsVDor6AKXpeA0ZtAS3rUBN7WXCkBf7q+lOcX57lO6Itq7Rhc7oytNhI
	vYFQAfmPVQUa3EjFsy37QxbKfCZSOlQdqisayxGP+CjhnwvMdzAtipLrsfSkC4inI7v8=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Huge pages are accounted as single units in the memcg's "file_mapped"
counter. Account the correct number of base pages, like we do in the
corresponding node counter.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/memcontrol.h | 6 ++++++
 mm/rmap.c                  | 4 ++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index baa274150210..c5ebb32fef49 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -741,6 +741,12 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
 	return false;
 }
 
+static inline void mem_cgroup_update_page_stat(struct page *page,
+					       enum mem_cgroup_stat_index idx,
+					       int nr)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff --git a/mm/rmap.c b/mm/rmap.c
index 1d82057144ba..f514cdd84482 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1154,7 +1154,7 @@ void page_add_file_rmap(struct page *page, bool compound)
 			goto out;
 	}
 	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, nr);
-	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
+	mem_cgroup_update_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, nr);
 out:
 	unlock_page_memcg(page);
 }
@@ -1194,7 +1194,7 @@ static void page_remove_file_rmap(struct page *page, bool compound)
 	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, -nr);
-	mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
+	mem_cgroup_update_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, -nr);
 
 	if (unlikely(PageMlocked(page)))
 		clear_page_mlock(page);
-- 
2.12.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
