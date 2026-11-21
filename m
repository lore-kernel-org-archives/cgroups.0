Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795230873;
	b=mZsKkdr+OZzmUrVgLHdxcv+5faTX5XDjbHxOC/v6SjBydK3R3kZGwDcSvY/7S7e47nbv
	 LE4xscV+KxduQdPVMvHgel9wo/VMSEHevyrEztblK7blGMgPGkpeKWhsA1JwV9s7S6pqp
	 Tz3ynesxN0JtA+YWOU8jemVcMH37XthJSrqhEgBpimTrR0LVriZoFT4jLgRA8L8PaqtzV
	 sS9BPont6CljXi0E1qJtROEYF1OuqTxmEqAQg0vDmPmJwDj7u5SZDXaVFA7ZQRkcCjpic
	 9JyEPqIneJCogor3TvQqvsV6mG5kdvLzpVqXHOOIVbSsvGIMklS2O5MhpSt7u7puPXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795230873;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=wTfmyiT0Ytm3pb1ocoVZSIujByKoDCAIKtW/TRjF8Lc=;
	b=DSwzri59R+tOzHzM13fEcZ8LGjeKmSxt0ab62Dj92nZXHC5sjCfyiC6ArCz6k8j84iLN
	 azGCjhKvjgUf/sNAhMteNqpCeUYRGJlaFAH6pm2FV4jLF2D50FrLyXqoeDXvRsH6K7WaO
	 dy9YDS6QI+90VhrMfZfXIRsWoIpnV+w9vBxR+Vaqix6ir928euywnJYG+oNdYn6CVCJJ3
	 GwA6q+kXwUXVK6Oh5oMM+jt6waQ75NNviI9Y3kjer1RSNZn4MtwtAoy8oiHWs5uparpN9
	 dtKSNfI7CBGqH3bEn0gjkSPspWFwv0hreYHcxoQm/i6NGiv041j+EWQFB230VVoO8LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Yvy5lTWS;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9587E606A6B6
	for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 03:14:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9587E606A6B6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Yvy5lTWS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795230866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wTfmyiT0Ytm3pb1ocoVZSIujByKoDCAIKtW/TRjF8Lc=;
	b=Yvy5lTWSMAEpKn6P8VKYgXRLBTu/70WWfPh3iMm8DgNNUsCfL6tpDqwV1koKtCzK9qUKwJ
	Es6jq7zExutpmiBeot+AjaquEq5PawQ3ozKHyAWBM3vXoklmvqoAxXvYCg1S32LAM2KRbu
	QtVk4GHzN8Qud9mCYG+2D1KaYjP89kk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-OGGaf1v8OrK9pLaSgY6x0Q-1; Sat,
 21 Nov 2026 03:14:20 +0000
X-MC-Unique: OGGaf1v8OrK9pLaSgY6x0Q-1
X-Mimecast-MFC-AGG-ID: OGGaf1v8OrK9pLaSgY6x0Q_1795230857
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D317518004DA;
	Sat, 21 Nov 2026 03:14:16 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C9E97195B3C2;
	Sat, 21 Nov 2026 03:14:11 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 3/3] cgroup/cpuset: Disallow CPU 0 from being used in isolated partition
Date: Fri, 20 Nov 2026 22:13:29 -0500
Message-ID: <20261121031329.240177-4-longman@redhat.com>
In-Reply-To: <20261121031329.240177-1-longman@redhat.com>
References: <20261121031329.240177-1-longman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Domain isolating CPU 0 can be problematic and may even cause panic in
some cases. So it is better to disable its use in an isolated partition.

Add a new partition error code to indicate to the users that CPU 0
cannot be used in an isolated partition.

Some existing test cases in test_cpuset_prs.sh are modified to remove
the use of CPU 0 in isolated partition setup and explicit new test cases
are added to test that. The NOHZ_FULL test cases also modified to run if
the "nohz_full" parameters includes all the CPUs except CPU 1-7 instead
of 0-7. Though it is not recommended to put CPU 0 in the nohz_full boot
parameter, it is the only way we can test that the cpuset code is able to
correctly disallow isolating the last nohz_full/domain housekeeping CPU.

With CPU 0 likely not allowed in the nohz_full list and with CPU 0 also
disallowed from being domain isolated and offline, we will likely have CPU
0 being an always present online housekeeping CPU for most kernels. For
those kernels, we will not be able to trigger partition invalidation due
to using up the last nohz_full/domain housekeeping CPU in an isolated
partition and the NOHZ_FULL test cases in test_cpuset_prs.sh will not
be run.

The cgroup-v2.rst documentation file is also modified to indicate that
CPU 0 cannot be used in an isolated partition.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst       |  1 +
 kernel/cgroup/cpuset-internal.h               |  1 +
 kernel/cgroup/cpuset.c                        |  6 +++
 .../selftests/cgroup/test_cpuset_prs.sh       | 43 ++++++++++++-------
 4 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..2f792ff29425 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2771,6 +2771,7 @@ Cpuset Interface Files
 	and excluded from the unbound workqueues.  Tasks placed in such
 	a partition with multiple CPUs should be carefully distributed
 	and bound to each of the individual CPUs for optimal performance.
