Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EDD339371;
	Wed, 22 Jul 2026 10:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784715924; cv=none; b=ckc47spqoTqwAKLU6Yv8VB96RPGdt7B5GZYdfexxSIvsCGeC15VuSJjwLN+TqBq4+e1dOWIc8ilxtLzC951rQRk52RUGpAd+U9manZ7aEV4XJvteBP4gQTAeTPEuIT1EwDmxwXamMA5uwiwxsHej0EiN26DaNajvziWB1zhXc3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784715924; c=relaxed/simple;
	bh=1OcsFA5xETydKj/a/BPRbzK34nAsDcbpJ4tIWjpAfgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CFnFU/iRbV7p78DZ7bTXryws4sYJ0gTbXaCW+vZMHAFGD7kUBvlbfM6etxu3mBbkoFJJqsJfJiXAVZFITLOEgGbv6AMSW8iMFwa8///KDEMANEQKirzmgG6NHG9ITUcKNJYHkHup3an/duOoah0+A9IxddkJSEvBDZnwU6S3ZyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JmGuYE6+; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JmGuYE6+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784715910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gi0rqPlLMNHpvuGTqnaQG76LXt2I74tCCqNp3y8hndw=;
	b=JmGuYE6+CypZ8sKIfnhZ1RpivPmM3nHfhU1gFdVpdotYJKRZQIOO4g7n3Bk9pzBEWszVtY
	ecTENsnbgkLi04GGuwWXEkYjKasLRexpCdQyGuM6qRyqid01gkgDSgSuoJu6Yw3Ypn7n6m
	WQtGf1M50lqPoBc5Wek8cH8ubeKiJyA=
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	josef@toxicpanda.com,
	yu kuai <yukuai@fygo.io>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	david.laight.linux@gmail.com,
	haris.iqbal@linux.dev,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH v4] blk-throttle: fix divide-by-zero on legacy iops limit of 0
Date: Wed, 22 Jul 2026 18:24:59 +0800
Message-ID: <20260722102459.253189-1-cui.tao@linux.dev>
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

triggering a divide-by-zero oops.

Fix it in tg_set_conf() by clamping the value to UINT_MAX, consistent
with tg_set_limit(). This closes the truncation root cause: with 0 no
longer reachable as a stored limit, the HZ / iops_limit divide is never
hit.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>

---
Changes in v4:
- Drop the defensive "iops_limit == 0" check in tg_dispatch_iops_time():
  with the tg_set_conf() clamp in place, 0 can never be stored as a limit,
  so the runtime check only guards an unreachable state. (Yu Kuai)
- Drop the Fixes: tag: the unclamped write -- and the iops=0 behavior it
  can produce (calculate_io_allowed() returns 0, so no IO is issued) --
  long predates the commit that added the HZ / iops_limit divide, so
  attributing it there was incorrect. (Yu Kuai)

Changes in v3:
- Drop the (u64) cast on UINT_MAX: the kernel's type-checked min() accepts
  two unsigned types of different width (both >= 4 bytes), so
  min(v, UINT_MAX) compiles clean. (David Laight)

Changes in v2:
- Use a "void *field" local for the config write so the assignment reads
  *(u64 *)field / *(unsigned int *)field instead of the
  (type *)((void *)tg + of_cft(of)->private) casts.
- Use min(v, UINT_MAX) instead of min_t(u64, v, UINT_MAX).
---
 block/blk-throttle.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index ffc3b70065d4..97ad7959d006 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1383,10 +1383,12 @@ static ssize_t tg_set_conf(struct kernfs_open_file *of,
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

