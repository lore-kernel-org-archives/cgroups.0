Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6C148CD68
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786726646; cv=none; b=ELOBdJa5Rz09p+vvahKBOoCTSjXDcp4a0kTZnT60wsjKlT43O1N3tqH4f1g3tB4NH/vMOVaM9aQqSfOOGIiPrzH7EplW0J9ALRBlIF3yGVhREdWYtSmfpv5Of4ns8gbqfjwTLeY5MyiKJIZCuYoGT76AuCMKNgsrf60zz90ChEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786726646; c=relaxed/simple;
	bh=MgdIR1gKCaB7HmkjICzTGmBtenY5gqEIgSXJG/amQ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRLr+i0Q6fTSrCIZjOg/vz2hjP441aQSXYrRaB5Vil/UdPHmreprNsI4hERafjmm6DjgfetrNQQffTG+/HEH66ClRofv0EQZIwEASqZtSs6+N4dCh97rZItc/4Xpx7c8KQz0dk/R/ZihNjTTH2cfjGM9a37OqS7t39avE+fkDL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DuE+Ts+m; arc=none smtp.client-ip=91.218.175.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DuE+Ts+m"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MgdIR1gKCaB7HmkjICzTGmBtenY5gqEIgSXJG/amQ6w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786726642; v=1; x=1787331442;
 b=DuE+Ts+mGA+aggzm3O/Vs4/nRh7eJTlNszT7Bkhn1b75MZUTOdPz72Ue3jBxpTbKSs+qEinx
 PyPr/P85vepOf1NxoaCIW8GwsiJVt4Lr3DxN2oKBELRwy4QupF8MaHp55v+IjHSpzZXeoOKM4Kd
 2YQHZzxWBUizSxWywO6LNbFo=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:24::)
	by mta11.migadu.com with ESMTPS id a2c8de5b93f351fd;
	Fri, 14 Aug 2026 16:57:22 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: tj@kernel.org,
	axboe@kernel.dk,
	cgroups@vger.kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	riel@surriel.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 2/3] blk-iocost: clear delay state when freeing policy data
Date: Fri, 14 Aug 2026 09:56:38 -0700
Message-ID: <20260814165712.510132-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814165712.510132-1-usama.arif@linux.dev>
References: <20260814165712.510132-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iocg_kick_delay() turns sufficiently large debt into an explicit
block-cgroup delay with blkcg_set_delay(), setting blkg->use_delay to
-1 and incrementing blkcg->congestion_count.  Clearing it again depends
on iocg_kick_delay() running from the period timer, the waitq timer or
the issue path.

ioc_pd_free() removes the iocg from active_iocgs and cancels its waitq
timer, and no further bios can arrive, so once it has run nothing is
left which can reduce the debt and clear the delay.  The blkcg stays
marked congested for the rest of its life.

blk_cgroup_congested() then returns true for every task in that cgroup
and its descendants: page_cache_sync_ra() cuts readahead to a single
page, page_cache_async_ra() skips it altogether, and
__folio_throttle_swaprate() takes swap_avail_lock and schedules a
throttle on anonymous folio allocation.

Clear it explicitly, after the list removal and the synchronous
hrtimer_cancel() so that neither timer processing nor an I/O path can
re-arm it.  The free callback can also see policy data which was never
attached to a blkg, hence the pd->blkg check.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 block/blk-iocost.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index b60625613e095..64b92aa3e5d48 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3063,6 +3063,7 @@ static void iocg_release(struct rcu_head *rcu)
 static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
+	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct ioc *ioc = iocg->ioc;
 	unsigned long flags;
 
@@ -3085,6 +3086,12 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 		hrtimer_cancel(&iocg->waitq_timer);
 	}
 
+	/* off ->active_iocgs and timer gone, so nothing can re-arm the delay */
+	iocg->delay = 0;
+	iocg->indelay_since = 0;
+	if (blkg)
+		blkcg_clear_delay(blkg);
+
 	call_rcu(&pd->rcu_head, iocg_release);
 }
 
-- 
2.53.0-Meta

