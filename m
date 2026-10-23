Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785657;
	b=Erm6yhJnNtylngwYXrLfc1oGOEr2QaPvVXeCIhvWdxTeryibprY+bf0twp7i+0svX+DN
	 hHcDM3cNGvK/VhoeaBo3pgx7zeEx1BSj8CIlDmVOjB2CBFCahDJA6JDFTG80RoisiyFJ0
	 upcBBXcy1OCugD8a/IjDgmcfmD9F9UfdzNIF+RUKBKXPdWPNv3HDchgWVfYs7MmHKyD1+
	 nNdGS34/ug4Qbt+0tqX2QykVTy997uevTl1CA9/86jLeDTKYRSoaWvDozwOmU782r96S2
	 ljloQ6l6JeYUFXNDOq/JXZCbFN6HcEW8mAXDdDHBwyvVXD5uc89/8CZViQDW6Td+r8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785657;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=aDog0cwFprcmOhBqY1U+Au/ledekVgUgovHWk46fOl8=;
	b=tqoMbPyhNZ4MSrOQsGze46D/0olgjKtodk/cg/YZsUPQfO4FFwyE2Sf2WO48OzmdR9Nz
	 FEUZ1WEyrUe1ZPGfMQijh+ACEZfg/957H5a8hKFr2Uh4bwOJGFY7sHGF+HjWqzfB+56x6
	 BabHkASr5yLZqHM1Olk5B39CqwsFPssQsOzViwOpv5ukc2dn5EYmEce5/RytLTp3qIwFQ
	 2onDLcrygTTeHOURnIWlHCKWlL+iwdYkYg8+1wI6AUjswK1+xR+LD4M3qKG3/Fe10rLDI
	 4dcKXLyTo+cTm9m2yWsd8Z6iJTlPz0B73kCz+oW0Gp4nfEEfaePsZqWUk0JBUUnyPcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aBTNiaKC;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C7A606A32E
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 20:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12C7A606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aBTNiaKC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792785656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aDog0cwFprcmOhBqY1U+Au/ledekVgUgovHWk46fOl8=;
	b=aBTNiaKClnZl8Jd89aLn4Qq7Cb3qUzGA1RuxKGrTRvDF9Tcb1PVabEoNjNXCNVrXWXOzDz
	zSoWxz40ai2k/u3fnk1RW/gWEaq61TnMFzn59fUkP9kJLoox5P+Z7O7Faqt+yml3nHwOYw
	0Pkc1vfMbSsqsXvXGhB4Sfnd6LCNM4U=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589--75bblV7PDe_Zy4h5h1kZQ-1; Fri,
 23 Oct 2026 16:00:53 -0400
X-MC-Unique: -75bblV7PDe_Zy4h5h1kZQ-1
X-Mimecast-MFC-AGG-ID: -75bblV7PDe_Zy4h5h1kZQ_1792785651
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41D351955DE9;
	Fri, 23 Oct 2026 20:00:51 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC06F1955F0A;
	Fri, 23 Oct 2026 20:00:49 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v2 02/10] cgroup/cpuset: Properly compute effective xcpus in update_parent_effective_cpumask()
Date: Fri, 23 Oct 2026 16:00:28 -0400
Message-ID: <20261023200036.60560-3-longman@redhat.com>
In-Reply-To: <20261023200036.60560-1-longman@redhat.com>
References: <20261023200036.60560-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Since the introduction of cpuset.cpus.exclusive in commit
e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2"), a
compute_effective_exclusive_cpumask() helper which is later renamed to
compute_excpus() is added to compute the effective xcpus of a partition
root. However update_parent_effective_cpumask() is not updated in all
proper places to use the new helper to check if a given cpuset should
remain a valid partition root. This can cause a cpuset to incorrectly
remain a valid partition root even if no effective xcpus is left.

Fix that problem by using compute_excpus() to compute the effective xcpus
into delmask in all cases except partcmd_disable, partcmd_invalidate
or partcmd_update with newmask set and use it for tasks_nocpu_error()
check as well as checking its emptiness. This enables us to catch invalid
partition root more accurately in update_parent_effective_cpumask().

In the case of partcmd_update with newmask set, the passed in new
effective xcpus value will directly be used in the tasks_nocpu_error()
check without relying on old data in the cpuset.

