Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B19251B173
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 11:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064453; cv=none; b=SODdjuLsWC8xS6lIVyfXfgJkVRRgJ/GBQhk2O/LAXwoMl0JhutwEDO52/hoD6YIvHY2SlJvCmWVYcPYTSGTspKHAk7RYAb80kmuyq5Srj3YEfNzZd/fXOC+b3VfCnf2ou6ewrYw0PSv29YpvGPPWmVpGcVec4bu6w7CVaTZnIiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064453; c=relaxed/simple;
	bh=VTyms48DupY+M0j/NCiYvBN7G4Zz1bI67Q/WcU/bpsM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=a4D3OpH73bcwkjzDmD4nyeVxcHqJFtFgAWx0FKNNIxUGOg7j/f7axX4aNvC9WuxlQYzDeYOVkLG1KjMkcXEjHLDNuqOqFScXgxeC2u+bRvdQkOayg1ThpSCn61xJwFD2RI0oneNMq0LEf89zUbj9fJ9LFQAP/7SqY6aqvOWIpHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=NII9648i; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="NII9648i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:mime-version:content-type:content-transfer-encoding:
	to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1792064445;
	bh=bCnNKTsKL4tE3BHNaD7/M/1HrMbDpTApOPkzvLfLa5g=;
	b=NII9648ieqx6hmdEPBiJIIcQFfEv2q593VKIKdxlP68HZoEkRCeaGvrfJdnqRqOqWIv2
	Vh5LawdtohIZeF/nvIfeQHOHc+h/vFLVqEkMLCIoU0nyI/hn1PfbLuhd/VJ8YUU9Jjpngg
	ORo8LrCrHCXz+Desi8g1pnAW7q+ASWfKiQlDtNabWsSHwLd30chMGeN9PvVfmy913IoF5t
	Bo5eTSg7taQc1mmW3naD7E4Ow04VIMfDPA7Y0F9hdEzf1f6Sxn20VQ2B3yz/amDDvCHVV1
	FzyFASrjk4swVr+JxZHxEgByd/Y5hkVasjYoQV1OVzi4gu0ylRGQ4rzFqo+Pg5UQ==
Received: by recvd-c977b4567-gqtp9 with SMTP id recvd-c977b4567-gqtp9-1-6AD0BBBD-60
	2026-10-15 11:40:45.768673003 +0000 UTC m=+1363213.894827407
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-34 (SG) with ESMTP
	id B9491fufQs-q2WdzhwHlDg
	Thu, 15 Oct 2026 11:40:45.691 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: [PATCH v7 0/3] writeback: let foreign flushes reach dying cgwbs
Date: Thu, 15 Oct 2026 11:40:45 +0000 (UTC)
Message-Id: <20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43N20rEMBAG4FdZcm0kx0nile8hXuQwbSPaSrNbL
 Uvf3XQFKRLEu/mZme+/koJzxkIeTlcy45JLnsYazN2JxMGPPdKcaiaCCWBOAP0INK157Gns69i
 9XspAGWDdovDBJ1I/32fs8udNfXr+zuUSXjCed2q/GHI5T/N6q134fvd3w8Ipp94m6yyz2kv/O
 EwjrnF6C/d5InvJIo6MbTOiMhqCVjF5ozrRYOQ/GEkZRamlUdYqANNg1IGRrM2oyoSEII1l0jt
 oMPqH4YzxNqMrYyVwDDaCji0GjoxoM1AZ7hwPCkWKXfeL2bbtC3NKM4AuAgAA
