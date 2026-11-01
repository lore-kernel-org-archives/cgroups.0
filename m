Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533489;
	b=141LR1ebHKgWBQGta1ronnwAIz68BWx6C2gv0rExw3OKfUCZol1wYrFjpgUEm/kSjD10
	 1QsAemMEbBLbiryauFoDYYAqythc9NIRG7RYkesz2E+kZmYoyIlFqsedoxeSnUlw8U01P
	 4qx3JznJrmO964vk0KR1mXifLZH2DOYdwYiGPovN4OLEZ35ypLzBfmUl/XdwqHnjeHxbY
	 sXlhiftDjZbNZqJMURUQ8oi+v3FrWrFajV/f1U9HLVZS2tpQvYpFeFn5vmxigXkVhwse5
	 L+XqRP2GtzkpfXAaefqHLue+p8wTjdVLGGmZdr8j8QwlNxnQS2Ruy1eDL/49fVtZIZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533489;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=iqwwcy52VO5DZGBLLQ3hXkLYL2mE2/lsqfCFZoXvqEs=;
	b=z5EDcp+kn6XRKrHUXp64WKVPf2+eJuWWSNwu4VzD/rvRkbCBI3rEYhK+2PEtcNV3i8Rd
	 hUhZGSvYfTORgT4mhMzyBdlu6Ebj5jGNJhcB+B2sEMH1K7LPwaiGogxDgEI1ERUU6vls6
	 rWUEuJ6yq4vBJlvCcnUmp05NXsfq4Ih5tEdulX6nn6nvonnXJ6Be2ozCLccCmwhgZz48A
	 2oKo6/wD6K2hixE9bceZYnkQiSq8+5MdVKWUAqnum9GykMKz4zfYFNY5tmy0zoo1PM9ID
	 NIvcb08WrBgtKYlykHGZjfM+4RFsJrc245aRKVL5N7E5froSW1uBVj07CFc0wfYWhlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t2DWzzhc;
	arc=none smtp.remote-ip=91.218.175.131
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F13606A326
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:44:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12F13606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t2DWzzhc
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ILvCOnm6sZIe7jHPsMN2rND8Zblf82VDQt6Vsn3VCoo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533486; v=1; x=1794138286;
 b=t2DWzzhcADOv6QhwnCIiFKw//OTrS87m8cFJoxgPJtFm8GIzkaX9+l9T5Wvn4EtK10DzkUIV
 l7NDO0rLwTeuJHEFVh3GcqT59wAEq5c2PFmu9euru4k4fo5eyxGpnsiNPl2ihfdMmgMrrLh+H2e
 qaxAt58OkKgAdRIrgrUlACsM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 219c12c4e3c1b043;
	Sun, 01 Nov 2026 11:44:46 +0000
X-Mizu-Trace-ID: 219c12c4e3c1b043
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
Subject: [RFC PATCH -v4 18/22] cpuset: use validate_local_partition in local_partition_enable
Date: Sun,  1 Nov 2026 19:42:02 +0800
Message-Id: <20261101114206.2434398-19-ridong.chen@linux.dev>
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

Replace the partition error checks within local_partition_enable() by
utilizing the common validate_local_partition() function.

As validate_local_partition() already rejects a root partition under an
isolated parent, the PERR_ISOPARENT check in update_prstate() is no
longer needed and is removed.

validate_local_partition() and is_user_xcpus_exclusive() are moved
before local_partition_enable() without change.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 131 ++++++++++++++++++-----------------------
 1 file changed, 56 insertions(+), 75 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index af42666d4530..ecb7fd378a3f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1978,6 +1978,61 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	remote_partition_disable(cs, tmp);
 }
 
