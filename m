Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66E91FF1DA
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 04:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784606985; cv=none; b=XdQwNFzoWJ9GicUeIKu6JEeNid1UyNpQlgjbdHXG1VvltMPvkTx+p07wz08cl/ubkwkohbrNvWkVhU8PvLJ416JHgnhx4dhIx+XbgzSFd+R+gj4Rs/u+kX6W3PohEcqPIAXENbzDLIkELT2iMUq274iG4FzhCRPUZo716WdY4bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784606985; c=relaxed/simple;
	bh=TfHtN98F+C0beBAmQC91Qi2Fba7QSVBUL1zD90xob5U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VfururtGR6DkHEO5FKkMDb71/+XzdsWp/F7qkZrIL0Oc4WZunsx8s/5Ozc81XJnyHBBFy4EXAjAAH2ad7/bH+O8NRH/TijZSsCW5nXTMbm4vBQBHaVGQUwAnhx1zMMS7hbt4v/RgH/yZDc5vYA1Ve76bHP/v9In3xENrTA+AByg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q2fj3TUk; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q2fj3TUk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784606967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7RH3/Rwf7tA6LTcRQBD8dH2kVM7pDy1c+3FZ4K3r3vw=;
	b=Q2fj3TUkPE4a7UUD0FDxuB0mPANlCCFPRs6iya5K+S6c7MHuupWk1N97IZFYsnzY5xJagW
	Il/S8t37gTok+qjPZA/KAME8dj/nUmLsuMmHs71Y+AaJ3ho31IZi/3PuJ6X26Rkbav+h45
	HAUAnWppWVE6ykUj+Htb/QF7WaGIJhw=
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	josef@toxicpanda.com,
	yukuai3@huawei.com,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	david.laight.linux@gmail.com,
	haris.iqbal@linux.dev,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v3] blk-throttle: fix divide-by-zero on legacy iops limit of 0
Date: Tue, 21 Jul 2026 12:08:50 +0800
Message-ID: <20260721040850.90544-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

Writing a multiple of 2^32 (e.g. 4294967296) to a legacy cgroup v1
throttle iops file (blkio.throttle.{read,write}_iops_device) silently
truncates to 0: tg_set_conf() stores the sscanf-parsed u64 value into
an unsigned int field with no clamping. The cgroup v2 path,
tg_set_limit(), already clamps the same kind of value with
min_t(u64, val, UINT_MAX), but the legacy path never did. Note that
the "!v -> U64_MAX" mapping only catches an explicit zero and does not
catch a value that truncates to zero.

With iops stored as 0, tg_update_has_rules() sets has_rules_iops[] and
the next IO reaches tg_within_iops_limit(), which computes

    jiffy_wait = max(jiffy_wait, HZ / iops_limit + 1);

triggering a divide-by-zero oops. The unclamped write in tg_set_conf()
is long-standing, but it only became a crash once the HZ / iops_limit
divide was added.

Fix it in two places:

  * tg_set_conf(): clamp the value to UINT_MAX, consistent with
    tg_set_limit(). This closes the truncation root cause (and the
    general silent truncation for any value above UINT_MAX).

  * tg_dispatch_iops_time(): treat iops_limit == 0 as unlimited so the
    divide in tg_within_iops_limit() is never reached, defending
    against any future path that could produce a zero limit.

Fixes: 1beabab88ece ("blk-throttle: fix lower control under super low iops limit")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---
Changes in v3:
- Drop the (u64) cast on UINT_MAX: the kernel's type-checked min() accepts
  two unsigned types of different width (both >= 4 bytes), so
  min(v, UINT_MAX) compiles clean. (David Laight)
- Add a Fixes: tag pointing at the commit that introduced the
  HZ / iops_limit divide, which is also where the oops became reachable.

Changes in v2:
- Use a "void *field" local for the config write so the assignment reads
  *(u64 *)field / *(unsigned int *)field instead of the
  (type *)((void *)tg + of_cft(of)->private) casts.
- Use min(v, UINT_MAX) instead of min_t(u64, v, UINT_MAX).
---
 block/blk-throttle.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ffc3b70065d4..e894852c3142 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -883,7 +883,12 @@ static unsigned long tg_dispatch_iops_time(struct throtl_grp *tg, struct bio *bi
 	u32 iops_limit = tg_iops_limit(tg, rw);
 	unsigned long iops_wait;
 
-	if (iops_limit == UINT_MAX || tg->flags & THROTL_TG_CANCELING)
+	/*
+	 * iops_limit == 0 is not a valid limit. Treat it as unlimited so we
+	 * never reach the HZ / iops_limit divide in tg_within_iops_limit().
+	 */
+	if (iops_limit == UINT_MAX || iops_limit == 0 ||
+	    tg->flags & THROTL_TG_CANCELING)
 		return 0;
 
 	tg_update_slice(tg, rw);
@@ -1383,10 +1388,12 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
 	tg = blkg_to_tg(ctx.blkg);
 	tg_update_carryover(tg);
 
+	void *field = (void *)tg + of_cft(of)->private;
+
 	if (is_u64)
-		*(u64 *)((void *)tg + of_cft(of)->private) = v;
+		*(u64 *)field = v;
 	else
-		*(unsigned int *)((void *)tg + of_cft(of)->private) = v;
+		*(unsigned int *)field = min(v, UINT_MAX);
 
 	tg_conf_updated(tg, false);
 	ret = 0;
-- 
2.43.0

