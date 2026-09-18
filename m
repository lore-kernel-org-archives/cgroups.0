Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FEB331EB0;
	Fri, 18 Sep 2026 04:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789705078; cv=none; b=iN8NvXJwOS3njSTcVxKHPgAMvCsQl4J04/i27zzYU4kxJZECxBu80e76OK6FqfzR05xJHPbXCCLiPuegktET86NsRFIiXAxTFdofcq8xZ5FOo6JSMK8p038Cpk7vzk6busfUcu/QnGs3HrvSQxDwyvjBqlP+iFgj5/imxgTs4gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789705078; c=relaxed/simple;
	bh=hAKfeURgimH+zD5v3mZSGKclYtLi5kuQXJoRur/UxdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M+B35J+r2cqVzhdIuSg6kwqrG9v3Mq0KdT0rSKMx6EBnXElftmnGatRpVSopnHAcG9ANu2n9/FAfX/b9wZvxk/zDXasxA2zMu2NYQwG4ie4N9g2PErWX4D43fkz3HZI74aXAdY4UQ+Qj0TT70+Nx1CbbyQCrO48lEUJs0+E7q2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dZdUIubP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZdUIubP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E811F000FF;
	Fri, 18 Sep 2026 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789705076;
	bh=WWxabFUVlB3kxXBm4kFTC6I3NzI8FakdyNfET9iDosQ=;
	h=From:To:Cc:Subject:Date;
	b=dZdUIubP7WawPPBoUISGeGIF5ET69n9vHrkUVvspPnrH7fxHweJj2pqEOElVx2vIL
	 0gFC5UbRFw2yyrUHY8PuEWsj3Mk6WHImCplwTlI60/XUI76P7v6YKqCFuBRQ3z6vC8
	 D4IfiDdtb9OpF9KJwyaUUmE0WCWrChqkCcnscAtjBVSlbLeT1gn8kIAGDPn7QXBRDy
	 uyVZJ/cSvCjKvvkrk1SWqjkP71K7D2BHoKJ257aiaDDnQ+ozchaBZMGL59Cyc8YNCA
	 cgNPGGgrw2vZkS3Mn+lrb1xgQs6YmdMPOv5u8KaDeiJ+0j1eeksXZuaT4qd7J9F0+p
	 3erBVRFc7D2AQ==
From: Yu Kuai <yukuai@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	Josef Bacik <josef@toxicpanda.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Cc: Yu Kuai <yukuai@fygo.io>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Tao Cui <cuitao@kylinos.cn>,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH v3 0/3] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Fri, 18 Sep 2026 12:17:41 +0800
Message-ID: <20260918041744.1526924-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

This is v3 of the preparatory series for the blkcg_mutex conversion
proposed in the related series [1]. That conversion moves queue-local
blkg topology synchronization from q->queue_lock to q->blkcg_mutex,
which is awkward while bios directly store queue-local blkg references.

Storing a blkg also ties a bio to one request_queue. A remapped bio must
drop that reference and recreate the association for the new queue even
when no blkcg policy needs it. Dying blkgs add another complication:
they disappear from the per-blkcg lookup tree before all pinned bio
references drain.

Patch 1 makes request_queue the authoritative lookup owner. A
queue-owned rhashtable keyed by the blkcg CSS ID keeps dying blkgs
discoverable until their references drain, while q->blkg_list remains
available for ordered walks.

Patch 2 stores and pins the queue-independent blkcg CSS in each bio.
Queue-local blkgs are created lazily by policy users, then pinned until
the bio changes devices or releases its cgroup state. Completion and
accounting paths which do not create a blkg remain lookup-only.

Patch 3 moves async bio punt state from blkg to blkcg, so punting alone
does not instantiate a queue-local blkg.

Changes since v2:

  - Rebase onto the latest for-7.4/block branch.
  - In patch 2, clarify why dm_bio_record() excludes BIO_BLKG_REF and
    add Nilay Shroff's Reviewed-by.
  - In patch 3, replace scoped spinlock guards with explicit
    spin_lock()/spin_unlock(), drop the redundant teardown check, and
    rely on zero-initialization for async_bios before publication, as
    suggested by Nilay Shroff and Christoph Hellwig.

Changes since v1:

  - Rebase onto the latest block-7.3 branch.
  - In patch 2, require every blkg rhashtable lookup to run inside an
    explicit RCU read-side critical section. Annotate blkg_lookup_any(),
    blkg_lookup(), and recursive wrappers with __must_hold_shared(RCU)
    so Clang thread-safety analysis verifies the contract.
  - In patch 2, exclude BIO_BLKG_REF from the flags saved by
    dm_bio_record(), since restoring an ownership bit cannot recreate
    the associated blkg reference.
  - In patch 3, use scoped spinlock guards for async_bios and annotate
    the list with __guarded_by().
  - Add Nilay Shroff's Reviewed-by to patch 1.

