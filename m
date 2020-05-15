From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH mm v3 2/3] mm: move penalty delay clamping out of calculate_high_delay()
Date: Fri, 15 May 2020 13:20:26 -0700
Message-ID: <20200515202027.3217470-3-kuba@kernel.org>
References: <20200515202027.3217470-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589574036;
        bh=ZAMCAB5zes7ruduXHumaQzQVZLxAMKuG/SKsRaj1NlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SkFSq6ZAAiVv4raX5iKLhpQJFcUpdyCP3HRO0BnvNHpA1KIXtJ66vTw9tP+hrXvFM
         oCx3nKSJOBP94f02W5Ib95YlcxwiP2RtVmREMECQWBsxvJLKd8Zv5DzjTRANhA076R
         AG6UWkiTWPsXNw2UhZeUbOVwzHw+bTx0zE8uLMZk=
In-Reply-To: <20200515202027.3217470-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

We will want to call calculate_high_delay() twice - once for
memory and once for swap, and we should apply the clamp value
to sum of the penalties. Clamping has to be applied outside
of calculate_high_delay().

Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 851f4d033e8f..b2022f98bf46 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2365,14 +2365,7 @@ static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
 	 * MEMCG_CHARGE_BATCH pages is nominal, so work out how much smaller or
 	 * larger the current charge patch is than that.
 	 */
-	penalty_jiffies = penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
-
-	/*
-	 * Clamp the max delay per usermode return so as to still keep the
-	 * application moving forwards and also permit diagnostics, albeit
-	 * extremely slowly.
-	 */
-	return min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+	return penalty_jiffies * nr_pages / MEMCG_CHARGE_BATCH;
 }
 
 /*
@@ -2400,6 +2393,13 @@ void mem_cgroup_handle_over_high(void)
 	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
 					       mem_find_max_overage(memcg));
 
+	/*
+	 * Clamp the max delay per usermode return so as to still keep the
+	 * application moving forwards and also permit diagnostics, albeit
+	 * extremely slowly.
+	 */
+	penalty_jiffies = min(penalty_jiffies, MEMCG_MAX_HIGH_DELAY_JIFFIES);
+
 	/*
 	 * Don't sleep if the amount of jiffies this memcg owes us is so low
 	 * that it's not even worth doing, in an attempt to be nice to those who
-- 
2.25.4

