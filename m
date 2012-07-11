From: Wanpeng Li <liwp.linux@gmail.com>
Subject: [PATCH] mm/hugetlb_cgroup: Add list_del to remove unused page from hugepage_activelist when hugepage migration
Date: Wed, 11 Jul 2012 11:51:58 +0800
Message-ID: <1341978718-6423-1-git-send-email-liwp.linux@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=3XgEXIISozfxfXrGC11Bn86OxxMHA+1MNQQiGffGSEU=;
        b=j6a7h4jOYFXXayPaIhW7SVJY8HnydRqOVQ4Qbhha7DSvRopahKiFpyGcWUa8DQhpby
         yuBuzfM3ZPgHd8HSng3RxYpQP9RxrlAl9NLWzW+NgIDboyu9UwYma/NT2+s3yQCR/TQb
         +wjKeysbCZbt92tBzuyfJ4OgS6Kssm8qbPCCNcU5xc8xyScspbc1ohVC13CdcX1Rk1tR
         bmeXD2Mhj9e8MLbgBtHwLwMk1sorhGkJPJrWfLsGkSnJPsnN0LDjC5NISrWPHsAROw3m
         aGiVz4G8X1jZB+3KaMTBECcfqgSTQ4JWzwPBK4/cJ5YmAGx4SusWLrjbs0jFl25FERWE
         9Pfg==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>

From: Wanpeng Li <liwp@linux.vnet.ibm.com>

hugepage_activelist is used to track currently used HugeTLB pages.
We can find the in-use HugeTLB pages to support HugeTLB cgroup
removal. Don't keep unused page in hugetlb_activelist too long.
Otherwise, on cgroup removal we should update the unused page's 
charge to parent count. To reduce this overhead, remove unused page 
from hugepage_activelist immediately.

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
---
 mm/hugetlb_cgroup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
index b834e8d..d819d66 100644
--- a/mm/hugetlb_cgroup.c
+++ b/mm/hugetlb_cgroup.c
@@ -398,6 +398,7 @@ void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
+	list_del(&oldhpage->lru);
 
 	/* move the h_cg details to new cgroup */
 	set_hugetlb_cgroup(newhpage, h_cg);
-- 
1.7.5.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
