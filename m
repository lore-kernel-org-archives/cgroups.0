Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94A8231A21
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 19:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784315918; cv=none; b=tASHN+V0A9Y/APm6g41ArQktcvUfHheyNKH8eRUkySzaajnpyQOvpFMTd299XL/l3biv40/tAT6FIJOgOgDKzRC1Lf+TF4WK9eXuej6PaN+qy59KTk7ODpkW/kLNAq+BYdoYBbGm5CqwQ3zzYqUa3WXNo8u75kpM1hIxHo6Wqn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784315918; c=relaxed/simple;
	bh=srYYVlEd4UwIAe59iTD2Ack8aE8OFUXoRQ1EbQoEtnY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=quQNsiAhnR6H9JiY30fDDETp5Ai/Mv35S6gchG2CtB8JmkHLVgaICGfScu1UiI12EnqTzrnvbpEsAIrJu1qS2zs/2HiOw1YaJ2AF4tm2PhvmEWYq7ngStVeg43IReK+X1+JRWQ1tT3aLKWffaumqSRBfQ7uHA1FaEAftsnvsWNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hjDEtnT2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hjDEtnT2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784315915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qEQzok7ha6LEmTS02fNPAr67fZndbGmEAF+yiB9riKU=;
	b=hjDEtnT2FPHzk3XWYQ+K1wqdL7XcxxXcVJaXylrCbTyJ3J2pfi53eUnxQ+kVg8ui503XMB
	mDZqRz1n/euHS2gr94bgJGr8zHNHjEnw98KrKqI22PZ2UBUi0lmyt1+B14RPFXZpeN3Urm
	hoOaEcuLc2ao8Of3JYPAgLCWr7kLZJk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-7QWie-4cNlqw6l1ueAylqA-1; Fri,
 17 Jul 2026 15:18:32 -0400
X-MC-Unique: 7QWie-4cNlqw6l1ueAylqA-1
X-Mimecast-MFC-AGG-ID: 7QWie-4cNlqw6l1ueAylqA_1784315911
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C82331944E43;
	Fri, 17 Jul 2026 19:18:30 +0000 (UTC)
Received: from llong-thinkpadp1gen5.rmtusnh.csb (unknown [10.22.81.98])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 00A2D1955D4A;
	Fri, 17 Jul 2026 19:18:28 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-cgroup/for-7.3] selftests/cgroup: Fix minor defects in test_cpuset
Date: Fri, 17 Jul 2026 15:18:14 -0400
Message-ID: <20260717191814.989215-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

With commit 98149f542530 ("selftests/cgroup: Add test for cpuset affinity
on controller disable"), sashiko [1] had report 3 different issues with
the new test_cpuset_affinity_on_controller_disable() test.

 1) `cpu_set_equal` iterates over mask bytes instead of bits, ignoring
    CPUs >= 8.
 2) Thread synchronization logic allows the main thread to read
    uninitialized stack memory, causing test flakiness.
 3) Test fails instead of skipping gracefully on uniprocessor systems
    or when CPU 1 is unavailable.

Fix the reported issues by:
 1) Iterates over the bit size of the mask.
 2) Test the new ready flag for each thread to end the wait
    on the condoitional variable and eliminate the now unneeded
    AFFINITY_THREAD_A_READY and AFFINITY_THREADS_READY test phases.
 3) Return KSFT_SKIP on "cpuset.cpus" setting failure.

[1] https://sashiko.dev/#/patchset/20260712235510.373125-1-longman%40redhat.com

Fixes: 98149f542530 ("selftests/cgroup: Add test for cpuset affinity on controller disable")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_cpuset.c | 38 +++++++++++---------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_cpuset.c b/tools/testing/selftests/cgroup/test_cpuset.c
index 8b4c4a9dd78b..8c2d4d4ef1fc 100644
--- a/tools/testing/selftests/cgroup/test_cpuset.c
+++ b/tools/testing/selftests/cgroup/test_cpuset.c
@@ -251,7 +251,7 @@ static int cpu_set_equal(cpu_set_t *dst, unsigned long mask)
 	CPU_ZERO(&expected);
 	assert(sizeof(mask) < CPU_SETSIZE);
 
