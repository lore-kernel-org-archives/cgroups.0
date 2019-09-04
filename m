From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH v1 7/7] mm/mlock: recharge mlocked pages at culling by vmscan
Date: Wed, 04 Sep 2019 16:53:22 +0300
Message-ID: <156760520240.6560.4933207338618527335.stgit@buzz>
References: <156760509382.6560.17364256340940314860.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1567605203; bh=tOkluSvMOilQtaQgeVN/jbLnmLXdvX3Fp9s5Z6P8s1g=;
        h=In-Reply-To:Message-ID:References:Date:To:From:Subject:Cc;
        b=Z4jm5Q2LTUYVSo8olrY0Quoi7AQsTBhZjF73yqtYmYod1nau/phdgy6bQwtVIC7rj
         788ePHQp13uvQW1vUeIf1xWUaY30sg+qS9qy1od1dkNufOcq1HIh0Z6xLrECdoAQoF
         GlBmDVdNCEbC2tjP/Z03EJTXlxSojcqYxr6uTv9Y=
In-Reply-To: <156760509382.6560.17364256340940314860.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>

If mlock cannot catch page in LRU then it isn't moved into unevictable lru.
These pages are 'culled' by reclaimer and moved into unevictable lru.
It seems pages locked with MLOCK_ONFAULT always go through this path.

Reclaimer calls try_to_unmap for already isolated pages, thus on this path
we could freely change page to owner of any mlock vma we found in rmap.

This patch passes flag TTU_LRU_ISOLATED into try_to_ummap to move pages
in mmlock_vma_page().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bf7a05e8a717..2060f254dd6b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1345,7 +1345,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page)) {
-			enum ttu_flags flags = ttu_flags | TTU_BATCH_FLUSH;
+			enum ttu_flags flags = ttu_flags | TTU_BATCH_FLUSH |
+					       TTU_LRU_ISOLATED;
 
 			if (unlikely(PageTransHuge(page)))
 				flags |= TTU_SPLIT_HUGE_PMD;

