Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23DE3AF66E
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 12:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992425; cv=none; b=qKL2ATbvqHAzE1syp7pkMn2CEHMUNw3vdRbw+WSAo6j0NIshYO5ODDdCsizq33Gjb73zft8p6nCsTfccr4GvJdd33uhPrvyXwk9tFWLSJ2apMPK0JnYGsK08jE/oonoMfyzXrqMPth/eNU1J3CWwq8Fz3qNogpscTpBM+oCJ6ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992425; c=relaxed/simple;
	bh=DdTVPz1QfbBgtnVhbDH8nDBRYlMIKdCe0cBp7p+nEA4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I/RzJvWECwMHtsQBZEBWJ/8W8e7IOJ+UujH2FX/Fgkv7Be3c5TKsfojrcKp5G+2CuwSL7dKLWSJg4UPbTYKnEBeVc/m4ZdunwU79b7mw7hNHgL3X2RWHqV0VJSt/I7tFhiS8vCqYQYwjblqRPYHb3h7asyBOparmWvZ4s/WRpmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=fU2rBcAD; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="fU2rBcAD"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-86212a185dcso3316058b3a.1
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 05:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789992422; x=1790597222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4yFs7aKADwEnqQrd+7DVxwZtTJDiMzxWaAyfpMFtjl0=;
        b=fU2rBcADmYQOfDDmyGFYlBIiKmaZ7elmKTsVqk5s6mzvH7ed/LP8czLi1qYlT/o999
         K8CQ3pYo665/r7WCumgleqncyec89cjQ4tm+P9vhoevFg8L6KrdbE4VO1Q2Et//WuwVl
         cdxp+r4lhFsRl2oXfBfoNqt8Q3pV1mr7mMprK/Whzs57uBPuYnmDQVZ8247t/FykgplM
         J9LerHjRpVPNTWjcnfkXrl09HhxH3JSGjLOawWJVysdCcaIMc8GPSV8Jf44KABY59cqm
         lY46M0JGvfA7Mbi2Fx59jY7DG0CBAyXH/yjJip2bvsf3OmhEU2BUCtntylfw4htbFNVy
         kUMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789992422; x=1790597222;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4yFs7aKADwEnqQrd+7DVxwZtTJDiMzxWaAyfpMFtjl0=;
        b=NUvd9W4Kgmo9u5NOq3SQvrR8sO+VLr9IYbrsVuvhsDKdlXtwjp6OH4RTSkc28nyEcE
         O9kGuhqtQS3rfzA8awVjyneq4cTJFB7Xz25Iin5ixTvcbt1rfmIAUdnZDl0GBCdL49CC
         rSJyjYrLecl0M7G/lzSUvlFh3w2oc67caF+nCfDxOfNX7/gWDTfy+rGiwaZV6Nb3/Yqu
         59BoeDHhXHZ2wtqagKmbNQizbZPgacH7OBfApCpAth/PiUMdiHSn4lnY+AZ+KX3aKXUv
         QlIz0UORCb6RfOVS1R7abuOGkuEnPC7cYyCoSIDl9OZkHa3sqGGyAdLeZngj/Oid4oEj
         3K1A==
X-Forwarded-Encrypted: i=1; AKwUvByf7aXNITKfzlJodpZAHROdfxuXA5GkaROqgteveyTxVm1Z2CnSalLrmcgW3PQkoG2048mh4r4c@vger.kernel.org
X-Gm-Message-State: AFuF++ktq2eGKk/seEGshJznfuDvUFK85Uqm/N7/fmnfI/oxIsx9+pKC
	1gTAFGPwQRMr/vOdTQ3bsYOc7NSsP2k8hRb5+6AJ1jrGXFfXacoAIfe0XQkqol1/Pv0=
X-Gm-Gg: AYBFou27Q8XqpSsF9mxDJNPTuLbbuf2zrf3pvqDfJQr0920RrKhcpKU8X8zOaGpCXNO
	m+UbLWKMILt3/WMI8baMFEGZ0s5x19jFn6ApTavle6nqdscCQUA3DcTCuMhqvMZ6442qqdGV1MA
	pvNRxl1eMMG4cMyjMiBQv53YpqiSnO13xEiqHWricC2haBQ03CycpzQOLYxvTLF+kt6k+YYrOJE
	MdmgRirL9y8ScyA7Xww4olsxOkVeDs5DYKgJGoR8bu1ZLniqgH8KTSM1eMDtsv5un131/KtFJ9N
	zLou3a+ZwrqxJaQ7m4QU2BXt9up9/puO4BN53M9NI/GD1+x8V46QKuvj07/F6sJKgarpw+Usqvb
	zrF5IHWkTqy3Nk3eVQm1nDoP4YlAWYWJHxHJuk1jW1tzVbOK5vVJW2y6UkK5FMV5CAXva04K1Kt
	W0v28G4ShukDG0bykR/ZQhHAs/UTh9kRP93T80iXczsTHTUXFcK78mlRreIEdEU+g1onDhBPsSk
	pM=
X-Received: by 2002:a05:6a00:4517:b0:872:20f2:3282 with SMTP id d2e1a72fcca58-874de507ca5mr14569283b3a.22.1789992422298;
        Mon, 21 Sep 2026 05:07:02 -0700 (PDT)
Received: from localhost ([106.38.226.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a9b0c504sm3156937b3a.33.2026.09.21.05.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 05:07:01 -0700 (PDT)
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
Subject: [PATCH v7 0/3] memcg,writeback: flush foreign bdev mappings separately
Date: Mon, 21 Sep 2026 20:06:55 +0800
Message-Id: <20260921120658.1627992-1-sunjunchao@bytedance.com>
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
slots on a shared workqueue and delay unrelated work. If allocation
fails, the existing foreign-wb mechanism remains in use.

This primarily affects filesystems that keep metadata in the bdev page
cache, such as ext4 and other buffer_head users, rather than the usual
metadata writeback paths of XFS and Btrfs. The decision still does not
account for how much of the memcg's dirty memory belongs to the bdev:
even a single dirty bitmap block can trigger writeback of the entire
bdev mapping when the memcg enters dirty throttling.

Changes since v6:
- Drop open_mutex and the openers check from bdev_flush_by_dev(), and
  add a !CONFIG_BLOCK stub.
- Follow the existing foreign-wb tracking policy: use timestamps for
  oldest-first replacement and expiry, and allow dirtying during an
  in-flight flush to re-arm the record.
- Replace frn_lock with an atomic in-flight flag.
- Drop WQ_MEM_RECLAIM and explain the separate max_active budget.
- Guard bdev work submission when workqueue allocation has failed.
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
  writeback: record bdev targets in foreign writeback tracepoints

 block/bdev.c                     |  18 +++++
 include/linux/blkdev.h           |   4 +
 include/linux/memcontrol.h       |  12 +++
 include/trace/events/writeback.h |  22 ++++--
 mm/memcontrol.c                  | 124 ++++++++++++++++++++++++++++---
 5 files changed, 160 insertions(+), 20 deletions(-)

-- 
2.39.5
