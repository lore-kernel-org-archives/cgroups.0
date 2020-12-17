From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 1/3] mm/memcg: revise the using condition of lock_page_lruvec function series
Date: Thu, 17 Dec 2020 14:28:50 +0800
Message-ID: <1608186532-81218-1-git-send-email-alex.shi@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The series function could be used under lock_page_memcg(), add this and
a bit style changes following commit_charge().

Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 mm/memcontrol.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b80328f52fb4..e6b50d068b2f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1345,10 +1345,11 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
  * lock_page_lruvec - lock and return lruvec for a given page.
  * @page: the page
  *
- * This series functions should be used in either conditions:
- * PageLRU is cleared or unset
- * or page->_refcount is zero
- * or page is locked.
+ * This series functions should be used in any one of following conditions:
+ * - PageLRU is cleared or unset
+ * - page->_refcount is zero
+ * - page is locked.
+ * - lock_page_memcg()
  */
 struct lruvec *lock_page_lruvec(struct page *page)
 {
-- 
2.29.GIT

