From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 6.1 16/35] blk-cgroup: fix missing pd_online_fn() while activating policy
Date: Tue, 24 Jan 2023 08:41:12 -0500
Message-ID: <20230124134131.637036-16-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567726;
        bh=jmVxCeavWO+FBi8yxOKCkQ7COU927JaLBNSDf/y4n/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZiqvLF9hbEAvczjGpp92ZDbSuAVa9Qz0SgHgCspWhVMk8ai5oJf2O3FlWZ5E/ufT
         Lxe2w1pwYf05JzI6XCqBVJ+9/pHA0qHGsMTxC643ZBtSoAqGGv5g1hEMAuHHDKBqbQ
         EuqpTOnMbtaAUzijwY0joCM4aCKYWi2iI9xZHWli1MnKRyE4WZPaX9qIPSCEYP8TPv
         Ssy9RocH4KI+PTJZdYvGycNeEM7ZHQy/IH4jDEPnQNxXoBnlSv8D9ygsPfeWySwFLz
         r9ST88QPiE1jMOqucbDXRNq3VXknxEG1ine+8iUN6RjAccxJpLWb3H12cBEHGrEk+h
         0O4OS7HC+td3Q==
In-Reply-To: <20230124134131.637036-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

[ Upstream commit e3ff8887e7db757360f97634e0d6f4b8e27a8c46 ]

If the policy defines pd_online_fn(), it should be called after
pd_init_fn(), like blkg_create().

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Link: https://lore.kernel.org/r/20230103112833.2013432-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org
Signed-off-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-cgroup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index fcf9cf49f5de..7c91d9195da8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1408,6 +1408,10 @@ int blkcg_activate_policy(struct request_queue *q,
 		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
 			pol->pd_init_fn(blkg->pd[pol->plid]);
 
+	if (pol->pd_online_fn)
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
+			pol->pd_online_fn(blkg->pd[pol->plid]);
+
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
 
-- 
2.39.0

