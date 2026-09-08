Received: from mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC57831E838
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 02:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788834115; cv=none; b=kQQcFw+Be4RMUzmVTAtwmPdDV1RmdzGeRUfFq/wF4XEVKbcx4giQw4+Mcjo4+XZs5v+SxAY12HtKIOEPCoytaG/LIuB0n1sHNYaIX7Be0ReCEIGS2nCEzFS5OiukoSOVAnMeWrT5TrzqDlodS/UuTO+fMAvMulleozJUe+/2uDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788834115; c=relaxed/simple;
	bh=ne1pjg2JXSgmlK/tL6Lc6k03xWsAn3yDAqFQQXmM6Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fG8wcNjsIIOD6IKeNxbd4J0s9M0PejHHrARL8uKP1mUHb8JswFdi9j8gGER2v+tF3o1GrgUQKkGVLby+FOY4Jnfhmsbf/MMXKVW6ikzeOYnaeQLPqwyopFviEcnQBy3xApKeD+LWNgfTpRoLmNJ0DSoUPMWGLi1WmULwpoocI7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uVG6fqNZ; arc=none smtp.client-ip=91.218.175.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uVG6fqNZ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ne1pjg2JXSgmlK/tL6Lc6k03xWsAn3yDAqFQQXmM6Ic=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788834111; v=1; x=1789438911;
 b=uVG6fqNZ7ji+TS/pIEpvLh9WNyaOnurF8wfU4AkKdcruF34hd30m5K0v+ab4oW7KHwfAsu7h
 nltkEU35Pg1IvvOeIC2m65DDxj+330H9kGK68nB3473016Ks+oSYDEbXn48fzZi7UqmOnepOHqR
 8OOSporXo6Bjj2Dt/y+YuyH0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a25c7cd72a5bdd48;
	Tue, 08 Sep 2026 02:21:51 +0000
X-Mizu-Trace-ID: a25c7cd72a5bdd48
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: tj@kernel.org,
	josef@toxicopanda.com,
	axboe@kernel.dk
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 0/4] blk-iocost: charge flushes and zone appends
Date: Tue,  8 Sep 2026 10:21:31 +0800
Message-ID: <20260908022135.1429281-1-cui.tao@linux.dev>
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
REQ_OP_WRITE | REQ_PREFLUSH bios from blkdev_issue_flush()) and zone
append requests on zoned devices fall through to a cost of zero.
Zone append completions are also excluded from the latency
statistics, so the vrate feedback loop cannot respond to latency
induced by zone append operations.

 1/4: charge flushes as pageless random writes with one-page floor
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

Tao Cui (4):
  blk-iocost: charge flushes as pageless random writes
  blk-iocost: charge zone appends as page-counted sequential writes
  blk-iocost: account zone append completions in latency stats
  blk-iocost: fix stale comment in ioc_rqos_throttle()

 block/blk-iocost.c | 39 ++++++++++++++++++++++++++++++++-------
 1 file changed, 32 insertions(+), 7 deletions(-)

-- 
2.43.0