X-Change-ID: 20260926-wb-dying-cgwb-flush-06e260e2abad
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10932; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=VTyms48DupY+M0j/NCiYvBN7G4Zz1bI67Q/WcU/bpsM=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBq0Lu8vDws/hL8zJ29aRx4P9bAz1xfFdnbW+yeL
 yD8A1dvSzGJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCatC7vAAKCRClztTjl62v
 wne6CACRt/8/1YTHY185YfOEJQJj0q+wiQPW/2GJI5mW6NKKZRf+zsmSnRC222UdaH4d/h9i5nx
 H8q7Ci36BzF3lJXZYXmL+hSbblnPxBSggQCZ6c2NcpyhL0qZLqelDX3zK7CXUFx8pyuxvavD68+
 PtGKzhDqfNRdLLgHaToOzLMPXrFdstaMQdrQMQ8fRD9oCagwZqFNlUm6SD5kdZbixgRvWWhUhhs
 gQ1affqT2oVAq67waNZIHhfHfApKm4zYnZhH7e7ab7MWCOzrLdrdukJlZTHR4c3x5C7mf5Cffj0
 nEHCciG5EjVMSJyVZ56JoJLRiosr2boYuQRhjcR/hdR6GQDe
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeTImm1ntFeNm?=
 =?us-ascii?Q?KU0+S2VZz4+h1CgyKuU4W5+SlLnm5IOUKkeu0qR?=
 =?us-ascii?Q?bXK=2FJ3KNE8qr70fPNgGjX0ydibO52h=2FAD7INEDL?=
 =?us-ascii?Q?t8wQimTyv=2FFugcexD7Iwv31GkvUDlLMRXTi5Foj?=
 =?us-ascii?Q?Q5grsLXo3pWFP+4kBjXLIRyWw0PDdQVOk74rok7?= =?us-ascii?Q?Gj+5?=
To: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Tejun Heo
	<tj@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner
	<hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==

At Honeycomb, a container that reads from Kafka and writes columnar
files to a host volume stalls for 30-60s after each deploy replaces it
(v6.18). We're increasingly confident this is the cause: the stall
looks the same as in the reproducer (little CPU use, lag growing
linearly and then recovering), and the mitigation it predicts, moving
our final syncfs after the last write, worked in production (below).
We haven't caught it with probes in production yet.

Patch 1 is a prep fix: switching a dirty inode away left the old wb
counted in bdi->tot_write_bandwidth. Patch 2 keeps killed wbs in
bdi->cgwb_tree until they are released, so foreign flushes can still
reach them. Patch 3 handles the other way a wb leaves the tree: when a
memcg's blkcg association changes and a new wb takes over the slot, it
switches the old wb's inodes, dirty or not, to the new one.

Applies to mainline (24a19b953e2a, 7.3-rc7) and vfs-7.4.misc. Tested on
vfs-7.4.misc and on mainline (d24e8ac715de, after 7.3-rc5) with
168a8c13159c, where patch 2's test gave 1.0s, 1.0s and 1.1s worst lag.
Patch 3's loop follows 407a5d205179, and f6988c90671e bounds its
rescans.

Syncing before the removal isn't enough: cleanup_offline_cgwbs_workfn()
skips a dying wb with any dirty inode and only retries on the next memcg
offline. On ext4, syncfs can leave inodes I_DIRTY_SYNC: at 5000 files
one syncfs still stalled in 7 of 9 runs (19-26s worst lag), a second
syncfs avoided it in 5 of 5, and with this series one syncfs lagged at
most 1.5s in 2 of 2. On XFS one syncfs left the wb clean in 5 of 5 runs,
but a single 4KiB append from the old cgroup after it stranded the wb
again (15-28s worst lag, 5 of 5; 1.2-1.6s in 2 of 2 with this series).
In production, our writer synced after closing its data files but before
writing its final Kafka offset to a small shutdown file, and moving the
syncfs after that write mitigated the stall for us on XFS. In the
reproducer, a 14-byte file written after the syncfs stranded the wb the
same way, whether created directly or via a temp file and rename (16-29s
worst lag, 7 of 7; with this series, 1.0-1.4s in 2 of 2 created
directly); an empty file did not.

The harness that produced the numbers (paced writer, lag per second,
MODE=alive control) is at
https://gist.github.com/lizthegrey/2209d831930588f63076bdc0ac7b78e2, and
a minimal recipe is below. Settings for all numbers: MEM_MAX=max
POD_MAX=4G RATE_MBPS=250, plus NFILES=5000 SYNC_OLD=1 (or 2) and
DIRTY_AFTER=1 or SHUTDOWN_FILE=offset|offset_rename|empty for the syncfs
runs and NFILES=500000 OLD_SECS=120 SYNC_OLD=1 POD_HOP=10 for the
500k-file runs.

