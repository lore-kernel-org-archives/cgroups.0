Received: from mta1.migadu.com (out-41.mta1.migadu.com [95.215.58.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4383515D6
	for <cgroups@vger.kernel.org>; Tue, 29 Sep 2026 02:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649505; cv=none; b=Sl9SkIjnDVMY9F5+RdeBJyhASHs+nq9uzpPOJtGEcbB43MHULf4xQWryX0Tu63LCH7yDPD+T2Yqvg2pi3b3kNG+HFwsgiyzbpM9qQEa7WSVuGtVCyG1j4wZ9Nfy72PB+u5tv3iLso5l2oDsVSZz3t8rmux9QWgq1E03dlupSeTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649505; c=relaxed/simple;
	bh=k6wnEFuT8qEx1llxgfw3F4pluHv6u4ZLjGzllNl5pVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pCNUKoQd5sDhiV7hKCemHwCqhniz4UuE2PyqpoJMRl0wCB7zEBYokybpaknMlCP7KxLtOdF7rPQf0aI4taN+DzMyWXrPeypNfXSMxWAOf8nMUY91IHg1RldVHAPzCU4JcJQQuBoUBfp17J0P8P3tfS4z+NUNpFtPABsx+4ZH9Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LTXvqZDt; arc=none smtp.client-ip=95.215.58.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LTXvqZDt"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=k6wnEFuT8qEx1llxgfw3F4pluHv6u4ZLjGzllNl5pVw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790649501; v=1; x=1791254301;
 b=LTXvqZDtakxqK8K8vlcHd7epv4GaYnv+SxkB8PSVBbVh/aphNaVP46EicrVbfPrJsPgaAzFF
 KW+CLbVCN07/UdslevanuhatyRRZNEGA5/7scyLE1Nn9PNR18Clug2Nscy3Sp7yW/kXxRFQePE0
 4LhCpx5ZXWi0LQO0rUFAQ7vM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ffc67f00d9d56710;
	Tue, 29 Sep 2026 02:38:21 +0000
X-Mizu-Trace-ID: ffc67f00d9d56710
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v3] cgroup/cpuset: Invalidate remote partition on housekeeping conflict
Date: Tue, 29 Sep 2026 10:38:05 +0800
Message-ID: <20260929023805.31648-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Widening an ancestor's exclusive CPU mask can add a boot-isolated CPU
to a valid remote partition root without touching the partition's own
control files. The partition then load balances that CPU, silently
defeating isolcpus=domain for it.

This can be reproduced on a 32-CPU system booted with
isolcpus=domain,4:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir -p A/B
    echo +cpuset > A/cgroup.subtree_control
    echo 2-4 > A/cpuset.cpus
    echo 2-3 > A/cpuset.cpus.exclusive
    echo 2-4 > A/B/cpuset.cpus
    echo 2-4 > A/B/cpuset.cpus.exclusive
    echo root > A/B/cpuset.cpus.partition
    cat A/B/cpuset.cpus.effective               # 2-3
    echo 2-4 > A/cpuset.cpus.exclusive
    cat A/B/cpuset.cpus.partition               # root
    cat A/B/cpuset.cpus.effective               # 2-4

The last write returns 0 and leaves the hierarchy in this state:

    root (cpuset.cpus.effective=0-1,5-31)
    |
    \-- A (member):           cpuset.cpus=2-4
        |                     cpuset.cpus.exclusive=2-4
        \-- B (root, remote): cpuset.cpus=2-4
                              cpuset.cpus.effective=2-4

B is a remote partition: it takes its CPUs directly from the root
cpuset, and A only passes its exclusive list down. Before the last
write, that list is 2-3, so B holds 2-3 and CPU 4 stays in the
root cpuset as a boot-isolated CPU. The write widens A's exclusive
list to 2-4, which additionally grants CPU 4 to B. Nothing rejects
the grant: B remains a valid root partition, and CPU 4 is still
listed in cpuset.cpus.isolated while sitting in a load-balanced
partition.

remote_partition_enable() already rejects such grants through
prstate_housekeeping_conflict(). remote_cpus_update(), which applies
ancestor changes to a remote partition, does not.

Both paths also open-code remote partition validation. Move those
checks into validate_remote_partition(), and check the resulting
effective exclusive CPU mask for a housekeeping conflict there. The
existing prs_err path then invalidates the remote partition instead of
assigning it a boot-isolated CPU.

Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Suggested-by: Ridong Chen <ridong.chen@linux.dev>
Suggested-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---

Changes since v2:
- Pass the enable/update mode explicitly to validate_remote_partition()
  instead of deriving it from cs->remote_partition, which can remain set
  after a failed partition state transition, as suggested by Tejun.

Changes since v1:
- Consolidate remote partition validation in a common helper, as
  suggested by Ridong.
- Check housekeeping conflicts against the resulting effective exclusive
  CPU mask.
- Rebase onto cgroup/for-7.3-fixes.

 kernel/cgroup/cpuset.c | 69 ++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1fcec89a28b9..d0a45241c070 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1561,6 +1561,43 @@ static inline bool is_local_partition(struct cpuset *cs)
 	return is_partition_valid(cs) && !is_remote_partition(cs);
 }
 
