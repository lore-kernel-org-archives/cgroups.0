Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA662D322E;
	Sun, 23 Aug 2026 15:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787498979; cv=none; b=bYWKTcpSS7kUq5/2fQVRqztpeqtB94HxJxhf54RIs8GV8jh+dQXyUmpDdRislvnukUDiBF8GJIHQ2iVCLt8vdwIU/jqdlHxZF+c8jBU+aSl9ZTZvMvPExfLrZeIt6JL274tWBeKCa7KBVdfRLuowVyPbC+YrGtDXTbEfqEv8LN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787498979; c=relaxed/simple;
	bh=34+mb1KkGdUdZcVmTZk/4A0ySjkpKEi5Sa6JYo2pJGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=map+ftFe/D1m2/Y62oebVYSFbRetdlUijmD2ecoa3xkjlNebm7EcvJJVDadlP94Lty+tmJ7Hjp+ElRAjW6qY1zBoY6mEwzzlTSmQEX5jZdP+RB/DXqm7vZwBsEq08kGhZbs1mFWJRKrgSYlVgyVeX3bm09C5Q69eRrybShPfsfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyPWA5yY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyPWA5yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8EF1F000E9;
	Sun, 23 Aug 2026 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787498978;
	bh=gJTlw9pG0iF77MWoDrbfyd9wd1A8GKfOoxlkht66Vv8=;
	h=From:To:Cc:Subject:Date;
	b=oyPWA5yYEsdMkuhrmrnedKtFDPvFXkjP2uCU8DuOnb3FBz0+0c9VNiVuTzdMMRs/7
	 dpTXVwB2zKrzybq/XQ2SySR3duHMdewyYQZCDTKUA/KNw6UzN2Qr5OYwmJWDiF9ebT
	 RArh4zDn6EjQT0MiO3nbYNEh3Em3YWfNYINZ36Gq0RVSQveDlKdBQltgPJ/hB6jzMK
	 Eth3wIdRxiwWYLzFQgsjxy4cdh7Wg2TmBtiYbBpKYms95qFZdAq//L4pS5f4jOpY+l
	 s13BsAUnU6r2hrZKY5+iLXLiLyuyz6ywoMclReh5zmiENJ3/xeALoI9jXbWFgEU+kA
	 uZMVle9yAWzeg==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cui.tao@linux.dev>,
	Hannes Reinecke <hare@suse.de>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 0/6] blk-cgroup: protect blkgs with blkcg_mutex
Date: Sun, 23 Aug 2026 23:29:19 +0800
Message-ID: <20260823152926.1043863-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

This RFC moves queue-local blkg topology synchronization from
q->queue_lock to q->blkcg_mutex.  It is based on the preparatory series
which stores a queue-independent blkcg in each bio and uses a
request_queue-owned rhashtable for blkg lookup.

q->queue_lock also protects block core state and is taken from atomic
contexts.  Keeping blkg creation, destruction, configuration and policy
lifecycle operations under that lock prevents those paths from using
sleepable operations and couples blkcg policy state to unrelated queue
locking.

Before switching locks, patch 1 moves pd_free_fn() calls outside spinlocks;
iocost's free callback can wait for an hrtimer callback on PREEMPT_RT.
Patch 2 gives throttle runtime state a private spinlock and shuts down its
timers before freeing their state.  Patch 3 then moves blkg topology and
policy synchronization to blkcg_mutex while retaining an RCU fast path for
existing-blkg I/O.  Patches 4 and 5 move allocation into blkg_create() and
share hierarchy creation with the configuration path.  Patch 6 keeps blkg
creation lazy for policy users and handles REQ_NOWAIT without sleeping,
falling back to the closest existing blkg when creation cannot proceed.

A git branch is available at:
  https://git.kernel.org/pub/scm/linux/kernel/git/yukuai/linux.git/log/?h=block-7.3-blkcg_mutex-v3

