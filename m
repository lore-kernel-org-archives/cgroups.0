From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 2/2] mm: memcg: do not allow task about to OOM kill to bypass the limit
Date: Wed,  4 Dec 2013 17:45:14 -0500
Message-ID: <1386197114-5317-3-git-send-email-hannes@cmpxchg.org>
References: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=YjrG/6f//dtUYb5RtMFhxBOzw077CyTsyM7ZyhWE2hs=;
	b=FYeUSX42ZXVF58rrTw5ArXVH/NjCWzOiFX72PzhW88Tyos9S0DpPglgcstqXyoJjoJUE2GMqUcR52QwjQws3pfrF27Ql1OI2oSamg1uofiZSpIfkFJv9J5YgBsOsl/ocMpduvfJq2cQhVDZHegvgYo7DpJg8ITMa20uY6bn5ong=;
In-Reply-To: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

4942642080ea ("mm: memcg: handle non-error OOM situations more
gracefully") allowed tasks that already entered a memcg OOM condition
to bypass the memcg limit on subsequent allocation attempts hoping
this would expedite finishing the page fault and executing the kill.

David Rientjes is worried that this breaks memcg isolation guarantees
and since there is no evidence that the bypass actually speeds up
fault processing just change it so that these subsequent charge
attempts fail outright.  The notable exception being __GFP_NOFAIL
charges which are required to bypass the limit regardless.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f6a63f5b3827..bf5e89457149 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2694,7 +2694,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
-		goto bypass;
+		goto nomem;
 
 	if (gfp_mask & __GFP_NOFAIL)
 		oom = false;
-- 
1.8.4.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
