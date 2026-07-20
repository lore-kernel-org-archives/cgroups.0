Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E955C3CC7F3
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 09:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540275; cv=none; b=PYJ9LxjshqswP56fyXbryRa/IEyP6lx+X8ijRoy5NeQbwLB2sv1D2cu0V582GXEyxWOhB+gyiGGjOFY4+ojBSn8FtjVzrlJAW0jT9H1xS1i2T+fw1VC+fmADDkpA7GfcpT/B3i0uQV3J7ZIoypRFbVUpz8Cp8HOVswp88tYE4Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540275; c=relaxed/simple;
	bh=DUYoLmN6cS1ifwCaOPVuhJdFQ8iak7gu6scRZPaSIZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T2xJrbarGMRRZEsNjwAbHaAv+NYdoa429CVD8d1MEQkRjBDa8sSY/7xOgiv5Zgh7fSO0gO1DhapRgKYqPVvooYpAyJKwsjNhnhmd8dh7PMWh7kZ+xrl/Fz2M8vzpg+Y7jdysGvuM5TecggQslsSDktjS22TwmQ0dBnp/cFfpFCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rnYWPNvr; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rnYWPNvr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784540260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FSEwvBD0sujeWAT93QEhvCEEmSiwHT6CnIw6yYF2s/4=;
	b=rnYWPNvrseDDwCUK5PnvhdDJ1reiUX8kjrceMKefKbYvc4Pw5ZEW880Kq2XjitjuPfm4c9
	XQ3DcJV2KuE0KuyY4gegusIR/CjMkroxPrREnUUnFeUR+XZCEioHc6S8ycrEMoDE2bfosc
	bjMYguv1WFQJdbl5ngt8I3y6wInZM7E=
From: Tao Cui <cui.tao@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Omar Sandoval <osandov@fb.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Yu Kuai <yukuai@fygo.io>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [PATCH 0/4] block: drain per-cpu latency stats over possible CPUs
Date: Mon, 20 Jul 2026 17:37:22 +0800
Message-ID: <20260720093726.28965-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Tao Cui <cuitao@kylinos.cn>

Several block-layer latency statistics accumulate samples in per-cpu
buckets and drain them periodically -- in timer callbacks, or at each
check / reporting site -- using for_each_online_cpu().  When a CPU that
holds pending samples is taken offline, that bucket is skipped during
the drain: the samples are neither accumulated into the current window
nor, where the drain also resets, cleared.  They sit in the bucket until
the CPU is brought back online, at which point they are flushed into
whatever window happens to be running.

The effect cuts both ways and is harmful in each direction:

  - while the CPU is offline, its samples are under-counted, so
    throttle / latency / scheduling decisions derived from these stats
    miss the work that actually happened ("should have throttled, but
    didn't");

  - on re-online, a burst of stale samples lands in a later window and
    can spuriously trip a throttle or skew a vrate / latency estimate
    ("shouldn't throttle, but did").

Fix: drain over for_each_possible_cpu() instead.  The per-cpu areas are
allocated for the full possible set, and the init paths already iterate
it; an offline CPU has no concurrent writer, so reading and resetting
its bucket is safe.

Cost is bounded: the extra work is over offline buckets that have no
writer and -- because each drain sums and resets -- hold a zeroed stat
after the first post-offline drain.  It amounts to O(possible - online)
trivial per-cpu reads on a timer / check / show path, alongside the
per-CPU stat work already done for online CPUs; on systems where all
possible CPUs are online it is exactly zero.

This is the same one-line mistake in four sites; each patch switches its
drain loop from for_each_online_cpu() to for_each_possible_cpu():

  - block/blk-stat.c        blk_stat_timer_fn() -- shared infrastructure
                            that also feeds wbt and blk-mq latency
  - block/blk-iolatency.c   iolatency_check_latencies() (throttle) and
                            iolatency_ssd_stat() (io.stat reporting)
  - block/blk-iocost.c      ioc_lat_stat() -- missed-ppm / rq_wait delta
  - block/kyber-iosched.c   kyber_timer_fn() -- latency histogram flush

blk-mq.c's for_each_online_cpu() at the hctx-has-online-cpu check is
correct and left untouched -- it is not a statistics drain.

Tao Cui (4):
  block/blk-stat: drain per-cpu callback stats over possible CPUs
  block/blk-iolatency: account per-cpu latency stats over possible CPUs
  block/blk-iocost: collect per-cpu latency stats over possible CPUs
  block/kyber-iosched: flush per-cpu latency buckets over possible CPUs

 block/blk-iocost.c     | 2 +-
 block/blk-iolatency.c  | 4 ++--
 block/blk-stat.c       | 2 +-
 block/kyber-iosched.c  | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--
2.43.0
