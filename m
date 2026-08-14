Received: from mta1.migadu.com (out-108.mta1.migadu.com [95.215.58.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1435448D890
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786726640; cv=none; b=Wi4b/0Doc1hIm00w9shD80N9gVVyle9tXZ/TaPwXfofTt/UX1EojFTTT+XkQGGmwFXsJiiBXwPxOpHWXCAR8+w98tyWUPKqXsq1kt4O45U5HIQnULpJCz33pGcbDTA98rORsZVrZ51/TKkj0IiL33fvAe6MrCiw52A/GHmVokac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786726640; c=relaxed/simple;
	bh=Q5/zdQWz0Amn1o+/OUx4rATy9xjEBYqtx8W87l2OgSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m9SW0QRaOMxpQtpAUWaoojxjwPJ+AQB561VNLm8TnpekPCNVkis1HaRHgobgaCElsG2nOU7aH+3lhFplgQ7XSAP64rIH7wXD1sjluELocoQhX5Kyzej3WFfqt/n4WBKmesz6Ba/DWCoduMG9gphy9m/JRF39LiiktXdxSQiYyE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IUQDuDEj; arc=none smtp.client-ip=95.215.58.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IUQDuDEj"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Q5/zdQWz0Amn1o+/OUx4rATy9xjEBYqtx8W87l2OgSc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786726637; v=1; x=1787331437;
 b=IUQDuDEjt3YDpnQfnPH1DMRHAKcWm9gVxWDavNl8KQW7Pe9vU/HMX75Pm3hd19A90JjFnKGk
 fL23eV2TTw8JBGoQgzdCMCIlhjX/exHb/xYEhkELr6zD2VtXii+/aHLDNSKMiPIBEceSSzjyV9l
 BgkJPQpcNwou+DEWWBWfnee0=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:51::)
	by mta10.migadu.com with ESMTPS id f3759c31d8a1f550;
	Fri, 14 Aug 2026 16:57:17 +0000
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
Subject: [PATCH v2 1/3] blk-iolatency: clear delay state when freeing policy data
Date: Fri, 14 Aug 2026 09:56:37 -0700
Message-ID: <20260814165712.510132-2-usama.arif@linux.dev>
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

io.latency can throttle a group which has no latency target of its own.
When a sibling misses its target, check_scale_change() scales down its
peers, and a peer that reaches queue depth one gets blkcg_use_delay()
called on it on every further scale-down, even with min_lat_nsec == 0.

iolatency_pd_offline() resets the target through
iolatency_set_min_lat_nsec(), which clears the delay only on a nonzero
to zero transition, so it never clears such a peer.  Freeing the policy
data then leaves blkg->use_delay set and blkcg->congestion_count
elevated with nothing left that can drop it.

blk_cgroup_congested() then returns true for every task in that cgroup
and its descendants for as long as the cgroup lives: page_cache_sync_ra()
cuts readahead to a single page, page_cache_async_ra() skips it
altogether, and __folio_throttle_swaprate() takes swap_avail_lock and
schedules a throttle on anonymous folio allocation.

Clear the delay in iolatency_pd_free().  By then bio-held blkg
references have drained, or the queue is frozen for policy
deactivation, so check_scale_change() cannot re-arm it.  The free
callback can also see policy data which was never attached to a blkg,
hence the pd->blkg check.

Fixes: d70675121546 ("block: introduce blk-iolatency io controller")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 block/blk-iolatency.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 9eb69010c34e6..2caa79a008ad1 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -1043,6 +1043,15 @@ static void iolat_release(struct rcu_head *rcu)
 
 static void iolatency_pd_free(struct blkg_policy_data *pd)
 {
+	struct blkcg_gq *blkg = pd_to_blkg(pd);
+
+	/*
+	 * Groups throttled as collateral have min_lat_nsec == 0, so
+	 * iolatency_pd_offline() leaves their delay set.  Drop it here, where
+	 * no in-flight bio can re-arm it via check_scale_change().
+	 */
+	if (blkg)
+		blkcg_clear_delay(blkg);
 	call_rcu(&pd->rcu_head, iolat_release);
 }
 
-- 
2.53.0-Meta

