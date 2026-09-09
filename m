Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783131AC45D
	for <cgroups@vger.kernel.org>; Wed,  9 Sep 2026 03:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788925429; cv=none; b=fXftjue207Y1GQArQc3E0yccOLeB9bSGKrZfNL9PE+mV+4uEUwWrbylMwfsaTzYu9v8lhPRwLi6fX0hAbkNeLo/H3XOra48Gzbi51V+pWkBp4DWctwK/j0ieLbwlf45E6SZ9NK1wISB3n4fsWmnhLXetuN3TJO2Ntrgm3jp1mTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788925429; c=relaxed/simple;
	bh=hcjcyrx4NnLd+4sco5obi2YPfyZnF6oovxqA6Uvpvxo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OunR3rwBDhwGY8LXwNBtcdwFj5Vk14Nau4I/qzu7+fv273qRCfav2Dpa640ilcJgJigOGiVBo7xVUVedsB/F6kUYgaWXBMYadmJxntnTPzU2m32L5Y2qYyU664xSuyrXzDpyNx+IZTLcWsUfPUFy+w2M++Q+EOayJDEW0Uxg53E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Qvc70PKi; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Qvc70PKi"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84e0688b7e8so4149973b3a.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 20:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788925427; x=1789530227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AUs1qeMV4Avebc488kXwADqOO+7MG6W6kUjE+T02g2E=;
        b=Qvc70PKiZeg+5rsATD9z9RSYDTyLNlqhYdOzwJBY82qgi+gt90lJz0a0gEK51KuCAu
         fqF+YaKGMwgQgKGTFLHLcdwBcFwi/s3wXu/jGtH3kFNqeRBgMP4xJgLLMdqx9TrmsX+G
         Te7rgwcLiQw82LGZEn1GjZ+6NA4Mn0Ca88mSItMuciPX1fD6HFPwquEQ6zu/qC4LLsIv
         DYg0tHk1RmHrOgFmryxRr5A9WzYup6oONhuIzSigKr5vV0OwTXSNq/ozVoq78kfTxqhn
         6IfT+tYddhxW/uGgN+/7vusQ9iT6R6BLEBbSwnoPTxTDbiyP2jnNO48md7k662tVKuUP
         XY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788925427; x=1789530227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AUs1qeMV4Avebc488kXwADqOO+7MG6W6kUjE+T02g2E=;
        b=ZItThU/52ZdCUCuqceVeJsJgxcuHKOlRt/IZDZ4zgXcFUBjB7UMKVOn6aqnvGFEDOL
         AclqkzjuCXW2XstX1GoarsW5wz/EhJkVD/QchODKhEISssr72lIqVxSR9EC3eEjrX8/T
         YovZp6bE6yo92GZjT1knaOhMlyuMufrqPjZIeWjlNYzZZ3+9FhqzKiPdz7C2vDq2vAVs
         CcYpqRjg9OuNmTevor+vrXXZKsR2F+gVUk8DuVEt7V5Yvwhqwa1CO7mLW1lt7/cIZLWx
         +2FA6ma4kdoZxZzoce4+dyMb2bddM+PafpuDT8TO8cctSWSLrHrEuDRwsIQ16FIjKuFF
         399A==
X-Forwarded-Encrypted: i=1; AKwUvBzsvByrnmU+WRS2BnryxJz6+QgJpkyH3t8Z8+x3LuPQPPAMz91jDiYf2lGu0mUqrzK3vKilwtwx@vger.kernel.org
X-Gm-Message-State: AFuF++lqLknMqqmFYp7K/9QAEWUep1Bpa1IqI5hjOM0Tr2try+lMgnrz
	omXJ2ZZIYB4cpu5wo2Dq5bxLQriw9yKn8N5CscOOs/Bap1+Tm00W0JoKXspx5pecot72R9AHbQd
	R6Otf5gU=