+	The boot CPU (CPU 0) cannot be used in an isolated partition.
 
 	A partition root ("root" or "isolated") can be in one of the
 	two possible states - valid or invalid.  An invalid partition
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 1ba94ffaff9d..505682493d81 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -36,6 +36,7 @@ enum prs_errcode {
 	PERR_ACCESS,
 	PERR_REMOTE,
 	PERR_ISOPARENT,
+	PERR_ISOLCPU0,
 };
 
 /* bits in struct cpuset flags field */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 30af9531acdd..68d104d0bdf5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -61,6 +61,7 @@ static const char * const perr_strings[] = {
 	[PERR_ACCESS]    = "Enable partition not permitted",
 	[PERR_REMOTE]    = "Have remote partition underneath",
 	[PERR_ISOPARENT] = "Root partition is not allowed with isolated parent",
+	[PERR_ISOLCPU0]  = "Boot CPU (cpu 0) cannot be isolated",
 };
 
 /*
@@ -1453,6 +1454,9 @@ static enum prs_errcode validate_partition(struct cpuset *cs,
 	if (tasks_nocpu_error(parent, cs, new_excpus))
 		return PERR_NOCPUS;
 
+	if ((new_prs == PRS_ISOLATED) && cpumask_test_cpu(0, new_excpus))
+		return PERR_ISOLCPU0;
+
 	return PERR_NONE;
 }
 
@@ -3002,6 +3006,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			err = PERR_HKEEPING;
 		else if (parent_prs == PRS_ISOLATED)
 			err = PERR_ISOPARENT;	/* old_prs should be isolated */
