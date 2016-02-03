From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH] mm/workingset: do not forget to unlock page
Date: Wed, 3 Feb 2016 19:41:36 +0900
Message-ID: <20160203104136.GA517@swordfish>
References: <1454493513-19316-1-git-send-email-sergey.senozhatsky@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LArXUZJdbe/qme3suyjet8uQSVmzf9pmoQhUfdzKyOs=;
        b=Qxk2lZJfsQJObWVv3eKQvfvRu52+pQJF5sS+TxReqcMiO//bHt+BWdzb9D2mVXMpN/
         iQwWd/HRzemgfOmETlyil2VhjgjQZtbxaRZdU8c30NPrp2TsIueMD277Qzogk+ppHQ7Q
         UwomlR0CwwaDgKbcQPVSouz2gLOytoLD+zrkPHx5pWV6RnICT9KvDPqTFA06aFfyXcgf
         VwqNduo28e9Y9GPo2r5DB5FisalBE4opZAt6v66th5GuVKENKS2eOMRT2HMzhbPYRAN7
         qrFVdQGcCPsjFrHoR2XJIaXMp73NBZsKqSPtwZEAnDkW26+N1G/zRGLAfM1C4SINfzdg
         ePzQ==
Content-Disposition: inline
In-Reply-To: <1454493513-19316-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>

On (02/03/16 18:58), Sergey Senozhatsky wrote:
> 
> Do not leave page locked (and RCU read side locked) when
> return from workingset_activation() due to disabled memcg
> or page not being a page_memcg().

d'oh... sorry, the commit message is simply insane.


apparently the patch fixes a new code
	mm-workingset-per-cgroup-cache-thrash-detection.patch added to -mm tree
	mm-simplify-lock_page_memcg.patch added to -mm tree


so if there is an option to fold this patch into mm-simplify-lock_page_memcg,
for example, as a -fix, then I wouldn't mind at all.



a better commit message
===8<====8<====

From 1d6315221f2f81c53c99f9980158f8ae49dbd582 Mon Sep 17 00:00:00 2001
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Date: Wed, 3 Feb 2016 18:49:16 +0900
Subject: [PATCH] mm/workingset: do not forget to unlock_page in workingset_activation

Do not return from workingset_activation() with locked rcu and page.

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
