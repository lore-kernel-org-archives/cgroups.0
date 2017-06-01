From: Yu Zhao <yuzhao@google.com>
Subject: [PATCH] swap: cond_resched in swap_cgroup_prepare()
Date: Thu,  1 Jun 2017 12:56:35 -0700
Message-ID: <20170601195635.20744-1-yuzhao@google.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=e6OMTWJB065jkdIptZPjGKpFsjPrnMqEOVupln6PY3o=;
        b=uQVANCzvuo6Vndg9/aymu7ViirgdVnfV2dVwZ6iHLh/KkV3d2PdosxXFwTfdScYoqr
         C6ImolmT3TrYCX8DGSU1pra4JRjInP7MzGwATZcQmeT36YA5G4scJkW1Xn8DbKsDFdo1
         0NwCHJ6Iub/KZTYjF4FqxzaXZJxJROvjD9KnksZrK+SQtVodwsT1OlxLW4KWx2qUAsYl
         J3pGEPAXm9KI94U9T3EMyG9eLFh+7sl6Gf2A6X06/ILF3y30uEhF1mQsVo10Aqod7Bq/
         MSKFT22BMoKk2m4Hh8cyWtTn30E3g9AQ5mFUEqqUsGKM3kugA1eq/q1H646O/srRpnTO
         VOlQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>

Saw need_resched() warnings when swapping on large swapfile (TBs)
because page allocation in swap_cgroup_prepare() took too long.

We already cond_resched when freeing page in swap_cgroup_swapoff().
Do the same for the page allocation.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 mm/swap_cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index ac6318a064d3..3405b4ee1757 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -48,6 +48,9 @@ static int swap_cgroup_prepare(int type)
 		if (!page)
 			goto not_enough_page;
 		ctrl->map[idx] = page;
+
+		if (!(idx % SWAP_CLUSTER_MAX))
+			cond_resched();
 	}
 	return 0;
 not_enough_page:
-- 
2.13.0.219.gdb65acc882-goog

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