Changes since RFC v3:

  - Drop the RFC prefix.
  - Add Christoph Hellwig's Reviewed-by to patch 1.
  - Add Tao Cui's Reviewed-by to patch 2.
  - In patch 2, relax blkg_lookup_any()/blkg_lookup() to also allow
    q->queue_lock as an alternative to the RCU read lock.

Changes since RFC v2:

  - Drop the old patch 1 and send it separately as a bugfix for 7.3 and
    -stable, as suggested by Christoph Hellwig.
  - Rebase onto the latest for-7.3/block branch.
  - In the new patch 1, note that the remaining q->blkg_list walkers are
    cgroupfs/sysfs slow paths and can move to rhashtable iteration after
    the queue_lock-to-blkcg_mutex conversion.
  - In the new patch 1, explain the list_empty case in blkg_release(), and
    add an RCU lockdep assertion plus documentation that blkg_lookup_any()
    does not acquire a reference.

Changes since RFC v1:

  - Add patch 1 to wait for every old blkg to leave q->blkg_list before a
    shared request_queue is rebound, instead of treating root_blkg == NULL
    as completion of asynchronous blkg teardown.
  - Add patch 2 to replace the per-blkcg radix tree and lookup hint with a
    request_queue rhashtable keyed by blkcg->css.id, as suggested by
    Christoph Hellwig. Keep dying pinned blkgs in the hash until
    blkg_release() so bio-owned references remain discoverable.
  - Fold the v1 helper-only patch into patch 3, as suggested by Jan Kara
    and Christoph Hellwig, and make bio_blkcg() naturally return NULL for
    an unassociated bio.
  - Rework patch 3 so blkg_lookup_create() acquires the bio-owned
    reference, falls back to a live parent when creation or tryget fails,
    and updates bi_blkcg when the returned blkg belongs to an ancestor.
  - Make bio_blkg_lookup() lookup-only: it returns NULL unless BIO_BLKG_REF
    is already set. Use bio_blkg() in the BFQ and IOCOST merge paths which
    may need to create a blkg, while keeping blk_cgroup_bio_start() and
    completion paths lookup-only.
  - Move CSS online-reference handling into
    bio_associate_blkcg_from_css(), including fallback to the root blkcg,
    so bio_associate_blkcg() does not take a redundant reference.
  - Keep the v1 async bio punt conversion as patch 4 and document that
    async_bio_lock protects async_bios.

Previous versions:
  - v2: https://lore.kernel.org/r/cover.1789237876.git.yukuai@fygo.io
  - v1: https://lore.kernel.org/r/20260823133045.970199-1-yukuai@kernel.org
  - RFC v3:
    https://lore.kernel.org/r/20260818070641.756747-1-yukuai@kernel.org
  - RFC v2:
    https://lore.kernel.org/r/20260811064744.1139446-1-yukuai@kernel.org
  - RFC v1:
    https://lore.kernel.org/r/20260804065313.2092022-1-yukuai@kernel.org

Related series:
  [1] RFC v2 blk-cgroup: protect blkgs with blkcg_mutex
      https://lore.kernel.org/r/20260724123037.3004560-1-yukuai@kernel.org

Yu Kuai (3):
  blk-cgroup: use a request_queue rhashtable for blkg lookup
  blk-cgroup: store blkcg in bio instead of blkg
  blk-cgroup: move async bio punt state to blkcg

 Documentation/admin-guide/cgroup-v2.rst |   2 +-
 block/bfq-cgroup.c                      |  18 +-
 block/bfq-iosched.c                     |  19 +-
 block/bio.c                             |  22 +-
 block/blk-cgroup-fc-appid.c             |  10 +-
 block/blk-cgroup-rwstat.h               |   2 +-
 block/blk-cgroup.c                      | 346 ++++++++++++++----------
 block/blk-cgroup.h                      |  93 +++++--
 block/blk-core.c                        |   9 +-
 block/blk-crypto-fallback.c             |   2 +-
 block/blk-iocost.c                      |  12 +-
 block/blk-iolatency.c                   |  11 +-
 block/blk-ioprio.c                      |   2 +-
 block/blk-throttle.c                    |   3 +-
 block/blk-throttle.h                    |   2 +-
 drivers/md/bcache/request.c             |   2 +-
 drivers/md/dm-bio-record.h              |   5 +-
 drivers/md/dm.c                         |   2 +-
 drivers/md/md.c                         |   2 +-
 fs/gfs2/lops.c                          |   3 +-
 include/linux/bio.h                     |  26 +-
 include/linux/blk_types.h               |   9 +-
 include/linux/blkdev.h                  |   2 +
 include/linux/writeback.h               |   2 +-
 mm/page_io.c                            |  12 +-
 25 files changed, 381 insertions(+), 237 deletions(-)


base-commit: af78ca007be5f63dc34b8180c8063c1113697192
-- 
2.51.0