-	for (int cpu = 0; cpu < sizeof(mask); ++cpu)
+	for (int cpu = 0; cpu < sizeof(mask) * 8; ++cpu)
 		if ((1UL << cpu) & mask)
 			CPU_SET(cpu, &expected);
 
@@ -260,8 +260,6 @@ static int cpu_set_equal(cpu_set_t *dst, unsigned long mask)
 
 enum test_phase {
 	AFFINITY_SETUP,
-	AFFINITY_THREAD_A_READY,
-	AFFINITY_THREADS_READY,
 	AFFINITY_CONTROLLER_DISABLED,
 	AFFINITY_COMPLETE,
 	AFFINITY_ERROR
@@ -271,7 +269,7 @@ struct thread_args {
 	const char *cgroup;
 	cpu_set_t *affinity_before;
 	cpu_set_t *affinity_after;
-	enum test_phase ready_phase;
+	int affinity_before_ready;
 };
 
 static pthread_mutex_t test_mutex = PTHREAD_MUTEX_INITIALIZER;
@@ -289,8 +287,7 @@ static void *affinity_thread_fn(void *arg)
 		goto fail;
 
 	pthread_mutex_lock(&test_mutex);
-	if (test_phase < args->ready_phase)
-		test_phase = args->ready_phase;
+	args->affinity_before_ready = 1;
 	pthread_cond_broadcast(&test_cond);
 
 	while (test_phase < AFFINITY_CONTROLLER_DISABLED)
@@ -361,18 +358,20 @@ static int test_cpuset_affinity_on_controller_disable(const char *root)
 		goto cleanup;
 
 	/* Now enable cpuset controller in parent */
-	if (cg_write(parent, "cgroup.subtree_control", "+cpuset")) {
-		ret = KSFT_SKIP;
-		goto cleanup;
-	}
+	if (cg_write(parent, "cgroup.subtree_control", "+cpuset"))
+		goto skip;
 
-	/* Set CPU affinity constraints */
+	/*
+	 * Set CPU affinity constraints
+	 * Skip the test if the setting of "cpuset.cpus" fails as the test
+	 * system may not have CPU 1.
+	 */
 	if (cg_write(parent, "cpuset.cpus", "0-1"))
-		goto cleanup;
+		goto skip;
 	if (cg_write(child_a, "cpuset.cpus", "0-1"))
-		goto cleanup;
+		goto skip;
 	if (cg_write(child_b, "cpuset.cpus", "1"))
-		goto cleanup;
+		goto skip;
 
 	/* Move group leader (main thread) to child A */
 	if (cg_enter_current(child_a))
@@ -385,7 +384,7 @@ static int test_cpuset_affinity_on_controller_disable(const char *root)
 		.cgroup = child_a,
 		.affinity_before = &affinity_a_before,
 		.affinity_after = &affinity_a_after,
-		.ready_phase = AFFINITY_THREAD_A_READY,
+		.affinity_before_ready = 0,
 	};
 	if (pthread_create(&thread_a, NULL, affinity_thread_fn, &args_a))
 		goto cleanup;
@@ -395,14 +394,15 @@ static int test_cpuset_affinity_on_controller_disable(const char *root)
 		.cgroup = child_b,
 		.affinity_before = &affinity_b_before,
 		.affinity_after = &affinity_b_after,
-		.ready_phase = AFFINITY_THREADS_READY,
+		.affinity_before_ready = 0,
 	};
 	if (pthread_create(&thread_b, NULL, affinity_thread_fn, &args_b))
 		goto cleanup_threads;
 	thread_b_created = 1;
 
 	pthread_mutex_lock(&test_mutex);
-	while (test_phase < AFFINITY_THREADS_READY)
+	while ((test_phase < AFFINITY_ERROR) &&
+	       (args_a.affinity_before_ready + args_b.affinity_before_ready < 2))
 		pthread_cond_wait(&test_cond, &test_mutex);
 
 	/* If a thread failed during setup, bail out */
@@ -449,6 +449,10 @@ static int test_cpuset_affinity_on_controller_disable(const char *root)
 	ret = KSFT_PASS;
 	goto cleanup;
 
+skip:
+	ret = KSFT_SKIP;
+	goto cleanup;
+
 cleanup_threads:
 	pthread_mutex_lock(&test_mutex);
 	test_phase = AFFINITY_COMPLETE;
-- 
2.55.0

