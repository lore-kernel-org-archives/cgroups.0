From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: [PATCH v4 2/9] mm/huge_memory: fix uninitialized compiler warning
Date: Tue, 19 Nov 2019 20:23:16 +0800
Message-ID: <1574166203-151975-3-git-send-email-alex.shi@linux.alibaba.com>
References: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1574166203-151975-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, willy@infradead.org, shakeelb@google.com, hannes@cmpxchg.org
Cc: Alex Shi <alex.shi@linux.alibaba.com>

../mm/huge_memory.c: In function ‘split_huge_page_to_list’:
../mm/huge_memory.c:2766:9: warning: ‘flags’ may be used uninitialized
in this function [-Wmaybe-uninitialized]
  lruvec = lock_page_lruvec_irqsave(head, pgdata, flags);
  ~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 13cc93785006..4cdfdbeb6b2b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2699,7 +2699,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	struct address_space *mapping = NULL;
 	int count, mapcount, extra_pins, ret;
 	bool mlocked;
-	unsigned long flags;
+	unsigned long flags = 0;
 	pgoff_t end;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
-- 
1.8.3.1

