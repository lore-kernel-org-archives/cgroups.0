From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Subject: [PATCH v1] mm:memcg: skip memcg of current in mem_cgroup_soft_limit_reclaim
Date: Fri,  3 Aug 2018 13:48:05 +0800
Message-ID: <1533275285-12387-1-git-send-email-zhaoyang.huang@spreadtrum.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=fVXWaxwxreKXlqc1RlFh2JofIARKEY7E1agRdUX+U64=;
        b=cM8AIGcr923zdMpdIzff6uaGULx90HD6/pb1SzOlHNxmQn3SGmQgrKeg3Nlb4SdcOH
         cq/h+mPUPhUuKOv2G+0z5sEW6+V/MAalhyHs20OWjxCoeA5ptfJnK7IEg1RwzULhiUsw
         wVcWZUts+sDYXxQIkEzwX1NwC8rstIp4/7nfOB7OwGVhnOF8Iacuyx3n9YDEw7fwikdo
         a6W9Ioie7idm4r/niISTiosCax+bavEPBe4jK8TqhvOcvztd7ONwFBKwZ3zBgafUMXmZ
         UCWFU3UAsgx5SttmwJsyiVKdSBGSjwk39mCpgaz6LZ/K2RgIwBPFtxPcGP23CIqVd1vP
         wXjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-patch-test@lists.linaro.org

for the soft_limit reclaim has more directivity than global reclaim, we
have current memcg be skipped to avoid potential page thrashing.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@spreadtrum.com>
---
 mm/memcontrol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8c0280b..9d09e95 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2537,12 +2537,21 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 			mz = mem_cgroup_largest_soft_limit_node(mctz);
 		if (!mz)
 			break;
-
+		/*
+		 * skip current memcg to avoid page thrashing, for the
+		 * mem_cgroup_soft_reclaim has more directivity than
+		 * global reclaim.
+		 */
+		if (get_mem_cgroup_from_mm(current->mm) == mz->memcg) {
+			reclaimed = 0;
+			goto next;
+		}
 		nr_scanned = 0;
 		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
 						    gfp_mask, &nr_scanned);
 		nr_reclaimed += reclaimed;
 		*total_scanned += nr_scanned;
+next:
 		spin_lock_irq(&mctz->lock);
 		__mem_cgroup_remove_exceeded(mz, mctz);
 
-- 
1.9.1

