Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B02C53ED09
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986788; cv=none; b=JF9U5nXcCAwMf4WRjYjMH7vv945KJz9sB5LoFgOPtgPXrBYDLYHtMpC72Ek7H9SNG2xS/CcrbM9/fPuRLCKl4osXmwbghw/hpKLtxveo6udYvtPHv/ZmqFZMw2xle2j9/wTo9Oed9uxnjpDyITXiDH7aFR8T5q8O7g1sJMi43GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986788; c=relaxed/simple;
	bh=lX21Hh+kVmN235zbrNzna2Pun0sxktr9gDm/esgokJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6JbqcUd+p9RIgOt5bzQVj64FDbVZSsODSY0a3nkRHp4JgQaRQvgc2UcW8zNYietuRLRajaz+3t2VXSl7iDvxK7ZnlAIv7lNq7cXDpRvBnXV51Df1n56pDf/1/Bz9yFHGzjWmz0Z0qyPnpNYWppeqFx94CWDVDxQeBlncj//N5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AtRr64dw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AtRr64dw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+NgPv1yDSRRf/voLY8nLEcpob6SWhAeNI2Dq+rLDpA=;
	b=AtRr64dwuIVSsFczBiQJh4k8zBqfv/Y+1DdFATNX4j2pD4DwvwHoT6m+6QR/WR04JiD494
	L5Xs3rH+xnGrjAlQ9IIiCKRl3e4oWsN157L14FzgEE4XVFxN1EMyREzU2LC4brsUORINpS
	ia+scCZkSG81Tv5edEwIyp33WM77A2k=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-37-IkDkDjKKPHm7gwL82Ma3vQ-1; Wed,
 14 Oct 2026 14:06:11 +0000
X-MC-Unique: IkDkDjKKPHm7gwL82Ma3vQ-1
X-Mimecast-MFC-AGG-ID: IkDkDjKKPHm7gwL82Ma3vQ_1791986769
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0D791800616;
	Wed, 14 Oct 2026 14:06:08 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3664362;
	Wed, 14 Oct 2026 14:06:06 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next v3 1/9] cgroup/cpuset: Fix a missing isolated_cpus update in update_cpumasks_hier()
Date: Wed, 14 Oct 2026 10:05:40 -0400
Message-ID: <20261014140548.575122-2-longman@redhat.com>
In-Reply-To: <20261014140548.575122-1-longman@redhat.com>
References: <20261014140548.575122-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

It is found that when a local isolated partition is being invalidated
because its root partition parent is no longer valid, the isolated_cpus
cpumask may not be properly updated. If the parent was previously
an isolated partition, its invalidation should have properly updated
isolated_cpus before and no action will be needed.

Fix that by calling isolated_cpus_update() in this invalidation case
to update isolated_cpus. A test case in test_cpuset_prs.sh is modified
to test that.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                        | 19 ++++++++++++++-----
 .../selftests/cgroup/test_cpuset_prs.sh       |  4 ++--
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0ebba2d646c3..6b5c870e5607 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2229,7 +2229,9 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		 * cpuset if the parent's effective_cpus changes.
 		 */
 		if ((cp != cs) && old_prs) {
-			switch (parent->partition_root_state) {
+			int parent_prs = parent->partition_root_state;
+
+			switch (parent_prs) {
 			case PRS_ROOT:
 			case PRS_ISOLATED:
 				update_parent = true;
@@ -2238,11 +2240,18 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 			default:
 				/*
 				 * When parent is not a partition root or is
-				 * invalid, child partition roots become
-				 * invalid too.
+				 * invalid, child partition roots become invalid
+				 * too. For an isolated partition with root
+				 * partition parent, isolated_cpus_updated()
+				 * is called to update isolated_cpus.
 				 */
-				if (is_partition_valid(cp))
-					new_prs = -cp->partition_root_state;
+				if (is_partition_valid(cp)) {
+					new_prs = -old_prs;
+					if ((old_prs == PRS_ISOLATED) &&
+					    (parent_prs == -PRS_ROOT))
+						isolated_cpus_update(old_prs, new_prs,
+								     cp->effective_xcpus);
+				}
 				WRITE_ONCE(cp->prs_err,
 					   is_partition_invalid(parent)
 					   ? PERR_INVPARENT : PERR_NOTPART);
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 7efd5e645767..874a8a161236 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -292,9 +292,9 @@ TEST_MATRIX=(
 								       A1:P0|A2:P2|A3:P1 2-4|2-3"
 	"   C0-4    C1-4  C2-4     .    X2-4  X2-4:P2 X3-4:P1   .    0 A1:0-1|A2:2|A3:3-4 \
 								       A1:P0|A2:P2|A3:P1 2"
-	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
+	" C0-4:X2-4 C1-4:X2-4:P1 C2-4:X4:P2 \
 				   .      .      X5      .      .    0 A1:0-4|A2:1-4|A3:2-4 \
-								       A1:P0|A2:P-2|A3:P-1 ."
+								       A1:P0|A2:P-1|A3:P-2 ."
 	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
 				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
 								       A1:P0|A2:P2|A3:P-1 2-4"
-- 
2.55.0

