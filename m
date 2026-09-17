Received: from mta0.migadu.com (out-130.mta0.migadu.com [91.218.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0D449D5AE
	for <cgroups@vger.kernel.org>; Thu, 17 Sep 2026 16:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661434; cv=none; b=dinoLpvnErZsVlqozjhwgy2+yGiogSdbKMtQR6ZM8jzulEWLoxSCe3CySTZ85X1IKBdxx2K9FYs0qEUZ+w8fqdM8nAFWGoosReQFZizfZnFmgEX2p3CuDM7nKODo0xDQAyMnPGzGi1l2GAzkfzya96IFUCuLez5y/k4bTcBHl2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661434; c=relaxed/simple;
	bh=6Wl51RpNHVgkOjA0fcQCXELr6VR36ezdQnHaPS1eqgc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CqHP5ctimnbhXHy9yJRsikDq1NgU0me9RknDILRJ7DVzOgNHtCYxXDj++SyU7zzmUfMYDvqzs4lTps5vqnyL31ESWNdNDzY4ao5B9Gb4HAcMuXISwlj/jWYtRBYFFlCOxq8EI3qhNiMxytEdiak5Qd7zpP61iU6rPgZGc5SgyO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YFvDDmXC; arc=none smtp.client-ip=91.218.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YFvDDmXC"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6Wl51RpNHVgkOjA0fcQCXELr6VR36ezdQnHaPS1eqgc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789661429; v=1; x=1790266229;
 b=YFvDDmXC5TZ+ZWaTn058bDJjWQlW6EROPR1eWG/rkITD5gGtqbE5v1ltK0QrIL2AGNZSsQne
 QoiaOKFsN6nmSGRWA05HH8QASBm35k88gnOj2hPIdmQn4herYdwv7WZmZmYeP2HI38aBvAb/nkA
 Araqm7pp3kRE5xYi2ZIf0iRY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id eed331233a5ea59d;
	Thu, 17 Sep 2026 16:10:29 +0000
X-Mizu-Trace-ID: eed331233a5ea59d
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: axboe@kernel.dk,
	cgroups@vger.kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tj@kernel.org
Cc: hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] blk-cgroup: skip rstat flush for cgroups without blkgs
Date: Thu, 17 Sep 2026 09:10:20 -0700
Message-ID: <20260917161020.4139163-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Non-root io.stat reads flush the blkcg rstat subtree before walking
->blkg_list. This takes the subsystem rstat lock and checks for pending
updates on every possible CPU, even when there is no per-device state to
print.

Blkg creation is hierarchical. A descendant blkg implies an ancestor
blkg on the same device, so an empty ->blkg_list means the subtree cannot
contribute any output. Return early in that case.

A concurrent first blkg may be deferred to the next read. This is
consistent with the existing non-atomic flush and list walk.

This is not rare: 340 of 969 io.stat files were empty on a 316-CPU host.
In a 16-vCPU lockdep-enabled guest, the median
open/read/close time over 35 batches of 20,000 reads changed as follows:

                         before     after
  empty io.stat          49.1 us   41.0 us
  populated io.stat      49.9 us   50.2 us

This is a 16.6% reduction for empty reads. Populated reads were unchanged
within measurement noise.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 block/blk-cgroup.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2b5c29434e426..0d7a451473b04 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1189,10 +1189,17 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
 	struct blkcg_gq *blkg;
 
-	if (!seq_css(sf)->parent)
+	if (!seq_css(sf)->parent) {
 		blkcg_fill_root_iostats();
-	else
+	} else {
+		/*
+		 * Descendant blkgs imply ancestor blkgs, so an empty
+		 * ->blkg_list has no stats to report.
+		 */
+		if (hlist_empty(&blkcg->blkg_list))
+			return 0;
 		css_rstat_flush(&blkcg->css);
+	}
 
 	guard(spinlock_irq)(&blkcg->lock);
 	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node)
-- 
2.53.0-Meta

