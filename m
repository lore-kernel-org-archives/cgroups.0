From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v6 1/7] mm: memcontrol: fix NR_ANON_THPS accounting in charge moving
Date: Tue, 29 Dec 2020 00:41:04 +0800
Message-ID: <20201228164110.2838-2-songmuchun@bytedance.com>
References: <20201228164110.2838-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sihbqHAwSrWiI/mby0PYKEUO9C1z2oJ0qLp+LWcjDHg=;
        b=j0OfcSNpacng4hvdoRiR1uS85K8rrj0CdsiliQJQ8Og/XxzfCZ6Ea3Vf62WLk18s1t
         097T5NlYVhpsy3KHkrlBaAGQB/80yljFxfLNi69xsPgf/5Pv/HhU0nZPqmt35olPihVB
         oyfOiR0eqLBYui3e9zAcs8ntUCbtnuGhNAlBLauG7rodu0rZJfaNb3ApAb0ONT0iokb7
         TnqteMs2En4iGsY7j/R/QtN4G9zGXpf1NW8pmmCI3Gqj5tbjpETbvDBGHFDTLcqFhejr
         TFjBesOPf+dliiY+rEfOv5tFQAYyf7MvvZ3PWlCwDOXxqIVJk0ENuaH8f2Jp8QrEVSrM
         EiVA==
In-Reply-To: <20201228164110.2838-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, shakeelb@google.com, guro@fb.com, samitolvanen@google.com, feng.tang@intel.com, neilb@suse.de, iamjoonsoo.kim@lge.com, rdunlap@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, Michal Hocko <mhocko@suse.com>, Pankaj Gupta <pankaj.gupta@cloud.ionos.com>

The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
by one rather than nr_pages.

Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
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

