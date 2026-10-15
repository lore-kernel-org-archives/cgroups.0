Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061B23783AE
	for <cgroups@vger.kernel.org>; Thu, 15 Oct 2026 11:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792064593; cv=none; b=RCPRlgJ5wzkdgG0Cppb/PEWgfKr1NeqgWqSyT1PTihAASgmJKeHLesELV3XLUxvJw8j/3x0p0YbTJZEhED8zjNuQPGqtYdJHrSsV+MByOy4L4mfehPZPwq4OOdvLhn6M7jste/PHrvULx5KgT4vKzQSKKWWOrgv9WfT9yewSutk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792064593; c=relaxed/simple;
	bh=J+O17Ew/SQxYOGMzCNRKgNxjyQ5hnOTejFZPyCodR6g=;
	h=From:Subject:Date:Message-ID:MIME-Version:To:Cc:Content-Type; b=dXv8yAHzY8ZpJ5LaRrcrA59OX1UHfZ65/PMNeM/h1C8ExOutfV4GZ/sM9G9E0FRVgsQ3j8kUSmQhR0r1embWdCrNuMcMn1aay/vkhtAsLQxHOb8vOkwcxVuVB3gL8Wr1Yqyv2ALY3PdBsbE29QsXBgnAljelt7rG0MnRVi4v7TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=oie2kMyF; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="oie2kMyF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:mime-version:to:cc:content-transfer-encoding:
	content-type:cc:content-type:date:from:subject:to;
	s=s1; t=1792064589;
	bh=YDGQhlGINpSPM53EPb5WQDPiXIGq0eajS/04uEiHt3I=;
	b=oie2kMyFov1hla3mld0T4ApOwSy72MrCr1e3xqtwc1ASEmmv5ZDbyWPmePcf2LO3rlqa
	hL8jMODArPU80MFo2yyeGmp90iA7wVZWZJ0g6RIzeoDGnEr0wNuUlwUtEqH2l+JsEEZV8a
	v0lugJ3N5qPQSfdI9nSPN8bw/+JyjiegKgbQQfMJOfp1kjv8+a1FMrNksBWmJIC8nfVlzi
	gLIuHM9ia5ELs2GH92oq8HuLgeiAcGd7R+SVwEl7ZrcEJCd0APAuVbTK+hCZp6e6k+Y8Uk
	dUTDAquv15AbJCFm9w3QTKOrShy7tHlxLe3YQWom1mKpEG+VOFKgqp2FmytANYnw==
Received: by recvd-canary-58784594b9-s44q6 with SMTP id recvd-canary-58784594b9-s44q6-1-6AD0BC4D-14
	2026-10-15 11:43:09.292501886 +0000 UTC m=+1363369.825756546
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-83 (SG)
	with ESMTP
	id HHz3NpWqQwq5869tmBL4PQ
	Thu, 15 Oct 2026 11:43:09.124 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: [PATCH] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
Date: Thu, 15 Oct 2026 11:43:09 +0000 (UTC)
Message-ID: <20261015114307.1041273-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmee6tjAzEd4N6?=
 =?us-ascii?Q?h5hjz4W8xyC5g=2F6dVBEu2QNVvEvYnKd7+KOyPIL?=
 =?us-ascii?Q?xLHG5pUwOvvkK=2FT5OdJf55Js6Vqu0q9rSFlh23N?=
 =?us-ascii?Q?1P+AQE=2FMyUzWzQdh3ArGxKwAJRy9zgBQ6OFrlj+?=
 =?us-ascii?Q?vf0XyFvthSoplE5jOoAt+4UstDC=2FSx=2FPjMKu09h?=
 =?us-ascii?Q?ilys?=
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, Christian Brauner
	<brauner@kernel.org>
Cc: "Patrick Lu (Anthropic)" <perf.patrick.lu@gmail.com>, Roman Gushchin
	<roman.gushchin@linux.dev>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, ian@honeycomb.io, Liz Fong-Jones
	<lizf@honeycomb.io>
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii

On a filesystem mounted with lazytime, sync() and syncfs() can return
without persisting timestamp updates (atime, mtime, ctime) of inodes
attached to a cgroup writeback that is being cleaned up after its
memory cgroup was removed. A crash after the sync loses them, contrary
to the lazytime guarantee that sync persists them. File data and sizes
are not affected.

