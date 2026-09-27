Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D2A1DED42
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 05:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790485482; cv=none; b=H1kT9q1bDFd2KfZItr88ggLvrMk0i+Dxl4ML1zfqjNl2/IrNhnodS4Z8SWRvzjPqIvG95YslzbRMMKayASwCCKSxmnrKPZl8U8OMUg457NfNltuyTBQ/SscOM0BpIQ5xrGLRGuybj3KJ/hTrjXE2NArTF37Gs0xMNtWkptcAWzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790485482; c=relaxed/simple;
	bh=TvjgwKfxRWoop+S5G5ZIakPAQZmM9hjcQdoUj56GMq0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mLDPn4kh5suIS2ZkuJGXP+r6Nx8N97Es33/ZmLRxXWOunQtsJqsAKUoZPFoO1ALn+/1FPyvQeegxf7VMUNDjSFwXsZRg7lm90gX7xYQz5MhuB9ZMfEeh6JyzYJXQcmjVSVpuGuHw7QY+MS9f4IL2NUwAvQlIUqj6twB7F/EEeW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=kknxETGX; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="kknxETGX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:date:subject:mime-version:content-type:content-transfer-encoding:
	to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790485479;
	bh=+4jro1MTzUF06io04gLz+PFvy0PpidJfPQA84CrpgNI=;
	b=kknxETGXBLiN+fC0CeXE1ukNhZOsuMLR5UzCAlEaXRQeDgkRzLcNF0OOkTfPgNQWiICR
	3AUVExFJIvOhYg/aoVp3N7mjOGkoFtcXAMSIy+UiilUxqSuFbn4T/fxxwYuap5EVqd9pxA
	3LJk4TGrz8g5yBaYzJwiFmFMU6mBsODIiSEHZmtFv78lXQ7Qcr1MF8FXuwRdNesa9fUy0y
	XrndeTaWyntZUDlINYJGdOWidPHEmmQOJeSdd7AcA4bkeZXrfnycHeWqYK5Mr/udkFgw7U
	x2ssd1dkBi2d5Xfd3XGrjdzwZe6kSRxSc2AhR7FzcyrLEldwwSgBSOKwSvEfOE8w==
Received: by recvd-859f4b9877-dwngx with SMTP id recvd-859f4b9877-dwngx-1-6AB8A3E7-47
	2026-09-27 05:04:39.464940507 +0000 UTC m=+206322.744621825
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-20 (SG) with ESMTP
	id CwOn27KUQ7m8N7Fcb1r4_Q
	Sun, 27 Sep 2026 05:04:39.406 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Date: Sun, 27 Sep 2026 05:04:39 +0000 (UTC)
Subject: [PATCH] writeback: let foreign flushes reach dying cgwbs
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMywqDMBBFf0Vm3YE0i4D+inSRxxhHJC2ZWlvEf
 3esu3u4nLOBUGUS6JoNKn1Y+FkU7rcG4uhLJuSkDNZYZ1rrcA2YflwyxqxzmBcZ0TjSl6wPPoG
 ar0oDf//V/nGxLGGi+D5TsO8HW4+owXcAAAA=
X-Change-ID: 20260926-wb-dying-cgwb-flush-06e260e2abad
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8522; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=TvjgwKfxRWoop+S5G5ZIakPAQZmM9hjcQdoUj56GMq0=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBquKPn1sNIzpCLby9DFncuje+MLA0Jh6n64I/7x
 T0INynFIhiJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCarij5wAKCRClztTjl62v
 wgqtB/9JY2u8FDB4jdu0zx08IpYZbBst2X/t92lMZU/EhRadpIbqbAcbQhiTHD48+MH6n3ERy24
 tsVF1Vr+QV3T2zpzzxgarSuCPtGS/ZRPmWY0G3Fa+KQC8pDqJ1+LohkTEUZ1JxzKavSeOGbelC3
 r3pPpQqhEaZXeZeTMxhqLKDhBX+ei6plsi5qAmvLRh+N/sF0eg4qLWJt9z47Btll94kTwD6FT0H
 ZVsAi4tFOGbUPxG7CDcv7PQARoNdQh7LTkv1QrBtQy1Ba4HqUoiAK8EBnugu58XeesHkWZ2loLs
 1YxiVg8idpW15lSEMAL4gLK4AEnVs8ITAXJ+Cd0gmhKn3Syn
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeUj22rDtwFPn?=
 =?us-ascii?Q?6t5WoqjriadbwirARoiyHWAvFOS2kX70JYRV+VB?=
 =?us-ascii?Q?yTo5789UNL2v4=2FqF1gmk28QYLOV8QYCFeeMX2hE?=
 =?us-ascii?Q?tt9jtFj=2FdAtsJmm4z6ab2FGK49iAB2Jwb4T9nDD?=
 =?us-ascii?Q?Aytt4VX1zbvp7lVXmNYG+8WGadxtMHXiQ9+S159?= =?us-ascii?Q?Tzlm?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, stable@vger.kernel.org,
	Liz Fong-Jones <lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==

