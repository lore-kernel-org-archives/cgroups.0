From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/4] memcg: fix over-high reclaim amount
Date: Fri, 28 Aug 2015 11:25:27 -0400
Message-ID: <1440775530-18630-2-git-send-email-tj@kernel.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Bb36+HiD2mRozNUX2uKIfqqjivkVkcQ6UWHPJ9Y3lis=;
        b=alT/i+8J8TEXx/TTGw38NZloyW/WogwIlbgocNAOI8W8I8i+0XxPzx8SgV0tDnkrIc
         TXJbLC36/wl19Syp5FayAsLHTQZgpVeEv8ijrTUDFd8JcLmtUEGGyb47vTnCQhxxHFrB
         Wd4Y5YNxE5ifKpxRQUvOv+hEbfRslJZyPDgRJ19cwoSy2RvEuvk2cFB3HbCLGDYI01eI
         nsPPhqSGa3SzG0FXUl5pVTTTzZ9Ro98Ays6I152712H9Ih7pG3Ff9E66wrQZNkYR4E6U
         xOGtAHA+/7GPaIGkOiR/cYZJpxdPlZ/x3eqvvXRXxwoFYu9cqU64fGISoaNucfu44xUb
         qgFA==
In-Reply-To: <1440775530-18630-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

When memory usage is over the high limit, try_charge() performs direct
reclaim; however, it uses the current charging amount @nr_pages as the
reclamation target which is incorrect as we want to reclaim down to
the high limit.  In practice, this doesn't matter all that much
because the minimum target pages that try_to_free_mem_cgroup_pages()
uses is SWAP_CLUSTER_MAX which is rather large.

Fix it by setting the target number of pages to the difference between
the current usage and the high limit.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 mm/memcontrol.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aacc767..18ecf75 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2078,10 +2078,13 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * make the charging task trim their excess contribution.
 	 */
 	do {
-		if (page_counter_read(&memcg->memory) <= memcg->high)
+		unsigned long usage = page_counter_read(&memcg->memory);
+		unsigned long high = ACCESS_ONCE(memcg->high);
+
+		if (usage <= high)
 			continue;
 		mem_cgroup_events(memcg, MEMCG_HIGH, 1);
-		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
+		try_to_free_mem_cgroup_pages(memcg, high - usage, gfp_mask, true);
 	} while ((memcg = parent_mem_cgroup(memcg)));
 done:
 	return ret;
-- 
2.4.3
