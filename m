Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201188;
	b=s7/CtF9HUUi1AF7cxw2N5Ubhf3CoAPKjSP49wI611hjvgeGYSkQy16JhngVwIxK/hyx5
	 K/+HKRYduwnF90GLN+Dy/oh/eyoTMojgeY4K+tu60VOt5ZivKTUfLWcLMMzrm6qO6vrhE
	 FOyPM3T1hh/qvjRjNEwZHlM+yZy4CFxQ6aEKs7UQb157lPKlr4EsYo2xyl7exSM4acJjw
	 xaX5cwIFUE++YnMSRrLH5lFpk8VvOH8RnPDH7AZsC4cN2G88AAJwOIMEOcLqhE48z112U
	 OLwR3LqWcQBHPkb0X66Hrxqt6rzMVr46P2xp4J94OfzESrXehPk2mTx0OxyiBdgAZaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201188;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=JhAXt4molpXArE2a+9w99iksxXXbJLMh4ialGyXcuqw=;
	b=QDmwDXuEm8ZkmOvAddiq7AS6XvWpZWqE1mpTHuh1ZWKYj+9DT3EOF3ORuBBn9XMsyCmP
	 YOCRVR/KtqbSireLcBNZK7kSVTo7e+jSOLwV5S4caAkIgcS/PW7rKuQTqB4wtDGhh4brg
	 cyKW75f6scxkIBW8yITtU2eN6d1Vhw+QsbbTW4t+pyh9PjyxdpFtrzmM4S9kOm4pJ17Az
	 0RGqjtzgKSKZdRt8fwk4Ruwwr1RtBElmkY+vH+vn104YIa+fNMxgZY9xiWP+P9MdjnL8q
	 sIG9oU+pAzkQlzUG3BnJkK9RoKk63I0jnH5n6STll/5GgCvz+kTrYtuaOQDlnB/M8Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hXoMAlCz;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A838606A31F
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 15:26:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A838606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hXoMAlCz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793201186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JhAXt4molpXArE2a+9w99iksxXXbJLMh4ialGyXcuqw=;
	b=hXoMAlCzx6kLbu3z5ehl9hX+NZ75++Z7jEh0VTm+CRKeFzYh4xxdtLMgfY0E+/I/tA07rK
	YqQneQPJdA9/C9zS2ouDtni2ybnI8UhgosAaQ4zn7kXqqDdxxN8hFpBZP8qh3ob/AjqVBy
	c8xqrznsq+mIp6lhII6WvmVbgdvnfoU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-CtpSHA7KMquQw3VQ_r5-PA-1; Wed,
 28 Oct 2026 11:26:23 -0400
X-MC-Unique: CtpSHA7KMquQw3VQ_r5-PA-1
X-Mimecast-MFC-AGG-ID: CtpSHA7KMquQw3VQ_r5-PA_1793201181
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF1B41800BED;
	Wed, 28 Oct 2026 15:26:20 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B0C6F433;
	Wed, 28 Oct 2026 15:26:18 +0000 (UTC)
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
Subject: [PATCH-next] cgroup/cpuset: Fix incorrect CPU accounting with parent's effective_xcpus expansion
Date: Wed, 28 Oct 2026 11:26:08 -0400
Message-ID: <20261028152608.648427-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Commit ec0254b9eb49 ("cgroup/cpuset: Release invalid isolated CPUs with
a shrunk root partition parent") fixes incorrect isolated_cpus accounting
when contraction of a parent's effective_xcpus can cause a child partition
to lose isolated CPUs. Expansion of parent's effective_cpus can also allow
a child partition to gain more effective_xcpus. However, the current code
doesn't handle this case correctly leading to incorrect effective_cpus
and isolated_cpus accounting. Fix that by looking for this possible
expansion of effective_xcpus and perform the proper accounting action.

New test cases are added to test this effective_xcpus expansion scenarios.

Reported-by: Guopeng Zhang <guopeng.zhang@linux.dev>
Link: https://lore.kernel.org/lkml/20261027123837.100909-1-guopeng.zhang@linux.dev
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                            | 12 ++++++++++++
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 15 +++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..39c81a0a8ab9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2097,6 +2097,7 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 							     parent->effective_xcpus);
 			if (!cpumask_empty(tmp->addmask))
 				isolated_cpus_release(cs, tmp->addmask);
+			/* Expansion of parent's effective_xcpus is handled below */
 		}
 		if (nocpu) {
 			part_error = PERR_NOCPUS;
@@ -2106,11 +2107,22 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 						     parent->effective_xcpus);
 		} else if ((parent_prs == PRS_ISOLATED) &&
 			   ((old_prs == PRS_ROOT) || (old_prs == -PRS_ROOT))) {
+			/* Parent partition state changed to PRS_ISOLATED */
 			part_error = PERR_ISOPARENT;
 			if (old_prs == PRS_ROOT) {
 				cpumask_copy(tmp->addmask, cs->effective_xcpus);
 				adding = true;
 			}
+		} else if (is_partition_valid(cs) &&
+			   !cpumask_equal(tmp->delmask, cs->effective_xcpus)) {
+			/*
+			 * If there is an expansion of parent's effective_xcpus,
+			 * we may take more xcpus from parent. The parent's
+			 * effective_cpus should still have active CPUs or nocpu
+			 * should have been set.
+			 */
+			deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
+						  cs->effective_xcpus);
 		} else if (is_partition_invalid(cs)) {
 			struct cgroup_subsys_state *css;
 			struct cpuset *child;
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 83ef6c781af3..844efdf029cd 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -531,6 +531,21 @@ TEST_MATRIX=(
 	" C1-4:P1 C3-4:P2   .      .    T:C4-6   .      .      .     0 A1:5-6|A2:4 A1:P1|A2:P2 4"
 	" C1-4:P1 C1-2:P2   .      .    T:C4-6   .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
 
+	# The extra CPUs gained by a child partition when its parent expands the
+	# exclusive CPUs have to be taken away from the parent.
+	" C2-6:X2-5:P1 CX3-6:P1 \
+	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P1 ."
+	" C2-6:X2-5:P1 CX3-6:P2 \
+	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P2 3-6"
+
+	# Both expansion and contraction of parent's effective_xcpus will be
+	# correctly handled in child partition and the child can be invalidated
+	# if a populated parent could lose all its effective_cpus.
+	" C2-6:X2-5:P1 CX3,5-6:P2 \
+	                    .      .    X4-6     .      .      .     0 A1:4|A2:5-6|XA2:5-6 A1:P1|A2:P2 5-6"
+	" C2-6:X2-5:P1 CX3-6:P2 \
+	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.56.0

