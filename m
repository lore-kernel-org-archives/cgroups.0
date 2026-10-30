Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793387246;
	b=nOXSbZeKUOv+sWQvqGfFwespCiW7nJXyCdNyitudE64oexegVNGPY6Enor9mm8l72UIY
	 MouA5d44kiqcGBWVryF8KVT53/v59b/wXg+Pjby6Rsrbm/vzW5kwKNN39VtzhPt3pRyYz
	 7RwL/Z0mWh3guBfC4FVQZA+bq3P9etUuUafrPH5tuHray954O2mjl+kQx4sdTMJjD1RY7
	 rPV4MfdZTvbhYgf7G1/d30uzkm49OKTNjRPae+p/6m3kz63WGxWolr1Zc7+eoK3fHiLrI
	 OdPJbbrarSOLIF3TRsXhxTUhdzXVxxuTT9aT8Hjl+hWdJBLnM+IFC3XUWRCa4hjWukg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793387246;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=doGm8YEi7ReA6fG2QtnAPdDqQF6M4QUDn6Fjx3r7tcQ=;
	b=S0zRBFq/CJ81A8NdI5mTNDpGbuyhpbSt943qTuo/xY1xt+mg+39gs8cMLeaNoRvvFW2B
	 ZfbiRfCiKVD21oeOldsKv2UNkqTNPTZN0gI9FK8tJnkgNFrmzo9xVY+CBLn3NtgmTaVAl
	 aXnPTr28Io/LDo254VS67PlUXq19Oi0byRoEKgCwF3HrFrgvuyhVoknqeF+k8gHnTzSlD
	 Gdl3oLo+YuFoh5Kd83OBj6iGhdqeBs+1fDJx7QWHSArbcU5I5rZo10ZL3zHAKeZgEOlEa
	 kbIAUjKjk1ESEqVF7rqLululdNukDOeSZrI0kvWbOYjFu420+qPc5nbqDkQNV+5QaDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eg9eaep9;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3574860A260A
	for <cgroups@vger.kernel.org>; Fri, 30 Oct 2026 19:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3574860A260A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eg9eaep9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793387245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=doGm8YEi7ReA6fG2QtnAPdDqQF6M4QUDn6Fjx3r7tcQ=;
	b=eg9eaep9CPjfG6iPEDI1jRTN8hfjubOhyAZ0VkuLjnGvGPmtJ/0qOqF77T/DYCGeR1YtvO
	8Vp4AzTyb302EsFZiclQDRx8dHS6t5oSMQIzRJvglSTvN+QOxiT6NtJpohPm1lF6+u7fOg
	NMztzl8SLkl+DeEZyFK+fxaL6NXjdcE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-fNo9U81bM_igiDEzXJjw7Q-1; Fri,
 30 Oct 2026 15:07:21 -0400
X-MC-Unique: fNo9U81bM_igiDEzXJjw7Q-1
X-Mimecast-MFC-AGG-ID: fNo9U81bM_igiDEzXJjw7Q_1793387239
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D9D2D180057D;
	Fri, 30 Oct 2026 19:07:18 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 223561956087;
	Fri, 30 Oct 2026 19:07:17 +0000 (UTC)
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
Subject: [PATCH v2 3/3] cgroup/cpuset: Do housekeeping check when isolated child with root parent may get more xcpus
Date: Fri, 30 Oct 2026 15:07:01 -0400
Message-ID: <20261030190701.78308-4-longman@redhat.com>
In-Reply-To: <20261030190701.78308-1-longman@redhat.com>
References: <20261030190701.78308-1-longman@redhat.com>
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

It is reported by sashiko and Guopeng that when an isolated child with
root parent gets more isolated CPUs from the expansion of the parent's
effective_xcpus, it is possible that all the active housekeeping CPUs
may be gone. So a prstate_housekeeping_conflict() should be performed
when that happens. Add the check to make sure that we can't exhaust
all the active housekeeping CPUs.

Test cases are added to the NOHZ_FULL_TEST_MATRIX of test_cpuset_prs.sh
to test that.