Also reproduced unpatched on bare-metal arm64 with Ubuntu's 7.0 kernel
(ext4 on a loop device): 12.9s worst lag with the old cgroup removed,
2.5s with it kept.

Tested: arm64 KVM guests (virtme-ng), ext4 and XFS on virtio, on
vfs-7.4.misc and on mainline with 168a8c13159c. No KASAN, lockdep,
PROVE_RCU, DEBUG_LIST, DEBUG_OBJECTS_WORK, DEBUG_ATOMIC_SLEEP or
DEBUG_PAGEALLOC reports, including a stress run toggling io on the
parent of two writers 40 times so their wbs are killed and replaced in
the same slot (240 calls of patch 3's switch, 16400 inode switches,
counted with bpftrace), and the patch 1 and 3 tests in their changelogs
and the re-kick race test below. W=1 and checkpatch --strict clean, no
new sparse warnings. All changes are under CONFIG_CGROUP_WRITEBACK, and
only builds with it enabled were done for v7.

Not tested: x86 runtime, this series in production, linux-next, and
patch 3's fallback for a successor that is already gone (not reachable
on demand; it is cleanup_offline_cgwb()'s loop).

Workaround until this lands: syncfs after the old container's last
write (twice on ext4). Lowering vm.dirty_expire_centisecs from 3000 to
500 cut the worst lag on unpatched mainline to 4.8s, 4.6s and 14.3s, but
did not remove the stall.

Related: without 168a8c13159c the flush is sized from the dead memcg's
own dirty pages, so this only helps while it has some. f6988c90671e
(mainline) also matters: on XFS with 500k synced inodes and the pod
cgroup removed 10s later, the handover was slow enough without it that
the replacement fell 21-22s behind (vfs-7.4.misc), against 1.0-1.2s with
it (mainline), both with v1 of this series.

In patch 3's test all 5001 inodes switched within 23-35ms, and on
mainline the sibling lagged at most 2.1s. That lag varies from run to
run: in 15 alternating runs each on vfs-7.4.misc, it averaged 1.33s with
v6 and 1.35s with v7 (1.0-2.1s and 1.0-3.4s), and in the 10 pairs I
probed no sync ran, so the new lock was never contended. As with today's
per-inode switches, switched inodes land at the newest end of the new
wb's b_dirty with their old dirtied_when, so periodic writeback may
reach them up to dirty_expire_centisecs late; background and foreign
flushes are unaffected.

To test the re-kick in patch 3, a debug-only delay in
inode_switch_wbs_work_fn() held back foreign switches to a memcg's wb
until after io was disabled on its parent, a new wb took over its slot
and the memcg was removed. With v5, the 61, 62 and 19 inodes that then
landed on the replaced wb stayed there until the next memcg offline ran
cleanup_offline_cgwbs_workfn(); with v6, all 5, 35 and 82 that landed
were queued to the successor as they landed, checked by wb pointer with
bpftrace. Switches queued after the takeover went to the successor
directly. The inodes were clean by the time they landed, so this shows
where they end up, not a stall. On the lockdep kernel, the re-kick moved
165, 82 and 198 inodes from the replaced wb to the successor with v6,
and 116 and 85 in two runs with v7.

Tejun spotted on v6 that, with mainline's f6988c90671e, patch 3's scan
could make a concurrent sync miss data. I reproduced it on mainline with
a debug-only delay holding a sync's work on a memcg's wb between fixing
its cutoff and queueing inodes (and skipping sync's best-effort
pre-flush there): the memcg had 400 64KiB files dirty, created one more
file after the cutoff, and then its wb was replaced. With v6, sync()
queued 22 of the 400 and returned with the other 378 still dirty,
and after a crash right after it, those 378 files were empty. With v7,
sync() queued all 400 and all 400 survived the crash. 3 of 3 runs each,
on ext4.

