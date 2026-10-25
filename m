Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964743;
	b=Gcu+LnXXgnN8wee70Ztwd+nEymvD40JehYajQEIew8nifAWG8xpLm9TWnlXjd6gHZYxI
	 tIl1iSr+HX3IuDEEYVD4m/Sw04sfErAxKXxUisq2YLPRkl7J6z4f1t1C/rpGorFw4CWNT
	 lyBEZJ1A+YTNV1EZk0TDOoMfZ6BqQTJdqNm5cINWHhJEqHSGk05hf7Ck3JDpLMXI2UWUz
	 exXGIweJoFf90vc4Tl9Dh2uDzsBfyIcECrXWx+2avd6yHimrsQ8dGfVKWh9QchvPeqOmu
	 HzRGXv+oFihERtO7viB9Xyyi63tqjHWBGqKUMN745zgc48j1xfx/Gpojt1nNS29hSOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964743;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=hq2/PF+JuIi0SJGOsKa9UMorySX00/w1KvSGJkRcpbE=;
	b=kKQk69OGjY6SNwD4auyBwt1Enn/9S2wst/bz36hkRktiHtD8LMmyHqtmJvfbuQU9EpM2
	 TwRKoZiIUpEzfQRL8DszfVBR88W2g8HtX99J9fL8WSYZFQOSPMdvY4GJ1SmmOpXOv0Stk
	 tHPJ8tuyyhMr2g1+Xuejt05FT/rkgdGB4jsAA5dPddMe9nvhbVYd7ZqudJFn7Q1edPXNS
	 peWwaMeqYmuiFAF8/+mUD0Nm9i6JrYAH1Ze00VW/H/EI/PkGW0eOhHYxz1g/l3H+bksM6
	 7ahH0+Z/kEJSkL9aKC+kSkOawYU3d9FawbjRPT6IwzUcyW+WVjMoEeIkufn/OXLsUFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SsL4CFq6;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A50F606A31D
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 21:45:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A50F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SsL4CFq6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792964729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hq2/PF+JuIi0SJGOsKa9UMorySX00/w1KvSGJkRcpbE=;
	b=SsL4CFq6KrmW6M5Bv0KyzFz72fISvReSFTUZB9v0SQobMVJfTqzKF/BG+9bYWIiiCYaXFI
	Pqi9Hzz3xoSTMD5XXMCMa7KJYr/EFeB52NsG0zb8rG9NA3VpLz9jOQoHYLkB+CLKQN8aDj
	JJBHo/nxfhpBK3/oSbHFjkPPycjUDF8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-8q0vAT8hN1Skg5WDdLb6jw-1; Sun,
 25 Oct 2026 17:45:28 -0400
X-MC-Unique: 8q0vAT8hN1Skg5WDdLb6jw-1
X-Mimecast-MFC-AGG-ID: 8q0vAT8hN1Skg5WDdLb6jw_1792964726
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A840C1800615;
	Sun, 25 Oct 2026 21:45:26 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 048551956087;
	Sun, 25 Oct 2026 21:45:24 +0000 (UTC)
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
Subject: [PATCH-next v3 08/11] cgroup/cpuset: Release invalid isolated CPUs in compute_partition_effective_cpumask()
Date: Sun, 25 Oct 2026 17:44:46 -0400
Message-ID: <20261025214449.310715-9-longman@redhat.com>
In-Reply-To: <20261025214449.310715-1-longman@redhat.com>
References: <20261025214449.310715-1-longman@redhat.com>
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

It is found by sashiko that when a child isolated partition with parent
root partition is invalidated in compute_partition_effective_cpumask(),
the switching of the isolated exclusive CPUs from child to parent will
not be reflected in isolated_cpus leading to CPU leakage. Fix that by
calling isolated_cpus_update() when that happens.

Also simplify compute_partition_effective_cpumask() by doing
child partition invalidation only for the special case of no more
effective_cpus left in a populated parent. The other case doesn't
actually warrant invalidation at this stage and subsequent iteration
in update_cpumasks_hier() and update_parent_effective_cpumask() for
that child should handle that.

