Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794645113;
	b=IhXT5PpnsvEmqBkXAK3kt3LZJUyr+3f0x3hmEihBx2XL81IUv9V862FjEKCtji/20S5V
	 f6ctTUAiCTqLRGSSZV4+20gsUMIfQJlht5d/OCZXplITCLMfaVfQhe221sIeBBjIGOVD2
	 pmsAVkpVeHR8YJkc8ZyASgQ51jmY5GZfbgByGtKTaKLoSFXxVhCr+rSyvhZyONgWUEnnl
	 v4F0+hpQSpzjyXDVodQhYmO/qmT3KUMySSeuNRlEbZYF8U/w8pI6yb4aENN9pxeCWbdfH
	 t8r0egDvCKHbx0l4piTjwmX2dF1+X/qA4pqLNEW1QnWQJ/saWYd0k3oiCaQRYsFWt+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645113;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6jHu8MSPTx1jnIvnQsZM+1cdDg60LkNbSscYEqgqwmc=;
	b=eZrTG5SF/6ueWv48Uh36uzYeFnpNTcEK4+l+BTagt5SHO5XmxSmVe8SzGllJxhUe6HGO
	 NprYA+psSNXv3zV5s3jgRRsrA19vCAjh36jrB0QibKwjoZtTU2hwyKhg6e1DOqJx1d1Oy
	 c2AMAgXzk+J0rSPfwZ3/lgMd6anZlXZ2H+ndIDXQfVZTWNB+8XD1TKX+VikjMruYDq6Ui
	 wviNtpaYYQcd1shNcwtr6z+1dqTtaska3dv58IBobWB8btLqPKv5bMElcPTQ3ntSQuPyy
	 JF59yxSupnTqWsrSx6bGUq5PalKxW8mkT3kIIYYH1z4g3mPJRIKIKmXY++9PESmhMRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wvf99S6W;
	arc=none smtp.remote-ip=91.218.175.1
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF32F606A32E
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 08:31:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF32F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=wvf99S6W
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=btZU4WnrDgjnYlK4jJf6U3d+M+E9lQkyrXoyzHbzoM0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794645109; v=1; x=1795249909;
 b=wvf99S6W7CzbYOJ2nj3Ugk6LPBKW5jAlpwfth5foGFuooDjc5KLxELSoRuiDVgGwoNHoC3eK
 47mOx/gN70cki4WD88aKGWq6mhr0n3SN0nfpdDF43uOrzidFVdCVH1XGj12KsEYiFnm06UGz/Ef
 b393/BneqxsOlXlqY2hzENB4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c847cde1edbcd669;
	Sat, 14 Nov 2026 08:31:49 +0000
X-Mizu-Trace-ID: c847cde1edbcd669
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
Subject: [PATCH v5 02/12] cpuset: introduce partition_disable()
Date: Sat, 14 Nov 2026 16:31:14 +0800
Message-Id: <20261114083124.1340140-3-ridong.chen@linux.dev>
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

Add partition_disable() to consolidate updates to key cpuset structures
during partition disablement, including:
1. remote_partition
2. effective_xcpus
3. partition_root_state
4. prs_err

Key operations performed:
1. Cleaning up remote_partition
2. Removing exclusive CPUs via partition_xcpus_del()
3. Recomputing effective exclusive CPUs mask
4. Updating partition state and error status
5. Triggering required scheduler domain rebuilds
6. Sending partition change notifications
7. Propagating the change of the parent's effective_cpus

Only the CPUs actually granted by the parent are given back, as the
parent may have shrunk. An invalid partition, or a partition under an
invalid parent, has already given back its exclusive CPUs, so there is
nothing to delete. A remote partition gets its CPUs from top_cpuset,
which owns all the CPUs.

The parent is derived from @cs, top_cpuset for a remote partition.
When a valid partition gives back its CPUs, the change of the parent's
effective_cpus is propagated to the tasks of the parent and to its
other children. A member or an invalid partition only has its state
updated, so that all the callers can call partition_disable()
directly.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 66 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 860cb7ea3efb..12bdcaeb8ae5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1758,6 +1758,72 @@ static void __maybe_unused partition_enable(struct cpuset *cs, struct cpuset *pa
 	notify_partition_change(cs, old_prs);
 }
 
+/**
+ * partition_disable - Disable partition root state for a cpuset
+ * @cs: The cpuset to disable partition for
+ * @new_prs: New partition root state (should be non-positive)
+ * @prs_err: Error code to set if disabling due to validation failure
+ * @tmp: Temporary masks
+ *
+ * A valid partition gives its CPUs back to its parent, or to top_cpuset
+ * for a remote partition, and the change is propagated to the tasks and
+ * the other children of the parent. A member or an invalid partition only
+ * has its state updated. A valid partition under an invalid parent has
+ * already given back its CPUs, so only the propagation is done.
+ */
+static void __maybe_unused partition_disable(struct cpuset *cs, int new_prs,
+					     enum prs_errcode prs_err,
+					     struct tmpmasks *tmp)
+{
+	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
+	int old_prs = cs->partition_root_state;
+
+	lockdep_assert_cpuset_lock_held();
+	WARN_ON_ONCE(new_prs > 0);
+	WARN_ON_ONCE(!cpuset_v2());
+	/*
+	 * When a CPU is offlined, top_cpuset may end up with no available CPUs,
+	 * which should clear subpartitions_cpus. We should not emit a warning for this
+	 * scenario: the hierarchy is updated from top to bottom, so subpartitions_cpus
+	 * may already be cleared when disabling a remote partition.
+	 */
+	if (!parent)
+		WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) &&
+			     !cpumask_empty(subpartitions_cpus));
+
+	spin_lock_irq(&callback_lock);
+	cs->remote_partition = false;
+	/*
+	 * Disabling a partition should only delete exclusive CPUs, and only
+	 * those actually granted by the parent as the parent may have shrunk.
+	 * An invalid partition or an invalid parent has already given back
+	 * its exclusive CPUs, there is nothing to delete. A remote partition
+	 * gets its CPUs from top_cpuset which owns all the CPUs.
+	 */
+	if (is_partition_valid(cs) && (!parent || is_partition_valid(parent))) {
+		if (parent)
+			cpumask_and(cs->effective_xcpus, cs->effective_xcpus,
+				    parent->effective_xcpus);
+		partition_xcpus_del(old_prs, parent, cs->effective_xcpus);
+	}
+	/* effective_xcpus may need to be changed */
+	compute_excpus(cs, cs->effective_xcpus);
+	partition_state_update(cs, new_prs, prs_err);
+	spin_unlock_irq(&callback_lock);
+	cpuset_force_rebuild();
+	notify_partition_change(cs, old_prs);
+
+	/* A member or an invalid partition owns no CPU, nothing to propagate */
+	if (old_prs <= 0)
+		return;
+
+	/* Propagate changes in the parent's effective_cpus down the hierarchy */
+	if (!parent)
+		parent = &top_cpuset;
+	cpuset_update_tasks_cpumask(parent, tmp->new_cpus);
+	update_sibling_cpumasks(parent, cs, tmp);
+}
+
 /*
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
-- 
2.34.1

