From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 1/9] memcg: accounting for allocations called with disabled BH
Date: Tue, 9 Mar 2021 11:03:48 +0300
Message-ID: <18a0ae77-89ff-2679-ab19-378e38ce2be2@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5o8mkc1Zj8mwSqxNhwynoe0HUtQdQ5ByM2Mvj+TwRE=;
 b=DkMpIobrjefjSXZtSghiTKUWp4uff6vm9fpRtU1WBWcV1PYzM+ewJM1bLR3an8Bq2tdAd6P0h4wLKoIvzr3EYp2erx8PYrHBLGK802XcrZ3TyukFkBavAB8AhbZOTsAmil+ZhSLg58hC7gnvPvpY0Csrusg+Ao6IYplNsdq0ikE=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

in_interrupt() check in memcg_kmem_bypass() is incorrect because
it does not allow to account memory allocation called from task context
with disabled BH, i.e. inside spin_lock_bh()/spin_unlock_bh() sections

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 845eec0..568f2cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1076,7 +1076,7 @@ static __always_inline bool memcg_kmem_bypass(void)
 		return false;
 
 	/* Memcg to charge can't be determined. */
-	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
+	if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
 		return true;
 
 	return false;
-- 
1.8.3.1

