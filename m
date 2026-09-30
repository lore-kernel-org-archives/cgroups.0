Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A084403B1B
	for <cgroups@vger.kernel.org>; Wed, 30 Sep 2026 19:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796941; cv=none; b=APN3MmjdvUcuCZ1WF8ZXMHFIiIJvJ+dRWuKQCj3bIwgjUFxiGKq71v3sPhVzP7yRQR8pcbIu+h91xatfCAIRdPBU4BNPwbCeDdNJ/GXYmhi+B4jcQP+WUZnbL44stcqZT8GJfCMO+LaC+Id1p3Ufr4yxS3ANvYGhFQwzTX/2OEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796941; c=relaxed/simple;
	bh=Wnqlse4Bgg93MKf2VOtbUPjGQ9ZnN/dCEiKA2fPRoA8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=iDbjLBFSaHiCt0PGZq5h48BLo7wPcH5AO8t6pqRw5RAU3kgJ4AdwDPycg7wvLrNTQ16Ms1+FuMu7yV7S6x33p+Exx++GyCPen0zWAaJjLeY9WrjP8she3gOa5MqVfl0cq5nudM7uvU9IzTBNT6NaCaxKsMnA7Lr6ZZNMDoWLY00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=ldI+FtaO; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="ldI+FtaO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:mime-version:content-type:content-transfer-encoding:
	to:cc:cc:content-type:date:from:subject:to;
	s=s1; t=1790796936;
	bh=/+zzY0tFZaFFH1LTLV1nIHeogVgUYa0iBXA8efzOE3E=;
	b=ldI+FtaOJvQgdSiTV/hLcg35FSa4YjIah4vXqa52yDGT03L4EIYcqGzgIb9FMMoTsB4q
	J5K5ud+EJ8rbDyEBd9GDSSOdxsd6wkt2EGcwBerJzHdDHhBAe15LnzwoAOij7BoYrqhziA
	jYjYP2DtVNfcDJ8BN84AJtZBCkDIjyERn2Yh3a6vkmMAIL1Cya6cQrlbSlmOQuKzQBEjbR
	OZ4xd1bs4Qp+Udz7D/W2Ao8+Gu4yetCQDGMPB/irf0Alsb59o7WYwlCV7LTMMVhys66XLK
	nuKhlJ/+n9Gwx7472LZLhIGYuV0oQ0GqYrQUHWG5U6J9vSlmuhUatUVyoECYv0LA==
Received: by recvd-5dd7ccd7b6-h7p4q with SMTP id recvd-5dd7ccd7b6-h7p4q-1-6ABD6488-9A
	2026-09-30 19:35:36.668054639 +0000 UTC m=+95713.833204695
Received: from [127.0.1.1] (unknown)
	by geopod-ismtpd-6 (SG) with ESMTP
	id KTfzU9edSn-R8nTErLOwTw
	Wed, 30 Sep 2026 19:35:36.649 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: [PATCH v4 0/2] writeback: let foreign flushes reach dying cgwbs
Date: Wed, 30 Sep 2026 19:35:36 +0000 (UTC)
Message-Id: <20260930-wb-dying-cgwb-flush-v4-0-bde637803a96@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43NTQ6CMBAF4KuYrh1T2lKqK+9hXPRngBqlhiJKD
 He34MYYYtzNy8x870kith4j2a2epMXeRx+aFMR6RWytmwrBu5QJo0zSLZNwN+AG31RgqzSW51u
 sgUpMW2TaaEfS57XF0j9m9XB853gzJ7TdRE0XtY9daIe5ts+mu98NfQYZaOXUVlGVa673dWhws
 OFiNj6QqaRnn4xaZlhicmlyYZ0uRMkWGP4Hw4EC8pwXQikhZfHFjOP4AleWGrZZAQAA
X-Change-ID: 20260926-wb-dying-cgwb-flush-06e260e2abad
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7713; i=lizf@honeycomb.io;
 s=gpg; h=from:subject:message-id;
 bh=Wnqlse4Bgg93MKf2VOtbUPjGQ9ZnN/dCEiKA2fPRoA8=;
 b=owEBbQGS/pANAwAKAaXO1OOXra/CAcsmYgBqvWSIh6uUw3xXDhNTsLDLSPXL3NH4EhpGOcolP
 s7zD38JXUKJATMEAAEKAB0WIQSfW1LPQ0gyJmoTHwelztTjl62vwgUCar1kiAAKCRClztTjl62v
 whq5CACo3p7WlyY38v3Rgwh0v8Cs+Dihb6NqfWM5BZOVNkLl0sAsvdjhDTRFj92y8tW7445xnUx
 1P6MeqK8dMXPDwgpg+GS9w8mU5hLhcyOnzNptv6hcLL762Ucx3oWNib9bRSO6egDsh1qEN/KXun
 VyfoeLIRAM+2sEPFl9MQRCQQCrbmAQg2UfZxc+thXASehzRBzgVL4CtYrBYKGmFkyrfvJn89YXH
 9Rx2E0FTjazlqcOQnCMw8hdlokhOhq16n10ZqN55sP4B6Iuvqz9uvugpLn8mk3RtvXAg0fb5vq4
 kxEW+70wrZfp+ZojmBvITF4ZI4juZfwtjrwB3+0DJ24QPXJm