cgwb_kill() takes an offline memcg's wbs out of bdi->cgwb_tree, but
inodes that are still being dirtied stay attached to them. When a
replacement container keeps appending to those files, its foreign
flushes fail with -ENOENT in wb_get_lookup(), and it sleeps in
balance_dirty_pages() for seconds to minutes.

Fall back to searching bdi->wb_list, where killed wbs stay until they
are released. With commit 168a8c13159c ("writeback: size foreign
flushes by target wb dirty pages"), the flush is then sized from the
wb's own dirty pages and writes out what the replacement dirtied.

Test, on top of that commit: a cgroup appends to 1000 files at
250MiB/s and is removed, then a second cgroup keeps appending to the
same files under a 4G parent limit. Worst lag of the second writer
behind schedule over 120s, in three runs:

  without this patch   85.3s  46.9s  52.1s
  with this patch       1.0s   1.0s   1.1s

Fixes: d62241c7a406 ("writeback, memcg: Implement cgroup_writeback_by_id()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
At Honeycomb, a container that reads from Kafka and writes columnar
files to a host volume stalls for 30-60s after each deploy replaces it
(v6.18). This is likely the cause: the stall looks the same as in the
reproducer (little CPU use, lag growing linearly and then recovering),
though we haven't traced it in production yet.

Based on vfs-7.4.misc, next to Xin Yin's 168a8c13159c, which fixes the
sizing but not the lookup of a removed cgroup's wb. Each helps without
the other; this one also applies cleanly to mainline. On mainline
(fd179f8a05be), without 168a8c13159c, the test from the changelog gave
52.8s, 73.3s and 5.2s worst lag before this patch and 1.0s, 1.0s and
1.0s after.

Trigger: a cgroup dirties files and is removed while they are still
dirty; a sibling keeps appending to the same files under a parent memory
limit. Symptom: cgroup_writeback_by_id() returns -ENOENT and the sibling
stalls in balance_dirty_pages(). Minimal recipe below; the harness that
produced the numbers (paced writer, lag per second, MODE=alive control)
is at https://gist.github.com/lizthegrey/2209d831930588f63076bdc0ac7b78e2.

On ext4, syncing before the removal doesn't reliably help: writeback can
leave inodes I_DIRTY_SYNC after syncfs, and cleanup_offline_cgwbs_workfn()
then skips the dying wb entirely (2 of 3 runs at 5000 files; a second
syncfs avoided it in 5 of 5). On XFS one syncfs left the wb clean in 5
of 5 runs.

Harness settings for all numbers: MEM_MAX=max POD_MAX=4G RATE_MBPS=250,
plus NFILES=5000 SYNC_OLD=1 (or 2) for the syncfs runs and
NFILES=500000 OLD_SECS=120 SYNC_OLD=1 POD_HOP=10 for the 500k-file runs.

Also reproduced unpatched on bare-metal arm64 with Ubuntu's 7.0 kernel
(ext4 on a loop device): 12.9s worst lag with the old cgroup removed,
2.5s with it kept.

Tested: arm64 KVM guests (virtme-ng), ext4 and XFS on virtio. No lockdep,
PROVE_RCU, DEBUG_ATOMIC_SLEEP or DEBUG_PAGEALLOC reports. W=1, sparse
and checkpatch --strict clean.
No new warnings building arm64 defconfig with and without
CGROUP_WRITEBACK, allnoconfig, arm multi_v7_defconfig with
CGROUP_WRITEBACK, and the touched files (W=1) under arm64 allmodconfig
and x86_64 defconfig with CGROUP_WRITEBACK.

Not tested: x86, production, linux-next.

Workaround until this lands: lowering vm.dirty_expire_centisecs from
3000 to 500 cut the worst lag on unpatched mainline to 4.8s, 4.6s and
14.3s, but did not remove the stall.

Stable: please take 168a8c13159c too. Without it the flush is sized from
the dead memcg's own dirty pages, so this only helps while it has some.
f6988c90671e (already in mainline and tagged for stable) also matters:
on XFS with 500k synced inodes and the pod cgroup removed 10s later, the
handover was slow enough without it that the replacement fell 21-22s
behind (vfs-7.4.misc), against 1.0-1.2s with it (mainline).
Before 5.14 there is no offline_cgwbs cleanup, but the bdi->wb_list walk
should still apply.

Not covered: after a blkcg association change, wb_get_lookup() finds the
new clean wb, so the fallback doesn't run.

Developed with Claude Opus 5.5, which wrote the code, the reproducers
and first drafts of this text, and ran the builds and VM tests. I drove
the investigation from the production symptoms, designed the
experiments and controls (repeated runs, parent-commit baselines,
testing this patch on its own), and reviewed the analysis, code and
results.

Minimal recipe:
	#!/bin/bash
	# As root, cgroup v2, in a directory on ext4/xfs/btrfs ($DIR).
	cg=/sys/fs/cgroup/wbmini
	mkdir $cg && echo +memory > $cg/cgroup.subtree_control
	echo 4G > $cg/memory.max
	mkdir $cg/old $cg/new
	append() {  # append $1 blocks of $2 to each of 1000 files
		for i in $(seq 1000); do
			dd if=/dev/zero of=$DIR/f$i bs=$2 count=$1 \
			   oflag=append conv=notrunc status=none
		done
	}
	(echo $BASHPID > $cg/old/cgroup.procs
	 append 8 1M            # old owner writes the files...
	 append 1 64k)          # ...and exits with all of them dirty
	rmdir $cg/old           # its cgroup goes away while they are dirty
	bpftrace -e 'kretprobe:cgroup_writeback_by_id { @ret[(int32)retval] = count(); }' &
	sleep 3
	time (echo $BASHPID > $cg/new/cgroup.procs
	      append 4 1M)      # replacement keeps appending to the same files
	kill -INT $!; wait
	rmdir $cg/new $cg
	# Unpatched: many @ret[-2] (-ENOENT) and the append stalls.
	# Patched: @ret[0] only.
---
 fs/fs-writeback.c           |  2 ++
 include/linux/backing-dev.h |  2 ++
 mm/backing-dev.c            | 31 +++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d26b2cf05283..5fb70c16488d 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1189,6 +1189,8 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	 * there's nothing to flush, don't create one.
 	 */
 	wb = wb_get_lookup(bdi, memcg_css);
+	if (!wb)
+		wb = wb_get_lookup_dying(bdi, memcg_css);
 	if (!wb) {
 		ret = -ENOENT;
 		goto out_css_put;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c2284466e7aa..2bbc74b3b180 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -151,6 +151,8 @@ static inline void bdi_wb_stat_mod(struct inode *inode, enum wb_stat_item item,
 
 struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css);
+struct bdi_writeback *wb_get_lookup_dying(struct backing_dev_info *bdi,
+					  struct cgroup_subsys_state *memcg_css);
 struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 				    struct cgroup_subsys_state *memcg_css,
 				    gfp_t gfp);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index cecbcf9060a6..1437f80ed7e3 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -807,6 +807,37 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
 	return wb;
 }
 
+/**
+ * wb_get_lookup_dying - get a killed wb for a given memcg
+ * @bdi: target bdi
+ * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
+ *
+ * wb_get_lookup() only finds wbs that are still in @bdi->cgwb_tree.  A
+ * killed wb leaves the tree but stays on @bdi->wb_list until it is
+ * released, and inodes attached to it can keep collecting dirty pages from
+ * other memcgs until they are written back and switched away, so foreign
+ * flushes still need to reach it.  Returns a wb of @memcg_css on @bdi which
+ * has dirty IO, with a reference held, or %NULL.  If there are several,
+ * the first one found is returned; this is best effort.
+ */
+struct bdi_writeback *wb_get_lookup_dying(struct backing_dev_info *bdi,
+					  struct cgroup_subsys_state *memcg_css)
+{
+	struct bdi_writeback *wb;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(wb, &bdi->wb_list, bdi_node) {
+		if (wb->memcg_css == memcg_css && wb_has_dirty_io(wb) &&
+		    wb_tryget(wb)) {
+			rcu_read_unlock();
+			return wb;
+		}
+	}
+	rcu_read_unlock();
+
+	return NULL;
+}
+
 /**
  * wb_get_create - get wb for a given memcg, create if necessary
  * @bdi: target bdi

---
base-commit: 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd
change-id: 20260926-wb-dying-cgwb-flush-06e260e2abad

Best regards,
--  
Liz Fong-Jones <lizf@honeycomb.io>

