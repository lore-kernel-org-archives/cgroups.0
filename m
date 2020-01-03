From: Wei Yang <richardw.yang@linux.intel.com>
Subject: [RFC PATCH] mm: thp: grab the lock before manipulation defer list
Date: Fri,  3 Jan 2020 22:34:07 +0800
Message-ID: <20200103143407.1089-1-richardw.yang@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc: kirill.shutemov@linux.intel.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, yang.shi@linux.alibaba.com, Wei Yang <richardw.yang@linux.intel.com>

As all the other places, we grab the lock before manipulate the defer list.
Current implementation may face a race condition.

Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>

---
I notice the difference during code reading and just confused about the
difference. No specific test is done since limited knowledge about cgroup.

Maybe I miss something important?
---
 mm/memcontrol.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bc01423277c5..62b7ec34ef1a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5368,12 +5368,12 @@ static int mem_cgroup_move_account(struct page *page,
 	}
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	spin_lock(&from->deferred_split_queue.split_queue_lock);
 	if (compound && !list_empty(page_deferred_list(page))) {
-		spin_lock(&from->deferred_split_queue.split_queue_lock);
 		list_del_init(page_deferred_list(page));
 		from->deferred_split_queue.split_queue_len--;
-		spin_unlock(&from->deferred_split_queue.split_queue_lock);
 	}
+	spin_unlock(&from->deferred_split_queue.split_queue_lock);
 #endif
 	/*
 	 * It is safe to change page->mem_cgroup here because the page
@@ -5385,13 +5385,13 @@ static int mem_cgroup_move_account(struct page *page,
 	page->mem_cgroup = to;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	spin_lock(&to->deferred_split_queue.split_queue_lock);
 	if (compound && list_empty(page_deferred_list(page))) {
-		spin_lock(&to->deferred_split_queue.split_queue_lock);
 		list_add_tail(page_deferred_list(page),
 			      &to->deferred_split_queue.split_queue);
 		to->deferred_split_queue.split_queue_len++;
-		spin_unlock(&to->deferred_split_queue.split_queue_lock);
 	}
+	spin_unlock(&to->deferred_split_queue.split_queue_lock);
 #endif
 
 	spin_unlock_irqrestore(&from->move_lock, flags);
-- 
2.17.1