Trigger: a wb has lazytime-dirty inodes on b_dirty_time when a sync
starts, an inode on it gets a timestamp update after the sync's cutoff,
and then its memcg (or, if the wb is already dying, any memcg) is
removed, which runs cleanup_offline_cgwb() on it before the sync work
queues inodes.

Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves
every inode it walks, prepared or not, to the newest end of the list.
Once an isw fills before the scan reaches a newer inode, or a later pass
walks past it, older inodes land in front of it on b_dirty_time. A
for_sync queue_io() expires b_dirty_time with the sync's fixed cutoff
and stops at the first newer inode, so it never reaches them. The
switches themselves already wait for the sync on wb_switch_rwsem; the
scan does not.

Take wb_switch_rwsem for read across the scan, as
process_inode_switch_wbs() does for the switches.

Tejun spotted this reordering racing with a sync on b_dirty in a patch
under review and suggested holding wb_switch_rwsem for read across that
scan [1]. cleanup_offline_cgwb()'s scan of b_dirty_time needs the same.

Test, with a debug-only delay holding a syncfs's work on the wb between
its cutoff and queue_io(): 300 files on a cgroup's wb with lazytime
atime updates, a syncfs held after its cutoff, one more read, then the
cgroup removed so the cleanup ran. Without this patch, syncfs() queued
48 of the 300 and after a crash 252 atime updates were lost, on ext4
(-I 4096, so neighbours' timestamps are not written along) in 3 of 3
runs and on XFS in 1 of 1. With it, the scan waited for the sync, which
queued all 300, and none were lost.

Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
Cc: stable@vger.kernel.org
Suggested-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/ [1]
Assisted-by: Claude:claude-opus-5-5 checkpatch
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
This came up while answering Tejun's review of my series "writeback: let
foreign flushes reach dying cgwbs" [1], whose patch 3 had the same
problem on b_dirty in its own scan; v7 of that series [2] takes the same
read lock there. This patch is independent of the series and applies to
7.3-rc7 on its own; both together apply cleanly.

Impact is limited to lazytime timestamps on inodes attached to a cgroup
wb while it is cleaned up after its memcg is removed. On ext4 with the
default inode size, a write to any inode in the same inode-table block
also writes the neighbours' timestamps, so fewer are lost there; the
test used -I 4096 to rule that out. XFS has no such rescue.

The debug knob used for the test, applied to wb_writeback() and not part
of this patch: when /sys/module/kernel/parameters/wb_debug_sync_delay_ms
is set, a WB_SYNC_ALL work on a non-root wb sleeps that long once, after
dirtied_before is fixed and before queue_io(); it also skips sync's
best-effort WB_SYNC_NONE pass on cgroup wbs, which had nothing to write
here. Steps: mount -o lazytime,strictatime; a cgroup writes 300 small
files and one more, syncfs twice; read the 300 in order (each goes to
b_dirty_time); set the knob to 10s and start syncfs; 1s later read the
extra file; 1s later remove the cgroup; after syncfs returns, crash with
sysrq-b and compare atimes on disk in a second boot. The scripts are
available if useful.

Tested on arm64 KVM guests (virtme-ng) with ext4 and XFS on virtio, on
7.3-rc7. Not tested: x86, production.

Developed with Claude Opus 5.5 and Claude Fable 5.1. Fable spotted that
cleanup_offline_cgwb()'s scan of b_dirty_time was exposed the same way
while checking Tejun's analysis, and reviewed the fix and the claims
here; Opus wrote the fix, the reproducer and this text, and ran the
tests. I directed the investigation and reviewed the analysis, code and
results.

[1] https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
[2] https://lore.kernel.org/all/20261015-wb-dying-cgwb-flush-v7-0-9278d9ebaf5d@honeycomb.io/

 fs/fs-writeback.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ea3eb40bf828..99570aacdd18 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -789,6 +789,11 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
 
 	nr = 0;
+	/*
+	 * The scan reorders b_dirty_time.  Keep it out of a sync's way, which
+	 * could otherwise miss timestamps moved past its cutoff.
+	 */
+	down_read(&wb->bdi->wb_switch_rwsem);
 	spin_lock(&wb->list_lock);
 	/*
 	 * In addition to the inodes that have completed writeback, also switch
@@ -803,6 +808,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
 						 &nr);
 	spin_unlock(&wb->list_lock);
+	up_read(&wb->bdi->wb_switch_rwsem);
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0

