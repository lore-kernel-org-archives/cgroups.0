From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] mm: move penalty delay clamping out of calculate_high_delay()
Date: Thu, 16 Apr 2020 18:06:16 -0700
Message-ID: <20200417010617.927266-3-kuba@kernel.org>
References: <20200417010617.927266-1-kuba@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587085603;
        bh=atn+uG1raVqgcSHz1jVAI4WGiZvnKZIhSS07qsE9/Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwVvT4+5fMSy+zo4OcC+zP8T8hJMd156TkTFdpONYQ2O01c++xS+x7ytIq2AYo0fm
         587NHboBDyfT71UTbfftaFUVy+Voc1xJkSF2Y7eo4IVs5/cj16Z+J5sCr4clpJJ79g
         F/URS5LCdTMeCqzr5HCjnlMkYF+NSXJqaniVW3P8=
In-Reply-To: <20200417010617.927266-1-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

We will want to call calculate_high_delay() twice - once for
memory and once for swap, and we should apply the clamp value
to sum of the penalties. Clamping has to be applied outside
of calculate_high_delay().

Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9bfb7dcb3489..90266c04fd76 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2384,14 +2384,7 @@ static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
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
@@ -2419,6 +2412,13 @@ void mem_cgroup_handle_over_high(void)
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
2.25.2