Some test case are added to test_cpuset_prs.sh for invalidating a
partition root due to its effective xcpus becoming empty as well as
making sure that an invalid partition can only be revived when exclusive
CPUs are available agin.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                        | 59 +++++++++----------
 .../selftests/cgroup/test_cpuset_prs.sh       | 11 ++++
 2 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1ca548cd50fd..06b8a67cbd3d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1756,7 +1756,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
  * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state
  * @cmd:     Partition root state change command
- * @newmask: Optional new cpumask for partcmd_update
+ * @newmask: Optional new effective xcpus for partcmd_update
  * @tmp:     Temporary addmask and delmask
  * Return:   0 or a partition root state error code
  *
@@ -1771,11 +1771,11 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
  * given back to parent's effective_cpus. 0 will always be returned.
  *
  * For partcmd_update, if the optional newmask is specified, the cpu list is
- * to be changed from effective_xcpus to newmask. Otherwise, effective_xcpus is
- * assumed to remain the same. The cpuset should either be a valid or invalid
- * partition root. The partition root state may change from valid to invalid
- * or vice versa. An error code will be returned if transitioning from
- * invalid to valid violates the exclusivity rule.
+ * to be changed from effective_xcpus to newmask. Otherwise, effective_xcpus
+ * will be computed and a valid partition will be invalidated if it is the new
+ * cpumask is empty. The cpuset should either be a valid or invalid partition
+ * root. The partition root state may change from valid to invalid or vice
+ * versa.
  *
  * For partcmd_invalidate, the current partition will be made invalid.
  *
@@ -1798,7 +1798,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	int deleting;	/* Deleting cpus from parent's effective_cpus	*/
 	int old_prs, new_prs;
 	int part_error = PERR_NONE;	/* Partition error? */
-	struct cpumask *xcpus = user_xcpus(cs);
 	int parent_prs = parent->partition_root_state;
 	bool nocpu;
 
@@ -1841,30 +1840,30 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	if (!newmask && xcpus_empty(cs))
 		return PERR_CPUSEMPTY;
 
-	nocpu = tasks_nocpu_error(parent, cs, xcpus);
+	/*
+	 * Except for partcmd_disable and non-NULL newmask, use delmask
+	 * to compute the current effective xcpus value and use it for
+	 * tasks_nocpu_error check.
+	 */
+	if ((cmd != partcmd_disable) && !newmask) {
+		compute_excpus(cs, tmp->delmask);
+		nocpu = tasks_nocpu_error(parent, cs, tmp->delmask);
+	}
 
 	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
-		/*
-		 * Need to call compute_excpus() in case
-		 * exclusive_cpus not set. Sibling conflict should only happen
-		 * if exclusive_cpus isn't set.
-		 */
-		xcpus = tmp->delmask;
-		if (compute_excpus(cs, xcpus))
-			WARN_ON_ONCE(!cpumask_empty(cs->exclusive_cpus));
 		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
 
 		/*
 		 * Enabling partition root is not allowed if its
 		 * effective_xcpus is empty.
 		 */
-		if (cpumask_empty(xcpus))
+		if (cpumask_empty(tmp->delmask))
 			return PERR_INVCPUS;
 
-		if (prstate_housekeeping_conflict(new_prs, parent_prs, xcpus, NULL))
+		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
 			return PERR_HKEEPING;
 
-		if (tasks_nocpu_error(parent, cs, xcpus))
+		if (nocpu)
 			return PERR_NOCPUS;
 
 		/*
@@ -1876,16 +1875,14 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 *
 		 * Warn if it is not the case.
 		 */
-		cpumask_and(tmp->new_cpus, xcpus, cpu_active_mask);
+		cpumask_and(tmp->new_cpus, tmp->delmask, cpu_active_mask);
 		WARN_ON_ONCE(!cpumask_subset(tmp->new_cpus, parent->effective_cpus));
