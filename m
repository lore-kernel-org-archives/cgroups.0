Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203DE3939B1;
	Sun, 20 Sep 2026 09:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789896245; cv=none; b=c3Iy+87PN5v50nRxnovGQRoZVgbQUgRRag6w2UjkCt4v/RcwApQbcEtN8lKxR6ExmP8EDM5YWlcxs/HnlwLlG0KGm0ntTb3XrMp02RJpJIZZRIX9oCr83FLLz0PozcbEsvo0Ct5Ujp8bLLYzeferyh9ZcndroMYlpkuBIaMfR9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789896245; c=relaxed/simple;
	bh=NpsBroT/8a5poSPRtpeGWM1uOydviiavJJhsTPwpqa4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DuKBw6Kq42CSNYqZ/26tSaWzFTVeCmbS9sMGwmPk9Il+bs9ZNGbTXipRL2SbHG/BHrBjZSZJfnp4qUC3sPNtsrWg0UJ9SGy3CbSgErCHFMP7l04gDA24bP3YA//v4oCemEC74NrgcQ0ur5qH1kao3LeRUoO6TO8y+purMi6IApM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RjGRP7gw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RjGRP7gw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA1B1F000FF;
	Sun, 20 Sep 2026 09:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789896243;
	bh=5Zw9rJKZMZuSI+1jUTLBTxzKxPkXx7fMF487IMc+57k=;
	h=From:To:Cc:Subject:Date;
	b=RjGRP7gw9J6P3KEqUaIB6cDxXJQhT8hzei8Jwh2Nn3InDNpo9Mho80D9CpQxhAVRK
	 aBhXNLlHPQyd5p8OwuBQl5Iqrm0/6w5/yYfvlQIGUEQtf7jxe/WRjimLserbyQntBH
	 TpxqEqB6k9BLGNGVl/gqE2RN+JqoOryIYV34aohaGRE/08b5kWBFErEa/nb8/oFK7u
	 Yxti2M6U7/nf8NyXNH1gxEb0rmt2pFWMxr+9p3Kfc/FFEDxjmiKtBYrOtK4pn2F7Sh
	 SzXiC4mt2ivvlO4ppZ0xGS/h8g7W7WplY1cCuGW6ztDxmtgwK1t+BJrwUfmJEY/fCA
	 0h34u9P82y+2A==
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
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
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
Subject: [PATCH v4 0/3] blk-cgroup: store blkcg in bio before blkcg_mutex conversion
Date: Sun, 20 Sep 2026 17:23:48 +0800
Message-ID: <20260920092351.2434283-1-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

This is v4 of the preparatory series for the blkcg_mutex conversion
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

Changes since v3:

  - In patch 2, have blk_cgroup_bio_start() look up an online blkg under
    RCU and hold a temporary reference for accounting. 
  - In patch 2, dm may restore bi_flags without restoring that reference,
    instead of fix this problem in dm, drop the blkg pin after
    blk-throttle for bio-based drivers. This is safe because
    blk-throttle is the only policy and blkg is not longer needed.
  - Add Nilay Shroff's and Christoph Hellwig's Reviewed-by to patch 3.

Changes since v2:

  - Rebase onto the latest for-7.4/block branch.
  - In patch 2, release BIO_BLKG_REF after bio accounting and before
    entering a bio-based driver's ->submit_bio(), instead of filtering
    the flag in dm_bio_record(). Add Nilay Shroff's Reviewed-by.
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
  - v3: https://lore.kernel.org/r/20260918041744.1526924-1-yukuai@kernel.org
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
 block/blk-cgroup.c                      | 355 ++++++++++++++----------
 block/blk-cgroup.h                      |  93 +++++--
 block/blk-core.c                        |  17 +-
 block/blk-crypto-fallback.c             |   2 +-
 block/blk-iocost.c                      |  12 +-
 block/blk-iolatency.c                   |  11 +-
 block/blk-ioprio.c                      |   2 +-
 block/blk-throttle.c                    |   3 +-
 block/blk-throttle.h                    |   2 +-
 drivers/md/bcache/request.c             |   2 +-
 drivers/md/dm.c                         |   2 +-
 drivers/md/md.c                         |   2 +-
 fs/gfs2/lops.c                          |   3 +-
 include/linux/bio.h                     |  26 +-
 include/linux/blk_types.h               |   9 +-
 include/linux/blkdev.h                  |   2 +
 include/linux/writeback.h               |   2 +-
 mm/page_io.c                            |  12 +-
 24 files changed, 396 insertions(+), 234 deletions(-)


base-commit: 6aff7d30932eda1aa3e96364e73ec6fbcfbefe1a
-- 
2.51.0
