Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7398E2459E1;
	Sun,  2 Aug 2026 11:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785669942; cv=none; b=o7mnZQfg3wS573Fm0VBShA2w1rRHs5igDMa/7LGQvLox3wyImt07bVnR4eMX7yNrOH3FF3x7Xht4kiTjZ+W9qdYFUK6xF+QtAAs7zRmnM3iG2mMgwKoU5o8cMTcMwvMsz4nYAywU6e9nxXRlnNnn04+DLrRj0k95XizG8d7Bkv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785669942; c=relaxed/simple;
	bh=Djn9Wh91Tge1/LEJqxmAp63uERePRRuFeHogS2H/jq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=udwZJnSNxS55vt20RdQQWlwaJQeEyoZx+NaVu2l9z2m0Y7NnU2O1+XReqCbO66Mv+eA6Cmtz30i1gNFb2ureYZopUgsiAH45DpkG1SIT/HFQJSU1eBIF7PAENf4EWmsywt/X/ulHaRZzpuMTBbeBEyttD5v6SKAYI/AIHl6XwBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=idViBNig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="idViBNig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221D91F000E9;
	Sun,  2 Aug 2026 11:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785669941;
	bh=+EElcQqQAaLhU9f5uqkcUEntAit7MrM4wismRiz6B4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idViBNig88ItxvsXNGkgxuMReVHkcGcYRDkXoMBMraLZXfznQvQt90Z0su+0nfw0T
	 K4ljVrItv6W0A+kE37/D1Y8S0ilg6RuHO+b76S3l2YE4Wc+VBEHBtsWLnraXBrt7Bz
	 Zx2FlKleHAhqXr6BN1JVN8/pRRRqPYeeB5m7xHdPgItojR0dT4SacBnPAgBuWAYga2
	 C45V+aFYyWxfJKLT3Q4pMPzD0PoNnRIgAHYL9NloDe+KOQhdqG+rQuOLW2gBFmItCL
	 4AcrHNNkte8j01cQjeFJIuffav0GmCn4Lqexs66qk/KKX0DJh4H2mNUoepGeB0kPiO
	 e88hTxNlLJaDw==
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
Subject: [PATCH v4 1/4] blk-cgroup: protect q->blkg_list iteration in blkg_destroy_all() with blkcg_mutex
Date: Sun,  2 Aug 2026 19:25:17 +0800
Message-ID: <20260802112525.3933753-2-yukuai@kernel.org>
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

From: Yu Kuai <yukuai@fygo.io>

blkg_destroy_all() iterates q->blkg_list without holding blkcg_mutex,
which can race with blkg_free_workfn() that removes blkgs from the list
while holding blkcg_mutex.

Add blkcg_mutex protection around the q->blkg_list iteration to prevent
potential list corruption or use-after-free issues.

Reviewed-by: Tang Yizhou <yizhou.tang@shopee.com>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index d9676126c5b5..eb0cfb10b859 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -569,6 +569,7 @@ static void blkg_destroy_all(struct gendisk *disk)
 	int i;
 
 restart:
+	mutex_lock(&q->blkcg_mutex);
 	spin_lock_irq(&q->queue_lock);
 	list_for_each_entry(blkg, &q->blkg_list, q_node) {
 		struct blkcg *blkcg = blkg->blkcg;
@@ -587,6 +588,7 @@ static void blkg_destroy_all(struct gendisk *disk)
 		if (!(--count)) {
 			count = BLKG_DESTROY_BATCH_SIZE;
 			spin_unlock_irq(&q->queue_lock);
+			mutex_unlock(&q->blkcg_mutex);
 			cond_resched();
 			goto restart;
 		}
@@ -606,6 +608,7 @@ static void blkg_destroy_all(struct gendisk *disk)
 
 	q->root_blkg = NULL;
 	spin_unlock_irq(&q->queue_lock);
+	mutex_unlock(&q->blkcg_mutex);
 
 	wake_up_var(&q->root_blkg);
 }
-- 
2.51.0