Also drop the make_partition_invalid() helper by inlining it into
compute_partition_effective_cpumask() as it is the only caller.

A new test case is add to test_cpuset_prs.sh to verify this.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                        | 46 +++++++------------
 .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++
 2 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 53fa3970946e..6d224e614e74 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -254,15 +254,6 @@ static inline bool cs_is_member(const struct cpuset *cs)
 	return cs->partition_root_state == PRS_MEMBER;
 }
 
-/*
- * Callers should hold callback_lock to modify partition_root_state.
- */
-static inline void make_partition_invalid(struct cpuset *cs)
-{
-	if (cs->partition_root_state > 0)
-		cs->partition_root_state = -cs->partition_root_state;
-}
-
 /*
  * Send notification event of whenever partition_root_state changes.
  */
@@ -2153,8 +2144,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
  * or update_cpumasks_hier() where parent and children are modified
  * successively, we don't need to call update_parent_effective_cpumask()
  * and the child's effective_cpus will be updated in later iterations.
- *
- * Note that rcu_read_lock() is assumed to be held.
  */
 static void compute_partition_effective_cpumask(struct cpuset *cs,
 						struct cpumask *new_ecpus)
@@ -2166,15 +2155,16 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	WARN_ON_ONCE(!is_partition_valid(cs));
 
 	/*
-	 * Check child partition roots to see if they should be
-	 * invalidated when
-	 *  1) child effective_xcpus not a subset of new
-	 *     excluisve_cpus
-	 *  2) All the effective_cpus will be used up and cp
-	 *     has tasks
+	 * Check child partition roots to see if they should be invalidated
+	 * when all the effective_cpus will be used up and cs is populated.
+	 * It is better to sacrifice a child partition root than invalidating
+	 * the whole subtree.
+	 *
+	 * Return early if the effective_cpus is already empty.
 	 */
 	compute_excpus(cs, new_ecpus);
-	cpumask_and(new_ecpus, new_ecpus, cpu_active_mask);
+	if (!cpumask_and(new_ecpus, new_ecpus, cpu_active_mask))
+		return;
 
 	rcu_read_lock();
 	cpuset_for_each_child(child, css, cs) {
@@ -2186,22 +2176,20 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 		 * partition root.
 		 */
 		WARN_ON_ONCE(is_remote_partition(child));
-		WRITE_ONCE(child->prs_err, 0);
-		if (!cpumask_subset(child->effective_xcpus,
-				    cs->effective_xcpus))
-			WRITE_ONCE(child->prs_err, PERR_INVCPUS);
-		else if (populated &&
-			 cpumask_subset(new_ecpus, child->effective_xcpus))
-			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
-
-		if (child->prs_err) {
+		if (populated && cpumask_subset(new_ecpus, child->effective_xcpus)) {
 			int old_prs = child->partition_root_state;
+			int parent_prs = cs->partition_root_state;
 
 			/*
-			 * Invalidate child partition
+			 * Invalidate child partition and update isolated_cpus
+			 * if necessary.
 			 */
 			spin_lock_irq(&callback_lock);
-			make_partition_invalid(child);
+			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
+			if ((old_prs == PRS_ISOLATED) && (parent_prs == PRS_ROOT))
+				isolated_cpus_update(PRS_ISOLATED, PRS_ROOT,
+						     child->effective_xcpus);
+			child->partition_root_state = -old_prs;
 			spin_unlock_irq(&callback_lock);
 			notify_partition_change(child, old_prs);
 			continue;
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index f0d98da3cfd8..d7d0bef0a17a 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -518,6 +518,10 @@ TEST_MATRIX=(
 	" CX0-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
 								       A1:P2|A2:P2|A3:P-2 0-4"
 
+	# When an isolated partition child with root partition parent is invalidated,
+	# its effective xcpus will be removed from isolated_cpus.
+	" C1-4:P1 C3-4:P2   .      .    T:C3-4   .      .      .     0 A1:3-4|A2:3-4 A1:P1|A2:P-2 ."
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.56.0

