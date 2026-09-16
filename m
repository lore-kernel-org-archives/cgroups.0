Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A0E43DEA1
	for <cgroups@vger.kernel.org>; Wed, 16 Sep 2026 08:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548805; cv=none; b=fkxRSDEYaXEMjqNW3OnLJ8vx6fRcofveZO/ZKX1OfBFMWLMUcF4ZJIMwoXMb53oQVx51pJC+F/IT8FnXvmPOqEqC7HWFaDD9/jXj9su5dBt76rJigSNDifFsUW5N9vpl7//NG3whXOidBibm1YAUvqVgNZCiQTtdP03UMJQtzZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548805; c=relaxed/simple;
	bh=Pp4mo6wSYU3iUIB4cOhis/I4KubwnLfXKOb5ZDDJDJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V0ZHFD2MKC/ifo5nzhBe8iMEj5n2h3WkwHCxD/tlAjSvct9H5wIG8hEWUKu/4hpZmPoTwl/hVkXbQSgxifxuTCe5yQzj12avfOQMq2hYOX3fug8yPS7hcSq7dPA48V9uzJw5CZJGRdzaJCqGxGQJhsHk5eEyDnwlHNuCZ78kRuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=k3LYlF3G; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="k3LYlF3G"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Pp4mo6wSYU3iUIB4cOhis/I4KubwnLfXKOb5ZDDJDJ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789548796; v=1; x=1790153596;
 b=k3LYlF3GDBXhyv23J4nyAwwzWJMtKONfvHeMcrS8I5Rk/x95YgwVLHCEm2YJy6SyE8e+hp49
 LnxldLZdREI+2TyHMMBC5/tFOLeB/6Ifn6BuM2Lf4cPjf7vJ8QyVuRe0bewRIgp/wrQ2UVFaGMw
 qhmubeL6xzBlHvVkcXiTiECQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 112d2f2d9fcc31ba;
	Wed, 16 Sep 2026 08:53:16 +0000
X-Mizu-Trace-ID: 112d2f2d9fcc31ba
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk,
	hch@infradead.org
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH v2 0/4] blk-iocost: charge flushes and zone appends
Date: Wed, 16 Sep 2026 16:53:00 +0800
Message-ID: <20260916085304.1080271-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

While testing iocost's weight-based throttling under concurrent IO,
we observed that a cgroup limited to 1% weight could issue an
unbounded number of flushes without being throttled: an fsync loop
produced ~510k flushes in 12s with cost.usage staying at zero the
entire time.  The device was monopolized while iocost reported no
activity.  On ext4, a write+fsync workload showed the same gap: the
write component was charged but the flush component was not.

The cause is that the builtin linear cost model defines coefficients
only for READ and WRITE.  Standalone flushes (the dataless
REQ_OP_WRITE | REQ_PREFLUSH bios from blkdev_issue_flush()), zone
append requests on zoned devices, and the flush component of
data-bearing REQ_OP_WRITE | REQ_PREFLUSH bios (e.g. journal commits)
fall through to a cost of zero.  Zone append completions are also
excluded from the latency statistics, so the vrate feedback loop
cannot respond to latency induced by zone append operations.

 1/4: charge the flush component of any REQ_PREFLUSH bio (standalone
     and pre-flush) as pageless random writes with one-page floor,
     and skip the cursor update for dataless bios
 2/4: charge zone appends as sequential writes; skip cursor update
     (ZA bi_sector is zone start, not the actual write position)
 3/4: count ZA completions in latency stats (vrate feedback)
 4/4: fix stale comment referring to nonexistent aux_iocg

After this series, on the same 1%-weight cgroup:

  - the fsync loop is limited to 24 flushes per 12s (matching the
    expected budget for the hdd profile)
  - 16000 zone appends on a zoned null_blk are charged 533264 usec
  - on ext4, the write+fsync workload is correctly accounted through
    the journal layer (~2.2us per flush, matching the ssd_fast
    profile's page-cost floor)
  - sequential read throughput is unchanged

Both v1 review findings (cursor corruption by dataless flushes,
missing charge for the PREFLUSH component of data-bearing writes)
are addressed in 1/4; see its changelog for details.  Proper
flush-cost modeling with a dedicated coefficient will follow as a
separate RFC.

Tao Cui (4):
  blk-iocost: charge flushes as pageless random writes
  blk-iocost: charge zone appends as page-counted sequential writes
  blk-iocost: account zone append completions in latency stats
  blk-iocost: fix stale comment in ioc_rqos_throttle()

 block/blk-iocost.c | 42 ++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--
2.43.0

