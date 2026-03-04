Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A7036DA10;
	Wed,  4 Mar 2026 07:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772609904; cv=none; b=QOqVhC+eNfskRtSOWfDhwEOMUMrSc+0cFXxFPgvHUvXqW10vadbfOawj9g/h/6AkSgt3GSjCA2+GTLx0VHzuuJeMMpSOUxCwjmVO93EU+hhA+4Kvqxk7MLz3YhO5ySx8Fvpn7zPKsMl9pfaVeoonZfrTJ7e9Uzz+VD6cF3vRa78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772609904; c=relaxed/simple;
	bh=zRNfVXYgulIZD3seS5ter0NjMXM16qYonEcmIcmnGMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbvhPNakCS5JyYZEyOV8UHi1wrWu0bUT0sCLDnFPzcgd+x4x4QSrgk5b5ho42HkKaAkmVdg15ibtHYCFEnVgtcddP2cGYcGWgrIXlc6RmwxzkFBSUVNNXqCDjbOhISaGOLwYMY4TY330XMB9ZUGBFnVKKKwfIa4elKJpv9UYepM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F70AC19423;
	Wed,  4 Mar 2026 07:38:21 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheng Qixing <zhengqixing@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>
Subject: [PATCH v3 4/7] blk-cgroup: skip dying blkg in blkcg_activate_policy()
Date: Wed,  4 Mar 2026 15:38:05 +0800
Message-ID: <20260304073809.3438679-5-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260304073809.3438679-1-yukuai@fnnas.com>
References: <20260304073809.3438679-1-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zheng Qixing <zhengqixing@huawei.com>

When switching IO schedulers on a block device, blkcg_activate_policy()
can race with concurrent blkcg deletion, leading to a use-after-free in
rcu_accelerate_cbs.

T1:                               T2:
                                  blkg_destroy
                                  kill(&blkg->refcnt) // blkg->refcnt=1->0
                                  blkg_release // call_rcu(__blkg_release)
                                  ...
                                  blkg_free_workfn
                                  ->pd_free_fn(pd)
elv_iosched_store
elevator_switch
...
iterate blkg list
blkg_get(blkg) // blkg->refcnt=0->1
                                  list_del_init(&blkg->q_node)
blkg_put(pinned_blkg) // blkg->refcnt=1->0
blkg_release // call_rcu again
rcu_accelerate_cbs // uaf

Fix this by checking hlist_unhashed(&blkg->blkcg_node) before getting
a reference to the blkg. This is the same check used in blkg_destroy()
to detect if a blkg has already been destroyed. If the blkg is already
unhashed, skip processing it since it's being destroyed.

Link: https://lore.kernel.org/all/20260108014416.3656493-4-zhengqixing@huaweicloud.com/
Fixes: f1c006f1c685 ("blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
---
 block/blk-cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a6ac6ba9430d..f5b14a1d6973 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1610,6 +1610,8 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 		if (blkg->pd[pol->plid])
 			continue;
+		if (hlist_unhashed(&blkg->blkcg_node))
+			continue;
 
 		/* If prealloc matches, use it; otherwise try GFP_NOWAIT */
 		if (blkg == pinned_blkg) {
-- 
2.51.0