X-Gm-Gg: AYBFou1Idm3KK+ELgABQK8m9vwVvuBkaohbK0wwvpk5HQGJmUYTb4xcluXiTXAGLiAI
	utgeAr94sfE/KkirLfs/0W1lctwOqgFC8E5v7fF0UkDolXpNlPx8CnmnM4NHik2ZIRNp1g+aVFV
	0Q46cU2ptTXYTdt7RQAPsvHdDb9D9kFhyVZKmINs/UCfeJ7PLJqSdC5uiwyW/YOJkYUpZnD+Kxp
	D3XVqWd15KOxDPoueQD37wp91JkajfaER+NSqmfFWFChzZjjayUv+BY4xwsvKZ1COIUgKeY1xdA
	YpvSz5Z5EhBSibCFnNQg1jq4/7OtNPHKhOOJwyAVEETkCcVkdgOvkoQsIOhC3LxpdW54Zv4Nzb6
	CiRkY4AMmiwv+r0PJrCcELLJUaBoiszQuLzKoyBQobwzUlxn4AYvN25wBXx5NqWmIlaOzOeAbLH
	gmdURhQ6/BtWbp2WW7g5MQsQ7OZ1KsgPbBAxtSEbuisfsEah/tybJP8hJL7Zs/bc7Z9xWZbcxad
	A==
X-Received: by 2002:a05:6a00:440f:b0:84e:b7ed:7d50 with SMTP id d2e1a72fcca58-861684928fcmr45806421b3a.16.1788925426536;
        Tue, 08 Sep 2026 20:43:46 -0700 (PDT)
Received: from localhost ([106.38.226.27])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153f417f2sm6071019b3a.58.2026.09.08.20.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 20:43:46 -0700 (PDT)
From: Julian Sun <sunjunchao@bytedance.com>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	axboe@kernel.dk,
	tj@kernel.org,
	jack@suse.cz
Subject: [PATCH v3] writeback, memcg: skip foreign dirty tracking for bdev inodes
Date: Wed,  9 Sep 2026 11:43:43 +0800
Message-Id: <20260909034343.340703-1-sunjunchao@bytedance.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The expectation in wbc_detach_inode() that "concurrent write sharing of an
inode is expected to be very rare" does not hold for bdev inodes. On ext4,
metadata from many memcgs shares the same bdev inode, so dirty throttling
in those memcgs can repeatedly trigger foreign flushes of the owner wb.
These flushes can also write ordinary file data, reducing overwrite
coalescing under continuous buffered overwrites. The resulting extra I/O
leaves less device bandwidth for other workloads.

Skip foreign dirty tracking for bdev inodes. Ordinary writeback and
foreign dirty tracking for non-bdev inodes are unchanged.

In a synthetic ext4 test with cgroup v2 (QEMU/KVM, 4 vCPUs, 8 GiB RAM),
device writes are capped at 200 MiB/s. fio repeatedly overwrites a 256 MiB
file in the root wb while four memory- and I/O-limited memcgs generate
metadata and trigger foreign flushes through dirty throttling. A concurrent
fio performs 16 GiB of sequential direct writes on the same filesystem.
Across five pairs with 9 GiB of buffered overwrites per run, mean results
are:

                                      Baseline    Skip bdev
  Overwritten-file device writes       5.60 GiB     1.70 GiB (-69.6%)
  Foreground completion time           104.2 s      89.1 s   (-14.4%)
  Foreground bandwidth                 157.3 MiB/s 183.8 MiB/s
  Foreground p99 completion latency     1434 ms      480 ms

The tradeoff is that memcgs with dirty bdev folios lose this way of
requesting writeback to relieve dirty pressure. In a separate uncapped ext4
test, a memcg with memory.high=256 MiB creates 60,000 files paced at 4,000
files/s, each with a distinct 128-byte xattr, and makes occasional buffered
data writes. The xattrs use external 4 KiB blocks. Across two pairs,
completion is 31-33% slower including final sync, while device writes
remain about 524 MiB.

With 64-byte xattrs stored within the inode, the same paced workload
showed no substantial completion-time regression, including at
memory.high=16 or 32 MiB where the baseline triggered dirty throttling
and foreign flushes.

I believe this external-xattr-heavy workload under memory pressure is
relatively uncommon in practice, and expect the benefits to outweigh the
regression. I therefore consider this an acceptable workaround.

Core fio commands for the overwrite test:

    fio --name=hotspot --filename="$dir/hot.data" --rw=write \
        --bs=64K --ioengine=psync --direct=0 --thread=1 \
        --size=256M --io_size=9216M --rate=64M \
        --refill_buffers=1 --invalidate=0 --eta=never \
        --output-format=json --output="$out/target.json" &
    hot_pid=$!

    sleep 8
    fio --name=foreground --filename="$dir/foreground.data" \
        --rw=write --bs=1M --ioengine=libaio --iodepth=32 \
        --direct=1 --thread=1 --invalidate=0 --size=4096M \
        --io_size=16384M --eta=never --output-format=json \
        --output="$out/foreground.json"
    wait "$hot_pid"

