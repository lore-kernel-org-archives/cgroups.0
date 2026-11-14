Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794645137;
	b=XP8faMfpRvy1e1leP17sb6WzUDSN+ik6zCDq7/1Vg0of8JcHOXh1F3wSQ2G/b7sqYz8z
	 NgYd3C9K7QUK6LtE+Jeq4/dGxIlimXAGuqEU3jg5L43wIIytnmPA0Pb+2+a+4WIdLxjpQ
	 RcIL9k9QdlH1KiVKSRck4Nhmxlyc4UpK7LoZhJagboUhHMEGNOD6/GR/rch0580CAdgC1
	 muZ2ATdhe/GhIDVO5p2+Ppwk4kwLRqNudPCtsImrzgLUnvy4YrT01PzxLMu1Nr81RAvm9
	 h7hctWmqKnA470ff8vaqM3OSJ+u6e/5LgYRg7QbYy7AIb4tojWsyv6dMkiaApWfli/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645137;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gtb2s/M0SUfyMHwHNm+sD/xnx2KvSYwludBmFJ2dhUk=;
	b=1fnqj64WHTAFu7bxR23t13xadBHKVooaBSxdCXA8JWItS08pXJ8wTrOMnhCCV2PtFaDU
	 YTWbuboapnSyKuhOAnGoXITiGY/iwp0QrsR71oHzfR3wm4s9rL9OI/VZuy+ipYGAzSD0q
	 v6iJEohAz503Kdv98JcZGuE2BMju+eac8ZNGm2s4mVXplaKGElRsTskW47FESqOW7QgA3
	 SBCLN+6pY17PRc9oeobVVGxNu4k6OTOYPLrwHsBNkZBJUHl5utALN7GnU3I9PL6FaN4fE
	 dSbWLAc1TTtFxwuU6betGyR/ZrlDqgEW6GSumPsCahNEul+qqP483w6jtxBRa9ei68g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k1JAEl0Z;
	arc=none smtp.remote-ip=91.218.175.19
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D543606A8AE
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 08:32:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D543606A8AE
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k1JAEl0Z
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mkNIcFfKwLIZWCoobMMHj/Wg4RJNMEmLwIFPcFFstq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794645134; v=1; x=1795249934;
 b=k1JAEl0ZW1ojPPCoB+2P8DbY0DcTutEDSQppPqK8x9dwFNanzhXoUHEZHz1PHiZgfCG8MwWj
 d6k8m2x2CF8OcPZqYBgY1iCdg5IsSFKf2LWUUjG4veWJqf7KIZNpzP/QwySIVD1/GSHiSHbqjyS
 ifYbc3U7kulD+ABrSGHtWvUA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8cc6af9eb55f9eef;
	Sat, 14 Nov 2026 08:32:14 +0000
X-Mizu-Trace-ID: 8cc6af9eb55f9eef
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
Subject: [PATCH v5 08/12] cpuset: introduce local_partition_enable()
Date: Sat, 14 Nov 2026 16:31:20 +0800
Message-Id: <20261114083124.1340140-9-ridong.chen@linux.dev>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

Factor the local partition enablement out of
update_parent_effective_cpumask() into local_partition_enable(). It
computes the effective exclusive CPUs of the cpuset, validates them
with validate_local_partition() and then calls partition_enable() to
set up the partition, the same way as remote_partition_enable() does
for a remote partition.

As validate_local_partition() already rejects a root partition under an
isolated parent, the PERR_ISOPARENT check in update_prstate() is no
longer needed and is removed.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 84 +++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 38 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 78ca3c39c029..45605c6ab6a2 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2016,10 +2016,9 @@ static bool is_user_xcpus_exclusive(struct cpuset *cs)
  * Important: The caller must ensure that @cs's cpu mask is updated before
  * invoking this function when exclusive CPU validation is required.
  */
