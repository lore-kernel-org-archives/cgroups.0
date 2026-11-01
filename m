Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.126
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533398;
	b=U9EcIaYrp+zvRGbKvBxzDG/fPXzq6utsdgCr0TJDWabFiXvU2MMUarPlEOyAz33QUM98
	 07HaPM+Yrjf0XtxfiQP/t4fOwIHrTx2ut9Hva6HnF6UkBCvb1uIRq9CV8MUnKknQ67vPJ
	 jlnNqO1RSfMmXUfWMH6kCB2EvCo+oUYU1jYmPC6JMFUOtRKIjxdieciBXwDTQaSZvOY8x
	 xms4fJHXKgBjkaRRIuE/lW6p0cWQr8iluhc/RCTl4xl3owKTxGNvLAClEduz+fTrLpg22
	 8FtIdkZZQ70x8HxtR8tLIzBQif3j3zwa/9KBR2rAFrMj8d75iSuEfj5i6A+0kMO/0yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533398;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=egcDD7StWm2KzdxIHCTD2Wz1mW0J5nsYOleDz5MV2Lk=;
	b=h8qb2F/1xtqXG7fF+zF0r1q3AX683+Zqm1hUObiFjUaFUIfNRkJCcS7Su/5Rl0CThlrF
	 az10RvRnue7Y3iwaVQLhmN+BNENYIvfF6uJNjPYMxqtupuAqO/wHyxiaCU2EhMY2DaPsk
	 jN13877WCNxtvWuT+YledPfcJekgGu/SzgrB7obDanl0mIR1h//26y2BNADJTBPkI7K+P
	 k6pQ7E1pDhF5XhsyCbgkN2lR1Z4nOeWtF5nz2ouhCz6vw8tjc/QQHdzXMFflMJAqNSr0o
	 a4TIXLBF9p3wqaY9LbrBU8P+oJtBCFVQlv5qcjxnMSTuu3Cv2+s8qnhGbNbRPVOFTHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YTbKu2iT;
	arc=none smtp.remote-ip=95.215.58.126
Received: from mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA25606A325
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BA25606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YTbKu2iT
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IAIH0sUB6ZXvBp6EwjjsX/8m+Idapnbxreekm81rNgE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533395; v=1; x=1794138195;
 b=YTbKu2iTs7gB6eC8lZjXt8b4+Ea0sku+vWVfs41klTDt3SZlWPvCxes5HFXN/RBAL+sSvwmt
 uwRo4LBktaB8mXEZS2nlAendQ6QzeJ2uwM13ZNJPCnbiIFwDIkMMs9649+XKsUYN1O7QRP3FKNb
 XaVRTgHVPv2VOxUn7qQl+MvM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 45a4f65045edd856;
	Sun, 01 Nov 2026 11:43:15 +0000
X-Mizu-Trace-ID: 45a4f65045edd856
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
Subject: [RFC PATCH -v4 06/22] cpuset: introduce partition_update()
Date: Sun,  1 Nov 2026 19:41:50 +0800
Message-Id: <20261101114206.2434398-7-ridong.chen@linux.dev>
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

Introduce partition_update() to centralize updates to key cpuset structures
during a partition update, including:
1. effective_xcpus
2. exclusive_cpus

Key operations performed:
1. Adding and removing exclusive CPUs via partition_xcpus_add()/del()
2. Synchronizing the effective exclusive CPUs mask
3. Updating the exclusive CPUs mask when modification is required
4. Triggering scheduler domain rebuilds

For a local partition, the CPUs to be added or deleted are restricted to
those in the parent's effective_xcpus, as the parent may have shrunk.
The function returns early if nothing is to be changed.

The partition root state is unchanged by this function, so no partition
change notification is sent.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 51 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c0d6dd7297f1..23ae548c3994 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1806,6 +1806,57 @@ static void partition_disable(struct cpuset *cs, struct cpuset *parent,
 	notify_partition_change(cs, old_prs);
 }
 
+/**
+ * partition_update - Update an existing partition configuration
+ * @cs: The cpuset to update
+ * @prs: Partition root state (must be positive)
+ * @xcpus: New exclusive CPUs mask for the partition (NULL to keep current)
+ * @excpus: New effective exclusive CPUs mask
+ * @tmp: Temporary masks
+ *
+ * Updates partition-related fields. The tmp->addmask is the CPU mask that
+ * will be added to the subpartitions_cpus and removed from parent's
+ * effective_cpus, and the tmp->delmask vice versa.
+ */
+static void partition_update(struct cpuset *cs, int prs, struct cpumask *xcpus,
+			     struct cpumask *excpus, struct tmpmasks *tmp)
+{
+	struct cpuset *parent;
+
+	lockdep_assert_cpuset_lock_held();
+	WARN_ON_ONCE(!cpuset_v2());
+	WARN_ON_ONCE(prs <= 0);
+
+	parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
+
+	/*
+	 * Only CPUs owned by the parent can be taken from or given back to
+	 * it, the parent may have shrunk. A remote partition gets its CPUs
+	 * from top_cpuset which owns all the CPUs.
+	 */
+	if (parent) {
+		cpumask_and(tmp->addmask, tmp->addmask, parent->effective_xcpus);
+		cpumask_and(tmp->delmask, tmp->delmask, parent->effective_xcpus);
+	}
+	if (cpumask_empty(tmp->addmask) &&
+	    cpumask_empty(tmp->delmask) &&
+	    cpumask_equal(cs->effective_xcpus, excpus))
+		return;
+
+	spin_lock_irq(&callback_lock);
+	partition_xcpus_add(prs, parent, tmp->addmask);
+	partition_xcpus_del(prs, parent, tmp->delmask);
+	/*
+	 * Need to update effective_xcpus and exclusive_cpus now as
+	 * update_sibling_cpumasks() below may iterate back to the same cs.
+	 */
+	cpumask_copy(cs->effective_xcpus, excpus);
+	if (xcpus)
+		cpumask_copy(cs->exclusive_cpus, xcpus);
+	spin_unlock_irq(&callback_lock);
+	cpuset_force_rebuild();
+}
+
 /*
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
-- 
2.34.1

