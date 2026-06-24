Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED3A39150D;
	Wed, 24 Jun 2026 06:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283610; cv=none; b=QIcLyhbHMFDqFi8DwJcVmtrXFCbzUZumf9wjsXMgvJw8Ly/oYZoH+fItJGqWZn9iuGREO5UQrHh87apApr+63tE5surEVXfDf95Ag1qlKZ+o/Ms9syDkCNIRKqd705HgVa22Muq7/JsPBWa6wGnbUJx6ubzcW2pe0zeOhIe0jLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283610; c=relaxed/simple;
	bh=TuBq1EuVBCN2F3nRQtWtElfM/uUOviU5/aExIX4I9vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqeFlBBGv6wVtQWQelGOaDElUBz9Vd09W+zEDLr6FbihUAgmnBqsGnILw+ASZV4Nl183wiF8kn0xasa44rRp0NB7jMuhPCcQXie2Co9KPTY9eAgXfWq5r6ZZvw3/Zk8gdgUvbKBEL7vgSbX6z33tyAVkWcfklb3je1TWYMpYmmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKc/EQPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKc/EQPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054B71F000E9;
	Wed, 24 Jun 2026 06:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283609;
	bh=G4HfGCeNdq2zc5CMRZaEvNuo50V7VHV42j0cEQvxQTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKc/EQPrx8EiZiH0PGY7cTN1/iIB8v6PF1L5oT7EPGkOtjk2xIZDWRlu9PBoC0o/E
	 S3+j6jaCfEi8aWqwf4ceQHdRHkCBZu/vHIl1AukIYR4JQzO6H4m0JkWfb8Z/Rri4Pz
	 Fy2pFgz7zAohvSXI8ddU+pd8Q6FLdG3loXHQDdfBR6XuQuHZeTB2HTVZUPJTHHZnQx
	 4pMPVJ5a5cQO+e0mmuO76GyDkibb+EQVzsRYc99KQSm2B6759Qc6fP33A6WgO61Y5L
	 WLcOJlhLH7dlO8sjhzb45l6HFN/vbIADGbAdyvoCG++DAYMDbH2BxL8F/zIp5QIBSi
	 7iCsNfdpn3ueQ==
From: Yu Kuai <yukuai@kernel.org>
To: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Tang Yizhou <yizhou.tang@shopee.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] blk-cgroup: skip dying blkg in blkcg_activate_policy()
Date: Wed, 24 Jun 2026 14:46:24 +0800
Message-ID: <20260624064625.1743650-6-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260624064625.1743650-1-yukuai@kernel.org>
References: <20260624064625.1743650-1-yukuai@kernel.org>
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

Fixes: f1c006f1c685 ("blk-cgroup: synchronize pd_free_fn() from blkg_free_workfn() and blkcg_deactivate_policy()")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f7e788a7fe95..2538d8105e6c 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1574,10 +1574,12 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
 		struct blkg_policy_data *pd;
 
 		if (blkg->pd[pol->plid])
 			continue;
+		if (hlist_unhashed(&blkg->blkcg_node))
+			continue;
 
 		/* If prealloc matches, use it; otherwise try GFP_NOWAIT */
 		if (blkg == pinned_blkg) {
 			pd = pd_prealloc;
 			pd_prealloc = NULL;
-- 
2.51.0

