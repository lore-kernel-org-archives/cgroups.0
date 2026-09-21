Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE3549BD93
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789996872; cv=none; b=fxsoSGYkcZmtzyL5xQ6WYs4ZfEiQtXVvPOqpawBdKMj3oDA4HKv2pUcvoCceatPQ40v5X+iVh4UEMFyKDpGdNTBRGGCuszOY2iwjDzRv/hOPoe2qMGXH1dZZNtLcz3he3ME7QphiCq696h0aDcQM/V80TFwc4qWOaCyF/QDGaBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789996872; c=relaxed/simple;
	bh=XHhhpIRSVeRUFrSH06ZX2+yxFjIIN2iEIssHDbvjhag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LbOGEkWudfaQ4JEieXBMU74rBnLOFvia8if4hlhxrEDqnZogv7QYtMyqfsDHUIkKY2ZBgZkFFn6OAYaN03mSUTSnE7uVeXVcOaLX0QoJLqf0K8LmEdBnhY1Ia3e7YjMAmbcQexCnpVo+i1A93GTsrx/3E0CLiPYoCoE0dUpm1Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h61hi5Q/; arc=none smtp.client-ip=95.215.58.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h61hi5Q/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XHhhpIRSVeRUFrSH06ZX2+yxFjIIN2iEIssHDbvjhag=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789996867; v=1; x=1790601667;
 b=h61hi5Q/2wJTYqdxItt4/1796aHqTuarjm1NdgcjnSVgHRaz6PkW3vcHEGPCNpQm8tqkHPZz
 FlWrqTspoTQZV4LVHJ04a2DHsG4v18pvoUBBEMItXOoWBvfRAGvHoJLEfO+mmd37E706TaIRheK
 2HFfPOqLt6Q9R4SaNMLCHawU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id f27a01d63cb50625;
	Mon, 21 Sep 2026 13:21:07 +0000
X-Mizu-Trace-ID: f27a01d63cb50625
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
	kas@kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2] blk-cgroup: skip rstat flush for cgroups without blkgs
Date: Mon, 21 Sep 2026 06:20:58 -0700
Message-ID: <20260921132058.2091567-1-usama.arif@linux.dev>
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
i
This is not rare: 340 of 969 io.stat files were empty on a 316-CPU host.
In a 16-vCPU guest, the median open/read/close time over 35 batches of
20,000 reads changed as follows:

                          before    after
  empty io.stat           7.02 us   5.47 us
  populated io.stat       7.84 us   7.83 us

This is a ~22% reduction for empty reads. Populated reads were
unchanged.

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
v1 -> v2:
- Updated commit message with perf numbers with lockdep disabled (Tejun)
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

