From: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [Patch v3] mm: thp: grab the lock before manipulation defer list
Date: Thu, 16 Jan 2020 09:31:00 +0800
Message-ID: <20200116013100.7679-1-richardw.yang@linux.intel.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

As all the other places, we grab the lock before manipulate the defer list.
Current implementation may face a race condition.

For example, the potential race would be:

    CPU1                      CPU2
    mem_cgroup_move_account   deferred_split_huge_page
      list_empty
                                lock
                                list_empty
                                list_add_tail
                                unlock
      lock
      # list_empty might not hold anymore
      list_add_tail
      unlock

When this sequence happens, the list_add_tail() in
mem_cgroup_move_account() corrupt the list since which is already been
added to some split_queue in split_huge_page_to_list().

Besides this, David Rientjes points out the split_queue_len would be in
a wrong state, which would be a significant issue for shrinkers.

Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")

Signed-off-by: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>    [5.4+]

---
v3:
  * remove all review/ack tag since rewrite the changelog
  * use deferred_split_huge_page as the example of race
  * add cc stable 5.4+ tag as suggested by David Rientjes

v2:
  * move check on compound outside suggested by Alexander
  * an example of the race condition, suggested by Michal
---
 mm/memcontrol.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c5b5f74cfd4d..6450bbe394e2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5360,10 +5360,12 @@ static int mem_cgroup_move_account(struct page *page,
 	}
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && !list_empty(page_deferred_list(page))) {
+	if (compound) {
 		spin_lock(&from->deferred_split_queue.split_queue_lock);
-		list_del_init(page_deferred_list(page));
-		from->deferred_split_queue.split_queue_len--;
+		if (!list_empty(page_deferred_list(page))) {
+			list_del_init(page_deferred_list(page));
+			from->deferred_split_queue.split_queue_len--;
+		}
 		spin_unlock(&from->deferred_split_queue.split_queue_lock);
 	}
 #endif
@@ -5377,11 +5379,13 @@ static int mem_cgroup_move_account(struct page *page,
 	page->mem_cgroup = to;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (compound && list_empty(page_deferred_list(page))) {
+	if (compound) {
 		spin_lock(&to->deferred_split_queue.split_queue_lock);
-		list_add_tail(page_deferred_list(page),
-			      &to->deferred_split_queue.split_queue);
-		to->deferred_split_queue.split_queue_len++;
+		if (list_empty(page_deferred_list(page))) {
+			list_add_tail(page_deferred_list(page),
+				      &to->deferred_split_queue.split_queue);
+			to->deferred_split_queue.split_queue_len++;
+		}
 		spin_unlock(&to->deferred_split_queue.split_queue_lock);
 	}
 #endif
-- 
2.17.1

