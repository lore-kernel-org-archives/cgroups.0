From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 05/12] mm: memcontrol: reclaim at least once for __GFP_NORETRY
Date: Mon, 16 Jun 2014 15:54:25 -0400
Message-ID: <1402948472-8175-6-git-send-email-hannes@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=vmwZqnfZNeUpvOhu/Z9a3gaAvfYknV2+nafbq4DuDoE=;
	b=obddqG3Mq3pEeRJFcSeN1HlcW+vjkuauk0UhXZUnjzncgRCUg88lBkmDU1Y3Iopr1FkcQ717heHNGRJeubmLugR/vOzvTNzl7/S1/b3rP8tKoJ/kwnGpeqyQ1fNewoIEmP0XCoY9TO1vp0lH7r6gacPqUJnkVSSpHyVObeq9Gnk=;
In-Reply-To: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Currently, __GFP_NORETRY tries charging once and gives up before even
trying to reclaim.  Bring the behavior on par with the page allocator
and reclaim at least once before giving up.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 52550bbff1ef..9c646b9b56f4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2613,13 +2613,13 @@ retry:
 	if (!(gfp_mask & __GFP_WAIT))
 		goto nomem;
 
-	if (gfp_mask & __GFP_NORETRY)
-		goto nomem;
-
 	nr_reclaimed = mem_cgroup_reclaim(mem_over_limit, gfp_mask, flags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= batch)
 		goto retry;
+
+	if (gfp_mask & __GFP_NORETRY)
+		goto nomem;
 	/*
 	 * Even though the limit is exceeded at this point, reclaim
 	 * may have been able to free some pages.  Retry the charge
-- 
2.0.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