Reported-by: Guopeng Zhang <guopeng.zhang@linux.dev>
Link: https://lore.kernel.org/lkml/ed6fecb4-38e9-4a73-8c1a-7bdd80175a69@linux.dev
Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                         | 18 +++++++++++++++---
 .../selftests/cgroup/test_cpuset_prs.sh        | 10 ++++++++--
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ed014ecb770c..6e136888fc8e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2119,10 +2119,22 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			 * If there is an expansion of parent's effective_xcpus,
 			 * we may take more xcpus from parent. The parent's
 			 * effective_cpus should still have active CPUs or nocpu
-			 * should have been set.
+			 * should have been set. We also need to do a
+			 * housekeeping check for an isolated child with root
+			 * parent to make sure that it won't exhaust all the
+			 * active housekeeping CPUs.
 			 */
-			deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
-						  cs->effective_xcpus);
+			cpumask_andnot(tmp->addmask, cs->effective_xcpus, tmp->delmask);
+			if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED) &&
+			    prstate_housekeeping_conflict(old_prs, parent_prs,
+							  tmp->delmask, tmp->addmask)) {
+				adding = cpumask_and(tmp->addmask, cs->effective_xcpus,
+						     tmp->delmask);
+				part_error = PERR_HKEEPING;
+			} else {
+				deleting = cpumask_andnot(tmp->delmask, tmp->delmask,
+							  cs->effective_xcpus);
+			}
 		} else if (is_partition_invalid(cs)) {
 			struct cgroup_subsys_state *css;
 			struct cpuset *child;
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 844efdf029cd..bdca6c471f87 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -137,7 +137,8 @@ LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
 # If isolated CPUs have been reserved at boot time (as shown in
 # /sys/devices/system/cpu/isolated), these isolated CPUs should be outside of
 # CPUs 0-8 that will be used by this script for testing purpose. If not, some
-# of the tests may fail incorrectly.
+# of the tests may fail incorrectly. The first boot isolated CPU should be
+# 10 or above.
 #
 # The current set of isolated CPUs (as shown in cpuset.cpus.isolated) should
 # be the same as the boot value. If not, wait a bit and retry again just in
@@ -156,7 +157,7 @@ TEST_ISOLCPUS=
 [[ -n "$BOOT_ISOLCPUS" ]] && {
 	FIRST_ISOLCPUS=$(echo $BOOT_ISOLCPUS | sed -e "s/[,-].*//")
 	echo "Boot isolated CPUs: $BOOT_ISOLCPUS"
-	[[ $FIRST_ISOLCPUS -le 8 ]] &&
+	[[ $FIRST_ISOLCPUS -le 9 ]] &&
 		skip_test "Boot isolated CPUs overlap CPUs to be tested"
 }
 
@@ -602,6 +603,7 @@ ISOLCPUS_TEST_MATRIX=(
 )
 
 # Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
+# This also means that CPU 8 is available and is a nohz_full CPU.
 NOHZ_FULL_TEST_MATRIX=(
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
@@ -610,6 +612,10 @@ NOHZ_FULL_TEST_MATRIX=(
 	" C2-7:P2    .      .      .     C0-4    .      .      .     0 A1:0-4 A1:P2 0-4"
 	" C1-7:P2 C5-7:P2   .      .       .     .      .    C0:P2   0 A1:1-4|A2:5-7|B1:0
 								       A1:P2|A2:P2|B1:P-2 1-7"
+	# An isolated child partition cannot grow to take over the last
+	# housekeeping CPU when its parent expands the exclusive CPUs.
+	" C0-8:X1-8:P1 CX0-8:P2 .  .     X0-7    .      .      .     0 A1:0-7|A2:0-7 A1:P1|A2:P-2 ."
+	" C0-8:X0-6:P1 CX0-8:P2 .  .     X2-8    .      .      .     0 A1:|A2:2-8 A1:P1|A2:P2 2-8"
 )
 
 #
-- 
2.56.0