X-Developer-Key: i=lizf@honeycomb.io; a=openpgp;
 fpr=1F7714D7EC3441D2CECC24606A3F8B00FBDDD2A4
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeVwI5CqqQhMe?=
 =?us-ascii?Q?ovC51Laxj9Q2Yp=2F+nCOydlpb1F=2FabFvfTjnK=2FrH?=
 =?us-ascii?Q?xkmr5YK0QGsX=2F37QyCJz15lJo7iTZXy9OTV6S1Q?=
 =?us-ascii?Q?Mu8pV3RWMl+dH2fhuVpdQKhhIQqJqEbRlyoFY62?=
 =?us-ascii?Q?K7Z98f1uHsL2oh=2FR4HT5uX8xK5othhawW+aAlz8?= =?us-ascii?Q?vVY5?=
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

Patch 1 keeps killed wbs in bdi->cgwb_tree until they are released, so
foreign flushes can still reach them. Patch 2 handles the other way a wb
leaves the tree: when a live memcg's blkcg association changes and a new
wb takes over the slot, it switches the old wb's inodes, dirty or not,
to the new one.

Based on vfs-7.4.misc, next to Xin Yin's 168a8c13159c, which fixes the
sizing but not the lookup of a removed cgroup's wb. Each helps without
the other; this series also applies to mainline. On mainline
(fd179f8a05be), without 168a8c13159c, the test from the changelog gave
52.8s, 73.3s and 5.2s worst lag before this series and 1.0s, 1.5s and
1.0s with it.

Syncing before the removal isn't enough: cleanup_offline_cgwbs_workfn()
skips a dying wb with any dirty inode and only retries on the next memcg
offline. On ext4, syncfs can leave inodes I_DIRTY_SYNC: at 5000 files
one syncfs still stalled in 7 of 9 runs (19-26s worst lag), a second
syncfs avoided it in 5 of 5, and with this series one syncfs lagged at
most 1.3s in 2 of 2. On XFS one syncfs left the wb clean in 5 of 5 runs,
but a single 4KiB append from the old cgroup after it stranded the wb
again (15-28s worst lag, 5 of 5; 1.0-1.7s in 2 of 2 with this series).
In production, our writer synced after closing its data files but before
writing its final Kafka offset to a small shutdown file, and moving the
syncfs after that write mitigated the stall for us on XFS. In the
reproducer, a 14-byte file written after the syncfs stranded the wb the
same way, whether created directly or via a temp file and rename (16-29s
worst lag, 7 of 7; with this series, 1.2-1.4s in 2 of 2 created
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

Tested: arm64 KVM guests (virtme-ng), ext4 and XFS on virtio. No KASAN,
lockdep, PROVE_RCU, DEBUG_LIST, DEBUG_OBJECTS_WORK, DEBUG_ATOMIC_SLEEP
or DEBUG_PAGEALLOC reports, including a stress run toggling io on the
parent of two writers 40 times so their wbs are killed and replaced in
the same slot (240 calls of patch 2's switch, 16200 inode switches,
counted with bpftrace), and the patch 2 test below. W=1 and checkpatch
--strict clean, no new sparse warnings. All changes are under
CONFIG_CGROUP_WRITEBACK, and only builds with it enabled were done for
v4.

Not tested: x86 runtime, this series in production, linux-next.

Workaround until this lands: syncfs after the old container's last
write (twice on ext4). Lowering vm.dirty_expire_centisecs from 3000 to
500 cut the worst lag on unpatched mainline to 4.8s, 4.6s and 14.3s, but
did not remove the stall.

Related: without 168a8c13159c the flush is sized from the dead memcg's
own dirty pages, so this only helps while it has some. f6988c90671e
(mainline) also matters: on XFS with 500k synced inodes and the pod
cgroup removed 10s later, the handover was slow enough without it that
the replacement fell 21-22s behind (vfs-7.4.misc), against 1.0-1.2s
with it (mainline).

Patch 2 was tested with a live cgroup whose io controller is disabled on
its parent (its wb is killed and replaced) while a sibling keeps
appending to its files, on XFS with 5000 files. Without patch 2 the
sibling fell 16.6s, 28.7s and 1.6s behind, because the old wb's inodes
only moved to the new wb as they were written back; with it, 1.3s, 1.4s
and 1.0s, and all 5001 inodes switched within 40-60ms of the takeover,
with up to 139MiB of the old cgroup's pages dirty. v3's writeback kick
instead left the sibling stalled in 4 of 6 runs.

Developed with Claude Opus 5.5, which wrote the code, the reproducers
and first drafts of this text, and ran the builds and VM tests. Claude
Fable 5.1 reviewed the code and the claims in this text before v2, v3
and v4 were posted. I drove the investigation from the production
symptoms, designed the experiments and controls (repeated runs,
parent-commit baselines, testing this patch on its own), and reviewed
the analysis, code and results.

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
Liz Fong-Jones (2):
      writeback: let foreign flushes reach dying cgwbs
      writeback: switch a replaced cgwb's inodes to its successor

 fs/fs-writeback.c                |  53 ++++++++++++++++++
 include/linux/backing-dev-defs.h |  14 ++++-
 include/linux/backing-dev.h      |   2 +-
 include/linux/writeback.h        |   1 +
 mm/backing-dev.c                 | 117 ++++++++++++++++++++++++++++++++-------
 5 files changed, 164 insertions(+), 23 deletions(-)
---
base-commit: 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd
change-id: 20260926-wb-dying-cgwb-flush-06e260e2abad

Best regards,
--  
Liz Fong-Jones <lizf@honeycomb.io>

