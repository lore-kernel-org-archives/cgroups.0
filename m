Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.61
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794645129;
	b=lkgaXCPnctub3C12+gXWHnUelJa3JJIhHjzwdchu3bZW3asxhd7je2oLsjjWE35oJ377
	 3KQrgRhHyI5dhGj+cA7DjxMyHBneAbphwZXIe0Rx0CTtqSKdaL48qSleh93qqhqwdsX+D
	 AZ8OlisZs1Q7VlzMjdnmtSYukSJImvpjmv44ZNAfB8TjgXWwwlOCy7Gufi6Mktg28Eo5k
	 ZuehBKslLAtnf2NXnTM0S/w9dcYvN+aYLBuj6uVCol1UQVqSpQQByFmzp+IJXVLpIUVLG
	 /bC/kEOG4+hkSotoqDJ6RkKVmWhETQKCvgZBMyIWM8zMoCcyS0Ktq7y00veEjWrcIvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645129;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/kfnCnL2FfTXlX8HBdpj6Ey3REAg8JJil7iZklVSU5A=;
	b=ydAAFPDAiDcQcDWZkLcsSIm38L+/fdZSWaPdDVy9MPcE21le057y6OuC88x/3jz+/6OY
	 G4KF06HeOzxyw5cmenkzFfZHD1e3eQxQ5GD8RYpKZ/7y4vdQOYm7efI07221CmB2CEgJn
	 IFM5TWFDlU2Ofgvs47MT0afT/7+y9qAlf6MHaF209u8bLeltNhLVq6YUVJFvY9xT3SUha
	 wfHSArNCzvQZ/LNNPg/xzKbRNeRNiNeoAknQF9LuXsyjiGG9D5zCifO6QdpNLWuybxNLc
	 TkxUGc//a76r+W4NxOkOOtgDAIY0zrZs71ZXw3oU7yy/8D7XMi/1h3AVi3BmJjyIn6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TFUHhxWR;
	arc=none smtp.remote-ip=95.215.58.61
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F094F606A88F
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 08:32:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F094F606A88F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TFUHhxWR
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=c+2Dv0KGtPLfcqjt11UtONzjMu0zD2TMN0PDR+tdXHA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794645127; v=1; x=1795249927;
 b=TFUHhxWRfj4Z9HbV3CLqx2qLbrEyAA8e/DUUZ+LbLRAAGAvmqSY6E4riVwmFT9AQiUL6AiPu
 kyI1n+b+V3Sg3N0n8KNkOswWKAYHssJuiJe8zLkolUFXOkbKEngcEYDv9Lw0YRWupnhTy3LNtvQ
 GJfW0MDnPUl3zZEFa/kR7Z9E=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4e0684a63d91fa96;
	Sat, 14 Nov 2026 08:32:07 +0000
X-Mizu-Trace-ID: 4e0684a63d91fa96
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 06/12] cpuset: use partition_update() for remote partition update
Date: Sat, 14 Nov 2026 16:31:18 +0800
Message-Id: <20261114083124.1340140-7-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261114083124.1340140-1-ridong.chen@linux.dev>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
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

From: Ridong Chen <chenridong@xiaomi.com>

Now that the partition_update() helper is available, use it to replace
the existing remote partition update logic. This unifies the update
path through a single centralized function.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 681adcde10e8..7a3e797aee52 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1835,8 +1835,8 @@ static void partition_disable(struct cpuset *cs, int new_prs,
  * will be added to the subpartitions_cpus and removed from parent's
  * effective_cpus, and the tmp->delmask vice versa.
  */
-static void __maybe_unused partition_update(struct cpuset *cs, int prs, struct cpumask *xcpus,
-					    struct cpumask *excpus, struct tmpmasks *tmp)
+static void partition_update(struct cpuset *cs, int prs, struct cpumask *xcpus,
+			     struct cpumask *excpus, struct tmpmasks *tmp)
 {
 	struct cpuset *parent;
 
@@ -1935,7 +1935,6 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			       struct cpumask *excpus, struct tmpmasks *tmp)
 {
-	bool adding, deleting;
 	int prs = cs->partition_root_state;
 
 	if (WARN_ON_ONCE(!is_remote_partition(cs)))
@@ -1948,15 +1947,15 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 		goto invalidate;
 	}
 
-	adding   = cpumask_andnot(tmp->addmask, excpus, cs->effective_xcpus);
-	deleting = cpumask_andnot(tmp->delmask, cs->effective_xcpus, excpus);
+	cpumask_andnot(tmp->addmask, excpus, cs->effective_xcpus);
+	cpumask_andnot(tmp->delmask, cs->effective_xcpus, excpus);
 
 	/*
 	 * Additions of remote CPUs is only allowed if those CPUs are
 	 * not allocated to other partitions and there are effective_cpus
 	 * left in the top cpuset.
 	 */
-	if (adding) {
+	if (!cpumask_empty(tmp->addmask)) {
 		WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
 		if (!capable(CAP_SYS_ADMIN))
 			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
@@ -1971,22 +1970,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	}
 
 	cs->remote_partition_updating = true;
-	spin_lock_irq(&callback_lock);
-	if (adding)
-		partition_xcpus_add(prs, NULL, tmp->addmask);
-	if (deleting)
-		partition_xcpus_del(prs, NULL, tmp->delmask);
-	/*
-	 * Need to update effective_xcpus and exclusive_cpus now as
-	 * update_sibling_cpumasks() below may iterate back to the same cs.
-	 */
-	cpumask_copy(cs->effective_xcpus, excpus);
-	if (xcpus)
-		cpumask_copy(cs->exclusive_cpus, xcpus);
-	spin_unlock_irq(&callback_lock);
-	if (adding || deleting)
-		cpuset_force_rebuild();
-
+	partition_update(cs, prs, xcpus, excpus, tmp);
 	/*
 	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
 	 */
-- 
2.34.1

