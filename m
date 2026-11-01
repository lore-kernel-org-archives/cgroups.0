Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533383;
	b=AdNYkJ8CRdFoRsAHqGZI8GXFOrkBvS666QcgqjzTxluFGlgZnURxLnDnAYSWUAaxEf2x
	 AyYHZAr/M1u/SxnJ13zr1KWYGZETvjNoXbmaJ2fpq+UF1xw874zLzM9kqEr9ofjlOTHP8
	 W0z5SUyPNTZdlUCaO+ThTQOTxCsEtchttkfT1/SzmfSx17RjYVIyuv2lFs5bFTayWjMLy
	 KI4lheTIuTmGdNA95jYiJOYQiZI3dgF8RAtRBDl8YZrF6t9O0oMbhhMlUIdQk74zHSG8Y
	 UhkfG8KSVBLcZ8eS2wed+kTAHYm75W3alFsrviDz/FlhxxOD/FsnkJSdrZH/WD3t7CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533383;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LHF6GJPfrpZOo50VAQ6HTdgf2/QRvXqe/Z9PnbiTmr8=;
	b=xmp8Llp2hbk11dgUa6Q3DocKB0DH33NT0qCgdMLIdahvL6zHTL+IVoglRlV9HHVIRfDV
	 clJodZDmyKrmwNn1DJaBPSUS8jg+6qoDA3Mk0GlmUq84ULlUlHXrdZb2uQDl0LreNqxGC
	 NU8YxYQ6dQEZIlBfTXYDIJGpZh5D7dsYSAUtROxKiPu9Wq9b71+1AB//5UxsFhQeONwJo
	 viT2KHInuNFMSy75NfLIW5n0GAYMEsMfdvBtE2+PX/Ps5zVw7Zj/x+ifhtVWr9M5TJ+8P
	 xK43v/i3QiA24wn7/3qqXZG6YubOk/AkenWpDiJUY4di8qvoQZi2ArrOi7ptST3SCxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OTuFkBuU;
	arc=none smtp.remote-ip=91.218.175.69
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775B9606A326
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 775B9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OTuFkBuU
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=k/sdtO2/T8aAWFwwSFh+qz3+snC3R29hU6R0lxFG6Ek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533380; v=1; x=1794138180;
 b=OTuFkBuU9sZN/X76hfuk+axOUafijnVLVvbJb7KuOsi+8xON2awSJ5D1lokFIuh2yxvDSmCs
 7PFv/t5reV6MxZB8ZzNRROZjO2Guiai5MylqKilOrFwuBAdgzGvKM9q8OkxmU7oRhx5LSw/EpKn
 zynBaVIYodE4wa1nKiSsqiaQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b8a8a0cd6a8e99fa;
	Sun, 01 Nov 2026 11:43:00 +0000
X-Mizu-Trace-ID: b8a8a0cd6a8e99fa
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
Subject: [RFC PATCH -v4 04/22] cpuset: introduce partition_enable()
Date: Sun,  1 Nov 2026 19:41:48 +0800
Message-Id: <20261101114206.2434398-5-ridong.chen@linux.dev>
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

Add partition_enable() to consolidate updates to key cpuset structures
during partition enablement, including:
1. remote_partition
2. effective_xcpus
3. partition_root_state
4. prs_err

Key operations performed:
1. Invokes partition_xcpus_add() to assign exclusive CPUs
2. Maintains remote partition flag
3. Syncs the effective_xcpus mask
4. Updates partition_root_state and prs_err
5. Triggers scheduler domain rebuilds
6. Sends partition change notifications

This helper also handles the transition between root and isolated
states of a valid partition. In that case the cpumasks are unchanged
and only isolated_cpus is updated.

A partition_state_update() helper is added to set partition_root_state
and prs_err, and to reset the partition data when the new state is not
a valid partition.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 51 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index df52f6e5e99f..052a131731dd 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1716,6 +1716,57 @@ static void compute_effective_nodemask(nodemask_t *new_mems,
 		nodes_copy(*new_mems, parent->effective_mems);
 }
 
+static void partition_state_update(struct cpuset *cs, int new_prs,
+				   enum prs_errcode prs_err)
+{
+	lockdep_assert_held(&callback_lock);
+
+	cs->partition_root_state = new_prs;
+	WRITE_ONCE(cs->prs_err, prs_err);
+	if (!is_partition_valid(cs))
+		reset_partition_data(cs);
+}
+
+/**
+ * partition_enable - Transitions a cpuset to a partition root
+ * @cs: The cpuset to enable partition for
+ * @parent: Parent cpuset of @cs, NULL for remote parent
+ * @new_prs: New partition state to set
+ * @new_excpus: New effective exclusive CPUs mask for the partition
+ *
+ * Transitions a cpuset to a partition root, only for v2.
+ * It also supports the transition between root and isolated partition.
+ */
+static void partition_enable(struct cpuset *cs, struct cpuset *parent,
+			     int new_prs, struct cpumask *new_excpus)
+{
+	int old_prs = cs->partition_root_state;
+
+	lockdep_assert_cpuset_lock_held();
+	WARN_ON_ONCE(new_prs <= 0);
+	WARN_ON_ONCE(!cpuset_v2());
+
+	if (old_prs == new_prs)
+		return;
+
+	spin_lock_irq(&callback_lock);
+	if (old_prs > 0) {
+		/* Switch between root and isolated, cpumasks are unchanged */
+		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
+	} else {
+		/* enable partition should only add exclusive cpus */
+		partition_xcpus_add(new_prs, parent, new_excpus);
+		/* enable remote partition */
+		if (!parent)
+			cs->remote_partition = true;
+		cpumask_copy(cs->effective_xcpus, new_excpus);
+	}
+	partition_state_update(cs, new_prs, PERR_NONE);
+	spin_unlock_irq(&callback_lock);
+	cpuset_force_rebuild();
+	notify_partition_change(cs, old_prs);
+}
+
 /*
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
-- 
2.34.1

