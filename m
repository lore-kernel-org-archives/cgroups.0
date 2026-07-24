Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9262042D75B;
	Fri, 24 Jul 2026 12:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784896251; cv=none; b=Yo16wt2ogs13WXyP7hXN6TxaGV/WuU9nV4npqxz+dsU4N4mxIkErJ+A2Z/8jR6gXPxPSeKBBJDs04T/ITnDm29hY8+6XCQEjr9zXc9FAP8AVsVIALf8fQjKpNNzbB0j2IdqTp+24447+0DTjR4lej4iVnq6b7odu4m84oLKSzvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784896251; c=relaxed/simple;
	bh=Q0jESNPTrZhVyaOuqU33RhhTlFVPSViq1FoJQU3cjmE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GpBHEA3AyWUPO05i1pSHuGWy/qG8we3hUMxL5xQtZIxEAmsSifw7OVJF5FfSc8xBretMtZvTpXav66EzfbhWG/Ih6xB6qPaxZByUG17lygQ13BmDbUUqSp9F6Ne80qDyddqv2eWrqDjhAeoGKf+F/ujGJ+CRf28B9LDQFCyIUoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HtUdpXxq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtUdpXxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8E81F00A3E;
	Fri, 24 Jul 2026 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896250;
	bh=kEAnaGqaytAbEgYaQP5zjlCigKJ7kvFow6K/FiocpQY=;
	h=From:To:Cc:Subject:Date;
	b=HtUdpXxqZszVtOHLTeiOs++iH5JtidQRVxKNwAx/JI15LwXfG5mUAnf67jKKFy43N
	 1eaCT3kW2U9cWked5hWqdMWKTRadl3PlMl2znIyZO5Wc9abYv7pn51KnO7h9YXjBK4
	 jqZBR4sddn+L0evOLwXJkpmCr8QSLRTWFSHYLx2JesBGVohkinEOC0e+6qFoqISGIC
	 Ktxk8LZo0osE7bpn9vdIRCVXT1lklucIRoFUXQiBaecuaJTNDXxZ8xieh46eUJF+Lp
	 zjD5XJpJ8Bk95VaHQ+L2moHsRtHkZfH4oZCA0+yG1A7Ol6dLkP72mFll4xUONXrvI7
	 IcuGG1Qe7IdjA==
From: Yu Kuai <yukuai@kernel.org>
To: axboe@kernel.dk,
	tj@kernel.org
Cc: hch@lst.de,
	dongsheng.yang@linux.dev,
	cengku@gmail.com,
	josef@toxicpanda.com,
	nilay@linux.ibm.com,
	ming.lei@redhat.com,
	yukuai@fygo.io,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 0/8] blk-cgroup: protect blkgs with blkcg_mutex
Date: Fri, 24 Jul 2026 20:30:29 +0800
Message-ID: <20260724123037.3004560-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

This RFC moves queue-local blkg topology synchronization from q->queue_lock
to q->blkcg_mutex -- the same goal as v1 [1] -- but is restructured around
moving blkg association from bio_set_dev()/bio_init() into the submit path.

bio_set_dev() and bio allocation with a bdev currently associate a bio with
the destination queue's blkg.  Those helpers run from locked, irq-disabled
and GFP_NOWAIT contexts, so once missing-blkg creation is serialized by
q->blkcg_mutex they could no longer sleep safely.  Rather than auditing and
patching each such caller (as v1 did), v2 moves blkg association out of
bio_set_dev()/bio_init()/bio_reset() and into submit_bio()/
submit_bio_noacct(), which are always sleepable; bio_set_dev() now only
records the target device and drops the stale blkg.  This follows Christoph
Hellwig's review of v1.

q->blkcg_mutex then serializes blkg lookup/create/destroy, policy
[de]activation and configuration preparation; blkg allocation moves into
blkg_create() with a gfp_t argument; radix-tree preloading is removed; and
creation is shared between the bio path and configuration.

Nowait: REQ_NOWAIT I/O must not sleep to create a blkg.  The nowait
association path trylocks q->blkcg_mutex and allocates with GFP_ATOMIC; on
atomic context, mutex contention or allocation failure it leaves the bio
unassociated and submit_bio() completes it with BLK_STS_AGAIN so the
submitter retries.  This replaces v1's nowait-threading through the
bio_set_dev() callers.

Changes since v1 [1]:

- Reworked on top of "associate blkg in submit_bio instead of bio_set_dev"
- Dropped the per-subsystem bio_set_dev() workarounds -- NVMe multipath
  retarget (v1 1), dm-thin (v1 2), dm-snapshot (v1 3), bcache (v1 8),
  dm-bufio (v1 9), dm-pcache (v1 10), DM NOWAIT remaps (v1 12) -- no longer
  needed because bio_set_dev() no longer associates.
- Dropped atomic bio allocation -- bio_alloc_atomic() (v1 5) and
  non-blocking bio allocation with a bdev (v1 7); the
  nd_virtio/ocfs2 callers are handled separately.
- Dropped the nowait-bio-allocation association helpers (v1 6, 11); nowait
  is handled once, at submit, by failing the bio.
- Kept and adapted: blk-throttle private runtime lock (v1 4); the
  blkcg_mutex conversion (v1 14, now also annotating submit_bio() with
  might_sleep() since association may sleep there); radix preload removal
  (v1 15); blkg_create() allocation (v1 16); shared creation (v1 17); and
  the BFQ locked-cgroup-update fix (v1 13).

[1] v1: https://lore.kernel.org/r/20260704195124.1375075-1-yukuai@kernel.org

Yu Kuai (8):
  block: associate blkg in submit_bio instead of bio_set_dev
  blk-throttle: protect throttle state with td lock
  blk-cgroup: protect blkgs with blkcg_mutex
  blk-cgroup: remove blkg radix tree preloading
  blk-cgroup: allocate blkgs in blkg_create
  blk-cgroup: share blkg creation between lookup and config prep
  bfq: avoid blkg lookup from locked cgroup update
  block: fail nowait bio submit if blkg allocation can't sleep

 block/bfq-cgroup.c    |  26 ++-
 block/bio.c           |  18 +-
 block/blk-cgroup.c    | 434 +++++++++++++++++++-----------------------
 block/blk-cgroup.h    |  16 +-
 block/blk-core.c      |  36 ++++
 block/blk-iocost.c    |   5 +-
 block/blk-iolatency.c |   7 +-
 block/blk-throttle.c  |  93 ++++++---
 include/linux/bio.h   |  18 +-
 9 files changed, 350 insertions(+), 303 deletions(-)


base-commit: 093fbffe03f5c1bb9c10a9e5aa65b23250844403
-- 
2.51.0

