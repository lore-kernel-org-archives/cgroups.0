Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299FD381E94;
	Sun,  2 Aug 2026 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785669952; cv=none; b=fYdhUO71WTSp3R5BAAiAdvYoNvxjx6Q0zDeVIlYSwywlHelBleA0IBgtKR/Vz2Xs702WHIuSirM1hLvZ53tlWl3mcauHU1pDLq2SS+og9TLC67RCJsJxDbIOVoMA5FVJxFppVnfLkwFMZxh20Ung2WxsyU4q+0aSHet/C8Q4v20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785669952; c=relaxed/simple;
	bh=CbIcUGaG40OgJzRfbvqKSYTHTJMk+WRH2xbtk4uUbps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rX8YIrZoACsQpY3MM5CnRXx0WcuRlQC/2c/BhH9R4xndGjrCN7NFcdy3fS4yUJ7l1+jZCFG+l4IBsDT/jW0AG99xoq5rn1oDmDEolUDolo0VyYAfcpG0OtCZlp/cVMJ4qiPFy7wELtzYp/bkDzj4mjXiA8i5BisaI62N3YrBWnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1u15YaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1u15YaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F731F000E9;
	Sun,  2 Aug 2026 11:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785669950;
	bh=zU+TRKoCIS8QnsUNPujkhjRjzhengrzuAzjCZsXnVwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1u15YaALUspMGEXBQUaDY3xQPADr/4inUFUJzqWP7Pe7OdwtmjG19Ki0RdSOsj2/
	 LKkdvlt3eeNdKc4ciloR46liyglNsn4mIPOVnUWJL1+1R2ftBB9yRtrmFEFOWTzWPW
	 OOml2u6cRIYpCIfp0jJKW+1FJOMFmaECDFK5JsaWzCI/D7+KT9jckn1xOjAcxnR34Q
	 rILNF0mbNgXkUJKXgcOqnsx0mMijmhfnqCnZZai4M2Kggn/n8Ld5u92jVSQJ1mUAyL
	 sQyr3iHif6M3ZoN7v+synZteN9TtAw2yPmUfdRUim3Cv6T07zbjwv2+mCcp1mloAPX
	 s59/eYjTd+bCg==
From: Yu Kuai <yukuai@kernel.org>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhengqixing@huawei.com,
	hch@lst.de,
	yizhou.tang@shopee.com,
	yukuai@fygo.io,
	nilay@linux.ibm.com
Subject: [PATCH v4 3/4] blk-cgroup: skip dying blkg in blkcg_activate_policy()
Date: Sun,  2 Aug 2026 19:25:19 +0800
Message-ID: <20260802112525.3933753-4-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802112525.3933753-1-yukuai@kernel.org>
References: <20260802112525.3933753-1-yukuai@kernel.org>
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
index 047bb42c282b..d1895bc60fcf 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1577,6 +1577,8 @@ int blkcg_activate_policy(struct gendisk *disk, const struct blkcg_policy *pol)
 
 		if (blkg->pd[pol->plid])
 			continue;
+		if (hlist_unhashed(&blkg->blkcg_node))
+			continue;
 
 		/* If prealloc matches, use it; otherwise try GFP_NOWAIT */
 		if (blkg == pinned_blkg) {
-- 
2.51.0

