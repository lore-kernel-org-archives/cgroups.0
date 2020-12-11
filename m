From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 1/7] mm: memcontrol: fix NR_ANON_THPS accounting in charge moving
Date: Fri, 11 Dec 2020 12:19:48 +0800
Message-ID: <20201211041954.79543-2-songmuchun@bytedance.com>
References: <20201211041954.79543-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FpYaFCBP9ryR0HnwKGfpggL7bn85I6W2LvY3/jvWBMg=;
        b=T2ahvN7HcruB45VJZG2OJqfIapWawdOD8QtWwwwuD43vjFPlp2f0Yi8Gslq+3aVBN3
         QuexiT59I4+K7zRILtyttGcENl7TzkS+jsjA2Oh+lybl033Bptk3XduoWbvXn6xVDsAL
         7ee5f0G+Ld7Nk/1Y3Wh4XlEMomkWzrC1dLBL4zDjO8dWk8nn8cZPsKzWKj443KmhKlbA
         NKCRfX207fMkpWgeZ/0TF0rb0LteP1ZUhUv6MOH1oj64KFiCmTraUoFBRKZ2bpGW2vj5
         EG0+5TFj/Kc9+edCH85DQVHPkanMAhz8lGbgK+VXRAPkdeeGVlMCFhSbRk9PNWxS7rQK
         g/WQ==
In-Reply-To: <20201211041954.79543-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, shakeelb@google.com, guro@fb.com, samitolvanen@google.com, feng.tang@intel.com, neilb@suse.de, iamjoonsoo.kim@lge.com, rdunlap@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, Michal Hocko <mhocko@suse.com>

The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
by one rather than nr_pages.

Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
 mm/memcontrol.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b80328f52fb4..8818bf64d6fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5653,10 +5653,8 @@ static int mem_cgroup_move_account(struct page *page,
 			__mod_lruvec_state(from_vec, NR_ANON_MAPPED, -nr_pages);
 			__mod_lruvec_state(to_vec, NR_ANON_MAPPED, nr_pages);
 			if (PageTransHuge(page)) {
-				__mod_lruvec_state(from_vec, NR_ANON_THPS,
-						   -nr_pages);
-				__mod_lruvec_state(to_vec, NR_ANON_THPS,
-						   nr_pages);
+				__dec_lruvec_state(from_vec, NR_ANON_THPS);
+				__inc_lruvec_state(to_vec, NR_ANON_THPS);
 			}
 
 		}
-- 
2.11.0

