Received: from mta0.migadu.com (out-253.mta0.migadu.com [91.218.175.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306D1371D02
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 03:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788492698; cv=none; b=Vl2TxdU3EcUQS/7WPjX3J2U7CAiorubDnzdkpa5P82zrdRHpSVkImwtj/Uk3grnQYDkb6Bh8Nb8hjiTruHVNcHPHmKXmrV49C7jHF4Iy8qwiow9k6T7DE3PwalU3Zuo7ETiL4H+MgKRzh/5XGHpFIVhRhh4Wv6pHLG0MDyreNxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788492698; c=relaxed/simple;
	bh=JC2ag2alUjrEfUEf3ahBsTcggRXA+iSZInz01GqjHfE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sj2ZBVNU4ce4BSoOajo/9SkYbUSyB+y/7RJn+N/LyB0ihuJkeD6Z+VCfZvrUKHqMGWVzueN9ccghikQWAfmqh75hHyI8imr+ysO2E+aUsXTCk2hgcA6DuHiWK+DbK2SRTcAlZcoj4CrHphgNWeUN3iBZ4EaEsNw3wGk7ytIGVvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V02PX6Yi; arc=none smtp.client-ip=91.218.175.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V02PX6Yi"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JC2ag2alUjrEfUEf3ahBsTcggRXA+iSZInz01GqjHfE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788492695; v=1; x=1789097495;
 b=V02PX6Yi7ZG5YCxPYSpVKkgxrr+VMo/2hBCYEjnpGowVtCXPdWnYT4LWqFMW4HCwVnGLrC5C
 kUfTN1VQsknABHlUI8WK94PpXizVRPpuR0/4u6CI17y0vLGE3rNNYrb31y2BirrQs4zLOyLTV0p
 gjmSMcLN8FLuIKLyM8JSloC8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9d484e1fd16d84d9;
	Fri, 04 Sep 2026 03:31:35 +0000
X-Mizu-Trace-ID: 9d484e1fd16d84d9
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	yu kuai <yukuai@fygo.io>
Cc: tj@kernel.org,
	linux-block@vger.kernel.org,
	josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	david.laight.linux@gmail.com,
	haris.iqbal@linux.dev,
	cuitao@kylinos.cn,
	cui.tao@linux.dev
Subject: [PATCH v6] blk-throttle: fix divide-by-zero on legacy iops limit of 0
Date: Fri,  4 Sep 2026 11:31:26 +0800
Message-ID: <20260904033126.1194295-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Reviewed-by: Yu Kuai <yukuai@fygo.io>

---
Changes in v6:
- Fix the Reviewed-by address: yukuai@huawei.com -> yukuai@fygo.io, matching
  the address Yu Kuai used in his v4 review. No code change.

Changes in v5:
- Rebase onto current linux-next head (no code change, context shifted only).
- Add the Reviewed-by tag collected on v4.
- Link to v4: https://lore.kernel.org/r/20260722102459.253189-1-cui.tao@linux.dev

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

