From: chengkaitao <pilgrimtao@gmail.com>
Subject: [PATCH v2] mm: cleanup some useless code
Date: Tue, 10 Dec 2019 08:04:50 -0800
Message-ID: <20191210160450.3395-1-pilgrimtao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emGhzWuhNPjt1BJOm+vTsDQa4JuHnONtolq4L0YAYQ8=;
        b=eny3JXx2eahzZo3X31J0NB5EmLHKTOLzfIfOxR4z3ENiB1Iof+3JuFqpyvxRWvP4Pu
         fTylmtLSdoRXhWcJpw6qqXHQo3alRswnSIpp0AnOv6CzOgaxFODrXQWyIjvEwZEsrIB4
         WmCMT9eiUFYON+w7Ci5J22Zo5o+uMk5PDckFgxqAaEocNlmYdSm8fZHFeXRis1P+lrjQ
         DqGC8eVJXFytcZFNdUpWzOD/tLgWw6HWuFcaFbjO9acQjWg38quHgp5HUFwE8mHGKjGD
         RGaVQeqzNVgpLerJQ23QVALPzOL8cZStwWdXtH73Rnb56gTLJRufPy1w7SjKlZJuPiBb
         dXhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org
Cc: mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, smuchun@gmail.com, Kaitao Cheng <pilgrimtao@gmail.com>, Michal Hocko <mhocko@suse.com>

From: Kaitao Cheng <pilgrimtao@gmail.com>

Compound pages handling in mem_cgroup_migrate is more convoluted than
necessary. The state is duplicated in compound variable and the same
could be achieved by PageTransHuge check which is trivial and
hpage_nr_pages is already PageTransHuge aware.

It is much simpler to just use hpage_nr_pages for nr_pages and replace
the local variable by PageTransHuge check directly

Signed-off-by: Kaitao Cheng <pilgrimtao@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
Change in v2:
	Update commit message

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

