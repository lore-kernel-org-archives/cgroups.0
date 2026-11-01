Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.193
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533515;
	b=JQHfPPl/T6qY57EGxXcUbqautJ8EtU92loOTBo8/gk9d9RVyd9jVXMz4geTcz7coWmTj
	 0UTlHtwx6Q/71MtxZ/ZNxpCqeqcbBw3w5ymhuFCEEGFhdoLMyyHnIH7AyP3oGnfiJbETV
	 wOTpDieavWzFEoSEXTR6sEmO/eS9vNa3evFL20J4pHQdKblQxSJ1h+/72Flhn11eqxn4j
	 XhdHh7+Kt4eSHwEs3WTHm3bStNqQUFMpJjq+taRXpnvQNvL4ZKtDABrsl3WM1w99ec7mg
	 OXxEB+VUFdttcYh2IFTwBiD838X1NiITBFYthcldZ5tdl+b8G5Z6hQp1hHy1zIltKoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533515;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=61riLbuQPg1KcJfMojjkNbskFF3NsvlC9ERQA5V+JF8=;
	b=rw6QtVG8g1pgo5sHpoEk05952qmm7fXLUrohhHAe/toMBEmHxDK9xp9c8Q9BE2pxCEY9
	 XtSHScoqbKb86HFoW2nlNdn3cqFKZpxVafQU9TkYsNPlrvnqMlWBKd8hhaIxGKUGhyhmi
	 ii495F5Kq4EOyJQzsIrHWPG+dRgio6grO27N/M+bOS02QB9x1mm/0dxIwPc34jXpSVibu
	 bla65r1Al+hWyR+Z+eYiCAWWLIAlgtMvKCSeKWudClLx31xPRoD/YsjTonHa4xf+zA6YJ
	 Prsw8dsRV5MlTQFtHAlSmnetDb9r3KURNiM9EFnjPi7TvtscjvrmiIlWeRx1pd4viCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vJr7R6Pg;
	arc=none smtp.remote-ip=95.215.58.193
Received: from mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB079606A325
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:45:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CB079606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vJr7R6Pg
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ltwHVsY3uQ/3asEv2uZHqHgSzEqkB9mINDfRFIOSA6c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533513; v=1; x=1794138313;
 b=vJr7R6PgBG35KxgVAGjZzhae5zi/hAmI0FAlPjukRsntDzz3htLDVjoPDX3MhkRnNCSmPTc6
 HQxbI2fXapYZLu32L/ldh0vrBMsfZW8uJUKeKrz2UXBT6D/gpJPFbHKc/50TTknb0nj/WCVJvDz
 sqpt06T4k/KxdXR2fISkHnMI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 58aa590652f8e0a7;
	Sun, 01 Nov 2026 11:45:12 +0000
X-Mizu-Trace-ID: 58aa590652f8e0a7
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Michal Koutn?" <mkoutny@suse.com>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ridong <chenridong@huawei.com>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH -v4 22/22] cpuset: remove unnecessary validation in partition_cpus_change
Date: Sun,  1 Nov 2026 19:42:06 +0800
Message-Id: <20261101114206.2434398-23-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261101114206.2434398-1-ridong.chen@linux.dev>
References: <20261101114206.2434398-1-ridong.chen@linux.dev>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chen Ridong <chenridong@huawei.com>

When user-configured CPUs (including cpuset.cpus and cpuset.cpus.exclusive)
are modified, the partition may either be disabled or updated. Both local
and remote partitions update can fully validate their own validity: if the
validation fails, the partition will be disabled. Therefore, the
validation in partition_cpus_change is redundant and can be removed.

With that, trialcs->prs_err is never set, so remove its error branches
in partition_cpus_change() and its initialization in update_cpumask()
and update_exclusive_cpumask().

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 40 +++++-----------------------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4fd8b0025a5a..e710e7236922 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2459,43 +2459,15 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
 static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 				  struct tmpmasks *tmp)
 {
-	enum prs_errcode prs_err;
-	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
-
 	if (cs_is_member(cs))
 		return;
 
-	/*
-	 * Check for housekeeping conflict by passing the whole
-	 * effective_xcpus as well as those CPUs that are to be
-	 * removed from cs as delmask.
-	 */
-	if (is_partition_valid(cs))
-		cpumask_andnot(tmp->delmask, cs->effective_xcpus,
-			       trialcs->effective_xcpus);
+	if (is_remote_partition(cs))
+		remote_cpus_update(cs, trialcs->exclusive_cpus,
+				   trialcs->effective_xcpus, tmp);
 	else
-		cpumask_clear(tmp->delmask);
-
-	prs_err = validate_partition(cs, parent, trialcs->partition_root_state,
-				     trialcs->effective_xcpus, tmp->delmask);
-	if (prs_err)
-		trialcs->prs_err = prs_err;
-
-	if (is_remote_partition(cs)) {
-		if (trialcs->prs_err)
-			remote_partition_disable(cs, -cs->partition_root_state,
-						 trialcs->prs_err, tmp);
-		else
-			remote_cpus_update(cs, trialcs->exclusive_cpus,
-					   trialcs->effective_xcpus, tmp);
-	} else {
-		if (trialcs->prs_err)
-			local_partition_disable(cs, -cs->partition_root_state,
-						trialcs->prs_err, tmp);
-		else
-			__local_partition_update(cs, trialcs->exclusive_cpus,
-						 trialcs->effective_xcpus, tmp, false);
-	}
+		__local_partition_update(cs, trialcs->exclusive_cpus,
+					 trialcs->effective_xcpus, tmp, false);
 }
 
 /**
@@ -2521,7 +2493,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		return 0;
 
 	compute_trialcs_excpus(trialcs, cs);
-	trialcs->prs_err = PERR_NONE;
 
 	retval = validate_change(cs, trialcs);
 	if (retval < 0)
@@ -2597,7 +2568,6 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (alloc_tmpmasks(&tmp))
 		return -ENOMEM;
 
-	trialcs->prs_err = PERR_NONE;
 	partition_cpus_change(cs, trialcs, &tmp);
 
 	spin_lock_irq(&callback_lock);
-- 
2.34.1

