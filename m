From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] mm: memcontrol: drain memcg stock on force_empty
Date: Mon,  7 May 2018 13:16:51 -0700
Message-ID: <20180507201651.165879-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZkbjXuXmGO55DL15j170PYMzmg+KwhYXthb2CazHkFg=;
        b=otxEheU289OjZU+O+u9CFaSsGRmyIymcfyEHrtTA/GtmIhJs7cTOsUZ9uXNUOKhaG7
         KHEVvwBfVIEPo0MeNDLxpi7Qlxw5mZ4I66vrMsXrLmizFCMT97A5i6VZBtU236Y08Pt6
         TntEQkpzksgtV2ZlL6dBP/0wzQeULYbYVF53VD/I15z4fAXU74MYhmHDTI+KTMJVEOrV
         Ln+95/VSGRkjuGaYCIU6TwfikXP0csDV6Cb82Xnz88uThZC9HGVoNDfDMOD/zwpefq/c
         +ftZp6K9GGs7OO+hQUi10DDoEyWoyGmaXpc3UJYvwv4Jy2BEaa0oVGirgBHuOOcZ3Sk9
         rGvg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Junaid Shahid <junaids@google.com>, Junaid Shahid <juanids@google.com>, Shakeel Butt <shakeelb@google.com>

From: Junaid Shahid <junaids@google.com>

The per-cpu memcg stock can retain a charge of upto 32 pages. On a
machine with large number of cpus, this can amount to a decent amount
of memory. Additionally force_empty interface might be triggering
unneeded memcg reclaims.

Signed-off-by: Junaid Shahid <juanids@google.com>
Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2d33a37f971..2c3c69524b49 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2841,6 +2841,9 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 
 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
+
+	drain_all_stock(memcg);
+
 	/* try to free all pages in this cgroup */
 	while (nr_retries && page_counter_read(&memcg->memory)) {
 		int progress;
-- 
2.17.0.441.gb46fe60e1d-goog

