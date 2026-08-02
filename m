Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A803B14D2
	for <cgroups@vger.kernel.org>; Sun,  2 Aug 2026 15:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785683374; cv=none; b=FHYr9L2zSZ8iNUQzpbfXPPytRupRjbHQCwkTAKfrXzAgo1TV8vCCDoymenfYur4iGMCM8SjUVcHXFmvkiRPyEZ6/PehgbyqORq1P5blTN6i7+vdAzLTYYas+hzx/gIhVRMHxEahDid8tIJdhOLmbrnz0qVuiTkuKj+9Pk0H3uqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785683374; c=relaxed/simple;
	bh=GO57fwLKmtahu5pfDBmS9h308U2gsUIdwwTlL4eKMDc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=itNAf6JTFFAnS7pok9RmhGQoN7VEZ4f2L4Oh559OoaRaQrYFsH1clqL89DqTRgxh94b0mk2ry6raBTn73z/CR5M8o8KKuuKOrlSi0lIExMvsLQcjbxJOF9oFcH5QVn0o6MaQICmnVv2qQ60BD96aTCHg8SLUz2qzLtSLdxkMcNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZSlTj+Tr; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZSlTj+Tr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785683369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=U+PkYx72CUNkWIynR+5N3OXf9AazwCu7lYAq0hlj+nY=;
	b=ZSlTj+TrXDMFx/KsOnBE+19cxBjMRG8p9nBts/VsU7z0MzHkGR31qvtBVdJ5pZCXro9KoF
	Qx4t12ZGSwia3HxG0eAhy7ozpXOu30kLilFIYIWQA5IqMMyuJEK71IqaskUDb11pQYKzh+
	RaiPjdlY1cWXDThLl6MTlAfXtYZwdCM=
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH] block/blk-iocost: read ioc_pd_stat params inside ioc->lock
Date: Sun,  2 Aug 2026 23:09:13 +0800
Message-ID: <20260802150913.31977-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

ioc_pd_stat() reads ioc->enabled, ioc->vtime_base_rate, and
iocg->last_stat without holding ioc->lock, which trips KCSAN since
ioc_adjust_base_vrate() and iocg_flush_stat_upward() write those
fields under ioc->lock.

Commit 35198e323001 ("blk-iocost: read params inside lock in sysfs
apis") fixed the same issue in ioc_qos_prfill() and
ioc_cost_model_prfill(), but ioc_pd_stat() was missed.

Add spin_lock_irq(&ioc->lock) around the reads, matching the fix
style of 35198e323001.

Fixes: 35198e323001 ("blk-iocost: read params inside lock in sysfs apis")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 8b2aeba2e1e3..b491a6ab98ea 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3093,8 +3093,10 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 	struct ioc *ioc = iocg->ioc;
 
+	spin_lock_irq(&ioc->lock);
+
 	if (!ioc->enabled)
-		return;
+		goto out;
 
 	if (iocg->level == 0) {
 		unsigned vp10k = DIV64_U64_ROUND_CLOSEST(
@@ -3110,6 +3112,8 @@ static void ioc_pd_stat(struct blkg_policy_data *pd, struct seq_file *s)
 			iocg->last_stat.wait_us,
 			iocg->last_stat.indebt_us,
 			iocg->last_stat.indelay_us);
+out:
+	spin_unlock_irq(&ioc->lock);
 }
 
 static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
-- 
2.43.0