Developed with Claude Opus 5.5, which wrote the code, the reproducers
and first drafts of this text, and ran the builds and VM tests. Claude
Fable 5.1 reviewed the code and the claims in this text before v2 to v7
were posted. I drove the investigation from the production symptoms,
designed the experiments and controls (repeated runs, parent-commit
baselines, testing this patch on its own), and reviewed the analysis,
code and results.

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
	bpftrace -e 'kretprobe:cgroup_writeback_by_id {
		@ret[(int32)retval] = count(); }' &
	sleep 3
	time (echo $BASHPID > $cg/new/cgroup.procs
	      append 4 1M)      # replacement keeps appending to the same files
	kill -INT $!; wait
	rmdir $cg/new $cg
	# Unpatched: many @ret[-2] (-ENOENT) and the append stalls.
	# Patched: @ret[0] only.

---
Changes in v7:
- Patch 3: hold wb_switch_rwsem for read across the scan, so a sync
  can't miss inodes it moves (Tejun); doc and changelog say "inodes on
  the old wb's lists"; drop a redundant comment and reword
  cgwb_kick_replaced()'s summary (Tejun)
- Collect Jan's Reviewed-by on all patches
- Link to v6: https://patch.msgid.link/20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io

Changes in v6:
- Patch 1: trim the test paragraph (Tejun)
- Patch 2: comment updates for wb_get_lookup(), wb_get_create(),
  struct bdi_writeback and wb_dying() (Tejun)
- Patch 3: queue replaced_work again when a switch lands on a wb that
  was replaced after the switch was queued; share the tryget, queue
  and put on failure in a helper (Tejun)
- Link to v5: https://patch.msgid.link/20261001-wb-dying-cgwb-flush-v5-0-8361eb8c65c6@honeycomb.io

Changes in v5:
- New patch 1: clear the old wb's dirty IO state after switching
  inodes (Tejun)
- Patch 2: drop the css_is_dying() check, not needed with patch 3
  (Tejun)
- Patch 3: if the successor is gone, fall back like
  cleanup_offline_cgwb(); report a Tasks-RCU quiescent state per
  pass, as 407a5d205179 does (Tejun)
- Also tested on mainline (7.3-rc6) with 168a8c13159c
- Link to v4: https://patch.msgid.link/20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io

Changes in v4:
- Don't link a new wb for a dying memcg in cgwb_create() (Tejun)
- Patch 2: switch the replaced wb's inodes to its successor instead
  of kicking writeback (Tejun, Jan)
- Link to v3: https://patch.msgid.link/20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io

Changes in v3:
- Use wb_dying(), scoped_guard() with the offline_node list_del moved
  into it, and {}; filter dying wbs right after the lookup in
  cgwb_create(); comment wording (Tejun)
- New patch 2: kick writeback on a wb replaced in cgwb_create() (Tejun)
- Lead patch 1's changelog with the problem and its trigger (Andrew)
- Link to v2: https://patch.msgid.link/20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io

Changes in v2:
- Keep killed wbs in bdi->cgwb_tree until release instead of walking
  bdi->wb_list (Tejun)
- Drop Fixes: and Cc: stable (Tejun)
- Link to v1: https://patch.msgid.link/20260926-wb-dying-cgwb-flush-v1-1-a8d898085a3a@honeycomb.io

---
Liz Fong-Jones (3):
      writeback: clear the old wb's dirty IO state after switching inodes
      writeback: let foreign flushes reach dying cgwbs
      writeback: switch a replaced cgwb's inodes to its successor

 fs/fs-writeback.c                |  73 +++++++++++++++++++++
 include/linux/backing-dev-defs.h |  23 +++++--
 include/linux/backing-dev.h      |   3 +-
 include/linux/writeback.h        |   1 +
 mm/backing-dev.c                 | 138 ++++++++++++++++++++++++++++++++-------
 5 files changed, 210 insertions(+), 28 deletions(-)
---
base-commit: 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd
change-id: 20260926-wb-dying-cgwb-flush-06e260e2abad

Best regards,
--  
Liz Fong-Jones <lizf@honeycomb.io>

