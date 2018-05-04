From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] mm: memcontrol: drain stocks on resize limit
Date: Fri,  4 May 2018 13:55:48 -0700
Message-ID: <20180504205548.110696-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DnUXLEaCkkCVH3E829dGRxAOA8xyVQ0lOvRMY9hJGEI=;
        b=TURGtkQmk7rkrMeduUJd+hla+ZISuA1kz8znMwFvV0ZOR/uKnCBHtW+ZPl3g/Xn308
         R2I2KARF7NS44t0mwlpDcbZhSu3RdQpBAp7G4TlqmKGbxlQjXv+hnjB5HrWjJNgrCEi3
         xbIatTsSkoWNx935dwxn7kXYCsnBU2bUSxe5xoARvUYfXCVOuBSoEtB/obshbeAdQGaZ
         xc/0FUaWnLzogT1W+lSNtgQPOTZhnXtS2W91kdnnibLyS8H8HJThtYau9AKdJQQyjsi8
         I03/90qQ3mE8LCnTRPJILi9FMnIPJolIQf19DHOEhXdk0nClgPVELATOq8UVezrVTZK2
         OvXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Shakeel Butt <shakeelb@google.com>

Resizing the memcg limit for cgroup-v2 drains the stocks before
triggering the memcg reclaim. Do the same for cgroup-v1 to make the
behavior consistent.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 25b148c2d222..e2d33a37f971 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2463,6 +2463,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 				 unsigned long max, bool memsw)
 {
 	bool enlarge = false;
+	bool drained = false;
 	int ret;
 	bool limits_invariant;
 	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
@@ -2493,6 +2494,12 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		if (!ret)
 			break;
 
+		if (!drained) {
+			drain_all_stock(memcg);
+			drained = true;
+			continue;
+		}
+
 		if (!try_to_free_mem_cgroup_pages(memcg, 1,
 					GFP_KERNEL, !memsw)) {
 			ret = -EBUSY;
-- 
2.17.0.441.gb46fe60e1d-goog

