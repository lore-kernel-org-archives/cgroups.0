Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9463831E82E
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 07:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974426; cv=none; b=irIuFvjHLzEnEgA8Ba2S8uD/qjKd7Ph+vHUJSwKwZqjhYLtNsPCLucMaM6h5GVZwgtmvGDzTdpn5PSB5TMJduM8d6/nQPalfq030kT8q9GLtyT8VHlHRdv25BIvPtJ0cpkKGRx9eiWJsJe7xoQgcve//Byi5wIBjWevI6kwPfoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974426; c=relaxed/simple;
	bh=uDT0ATYSKthF666srJ0UipySpgzzQDPQH/7dLSLIUMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N81kpPQOZ8JDUFwKeE0D1G2owSWMrkY6xzB5483p1L61u6nFVqyyIiwtsEO2Vvn9WVCMv0xH07kFvh8SlSJF1EAhbIZ1M991i+hSeYjUn9lK3/IWxChQ/3Zcaow9s6TOtu/S8yUS7fFNfLxNOU2ifGlgJEmIpjmEpbNGrDnBGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H2iU+pMb; arc=none smtp.client-ip=95.215.58.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H2iU+pMb"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=uDT0ATYSKthF666srJ0UipySpgzzQDPQH/7dLSLIUMw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974419; v=1; x=1790579219;
 b=H2iU+pMb+Q8nDOrleSC/ZtQil13XSkISiu+GdZGKtiZ7au90SJw/Rl5l1PCPtyXpJbHyzwVX
 T6rWuEa0B4GECs2zdLIBfi7FsKwI61bzAJf13XGF7ANfTXfYFmwoq2S8rzTE0r9Ab8zvVEAo4ph
 l0ESaoWyxz55/HLy0FLxnyTE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0634c950bb179c52;
	Mon, 21 Sep 2026 07:06:59 +0000
X-Mizu-Trace-ID: 0634c950bb179c52
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: axboe@kernel.dk,
	kbusch@kernel.org,
	tj@kernel.org,
	hch@lst.de,
	sagi@grimberg.me,
	yukuai@fygo.io
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	cuitao@kylinos.cn
Subject: [RFC PATCH 0/1] block: charge passthrough requests to the submitter's cgroup
Date: Mon, 21 Sep 2026 15:06:46 +0800
Message-ID: <20260921070647.1928289-1-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

While looking at cgroup IO control coverage, I stumbled into a hole
that is probably familiar to people who have worked on passthrough:
SG_IO, bsg, and the NVMe ioctl / uring command paths build requests
directly and dispatch them through blk_execute_rq{,_nowait}(),
never passing through submit_bio().  The mapped bio carries no blkcg
association, so the bytes never show up in cgroup io.stat, and none
of the rq_qos policies (iocost, iolatency, wbt) see these commands;
blk-throttle, hooking submit_bio_noacct() directly, is equally
blind.  On a scsi_debug device with iocost enabled and vrate pinned
to its 1% floor, a direct writer in a cgroup is throttled ~10x while
the same cgroup issuing sg_dd writes runs at full device speed with
io.stat staying at zero.

This RFC is a prototype asking for feedback on one possible
direction, not a proposal I am attached to: is charging passthrough
at dispatch time the right layer and the right semantics at all?

The patch associates the mapped bio with the submitter's blkcg in
blk_execute_rq{,_nowait}(), runs the regular bio accounting
(blk_cgroup_bio_start()) and the rq_qos throttle path with it, and
gates by opcode (READ/WRITE/DRV_IN/DRV_OUT, mapping the latter two
to READ/WRITE for io.stat classification) and to queues that already
have a gendisk so probing stays exempt.  On linux-next, with
scsi_debug + sg_dd and qemu emulated nvme + an NVME_IOCTL_IO64_CMD
loop, the transferred bytes are fully accounted in the issuing
cgroup, and with vrate clamped the pacing bites: the same 128MB
SG_IO run takes 0.025s unthrottled and 31.7s at the 1% floor, with
the issuing task sleeping on the iocost waitqueue like any bio
submitter.

Questions I am unsure about:

 1. Is always-on the right default, or should this hide behind the
    queue/iostats_passthrough opt-in from the passthrough iostats
    series, keeping default behavior unchanged?
 2. The throttle may sleep; all callers I found (ioctl / uring_cmd
    submit, target and error handling kthreads) are sleepable, and
    kthread-issued charges land on root and turn into no-ops - but
    I may have missed paths, and I'd rather ask than assume.
 3. What should happen on nvme multipath failover, where the bio is
    re-routed to another queue but carries the original queue's
    blkg?  Untested; guidance welcome.
 4. wbt also gains passthrough throttling through the same rq_qos
    walk - probably benign since wbt targets buffered writeback,
    but it is a behavior change I did not set out to make.
 5. blk-throttle does not benefit (it is not an rq_qos policy, and
    its queue-and-resubmit model does not fit bios already bound to
    a dispatched request); would a synchronous wait variant there
    be welcome as follow-up work, or is leaving it alone preferred?

Reproduction notes in case anyone tries: sg_dd coalesces into very
large single commands by default (use bpt=1), and a short burst from
a single cgroup rides the initial budget, so sustained transfers
are what show the pacing.


Tao Cui (1):
  block: charge passthrough requests to the submitter's cgroup

 block/blk-mq.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

-- 
2.43.0

