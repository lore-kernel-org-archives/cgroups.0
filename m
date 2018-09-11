From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: [RFC PATCH v2 8/8] mm: enable concurrent LRU adds
Date: Mon, 10 Sep 2018 20:59:49 -0400
Message-ID: <20180911005949.5635-5-daniel.m.jordan@oracle.com>
References: <20180911004240.4758-1-daniel.m.jordan@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=AwKU9D2DXjht3CNnkLsSPDqQZuiwRTaiUp/PfPjCECA=;
 b=XowBvb3w4t3VICbk3/jLlxwdY79KT58Jn+A1CG7G2zjjqHd7SajwL523S89WDF807jiE
 F3tVjJE6B/DQsxJ8x353mkFCpY9rTfDQvBF9u+kpoeD093vmyw79SA6QWDp97UXCbYgv
 +ZKHuUw2NrnCaHsaVucqMdtDrgwy/7WpOMT+jPV+yvrBxDHC8qpZC0vq0xD3H4pSFrTE
 tN/FDgjT4JZTTLTglzcN+eFhq4+cUDg36nR0VneX0BrOggnJd4HidnAmuoQCdc6gZ6jn
 sW1gc9DxC6fTF6s0N38R+/1NlMMY5uFd7ObkNQaj45zzswV8b1K5lvB6/lo+X7f1saZT 2A== 
In-Reply-To: <20180911004240.4758-1-daniel.m.jordan@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: aaron.lu@intel.com, ak@linux.intel.com, akpm@linux-foundation.org, dave.dice@oracle.com, dave.hansen@linux.intel.com, hannes@cmpxchg.org, levyossi@icloud.com, ldufour@linux.vnet.ibm.com, mgorman@techsingularity.net, mhocko@kernel.org, Pavel.Tatashin@microsoft.com, steven.sistare@oracle.com, tim.c.chen@intel.com, vdavydov.dev@gmail.com, ying.huang@intel.com

Switch over to holding lru_lock as reader when splicing pages onto the
front of an LRU.  The main benefit of doing this is to allow LRU adds
and removes to happen concurrently.  Before this patch, an add blocks
all removing threads.

Suggested-by: Yosef Lev <levyossi@icloud.com>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
---
 mm/swap.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index fe3098c09815..ccd82ef3c217 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -999,9 +999,9 @@ void __pagevec_lru_add(struct pagevec *pvec)
 		 */
 		if (pagepgdat != pgdat) {
 			if (pgdat)
-				write_unlock_irqrestore(&pgdat->lru_lock, flags);
+				read_unlock_irqrestore(&pgdat->lru_lock, flags);
 			pgdat = pagepgdat;
-			write_lock_irqsave(&pgdat->lru_lock, flags);
+			read_lock_irqsave(&pgdat->lru_lock, flags);
 		}
 
 		lruvec = mem_cgroup_page_lruvec(page, pagepgdat);
@@ -1016,12 +1016,16 @@ void __pagevec_lru_add(struct pagevec *pvec)
 
 		if (splice->pgdat != pgdat) {
 			if (pgdat)
-				write_unlock_irqrestore(&pgdat->lru_lock, flags);
+				read_unlock_irqrestore(&pgdat->lru_lock, flags);
 			pgdat = splice->pgdat;
-			write_lock_irqsave(&pgdat->lru_lock, flags);
+			read_lock_irqsave(&pgdat->lru_lock, flags);
 		}
 		smp_list_splice(&splice->list, splice->lru);
 	}
+	if (pgdat) {
+		read_unlock_irqrestore(&pgdat->lru_lock, flags);
+		pgdat = NULL;
+	}
 
 	while (!list_empty(&singletons)) {
 		page = list_first_entry(&singletons, struct page, lru);
-- 
2.18.0

