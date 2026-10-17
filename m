Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEAB2931F4
	for <cgroups@vger.kernel.org>; Sat, 17 Oct 2026 04:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.72.141.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792210035; cv=none; b=LX2gW3hIvUkwhEceW9/UQmQSf4NH6T8jysBAkXxFXkksL2dS1+K+DxYOD6u+GWj/iZj55z/vtnoqmr8h+fg2cRhfy2gFBcHQCL72w2+vf5Ri1buqjLr5AhKM+rI3k/yjZrA7LaIkSo0K9tv92QVQfWouaHqXViLnqTNcpaZOZMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792210035; c=relaxed/simple;
	bh=n5waLsgtmninFOYJHl+hKGeJUS+GtfMfXZ+vQSML2oo=;
	h=From:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 To:Cc:Content-Type; b=G1TJDx2wyvriZyc0/XhXbAlbVW4czLSxf7tZ+7ckEZGWR4VzlC/jag4kWG/G/dMwEJlopRVuQmNwuhzOTattj23d/l76PRn9v+8uoymRdHWhgOh13T/T5fZRVWE6a9ZmTlCwcvsFN1exulipApNwhZlnskFTQ3DwTQbexXEp++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io; spf=pass smtp.mailfrom=em.honeycomb.io; dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b=RIok+owk; arc=none smtp.client-ip=149.72.141.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=honeycomb.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=em.honeycomb.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=honeycomb.io header.i=@honeycomb.io header.b="RIok+owk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-transfer-encoding:content-type:cc:content-type:date:from:subject:to;
	s=s1; t=1792210031;
	bh=vmoqsEUaflaluKIcotOa0bF0phf2HZlStSKylP4A7kA=;
	b=RIok+owkUkDTUdDOw52vTX1SqJKmm8h9Tg1GCpuJxWMAzeJHTHhhg7Ym/Q06670vcf1e
	o6DU/Cfpyw0Nnvli9OXDjWSyaVBSqYJCymjFhtXdpGqGHqlA94VSwqoI+2RSVIttdwAKs7
	rFe3ed/2wtPF5TJcK31bkD+sJ5h+ECZTPDbAMuiYxo0hnZ09p7e+fXnyvvxi3f1r8QD11f
	0fJLhDUhLK32t906GZiNaFuI6DJVxJBBke1rgP1D0JCS+Wfi8JBHYaGAnQm4jvJI943nZW
	Df0os7/S+AHK73xH67JyfxKRvDOF05D52uUvnuUNJhupzo6oezObwduZKSZ18LaQ==
Received: by recvd-canary-8465b4c48c-2zgt8 with SMTP id recvd-canary-8465b4c48c-2zgt8-1-6AD2F46F-5
	2026-10-17 04:07:11.103999751 +0000 UTC m=+1508805.732609009
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-19 (SG)
	with ESMTP
	id VZBbDvTlT0KW3V3gToMmBQ
	Sat, 17 Oct 2026 04:07:10.996 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: [PATCH v2] writeback: keep cleanup_offline_cgwb()'s scan out of syncs
Date: Sat, 17 Oct 2026 04:07:11 +0000 (UTC)
Message-ID: <20261017040710.1174009-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015114307.1041273-1-lizf@honeycomb.io>
References: <20261015114307.1041273-1-lizf@honeycomb.io>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeX7GlhsjZ8PC?=
 =?us-ascii?Q?Bz=2FZXm+aVDXju7NjTKrzoAAjIB+x+EO1=2FK2pA=2Fl?=
 =?us-ascii?Q?bVTzaKDdCTENpW=2Fe+wlK3vnOG5PPz5q0KKgwTsC?=
 =?us-ascii?Q?SgLeacwiiL6N8kw2KkGMjtQNIzeAP6nQG=2Fm2PQh?=
 =?us-ascii?Q?Ioz2aZT4YXDo8MSgZVS4Vvtae5wWtIXWiD=2F794w?= =?us-ascii?Q?K0xo?=
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
without persisting timestamp updates of inodes attached to a dying
cgroup wb, so a crash after the sync loses them. File data and sizes are
not affected.

Since commit f6988c90671e ("writeback: bound cleanup_offline_cgwb()
rescans by rotating scanned inodes"), isw_prepare_wbs_switch() moves the
inodes it walks to the newest end of the list. When a pass fills its isw
before reaching an inode that got its lazytime update after a sync's
cutoff, the walked inodes land past it on b_dirty_time, and the sync's
queue_io(), which stops at the first inode dirtied after the cutoff,
misses them. The late inode has to be one without a pending lazytime
update; one already on b_dirty_time keeps its position.

The window is narrow. cleanup_offline_cgwbs_workfn() skips wbs with
anything on b_dirty, b_io or b_more_io, so the scan has to land between
wb_writeback() fixing dirtied_before and taking list_lock for its first
queue_io(), unless a multi-pass drain started before the wb got dirty
IO.

Take wb_switch_rwsem for read across the scan, as
process_inode_switch_wbs() does for the switches.

Fixes: f6988c90671e ("writeback: bound cleanup_offline_cgwb() rescans by rotating scanned inodes")
Cc: stable@vger.kernel.org
Suggested-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/all/0bc5d58533f10b4841807be3025daa11@kernel.org/
Assisted-by: Claude:claude-opus-5-5 checkpatch
Assisted-by: Claude:claude-fable-5-1
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>
---
Changes in v2, all from Tejun's review:
- Correct the trigger and the reordering description, and note how
  narrow the window is
- Reword the code comment
- Move the test details here and trim the description

Test, with a debug-only delay holding a syncfs's work on the wb between
its cutoff and queue_io() to widen the window: 300 files on a cgroup's
wb with lazytime atime updates, one more read after the cutoff, then
the cgroup removed so the cleanup ran. Without this patch, syncfs()
queued 48 of the 300 and after a crash 252 atime updates were lost, on
ext4 (-I 4096, so neighbours' timestamps are not written along) in 3 of
3 runs and on XFS in 1 of 1; with it, none were lost. arm64 KVM guests,
7.3-rc7.

v1: https://lore.kernel.org/all/20261015114307.1041273-1-lizf@honeycomb.io/

 fs/fs-writeback.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index ea3eb40bf828..372ac9785e03 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -789,6 +789,13 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
 
 	nr = 0;
+	/*
+	 * The scan moves walked inodes to the newest end of b_dirty_time,
+	 * past ones it didn't reach. If one of those was dirtied after a
+	 * sync's cutoff, the sync's queue_io() stops there and misses the
+	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
+	 */
+	down_read(&wb->bdi->wb_switch_rwsem);
 	spin_lock(&wb->list_lock);
 	/*
 	 * In addition to the inodes that have completed writeback, also switch
@@ -803,6 +810,7 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 		restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time,
 						 &nr);
 	spin_unlock(&wb->list_lock);
+	up_read(&wb->bdi->wb_switch_rwsem);
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0