+static bool is_user_xcpus_exclusive(struct cpuset *cs)
+{
+	struct cpuset *parent = parent_cs(cs);
+	struct cgroup_subsys_state *css;
+	struct cpuset *child;
+	bool exclusive = true;
+
+	rcu_read_lock();
+	cpuset_for_each_child(child, css, parent) {
+		if (child == cs)
+			continue;
+		if (!cpusets_are_exclusive(cs, child)) {
+			exclusive = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return exclusive;
+}
+
+/**
+ * validate_local_partition - Validate for local partition
+ * @cs: Target cpuset to validate
+ * @new_prs: New partition root state to validate
+ * @excpus: New effective exclusive CPUs mask to validate
+ * @excl_check: Flag to enable exclusive CPUs ownership validation
+ * @tmp: Temporary masks
+ *
+ * Return: PERR_NONE if validation passes, appropriate error code otherwise
+ *
+ * Important: The caller must ensure that @cs's cpu mask is updated before
+ * invoking this function when exclusive CPU validation is required.
+ */
+static enum prs_errcode validate_local_partition(struct cpuset *cs, int new_prs,
+			struct cpumask *excpus, bool excl_check, struct tmpmasks *tmp)
+{
+	struct cpuset *parent = parent_cs(cs);
+
+	/* The parent must be a partition root */
+	if (!is_partition_valid(parent)) {
+		return is_partition_invalid(parent)
+			? PERR_INVPARENT : PERR_NOTPART;
+	}
+
+	/* A root partition is not allowed under an isolated parent */
+	if (new_prs == PRS_ROOT && parent->partition_root_state == PRS_ISOLATED)
+		return PERR_ISOPARENT;
+
+	if (excl_check && !is_user_xcpus_exclusive(cs))
+		return PERR_NOTEXCL;
+
+	return validate_partition(cs, parent, new_prs, excpus,
+				  tmp ? tmp->delmask : NULL);
+}
+
 /**
  * local_partition_enable - Enable local partition for a cpuset
  * @cs: Target cpuset to become a local partition root
@@ -1995,18 +2050,8 @@ static int local_partition_enable(struct cpuset *cs,
 	lockdep_assert_cpuset_lock_held();
 	WARN_ON_ONCE(is_remote_partition(cs));	/* For local partition only */
 
-	/*
-	 * The parent must be a partition root.
-	 * The new cpumask, if present, or the current cpus_allowed must
-	 * not be empty.
-	 */
-	if (!is_partition_valid(parent)) {
-		return is_partition_invalid(parent)
-		       ? PERR_INVPARENT : PERR_NOTPART;
-	}
-
 	compute_excpus(cs, tmp->new_cpus);
-	err = validate_partition(cs, parent, new_prs, tmp->new_cpus, NULL);
+	err = validate_local_partition(cs, new_prs, tmp->new_cpus, false, NULL);
 	if (err)
 		return err;
 
@@ -2054,61 +2099,6 @@ static void local_partition_disable(struct cpuset *cs, enum prs_errcode part_err
 	update_sibling_cpumasks(parent, cs, tmp);
 }
 
-static bool is_user_xcpus_exclusive(struct cpuset *cs)
-{
-	struct cpuset *parent = parent_cs(cs);
-	struct cgroup_subsys_state *css;
-	struct cpuset *child;
-	bool exclusive = true;
-
-	rcu_read_lock();
-	cpuset_for_each_child(child, css, parent) {
-		if (child == cs)
-			continue;
-		if (!cpusets_are_exclusive(cs, child)) {
-			exclusive = false;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return exclusive;
-}
-
-/**
- * validate_local_partition - Validate for local partition
- * @cs: Target cpuset to validate
- * @new_prs: New partition root state to validate
- * @excpus: New effective exclusive CPUs mask to validate
- * @excl_check: Flag to enable exclusive CPUs ownership validation
- * @tmp: Temporary masks
- *
- * Return: PERR_NONE if validation passes, appropriate error code otherwise
- *
- * Important: The caller must ensure that @cs's cpu mask is updated before
- * invoking this function when exclusive CPU validation is required.
- */
-static enum prs_errcode validate_local_partition(struct cpuset *cs, int new_prs,
-			struct cpumask *excpus, bool excl_check, struct tmpmasks *tmp)
-{
-	struct cpuset *parent = parent_cs(cs);
-
-	/* The parent must be a partition root */
-	if (!is_partition_valid(parent)) {
-		return is_partition_invalid(parent)
-			? PERR_INVPARENT : PERR_NOTPART;
-	}
-
-	/* A root partition is not allowed under an isolated parent */
-	if (new_prs == PRS_ROOT && parent->partition_root_state == PRS_ISOLATED)
-		return PERR_ISOPARENT;
-
-	if (excl_check && !is_user_xcpus_exclusive(cs))
-		return PERR_NOTEXCL;
-
-	return validate_partition(cs, parent, new_prs, excpus,
-				  tmp ? tmp->delmask : NULL);
-}
-
 /**
  * __local_partition_update - Update local partition configuration
  * @cs: Target cpuset to update
@@ -2918,7 +2908,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	int err = PERR_NONE, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
-	int parent_prs = parent->partition_root_state;
 	bool isolcpus_updated = false;
 	bool disable_partition = false;
 
@@ -2961,14 +2950,6 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * Otherwise, enable a remote partition.
 		 */
 		if (is_partition_valid(parent)) {
-			/*
-			 * It is not allowed to create a root partition under
-			 * an isolated parent partition.
-			 */
-			if ((new_prs == PRS_ROOT) && (parent_prs == PRS_ISOLATED)) {
-				err = PERR_ISOPARENT;
-				goto out;
-			}
 			err = local_partition_enable(cs, new_prs, &tmpmask);
 		} else {
 			err = remote_partition_enable(cs, new_prs, &tmpmask);
-- 
2.34.1