In the log below, base is the original kernel and skip includes this
patch. hot_GiB is device writes for the repeatedly overwritten file,
including final sync; the other performance columns describe foreground
fio.

Full five-pair log:
nohup: ignoring input
[2026-09-05 17:52:10] RESULTS=/tmp/cgwb-20260905-175145; WARNING: reformats /dev/nvme5n1; 5 pair(s), limit=200 MiB/s
[2026-09-05 17:52:10] round-001-base: booting
[2026-09-05 17:52:20] round-001-base: running workload
[2026-09-05 17:55:36] round-001-skip: booting
[2026-09-05 17:55:45] round-001-skip: running workload
[2026-09-05 17:58:57] ROUND 1: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 17:58:57]          base    104.574   156.67    156.67    203.82   1434.45     5.862    0
[2026-09-05 17:58:57]          skip     89.125   183.83    183.83    173.62    480.25     1.656    0
[2026-09-05 17:58:57] skip vs base: bandwidth +17.33%, time -14.77%, hotspot IO -71.75%
[2026-09-05 17:58:57] round-002-skip: booting
[2026-09-05 17:59:06] round-002-skip: running workload
[2026-09-05 18:02:18] round-002-base: booting
[2026-09-05 18:02:27] round-002-base: running workload
[2026-09-05 18:05:42] ROUND 2: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:05:42]          base    103.533   158.25    158.25    201.75   1434.45     5.493    0
[2026-09-05 18:05:42]          skip     89.124   183.83    183.83    173.65    480.25     1.730    0
[2026-09-05 18:05:42] skip vs base: bandwidth +16.17%, time -13.92%, hotspot IO -68.50%
[2026-09-05 18:05:42] round-003-base: booting
[2026-09-05 18:05:52] round-003-base: running workload
[2026-09-05 18:09:06] round-003-skip: booting
[2026-09-05 18:09:15] round-003-skip: running workload
[2026-09-05 18:12:28] ROUND 3: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:12:28]          base    104.648   156.56    156.56    203.96   1434.45     5.334    1
[2026-09-05 18:12:28]          skip     89.243   183.59    183.59    173.92    480.25     1.824    0
[2026-09-05 18:12:28] skip vs base: bandwidth +17.26%, time -14.72%, hotspot IO -65.80%
[2026-09-05 18:12:28] WARN: runtime diagnostics present; inspect each data/dmesg before using this pair.
[2026-09-05 18:12:28] round-004-skip: booting
[2026-09-05 18:12:37] round-004-skip: running workload
[2026-09-05 18:15:50] round-004-base: booting
[2026-09-05 18:16:00] round-004-base: running workload
[2026-09-05 18:19:15] ROUND 4: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:19:15]          base    103.565   158.20    158.20    201.84   1434.45     5.497    0
[2026-09-05 18:19:15]          skip     89.124   183.83    183.83    173.57    480.25     1.648    0
[2026-09-05 18:19:15] skip vs base: bandwidth +16.20%, time -13.94%, hotspot IO -70.01%
[2026-09-05 18:19:15] round-005-base: booting
[2026-09-05 18:19:24] round-005-base: running workload
[2026-09-05 18:22:41] round-005-skip: booting
[2026-09-05 18:22:50] round-005-skip: running workload
[2026-09-05 18:26:03] ROUND 5: kind     seconds    MiB/s      IOPS   mean_ms    p99_ms   hot_GiB WARN
[2026-09-05 18:26:03]          base    104.567   156.68    156.68    203.78   1434.45     5.830    1
[2026-09-05 18:26:03]          skip     89.035   184.02    184.02    173.47    480.25     1.648    0
[2026-09-05 18:26:03] skip vs base: bandwidth +17.44%, time -14.85%, hotspot IO -71.72%
[2026-09-05 18:26:03] WARN: runtime diagnostics present; inspect each data/dmesg before using this pair.
[2026-09-05 18:26:03] DONE: 5 pair(s); all test VMs stopped

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
---
 mm/memcontrol.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..6e8f7ff7d44a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(struct folio *folio,
 	u64 oldest_at = now;
 	int oldest = -1;
 	int i;
+	struct address_space *mapping = folio_mapping(folio);
+	struct inode *bdev_inode = mapping ? mapping->host : NULL;
+
+	/*
+	 * Bdev inodes are usually shared by many memcgs so foreign
+	 * tracking leads to frequent flushes which is counterproductive.
+	 */
+	if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
+		return;
 
 	trace_track_foreign_dirty(folio, wb);
 
-- 
2.39.5

