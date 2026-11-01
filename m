Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.142
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533421;
	b=DwJfMy5h03IcRft/oJ4D/XCcNc+AoXzZRO1xFDASUJxm0lCCZRg1+zPwBNJTnwQz0il0
	 z5yZWVpMLGULaJ+nu6AKwXJGgvM2m/CmyufHFRNxw9kd+BUBE3ebx/gjQ5cODIh49FLZe
	 xOwCrcz7JOR/xMF9YP96ASuKyXJUShtVJZtnM2FTGlAbu6U+lpgXnBvjq+AekU02EjT4z
	 ltOPFlNFQt3XNXr71riFdReSUJJV1avad0+7E3eMu2dkmpRi2QZ+jb2EKPh8byMplshRg
	 eOztxaw3irGyjn3LVcDj6zn5dkqMGeBHSivjj5+gwfZOYx71X5j74XdFhQl19bRPDZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533421;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2NNqnX5JtAH/rh3gL2YNYcQ4TYrngNuEYIZY89xW46s=;
	b=qj/A0yRG55eYyOMm7f8guR5zjIStTDzJr0Rs7IezX60UvonJqyGw4H0TF0OH/7Rc4a29
	 LTIONBV4dFzFR0uZfXRavVLOY1K2+PkhteJpdEJKVFrbgotjeymy5FjXuG7DUVKWNzUgp
	 wgqkuv1ztWXOYWLnZdlLj1IIgtFTzQCHTukpLVB7UpdBCMU51KYcH14fbcb01jiWj74DY
	 MHKcdHJAI/YhNlsZV/NnrKD6bqW3rQm7Jx7zce8TXD7oemH/nLFvbTTtieN57h+p+Y/Zv
	 vFl3UH3fFGFFgHulnsBpfawJ7d9svk9IQ8g2cFsLgQcoyN7cmq9V2KJxYbdrLQ6g91A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=evhcN5rC;
	arc=none smtp.remote-ip=95.215.58.142
Received: from mta1.migadu.com (out-142.mta1.migadu.com [95.215.58.142])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CAD606A324
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70CAD606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=evhcN5rC
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fDtXUi/ByUpoaM0U/cHBiVo6C1In1CKG6bTlc6gYAWk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533418; v=1; x=1794138218;
 b=evhcN5rCKTmVFalWuONolaWEBIlt8WfQG/nqyvNCZjidNjUDJDbVhoBkIpTmljobdKr00gOh
 OIQgvTVjUPFmsiQnDjJLVD3D+mbwRxfNebbuPA43zqGQh1vLTFB/ZAy7EqA1R6CcOTfR9sYMPIc
 wzhVN0jzsBqhZ1Ahc2bolm7w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2decbc861848a5f9;
	Sun, 01 Nov 2026 11:43:38 +0000
X-Mizu-Trace-ID: 2decbc861848a5f9
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
Subject: [RFC PATCH -v4 09/22] cpuset: use partition_update() for remote partition update
Date: Sun,  1 Nov 2026 19:41:53 +0800
Message-Id: <20261101114206.2434398-10-ridong.chen@linux.dev>
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

Now that the partition_update() helper is available, use it to replace
the existing remote partition update logic. This unifies the update
path through a single centralized function.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9a683e6ef0be..ef162935ba5a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1950,7 +1950,6 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			       struct cpumask *excpus, struct tmpmasks *tmp)
 {
-	bool adding, deleting;
 	int prs = cs->partition_root_state;
 
 	if (WARN_ON_ONCE(!is_remote_partition(cs)))
@@ -1963,15 +1962,15 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
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
@@ -1986,22 +1985,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
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

