From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: [PATCH] mm/workingset: do not forget to unlock page
Date: Wed,  3 Feb 2016 18:58:33 +0900
Message-ID: <1454493513-19316-1-git-send-email-sergey.senozhatsky@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=kA0jMxElWFXf/Z6CEqzW1/n8NsPkHEMu0tQ7thU2L4E=;
        b=n2c5+5en3wwnvKHpXIPyTkwq6i/C+OqY75w0I6uK2gWnihrhFJrVSzrYBfxPi7ZRB4
         sm2QdqVvETSJFiQoUme3h85zXomKSc4h04e5aCksjkPNQCK4WNJPuQ5rJg+ATRGs76Nu
         WwnYiRFET51HSJdrLO6t/gzmyq7gBw5UhP8k891TnXmHLnZj46QPQMbjlcKa7/9fDpqC
         hgWcKIDzhukBFcJNDFiAN5LpghxFRRJoicZ1OYcj7xjYWd3RiuljYFsX4teyDZ+BRyV7
         3aGr7KuraEFidellXkxkV+AP5018l3LyPC6b2E2/AY4Ffe4koQG3GIorLHn8DOqO1yRi
         olUg==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Do not leave page locked (and RCU read side locked) when
return from workingset_activation() due to disabled memcg
or page not being a page_memcg().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 mm/workingset.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 14522ed..54138a9 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -315,8 +315,10 @@ void workingset_activation(struct page *page)
 	 * XXX: See workingset_refault() - this should return
 	 * root_mem_cgroup even for !CONFIG_MEMCG.
 	 */
-	if (!mem_cgroup_disabled() && !page_memcg(page))
+	if (!mem_cgroup_disabled() && !page_memcg(page)) {
+		unlock_page_memcg(page);
 		return;
+	}
 	lruvec = mem_cgroup_zone_lruvec(page_zone(page), page_memcg(page));
 	atomic_long_inc(&lruvec->inactive_age);
 	unlock_page_memcg(page);
-- 
2.7.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
