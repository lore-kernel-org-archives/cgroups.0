From: Chris Down <chris@chrisdown.name>
Subject: [PATCH 1/2] mm, memcg: Fix corruption on 64-bit divisor in
 memory.high throttling
Date: Thu, 12 Mar 2020 18:02:54 +0000
Message-ID: <80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=CRd8IUcL1IWZS04LIYFbzj4WsXVZJS20ANjjPe46vbU=;
        b=Haae2SBurX0dFdW2FA0odm7mGIYVgXxbkX+kRhvt4ySMuKlguBzaUtjNrkfEaiED2N
         mbGRZT1Dix/XuTr0AVw4HxlQ1lhNxqlheMxxT7Vxz3Cz1I+Ulb5n/EARnD4G3g00Lwwn
         6gqr2BrDtb+6qJLFLYJHzj2AY9s6hHt0U7yk0=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

0e4b01df8659 had a bunch of fixups to use the right division method.
However, it seems that after all that it still wasn't right -- div_u64
takes a 32-bit divisor.

The headroom is still large (2^32 pages), so on mundane systems you
won't hit this, but this should definitely be fixed.

Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org
Cc: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-team@fb.com
Cc: stable@vger.kernel.org # 5.4.x
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 63bb6a2aab81..a70206e516fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2339,7 +2339,7 @@ void mem_cgroup_handle_over_high(void)
 	 */
 	clamped_high = max(high, 1UL);
 
-	overage = div_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
+	overage = div64_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
 			  clamped_high);
 
 	penalty_jiffies = ((u64)overage * overage * HZ)
-- 
2.25.1

