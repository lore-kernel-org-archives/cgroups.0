Received: from mail-pz2-f40.google.com (mail-pz2-f40.google.com [74.125.228.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A306442FA4
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 06:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790318689; cv=none; b=aIzqtRYhXo3nugMsI5GJYPZ8lasqQ5SUJlHSwZrSTMy2CNt09rvsHXWyXRKCqo45B9bK9atxvoZ1maJg9gJUvGPy+eaJVjVQ59IyZxHSZ0Xwwkk8S6QGwO5VL3+gG/rHeE5AHKix01JhJ6i8jYmotewLI5cNn3SNnmEpz9Fy6+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790318689; c=relaxed/simple;
	bh=WNzj1ofvlW/StQGSjkT6hTMDk1NSQ+fH1rnZp30fMcI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=juzOHJNt4P3GA+zP/uxRCprJRKuScgcVqHbbCcFl9haeBZ3pyPv/hx3RgWUGBny/oIyhUIpi75hEu2jHUE5rg/4hDjyVDrcCCRVNN6KFojUalF1JunVnevKCUyF3xSBjzZ4vBghQzImISG2drA/VxMu7u0dHPybXoB2QmTGoWdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=XSd+N3aq; arc=none smtp.client-ip=74.125.228.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="XSd+N3aq"
Received: by mail-pz2-f40.google.com with SMTP id d2e1a72fcca58-8804c1728f9so207364b3a.3
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 23:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790318687; x=1790923487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2CDje0QwiVgx6IbktJTGL2P21t+Ebt9LY+FLAFXNJ+o=;
        b=XSd+N3aqlnjwpCcoFJltBJxUkZhszXf62y/RTIrKn17nMMtycfIwQyOczOxhMm1OfF
         fI57bKs/1euARjygFEhN3Sz47Q2emjgwzURlkCvRLcXucoEKPg+Z7z+pv+2ydeQqbhFY
         mS4Zsl/64TS/5KUlLsibvg5ywnatU22BWtvGQDaQKDWMyMwsSsYCQZ6Pa4KZHu1vCmbk
         hVDsCeqIpMOp4qcBsaLX7qNxDVP1kpciuYKpuwAmhTOSFUZSVI4tTGeMAW/X/MZj8geB
         HaOajKlsH0OTas8RNXAF7DHWTfvV8RPrCRm4ig83hGrGjuw2MF14+9055xAvL0QS+4Sn
         I+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790318687; x=1790923487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2CDje0QwiVgx6IbktJTGL2P21t+Ebt9LY+FLAFXNJ+o=;
        b=0AouTnsE/OqvLUyMUy/XLbDocHSRoA1Rv50OLaWIAnOVDSmD5ZzwuZYyPD6F+iGWHm
         qc8UU81eNsOiPMP1evrMqE/XSSXkIv3IgUR1bTHMlejxNJqkKEPRMvXmU6uyud9Pfzmp
         +pS6s2ZewQ0wOFgY+Ols4u8hqRfl/jTNSpNsFl1HXNY6Pxs7Mz7StJKBWdcEeon/wcCA
         smc2hTmK22BYQIhMNtZifI4ueUYuCSlhtDunBUif7qOb4ts1WIeenuC++aVhWpAS5Na6
         MpRD2aLsCl0UFFwShVtHv8kjSYzJwHFsZDXn8AoP+BiRyzsHnyn0rEpJCNComt/OlVOG
         5cCw==
X-Forwarded-Encrypted: i=1; AKwUvBw60f35dOZgqXShOBnwt6QuA2LhMDpH7F3sQSeupl+BHTXlix4HuGXe6X3SBeywjayGF4UlyifI@vger.kernel.org
X-Gm-Message-State: AFuF++njE5XGvtXXJJrljIMXGcqr01fKe5gbZasNgieDnfnaRjd8bb5r
	nYN49WNJGAqVGMPS9BH/Epg+yVu5/9WA6GyBne4nq61BCJ2wwjRJ1vqvklzJ0K6AgUQ=
X-Gm-Gg: AYBFou1GGerdzBHf6GF1OzAkZnGbfkMcIS1xariFisCSM1VqKdJyrfZbEjrt0J7GrMh
	0irT4JrrHk3d4G+VBWFDOYLHixB9j7JqFMb91l7lxvoXLXcENMpeLVanQnVNO7TC8rCGonjs3LN
	dHwqGUMZMkISn62Cs2gCIP18KWI87/qqhK9UICoRiDB/ycpyQ7weHVZHPJWxS8EpOWjYqs4pna2
	D4Yl6fbjS8Foi9tpyFMUL61waZ8j4CJdnacr+ygamNvHvwO4ZLX7EuP01bKG5i64toGWi+oS4jH
	/Fg9EflqFyXp2lG0ALqFpyZ3OKFtiaiKDki3csZ4L5BXWiaTyKz8GEgTDsU45spFWTizg1sj8hG
	V/Qpj4p8dXV+8K1Vvrp5K6V5eWJdtsejTwlkzq0lPdKsH+umXLjdf3iOjJclLYS294RJEjD0f0p
	Q7v7zdoMkquaMSsw5PB9kQRn53LgBXJTIgOppsE3Hoz3ImFRtzPqC6qPF+nXn0WZ4qe3H98gUeb
	sKAGpDCcKv6XQ==
X-Received: by 2002:a05:6a00:6088:b0:871:2152:980e with SMTP id d2e1a72fcca58-87e9995d1c6mr3952766b3a.23.1790318687288;
        Thu, 24 Sep 2026 23:44:47 -0700 (PDT)
Received: from localhost ([106.38.226.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feb57e56csm575244b3a.48.2026.09.24.23.44.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 23:44:46 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: axboe@kernel.dk,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	willy@infradead.org,
	jack@suse.cz,
	tj@kernel.org,
	akpm@linux-foundation.org
Subject: [PATCH v9 0/3] memcg,writeback: flush foreign bdev mappings separately
Date: Fri, 25 Sep 2026 14:44:41 +0800
Message-Id: <20260925064444.3944820-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series avoids owner-wide foreign writeback triggered by dirtying
shared bdev inodes. Instead, it tracks bdev targets separately and
schedules writeback of their mappings.

Problem
=======

Bdev inodes are commonly shared by many memcgs. Dirtying their pages
can cause the owner wb to be tracked as foreign, triggering writeback
of the entire wb rather than just the bdev mapping.

In production, almost all the foreign dirtying we traced came from bdev
inodes. Across our observations, a bdev mapping had as little as about
10 MiB of dirty pages, yet foreign flushes targeted the entire owner
wb. On one machine, we observed 599 such works queued on one wb, with
an average request budget of about 43 GiB per work.

Measured impact
===============

The synthetic test used a VM with 4 vCPUs, 8 GiB RAM, ext4 and cgroup
v2, with device write bandwidth capped at 200 MiB/s. Background fio
repeatedly overwrote a 256 MiB file using buffered I/O, while
foreground fio performed sequential direct writes. Four memcgs
generated metadata and buffered writes to trigger foreign flushes.

We measured completed block writes to the background fio file,
including final sync, and foreground fio bandwidth, latency and
completion time.

Across three runs per kernel, mean background file write I/O decreased
by 72.7%, foreground bandwidth increased by 23.0%, and completion time
decreased by 18.8%.

Metric                         Baseline    Patched     Change
Background file write I/O (GiB)    6.154      1.680     -72.7%
Foreground bandwidth (MiB/s)      150.29     184.81     +23.0%
Foreground completion time (s)   109.203     88.652     -18.8%
Foreground mean latency (ms)      212.84     172.74     -18.8%

How it helps
============

Frequent writeback of the file overwritten by background fio reduces
the opportunity to coalesce buffered writes in the page cache.
Several overwrites of the same page can otherwise result in a single
write of its latest contents. Flushing between updates instead writes
the same page repeatedly, generating more device I/O for the same
application writes.

This additional I/O makes the device reach its performance limit
more easily and competes with foreground I/O for device bandwidth.

The benefit is expected to be most pronounced when these conditions
occur together on the same device:

1. Limited device bandwidth, as with an HDD, makes the additional
   writeback I/O more likely to saturate the device.
2. Multiple cgroups perform buffered overwrites. Frequent foreign
   writeback reduces write coalescing and increases device I/O.
3. Concurrent direct I/O bypasses the page cache and competes directly
   with writeback I/O for device bandwidth.

Approach
========

Following Jan's suggestion, this series records foreign bdev targets
separately and flushes their mappings instead of their owner wbs. This
preserves a way for dirty throttling to initiate bdev writeback while
avoiding owner-wide writeback triggered by these records. The existing
foreign-wb mechanism remains unchanged for other inodes.

Tracking uses oldest-first replacement and expiry after
dirty_expire_interval. Further dirtying during an ongoing flush can
trigger another flush after it finishes.

Tracking is best effort: each memcg keeps a bounded set of device
numbers without persistent device or inode references. Recording runs
under mapping->i_pages with IRQs disabled, while dropping a device
reference can sleep. A memcg that never enters dirty throttling could
also retain an unused record and pin the device object indefinitely.
Recording only dev_t avoids these lifetime constraints. Device removal
and device-number reuse may cause an unintended best-effort flush,
which is an accepted trade-off.

Writeback submission may block for a long time, with up to four work
items outstanding per memcg. A dedicated unbound workqueue provides
a separate max_active budget so these flushes do not exhaust active
slots on a shared workqueue and delay unrelated work. If the workqueue
cannot be allocated at boot, bdev inodes continue to use the existing
foreign-wb path.

Flushes use write_inode_now() with WB_SYNC_NONE to skip inodes already
under writeback, avoiding competing writeback passes on the same bdev
inode.

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. This also covers buffered
writes to raw block devices. The decision still does not account for
how much of the memcg's dirty memory belongs to the bdev: even a single
dirty bitmap block can trigger writeback of the entire bdev mapping
when the memcg enters dirty throttling.

Changes since v8:
- Use write_inode_now() with WB_SYNC_NONE to avoid competing writeback
  passes on the same bdev inode.
- Fix a race in foreign bdev tracking.
- Add separate tracepoints for foreign bdev tracking and flushing.

Changes since v7:
- Update comments and commit messages as suggested by Tejun Heo.

Changes since v6:
- Drop open_mutex and the openers check from bdev_flush_by_dev(), and
  add a !CONFIG_BLOCK stub.
- Follow the existing foreign-wb tracking policy: use timestamps for
  oldest-first replacement and expiry, and allow dirtying during an
  in-flight flush to re-arm the record.
- Replace frn_lock with an atomic in-flight flag.
- Drop WQ_MEM_RECLAIM and explain the separate max_active budget.
- Expand the dev_t lifetime rationale and filesystem scope, update
  the foreign-dirty overview, and drop the Fixes tag.

Changes since v5:
- Fix repeated overwriting of slot 0 in patch 2 and add comments.

Changes since v4:
- Add before-and-after performance comparisons to the cover letter.

Changes since v3:
- Flush foreign-dirtied bdev inode mappings separately, as suggested
  by Jan.

Thanks.

Julian Sun (3):
  block: introduce bdev_flush_by_dev()
  memcg,writeback: flush foreign bdev mappings separately from owner wbs
  writeback: add tracepoints for foreign bdev writeback

 block/bdev.c                     |  19 +++++
 include/linux/blkdev.h           |   4 +
 include/linux/memcontrol.h       |  12 +++
 include/trace/events/writeback.h |  67 ++++++++++++++++
 mm/memcontrol.c                  | 127 ++++++++++++++++++++++++++++---
 5 files changed, 220 insertions(+), 9 deletions(-)

-- 
2.39.5
