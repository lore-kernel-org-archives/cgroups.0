From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 1/7] mm: memcontrol: fix NR_ANON_THPS account
Date: Tue,  8 Dec 2020 12:18:41 +0800
Message-ID: <20201208041847.72122-2-songmuchun@bytedance.com>
References: <20201208041847.72122-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WYYxHKy2hNUOwy6YEzcM7TOwb+Qq885tP2jcyrxWyck=;
        b=gEpUnsZWYOjoACAUsQZDmde/SEQQIOvKt+ueoQYzxcPNg33SDVHk9FF1gWVVaN6rs4
         /aPL5PPxMnaE+DPh8DMDUoxFDpMJXOYSZs/IupuC1Q/TVUZZ1023ynmZ+enC3EPTOC3n
         hj8AGMbUX4SDYfWwFpT6VNLLopbu/Zp7aV83yNWA7hJAPq/+5Jqk9mYqHCVyp0bmK/o6
         ZfaRvPqDmHVJAhILi2YKpfJizlkIQL3Y04ky1LvHktsPKsw4k92k6hh6Bxam5CkIg4c+
         LHpPGdsTcqgRmcHOKKSym3csLwmcz5qUUiSxWAB9f8fTbZmkoNgnQshKdURnH/7YkbGs
         mUBA==
In-Reply-To: <20201208041847.72122-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, shakeelb@google.com, guro@fb.com, samitolvanen@google.com, feng.tang@intel.com, neilb@suse.de, iamjoonsoo.kim@lge.com, rdunlap@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, Michal Hocko <mhocko@suse.com>

The unit of NR_ANON_THPS is HPAGE_PMD_NR already. So it should inc/dec
by one rather than nr_pages.

Fixes: 468c398233da ("mm: memcontrol: switch to native NR_ANON_THPS counter")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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

