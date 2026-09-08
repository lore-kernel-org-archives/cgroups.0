Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454623803C8
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 10:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788861770; cv=none; b=iyA2FMbkZsDPlONkGBVZCMNx8KDexQqEBFiDtZOtai0j4rFPuD4MDhozCfkToLaTVbRHc4Qm/Fx6Ua4UtHzsNus5M7wIUjYO8i6Z7c1q4O73fyUoplui1Biin1FnmKsqgc1qPxbjP1UDUiR+hD8MDGmdnj6o/KIRZ7GISbRoZ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788861770; c=relaxed/simple;
	bh=FWmTXavAEUQXQQ4OFK6vpxzFjyhwrttNU0kXo7PDdAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARF54E+5L5bFRZk9uo46MwdgIf1zxjJ9tWNn4TjCYk6/AGgl6JdCcsKN9c7ZAzf/7GZlTgd6Y1/XzmbARJjelUOrUeEBB80rQ3O0YOgppBEDlfhD7tbA2bptLaVuzMBCZd7yJfl3iCQWgLcgWqZnAeRKHny6OaBLxRlTfseGdQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lc28t/me; arc=none smtp.client-ip=91.218.175.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lc28t/me"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=FWmTXavAEUQXQQ4OFK6vpxzFjyhwrttNU0kXo7PDdAo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788861766; v=1; x=1789466566;
 b=lc28t/meusKDHouTXP/HJ2d24QFJIztAQBrN4ALvCWiyzqnRntSYlEdJ51ypg6Q0vKKyG9ee
 SaFgvJcf47Bh/akHNkL/ctIkqPSMeqm72DahrIsFW/fpqe8gDbNxKbNRLQHz3gSBK0S0ICFpqVI
 4N4ECBq5dwxnVfEd0rBedLvo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dea8bc1b366ba06c;
	Tue, 08 Sep 2026 10:02:46 +0000
X-Mizu-Trace-ID: dea8bc1b366ba06c
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	andrii@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	linux-kselftest@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [RFC PATCH 4/8] blk-iocost: dispatch cost calculation to registered BPF model
Date: Tue,  8 Sep 2026 18:01:39 +0800
Message-ID: <20260908100143.47598-5-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260908100143.47598-1-cui.tao@linux.dev>
References: <20260908100143.47598-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

Add the bpf_cost_model field to struct ioc and the dispatch hook in
calc_vtime_cost(): when a BPF model is registered and the device has
opted in (bpf_cost_model set), call the model's calc_cost instead of
the builtin formula.  If no model is registered anymore the builtin
formula is used as fallback.

The user interface to set bpf_cost_model follows.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 block/blk-iocost.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index c24daa9d72ee9..bdb4bab86a116 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -177,6 +177,7 @@
 #include <linux/timer.h>
 #include <linux/time64.h>
 #include <linux/parser.h>
+#include <linux/blk-iocost.h>
 #include <linux/sched/signal.h>
 #include <asm/local.h>
 #include <asm/local64.h>
@@ -445,6 +446,7 @@ struct ioc {
 	int				autop_idx;
 	bool				user_qos_params:1;
 	bool				user_cost_model:1;
+	bool				bpf_cost_model;
 };
 
 struct iocg_pcpu_stat {
@@ -2578,6 +2580,23 @@ static u64 calc_vtime_cost(struct bio *bio, struct ioc_gq *iocg, bool is_merge)
 {
 	u64 cost;
 
+#ifdef CONFIG_BLK_CGROUP_IOCOST_BPF
+	struct ioc *ioc = iocg->ioc;
+
+	if (READ_ONCE(ioc->bpf_cost_model)) {
+		u64 bpf_cost;
+
+		if (iocost_bpf_calc_cost(bio_op(bio),
+					 bio->bi_iter.bi_size,
+					 bio->bi_iter.bi_sector,
+					 iocg->cursor,
+					 iocg_to_blkg(iocg)->blkcg->css.id,
+					 is_merge ? IOCOST_COST_F_MERGE : 0,
+					 &bpf_cost))
+			return bpf_cost;
+	}
+#endif
+
 	calc_vtime_cost_builtin(bio, iocg, is_merge, &cost);
 	return cost;
 }
-- 
2.43.0