Changes since RFC v2:

  - Base the series on the bio/blkcg preparatory series instead of moving
    blkg association into submit_bio().  Drop old patch 1 accordingly.
  - Drop old patch 4 because the preparatory series replaces the per-blkcg
    radix tree with a request_queue rhashtable, so radix-tree preloading no
    longer exists.
  - Drop old patch 7 because bios now retain their blkcg independently and
    BFQ can use the blkg already pinned by the bio.
  - Add patch 1 to detach policy data under the existing spinlocks but call
    pd_free_fn() after dropping them.  Keep this fix separate so the mutex
    conversion does not redesign generic policy teardown.
  - In patch 2, shut down all per-group and top-level throttle timers
    before freeing throtl_data.  Use timer_shutdown_sync() for final
    teardown so a concurrent callback cannot rearm a timer after shutdown.
  - In patch 3, keep bio_blkg() on an RCU fast path when the target blkg
    already exists, taking blkcg_mutex only when hierarchy creation is
    needed.
  - In patch 3, hold blkcg_mutex for the complete blkg_destroy_all() walk
    and remove the spinlock-era batch counter and cond_resched() restart.
  - Adapt patches 4 and 5 to the rhashtable-based lookup and make
    blkg_lookup_create() return the closest existing blkg through an out
    parameter without acquiring a reference.
  - Rewrite old patch 8 as patch 6.  Keep allocation lazy in bio_blkg()
    instead of preparing every REQ_NOWAIT bio in submit_bio_noacct().  Use
    mutex_trylock() and GFP_ATOMIC when creation is possible; otherwise
    lookup and pin the closest existing blkg under RCU.  Valid policy I/O
    therefore does not fail with BLK_STS_AGAIN or receive a NULL blkg.
  - Do not add nowait-specific changes to blk-throttle, blk-iocost or
    blk-iolatency because bio_blkg() retains its non-NULL result for valid
    policy I/O.

Changes since RFC v1:

  - Rework the series on top of "associate blkg in submit_bio instead of
    bio_set_dev".
  - Drop the per-subsystem bio_set_dev() workarounds: NVMe multipath
    retarget (v1 patch 1), dm-thin (v1 patch 2), dm-snapshot (v1 patch 3),
    bcache (v1 patch 8), dm-bufio (v1 patch 9), dm-pcache (v1 patch 10) and
    DM NOWAIT remaps (v1 patch 12).  They are no longer needed because
    bio_set_dev() no longer associates a blkg.
  - Drop atomic bio allocation: bio_alloc_atomic() (v1 patch 5) and
    non-blocking bio allocation with a bdev (v1 patch 7).  The
    nd_virtio/ocfs2 callers are handled separately.
  - Drop the nowait-bio-allocation association helpers (v1 patches 6 and
    11).  Nowait is handled once at submission by failing the bio.
  - Keep and adapt the blk-throttle private runtime lock (v1 patch 4), the
    blkcg_mutex conversion (v1 patch 14), radix preload removal (v1 patch
    15), blkg_create() allocation (v1 patch 16), shared creation (v1 patch
    17) and the BFQ locked-cgroup-update fix (v1 patch 13).

Previous versions:
  RFC v2:
    https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.org
  RFC v1:
    https://lore.kernel.org/r/20260704195124.1375075-1-yukuai@kernel.org

Yu Kuai (6):
  blk-cgroup: call pd_free_fn() outside spinlocks
  blk-throttle: protect throttle state with td lock
  blk-cgroup: protect blkgs with blkcg_mutex
  blk-cgroup: allocate blkgs in blkg_create
  blk-cgroup: share blkg creation between lookup and config prep
  blk-cgroup: make policy blkg creation nowait-safe

 block/bfq-cgroup.c    |  10 +-
 block/blk-cgroup.c    | 270 ++++++++++++++++++------------------------
 block/blk-cgroup.h    |  11 +-
 block/blk-iocost.c    |   8 +-
 block/blk-iolatency.c |   7 +-
 block/blk-throttle.c  |  93 +++++++++++----
 6 files changed, 207 insertions(+), 192 deletions(-)


base-commit: 81a5d989c04055860a66923e41151fd7faf4c295
-- 
2.51.0