+/**
+ * validate_remote_partition - Validate a remote partition CPU change
+ * @prs: partition root state to validate
+ * @updating: true for an update, false for an enable
+ * @excpus: resulting effective exclusive CPU mask
+ * @addcpus: exclusive CPUs to be added
+ * @delcpus: exclusive CPUs to be deleted, can be NULL
+ *
+ * Return: PERR_NONE if valid, otherwise an appropriate error code
+ */
+static enum prs_errcode
+validate_remote_partition(int prs, bool updating,
+			  struct cpumask *excpus,
+			  struct cpumask *addcpus,
+			  struct cpumask *delcpus)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return PERR_ACCESS;
+
+	if (!updating &&
+	    (!cpumask_intersects(excpus, cpu_active_mask) ||
+	     cpumask_subset(top_cpuset.effective_cpus, addcpus)))
+		return PERR_INVCPUS;
+
+	if (cpumask_intersects(addcpus, subpartitions_cpus) ||
+	    (updating &&
+	     cpumask_subset(top_cpuset.effective_cpus, addcpus)))
+		return PERR_NOCPUS;
+
+	if ((prs == PRS_ISOLATED &&
+	     !isolated_cpus_can_update(addcpus, delcpus)) ||
+	    prstate_housekeeping_conflict(prs, excpus))
+		return PERR_HKEEPING;
+
+	return PERR_NONE;
+}
+
 /*
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
@@ -1574,11 +1611,7 @@ static inline bool is_local_partition(struct cpuset *cs)
 static int remote_partition_enable(struct cpuset *cs, int new_prs,
 				   struct tmpmasks *tmp)
 {
-	/*
-	 * The user must have sysadmin privilege.
-	 */
-	if (!capable(CAP_SYS_ADMIN))
-		return PERR_ACCESS;
+	enum prs_errcode err;
 
 	/*
 	 * The requested exclusive_cpus must not be allocated to other
@@ -1591,15 +1624,10 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	 * above it or remote partition root underneath it is not allowed.
 	 */
 	compute_excpus(cs, tmp->new_cpus);
-	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
-	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
-		return PERR_INVCPUS;
-	if (cpumask_intersects(tmp->new_cpus, subpartitions_cpus))
-		return PERR_NOCPUS;
-	if (((new_prs == PRS_ISOLATED) &&
-	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
-	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
-		return PERR_HKEEPING;
+	err = validate_remote_partition(new_prs, false, tmp->new_cpus,
+					tmp->new_cpus, NULL);
+	if (err)
+		return err;
 
 	spin_lock_irq(&callback_lock);
 	partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
@@ -1672,6 +1700,7 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			       struct cpumask *excpus, struct tmpmasks *tmp)
 {
+	enum prs_errcode err;
 	bool adding, deleting;
 	int prs = cs->partition_root_state;
 
@@ -1695,14 +1724,10 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	 */
 	if (adding) {
 		WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
-		if (!capable(CAP_SYS_ADMIN))
-			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
-		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
-			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
-			WRITE_ONCE(cs->prs_err, PERR_NOCPUS);
-		else if ((prs == PRS_ISOLATED) &&
-			 !isolated_cpus_can_update(tmp->addmask, tmp->delmask))
-			WRITE_ONCE(cs->prs_err, PERR_HKEEPING);
+		err = validate_remote_partition(prs, true, excpus, tmp->addmask,
+						tmp->delmask);
+		if (err)
+			WRITE_ONCE(cs->prs_err, err);
 		if (cs->prs_err)
 			goto invalidate;
 	}

base-commit: 31c88350b7dd1522792f726f79607f31bb55c50f
-- 
2.43.0

