From: chengkaitao <pilgrimtao@gmail.com>
Subject: [PATCH] mm: cleanup some useless code
Date: Tue, 10 Dec 2019 05:49:10 -0800
Message-ID: <20191210134911.2570-1-pilgrimtao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2GTyISog1VX8yYAJFI+c/tQ5PL+DROiS/ITcUOlh5Cs=;
        b=c0FEADODck6cpIJJgtjKYAmemgt9mpnPLYw9O4bu5TW3TNCwI8b5q6ij8BkpCd0nYy
         6WxeFlUsOR7ofa8ZCWHs2hL8pJhGd7QjnStKiCJQkdx9MmdUCP2gGFzs4F8ZOLi1AUq1
         XYKwagD4yz/ZaQSs00mW5W5UC8JxZU1zLoHRSeDLI20r60Mw+pFb95bJtmHUs87j3z6U
         7vq+E8Gwe5pO9Zd2/h8+yHu/llz8RZR6RilV1lzKEupKwljmIfGEce8rCkKB5Zg3RVrw
         eXHGyM0pFtCiBBgQELyAUveIWL7Dc/o9mCkNnlBczw5Oejrclpe54hMvdzAAl5QZ6XTQ
         nJtA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org
Cc: mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, smuchun@gmail.com, Kaitao Cheng <pilgrimtao@gmail.com>

From: Kaitao Cheng <pilgrimtao@gmail.com>

There is a duplicate PageTransHuge, because hpage_nr_pages have
the same one.

Signed-off-by: Kaitao Cheng <pilgrimtao@gmail.com>
---
 mm/memcontrol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bc01423277c5..870284d3ee9d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6678,7 +6678,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 {
 	struct mem_cgroup *memcg;
 	unsigned int nr_pages;
-	bool compound;
 	unsigned long flags;
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
@@ -6700,8 +6699,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 		return;
 
 	/* Force-charge the new page. The old one will be freed soon */
-	compound = PageTransHuge(newpage);
-	nr_pages = compound ? hpage_nr_pages(newpage) : 1;
+	nr_pages = hpage_nr_pages(newpage);
 
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
@@ -6711,7 +6709,8 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
 	commit_charge(newpage, memcg, false);
 
 	local_irq_save(flags);
-	mem_cgroup_charge_statistics(memcg, newpage, compound, nr_pages);
+	mem_cgroup_charge_statistics(memcg, newpage, PageTransHuge(newpage),
+			nr_pages);
 	memcg_check_events(memcg, newpage);
 	local_irq_restore(flags);
 }
-- 
2.20.1

