Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792964734;
	b=Cz8OrwW3tY1IbxoUOXqMzQrV9Af8LOrH9EZR4F49HXq3gMuYUexHRm5pLkkLV4ymfnUT
	 DZi/RnlCUrq1KZDSiiVAy+R7jLCAl5f6DURhc92GLImfaXqKcKQAdWDdC9Q2Aj+XyObLc
	 Sc/q1o7uzdewkdSY2+a1nKV3eFFvuHUy2wJfSfcFyI/N5CvwgadNWVKYWXzhxOcJW9VEu
	 bzuEKYhNUQi1MSDPI38z5dt2Zse4m49VLy4hzHmkBmHX1YExFpAIoPhh7CCEYwAZRSAe6
	 /6h7mcpDDnLyu4kB8VNa+LSke7q/GPhVbJ5G1lAoO4odAsFcynpO2pcg0/lGtwyaMEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792964734;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=UKtbLxbYshK40FtQaV/RQPYY20tQv6mqzG+l/DciftU=;
	b=aPhxh0Ypo3NreQNYUHISt8qOkypCM8JagECQVDwClESjwJWek84O3tS8KvP0TxPLjoGl
	 KMXm5uWjigM1TxhHD5/Cwo7OP8H4Vow5MjmWZnace/b7zAX6X+cG1k9oiUiGbSCJpC3rz
	 YqnwYBgOg9cFrzMoJqDy56BJPLyjlUzNcMddrheRH9jIW+Hs2sBTw69lmwJAcqXbH8c3y
	 l6VSwjEagewC+KRXmMFi0HZNNu/vFVITuAeWOAIQYFS1jENS4Wt1f3z0uplHuukqL7+/Y
	 yL7E3C1yX0vUh/a6ytNLnY8M4g6paU/TJNovxfi3rN1sehpFmJQOCfyqWka1K9H/gPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IOL8Ai1V;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484F4606A329
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 21:45:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 484F4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IOL8Ai1V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792964733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UKtbLxbYshK40FtQaV/RQPYY20tQv6mqzG+l/DciftU=;
	b=IOL8Ai1VjhctQLcR5oTUHEr1BhBkLoZlMy+52yr6L+p4A3/0UYnu3UFgjHKaHEb0v+w1Q9
	KzaFIPiaoA6zDsiKy+pJGyYpFfHzm58yBAhZcQ0rkfmUot6KmNB2x3XoSMW2q7PINuSRbv
	NQiSL7hvfB9yEyyxTKiBCcC/h717Ck0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-qeCGxjooNamxI6Y-SxWo1Q-1; Sun,
 25 Oct 2026 17:45:24 -0400
X-MC-Unique: qeCGxjooNamxI6Y-SxWo1Q-1
X-Mimecast-MFC-AGG-ID: qeCGxjooNamxI6Y-SxWo1Q_1792964723
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 137221955F11;
	Sun, 25 Oct 2026 21:45:23 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DD0C01956087;
	Sun, 25 Oct 2026 21:45:20 +0000 (UTC)
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
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH-next v3 06/11] cgroup/cpuset: Prevent recursive call of remote_cpus_update() via update_cpumasks_hier()
Date: Sun, 25 Oct 2026 17:44:44 -0400
Message-ID: <20261025214449.310715-7-longman@redhat.com>
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

Guopeng reports that changing the cpumask of a remote partition root
may set the effective_cpus of the top_cpuset incorrectly. It is
due to the following call sequence:

  update_cpumask()
   -> partition_cpus_change()
    -> remote_cpus_update()
     -> update_sibling_cpumasks()
      -> update_cpumasks_hier()
       -> remote_cpus_update()

The second remote_cpus_update() call passes in the cs->effective_xcpus
instead of the trialcs->effective_xcpus of the first remote_cpus_update()
call.  As a result, the second call can revert what has been done in
the first call leading to incorrect effective_cpus of the top_cpuset
as well as subpartitions_cpus.

Fix that by adding a new remote_partition_updating flag into the cpuset
structure to indicate that a remote partition is being updated and
update_cpumasks_hier() should skip the whole subtree as update_cpumask()
or update_exclusive_cpumask() which calls partition_cpus_change()
will eventually calls update_cpumasks_hier() for that subtree anyway.

This new flag is currently set only in remote_cpus_update() to prevent
recursive call of remote_cpus_update() on the same cpuset.

A test case is added to test_cpuset_prs.sh to verify this change.

Reported-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Link: https://lore.kernel.org/lkml/20261010075947.333549-2-guopeng.zhang@linux.dev
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset-internal.h                   |  5 +++++
 kernel/cgroup/cpuset.c                            | 13 +++++++++----
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |  1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 2e44dc8634dc..1ba94ffaff9d 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -161,6 +161,11 @@ struct cpuset {
 	 */
 	bool remote_partition;
 
+	/*
+	 * Set to true when a remote partition is undergoing update.
+	 */
+	bool remote_partition_updating;
+
 	/*
 	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
 	 * know when to rebuild associated root domain bandwidth information.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 57e5334eb919..8903e441ecc1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1775,6 +1775,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			goto invalidate;
 	}
 
+	cs->remote_partition_updating = true;
 	spin_lock_irq(&callback_lock);
 	if (adding)
 		partition_xcpus_add(prs, NULL, tmp->addmask);
@@ -1796,6 +1797,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	 */
 	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
 	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
+	cs->remote_partition_updating = false;
 	return;
 
 invalidate:
@@ -2237,16 +2239,19 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		old_prs = new_prs = cp->partition_root_state;
 
 		/*
-		 * For child remote partition root (!= cs), we need to call
-		 * remote_cpus_update() if effective_xcpus will be changed.
-		 * Otherwise, we can skip the whole subtree.
+		 * For a child remote partition with remote_partition_updating
+		 * set, we can skip the whole subtree as the this function will
+		 * be called eventually. We can also skip the subtree if the
+		 * effective_xcpus isn't going to be changed. Otherwise, we
+		 * will have to call remote_cpus_update().
 		 *
 		 * remote_cpus_update() will reuse tmp->new_cpus only after
 		 * its value is being processed.
 		 */
 		if (remote && (cp != cs)) {
 			compute_excpus(cp, tmp->new_cpus);
-			if (cpumask_equal(cp->effective_xcpus, tmp->new_cpus)) {
+			if (cp->remote_partition_updating ||
+			    cpumask_equal(cp->effective_xcpus, tmp->new_cpus)) {
 				pos_css = css_rightmost_descendant(pos_css);
 				continue;
 			}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 3c9f67f91366..f0d98da3cfd8 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -347,6 +347,7 @@ TEST_MATRIX=(
 	"   C0-3    C1-3  C2-3    C4    X2-3   X2-3  X2-3:P2 P2:C4-5 0 A3:2-3|B1:4-5 A3:P2|B1:P2 2-5"
 	"  C4:X0-3  X1-3  X2-3     .      .      P2     .      .     0 A1:4|A2:1-3|A3:1-3 A2:P2 1-3"
 	"  C4:X0-3  X1-3  X2-3     .      .      .      P2     .     0 A1:4|A2:4|A3:2-3 A3:P2 2-3"
+	"   CX1-6  C1-4:P1  .    C4-5     .    C1-3     .      .     0 A1:4-6|A2:1-3|B1:4-5 A2:P1"
 
 	# Nested remote/local partition tests
 	"   C0-3    C1-3  C2-3   C4-5   X2-3  X2-3:P1   P2     P1    0 A1:0-1|A2:|A3:2-3|B1:4-5 \
-- 
2.56.0