+		else if ((new_prs == PRS_ISOLATED) && cpumask_test_cpu(0, cs->effective_xcpus))
+			err = PERR_ISOLCPU0;
 
 		if (err) {
 			disable_partition = true;
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 1397ec428c46..735d515ffc10 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -110,8 +110,8 @@ echo "" > test/cpuset.cpus
 
 #
 # If nohz_full CPUs have been reserved at boot time, they should not include
-# CPUs 0-7 as that may fail some of the test cases. On the other hand if the
-# set of nohz_full CPUs includes all the CPUs except 0-7 in a single range
+# CPUs 1-7 as that may fail some of the test cases. On the other hand if the
+# set of nohz_full CPUs includes all the CPUs except 1-7 in a single range
 # <first>-<last>, we can run a special set of housekeeping CPUs exhaustion
 # tests to see if the cpuset code will reject them.
 #
@@ -123,14 +123,22 @@ NOHZ_FULL_CPUS=
 	NOHZ_FULL_CPUS=$(cat /sys/devices/system/cpu/nohz_full)
 LAST_PRESENT_CPU=$(cat /sys/devices/system/cpu/present | sed -e "s/.*[,-]//")
 [[ -n "$NOHZ_FULL_CPUS" ]] && {
-	FIRST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/[,-].*//")
-	LAST_NOHZ_FULL_CPU=$(echo $NOHZ_FULL_CPUS | sed -e "s/,.*//;s/.*[-]//")
+	if [[ $(expr $NOHZ_FULL_CPUS : "^0,") -gt 0 ]]
+	then
+		NOHZ_CPU0=1
+		NOHZ_CPUS=$(echo $NOHZ_FULL_CPUS | sed -e "s/^0,//")
+	else
+		NOHZ_CPUS=$NOHZ_FULL_CPUS
+	fi
+	FIRST_NOHZ_FULL_CPU=$(echo $NOHZ_CPUS | sed -e "s/[,-].*//")
+	LAST_NOHZ_FULL_CPU=$(echo $NOHZ_CPUS | sed -e "s/,.*//;s/.*[-]//")
 	echo "Boot nohz_full CPUs: $NOHZ_FULL_CPUS"
 }
 [[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" -le 7 ]] &&
 	skip_test "Boot NOHZ_FULL CPUs overlap CPUs to be tested!"
 
 [[ -n "$FIRST_NOHZ_FULL_CPU" && "$FIRST_NOHZ_FULL_CPU" = 8 &&
+   -n "$NOHZ_CPU0" &&
    "$LAST_NOHZ_FULL_CPU" = $LAST_PRESENT_CPU ]] && RUN_NOHZ_FULL_TESTS=1
 
 #
@@ -394,8 +402,8 @@ TEST_MATRIX=(
 	# Invalid to valid local partition direct transition tests
 	" C1-3:P2  X4:P2    .      .      .      .      .      .     0 A1:1-3|XA1:1-3|A2:1-3:XA2: A1:P2|A2:P-2 1-3"
 	" C1-3:P2  X4:P2    .      .      .    X3:P2    .      .     0 A1:1-2|XA1:1-3|A2:3:XA2:3 A1:P2|A2:P2 1-3"
-	" C0-3:P2    .      .    C4-6   C0-4     .      .      .     0 A1:0-4|B1:5-6 A1:P2|B1:P0"
-	" C0-3:P2    .      .    C4-6 C0-4:C0-3  .      .      .     0 A1:0-3|B1:4-6 A1:P2|B1:P0 0-3"
+	" C1-3:P2    .      .    C4-6   C1-4     .      .      .     0 A1:1-4|B1:5-6 A1:P2|B1:P0"
+	" C1-3:P2    .      .    C4-6 C1-4:C1-3  .      .      .     0 A1:1-3|B1:4-6 A1:P2|B1:P0 1-3"
 
 	# Local partition invalidation tests
 	" C0-3:X1-3:P2 C1-3:X2-3:P2 C2-3:X3:P2 \
@@ -506,6 +514,11 @@ TEST_MATRIX=(
 	"  CX1-4  CX2-4:P2  .    C5-6      .     .      .   P1:C3-6  0 A1:1|A2:2-4|B1:5-6 \
 								       A1:P0|A2:P2:B1:P-1 2-4"
 
+	# CPU 0 cannot be used in an isolated partition
+	"  CX0-4     .      .      .       P2    .      .      .     0 A1:0-4 A1:P-2"
+	"  CX0-4  C0-2:P1   .      .       .     P2     .      .     0 A1:0-4:A2:0-2 A2:P-2"
+	"  CX0-4  C3-4:P2   .      .       .    C0-2    .      .     0 A1:0-4:A2:0-2 A2:P-2"
+
 	# When multiple partitions with conflicting cpuset.cpus are created, the
 	# latter created ones will only get what are left of the available exclusive
 	# CPUs.
@@ -525,8 +538,8 @@ TEST_MATRIX=(
 
 	# A middle isolated parent shrunk below coverage: the released CPUs of
 	# an invalidated child stay isolated as a higher ancestor still covers them.
-	" CX0-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:0-1,3-4|A2:2|A3:2 \
-								       A1:P2|A2:P2|A3:P-2 0-4"
+	" CX1-4:P2 CX2-4:P2 CX3-4:P2 .     .     X2     .      .     0 A1:1,3-4|A2:2|A3:2 \
+								       A1:P2|A2:P2|A3:P-2 1-4"
 
 	# When an isolated partition child with root partition parent is invalidated,
 	# its effective xcpus will be removed from isolated_cpus.
@@ -618,20 +631,20 @@ ISOLCPUS_TEST_MATRIX=(
 	" CX1-2,I:X1,I:P1 . .      .     X1,2,I  .      .      .     0 A1:1-2,I|XA1:1-2,I A1:P-1 ."
 )
 
-# Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 0-7
+# Test matrix to be run when boot time nohz_full CPUs cover all CPUs except CPUs 1-7
 # This also means that CPU 8 is available and is a nohz_full CPU.
 NOHZ_FULL_TEST_MATRIX=(
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
 	# Using all the nohz_full HK CPUs 0-7 in isolated partition is not allowed
-	" C0-7       .      .      .      P2     .      .      .     0 A1:0-7 A1:P-2 ."
-	" C2-7:P2    .      .      .     C0-4    .      .      .     0 A1:0-4 A1:P2 0-4"
-	" C1-7:P2 C5-7:P2   .      .       .     .      .    C0:P2   0 A1:1-4|A2:5-7|B1:0
-								       A1:P2|A2:P2|B1:P-2 1-7"
+	" C1-7       .      .      .      P2     .      .      .     0 A1:1-7 A1:P-2 ."
+	" C2-7:P2    .      .      .     C1-4    .      .      .     0 A1:1-4 A1:P2 1-4"
+	" C2-7:P2 C5-7:P2   .      .       .     .      .    C1:P2   0 A1:2-4|A2:5-7|B1:1
+								       A1:P2|A2:P2|B1:P-2 2-7"
 	# An isolated child partition cannot grow to take over the last
 	# housekeeping CPU when its parent expands the exclusive CPUs.
-	" C0-8:X1-8:P1 CX0-8:P2 .  .     X0-7    .      .      .     0 A1:0-7|A2:0-7 A1:P1|A2:P-2 ."
-	" C0-8:X0-6:P1 CX0-8:P2 .  .     X2-8    .      .      .     0 A1:|A2:2-8 A1:P1|A2:P2 2-8"
+	" C1-8:X1-8:P1 CX1-8:P2 .  .     X1-7    .      .      .     0 A1:0-7|A2:0-7 A1:P1|A2:P-2 ."
+	" C1-8:X0-6:P1 CX1-8:P2 .  .     X2-8    .      .      .     0 A1:|A2:2-8 A1:P1|A2:P2 2-8"
 )
 
 #
-- 
2.56.1