-static enum prs_errcode __maybe_unused
-validate_local_partition(struct cpuset *cs, int new_prs,
-			 struct cpumask *excpus, bool excl_check,
-			 struct tmpmasks *tmp)
+static enum prs_errcode validate_local_partition(struct cpuset *cs, int new_prs,
+						 struct cpumask *excpus, bool excl_check,
+						 struct tmpmasks *tmp)
 {
 	struct cpuset *parent = parent_cs(cs);
 
@@ -2044,6 +2043,47 @@ validate_local_partition(struct cpuset *cs, int new_prs,
 				  tmp ? tmp->delmask : NULL);
 }
 
+/**
+ * local_partition_enable - Enable local partition for a cpuset
+ * @cs: Target cpuset to become a local partition root
+ * @new_prs: New partition root state to apply
+ * @tmp: Temporary masks for CPU calculations
+ *
+ * Return: 0 on success, error code on failure
+ */
+static int local_partition_enable(struct cpuset *cs,
+				  int new_prs, struct tmpmasks *tmp)
+{
+	struct cpuset *parent = parent_cs(cs);
+	enum prs_errcode err;
+
+	lockdep_assert_cpuset_lock_held();
+	WARN_ON_ONCE(is_remote_partition(cs));	/* For local partition only */
+
+	compute_excpus(cs, tmp->new_cpus);
+	err = validate_local_partition(cs, new_prs, tmp->new_cpus, false, NULL);
+	if (err)
+		return err;
+
+	/*
+	 * This function will only be called when all the preliminary
+	 * checks have passed. At this point, the following condition
+	 * should hold.
+	 *
+	 * (new effective_xcpus & cpu_active_mask) ⊆ parent->effective_cpus
+	 *
+	 * Warn if it is not the case.
+	 */
+	cpumask_and(tmp->addmask, tmp->new_cpus, cpu_active_mask);
+	WARN_ON_ONCE(!cpumask_subset(tmp->addmask, parent->effective_cpus));
+
+	partition_enable(cs, parent, new_prs, tmp->new_cpus);
+
+	cpuset_update_tasks_cpumask(parent, tmp->addmask);
+	update_sibling_cpumasks(parent, cs, tmp);
+	return 0;
+}
+
 /**
  * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state
@@ -2142,27 +2182,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
 	}
 
-	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
-		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
-
-		part_error = validate_partition(cs, parent, new_prs,
-						tmp->delmask, NULL);
-		if (part_error)
-			return part_error;
-
-		/*
-		 * This function will only be called when all the preliminary
-		 * checks have passed. At this point, the following condition
-		 * should hold.
-		 *
-		 * (cs->effective_xcpus & cpu_active_mask) ⊆ parent->effective_cpus
-		 *
-		 * Warn if it is not the case.
-		 */
-		cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
-		WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
-		deleting = true;
-	} else if (cmd == partcmd_disable) {
+	if (cmd == partcmd_disable) {
 		/*
 		 * May need to add cpus back to parent's effective_cpus
 		 * (and maybe removed from subpartitions_cpus/isolated_cpus)
@@ -3112,7 +3132,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	int err = PERR_NONE, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
-	int parent_prs = parent->partition_root_state;
 	bool isolcpus_updated = false;
 	bool disable_partition = false;
 
@@ -3155,18 +3174,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * Otherwise, enable a remote partition.
 		 */
 		if (is_partition_valid(parent)) {
-			enum partition_cmd cmd = (new_prs == PRS_ROOT)
-					       ? partcmd_enable : partcmd_enablei;
-
-			/*
-			 * It is not allowed to create a root partition under
-			 * an isolated parent partition.
-			 */
-			if ((new_prs == PRS_ROOT) && (parent_prs == PRS_ISOLATED)) {
-				err = PERR_ISOPARENT;
-				goto out;
-			}
-			err = update_parent_effective_cpumask(cs, cmd, NULL, &tmpmask);
+			err = local_partition_enable(cs, new_prs, &tmpmask);
 		} else {
 			err = remote_partition_enable(cs, new_prs, &tmpmask);
 		}
-- 
2.34.1