-
 		deleting = true;
 	} else if (cmd == partcmd_disable) {
 		/*
 		 * May need to add cpus back to parent's effective_cpus
 		 * (and maybe removed from subpartitions_cpus/isolated_cpus)
-		 * for valid partition root. xcpus may contain CPUs that
-		 * shouldn't be removed from the two global cpumasks.
+		 * for valid partition root.
 		 */
 		if (is_partition_valid(cs)) {
 			cpumask_copy(tmp->addmask, cs->effective_xcpus);
@@ -1905,8 +1902,8 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			goto write_error;
 		}
 
-		/* Check newmask again, whether cpus are available for parent/cs */
-		nocpu |= tasks_nocpu_error(parent, cs, newmask);
+		/* Check newmask whether cpus are available for parent/cs */
+		nocpu = tasks_nocpu_error(parent, cs, newmask);
 
 		/*
 		 * partcmd_update with newmask:
@@ -1961,7 +1958,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		/*
 		 * partcmd_update w/o newmask
 		 *
-		 * delmask = effective_xcpus & parent->effective_cpus
+		 * delmask = newly computed effective xcpus value
 		 *
 		 * This can be called from:
 		 * 1) update_cpumasks_hier()
@@ -1973,7 +1970,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 * A partition error happens when parent has tasks and all
 		 * its effective CPUs will have to be distributed out.
 		 */
-		if (nocpu) {
+		if (nocpu || cpumask_empty(tmp->delmask)) {
 			part_error = PERR_NOCPUS;
 			if (is_partition_valid(cs))
 				adding = cpumask_and(tmp->addmask,
@@ -1986,8 +1983,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 				cpumask_copy(tmp->addmask, cs->effective_xcpus);
 				adding = true;
 			}
-		} else if (is_partition_invalid(cs) && !cpumask_empty(xcpus) &&
-			   cpumask_subset(xcpus, parent->effective_xcpus)) {
+		} else if (is_partition_invalid(cs)) {
 			struct cgroup_subsys_state *css;
 			struct cpuset *child;
 			bool exclusive = true;
@@ -1998,7 +1994,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			 * check.
 			 */
 			if (prstate_housekeeping_conflict(cs->partition_root_state,
-							  parent_prs, xcpus, NULL)) {
+							  parent_prs, tmp->delmask, NULL)) {
 				part_error = PERR_HKEEPING;
 				goto write_error;
 			}
@@ -2013,8 +2009,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			}
 			rcu_read_unlock();
 			if (exclusive)
-				deleting = cpumask_and(tmp->delmask,
-						xcpus, parent->effective_cpus);
+				deleting = !cpumask_empty(tmp->delmask);
 			else
 				part_error = PERR_NOTEXCL;
 		}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index d04aad697b96..8bdda955b4a7 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -359,6 +359,8 @@ TEST_MATRIX=(
 								       A1:P0|A2:P1|A3:P2|B1:P1 2-4|3"
 	"  C1-6:P1 C3-6:P1 C5-6:P1 .      .      P2      .      .    0 A1:1-2|A2:3-6|A3:5-6 \
 								       A1:P1|A2:P2|A3:P-1 3-6"
+	"  C1-6:P2 C3-6:P2 C3-4:P2 .      .     C5-6     .      .    0 A1:1-4|A2:5-6|A3:5-6 \
+								       A1:P2|A2:P2|A3:P-2 1-6"
 	" C1-4:X2-4 C2-4:X3-4:P1 C3-4:X4:P2 \
 				   .      .      X5      .      .    0 A1:1-4|A2:2-4|A3:3-4 \
 								       A1:P0|A2:P-1|A3:P-2 ."
@@ -427,6 +429,10 @@ TEST_MATRIX=(
 	# cpuset.cpus is allowed, but those extra CPUs are ignored.
 	"  C2-3:P1   C3:P1  .      .      .     C2-4    .      .     0 A1:|A2:2-3 A1:P1|A2:P1"
 
+	# A child cannot recover until its exclusive CPUs are available again.
+	" CX1-4:P1 CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
+	" CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
+
 	# Taking away all CPUs from parent or itself if there are tasks
 	# will make the partition invalid.
 	"  C2-3:P1   C3:P1  .      .      T     C2-3    .      .     0 A1:2-3|A2:2-3 A1:P1|A2:P-1"
@@ -503,6 +509,11 @@ TEST_MATRIX=(
 	"  C1-3:P2 C2:P2    .      .       .     P1     .      .     0 A1:1-3|A2:2 A1:P2|A2:P-1 1-3"
 	"  C1-3:P2 C2:P1    .      .       .    C2-3    .      .     0 A1:1-3|A2:2-3 A1:P2|A2:P-1 1-3"
 
+	# A middle isolated parent shrunk below coverage: the released CPUs of
+	# an invalidated child stay isolated as a higher ancestor still covers them.
+	" CX0-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
+								       A1:P2|A2:P2|A3:P-2 0-4"
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.56.0

