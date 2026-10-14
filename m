Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7564A541E44
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986798; cv=none; b=sUKSt28kVucFEAfeODHlokEINmdmo9SrNrDUnF+VEFi6K8rEecGl7Unz6ZDDFoNAnQX77j09sZ0tu1H9gykeqVfNC5zr04lwTxRjFD/3ygIL3r7Y+YEmeriziHGJCPoBcJrCUh2MsnCasrtnGFlJePqZdIG8IDk6iwK9LqIfFXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986798; c=relaxed/simple;
	bh=1S6V3BBmV/FRBQZzigWlCu+O7+/Gj7IFuk0w6N/11FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpmrEUDbj3Z0+/oWJTqd5Ka3kQIiQfo7urwqU3RMz/Jfqt+sDDpENpPBO103kM/JWUgvSUNgnP2ZoQgQv8IOocDUQPoOOvd8vIIUg2hbILEBOMgUYb4Od9O3NBLS/KEwSLQz8a5n+/kT7Qkrn1VYIGL69NRYTU7RB5ti9jLjdjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZJ5pB5lE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZJ5pB5lE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wGU+yhb3bVje6hDfkLGUe+XAk9XLTdvAsG9YvpbpH4=;
	b=ZJ5pB5lEMHglieosogmUo0T5PXC6hFFYZ3/sPI+moXhiDRBoQGGqI4B4zsAxZjIDo0oxFU
	FnJn1cdiYv21d3RIREj2PGgsVGh2jken1xXjVHnjNTYCRQhzI3z5FvrGoDuJsVq5Ak+7jt
	B1/CQWjHRDJvnPgiLybX5sGCMTjlMPU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-NwWOrrnEN5OMaDF-hulfig-1; Wed,
 14 Oct 2026 14:06:23 +0000
X-MC-Unique: NwWOrrnEN5OMaDF-hulfig-1
X-Mimecast-MFC-AGG-ID: NwWOrrnEN5OMaDF-hulfig_1791986780
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A85931800772;
	Wed, 14 Oct 2026 14:06:20 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AD62C418;
	Wed, 14 Oct 2026 14:06:18 +0000 (UTC)
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
Subject: [PATCH-next v3 6/9] cgroup/cpuset: Don't allow a child root partition under an isolated parent
Date: Wed, 14 Oct 2026 10:05:45 -0400
Message-ID: <20261014140548.575122-7-longman@redhat.com>
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

Although it is not typical for real users to create a complicated nested
partition hierarchy, it is currently allowed to create nested root and
isolated partitions. In addition, disabling or invalidating a partition
should always be allowed especially when the cpuset is being deleted.

With a nested root and isolated partition hierarchy, it is possible
that all active housekeeping CPUs can be exhausted when disabling or
invalidating a root partition and returning its CPUs to the isolated
parent.

One way to avoid this problem is to disallow the creation of a root
partition under an isolated parent. It is indeed a new limitation imposed
on the existing cpuset partition functionality. However an isolated
partition is usually a left node where scheduling and some other kernel
noises are disabled. It doesn't make much sense to create a child root
partition under an isolated parent and remove some CPUs from the set
of isolated CPUs again. Creation of a child isolated partition under a
root or isolated parent is still allowed.

The cgroup-v2 documentation is also updated to reflect this new
limitation. New test cases are added to test_cpuset_prs.sh to verify
this new behavior. Some existing test cases are also updated accordingly.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst           |  4 +++-
 kernel/cgroup/cpuset-internal.h                   |  1 +
 kernel/cgroup/cpuset.c                            | 13 +++++++++++++
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 14 ++++++++------
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index bd8c80f3bbc9..2c445829e24d 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2767,7 +2767,9 @@ Cpuset Interface Files
 	be retained, but behaves more like a "member".
 
 	All possible state transitions among "member", "root" and
-	"isolated" are allowed.
+	"isolated" are allowed with the exception that a local child
+	"root" partition is not allowed to be created under an "isolated"
+	parent partition.
 
 	On read, the "cpuset.cpus.partition" file can show the following
 	values.
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 5da9c91295b0..2e44dc8634dc 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -35,6 +35,7 @@ enum prs_errcode {
 	PERR_HKEEPING,
 	PERR_ACCESS,
 	PERR_REMOTE,
+	PERR_ISOPARENT,
 };
 
 /* bits in struct cpuset flags field */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 40c004386af0..681701ba46e1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -60,6 +60,7 @@ static const char * const perr_strings[] = {
 	[PERR_HKEEPING]  = "partition config conflicts with housekeeping setup",
 	[PERR_ACCESS]    = "Enable partition not permitted",
 	[PERR_REMOTE]    = "Have remote partition underneath",
+	[PERR_ISOPARENT] = "Root partition is not allowed with isolated parent",
 };
 
 /*
@@ -2865,6 +2866,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	int err = PERR_NONE, old_prs = cs->partition_root_state;
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
+	int parent_prs = parent->partition_root_state;
 	bool isolcpus_updated = false;
 	bool disable_partition = false;
 
@@ -2910,6 +2912,14 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			enum partition_cmd cmd = (new_prs == PRS_ROOT)
 					       ? partcmd_enable : partcmd_enablei;
 
+			/*
+			 * It is not allowed to create a root partition under
+			 * an isolated parent partition.
+			 */
+			if ((new_prs == PRS_ROOT) && (parent_prs == PRS_ISOLATED)) {
+				err = PERR_ISOPARENT;
+				goto out;
+			}
 			err = update_parent_effective_cpumask(cs, cmd, NULL, &tmpmask);
 		} else {
 			err = remote_partition_enable(cs, new_prs, &tmpmask);
@@ -2922,6 +2932,9 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		if (prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
 			disable_partition = true;
 			err = PERR_HKEEPING;
+		} else if (parent_prs == PRS_ISOLATED) {
+			disable_partition = true;
+			err = PERR_ISOPARENT;
 		} else {
 			isolcpus_updated = true;
 		}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 874a8a161236..85a4f87840b4 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -288,16 +288,12 @@ TEST_MATRIX=(
 								       A1:P0|A2:P1|A3:P0|B1:P1"
 	"   C0-3    C1-3   C3     C4    X2-3  X2-3:P1   P2     P1    0 A1:0-1|A2:2|A3:3|B1:4 \
 								       A1:P0|A2:P1|A3:P2|B1:P1 2-4|3"
-	"   C0-4    C1-4  C2-4     .    X2-4  X2-4:P2  X4:P1    .    0 A1:0-1|A2:2-3|A3:4 \
-								       A1:P0|A2:P2|A3:P1 2-4|2-3"
-	"   C0-4    C1-4  C2-4     .    X2-4  X2-4:P2 X3-4:P1   .    0 A1:0-1|A2:2|A3:3-4 \
-								       A1:P0|A2:P2|A3:P1 2"
 	" C0-4:X2-4 C1-4:X2-4:P1 C2-4:X4:P2 \
 				   .      .      X5      .      .    0 A1:0-4|A2:1-4|A3:2-4 \
 								       A1:P0|A2:P-1|A3:P-2 ."
-	" C0-4:X2-4 C1-4:X2-4:P2 C2-4:X4:P1 \
+	" C0-4:X2-4 C1-4:X2-4:P1 C2-4:X4:P2 \
 				   .      .      .      X1      .    0 A1:0-1|A2:2-4|A3:2-4 \
-								       A1:P0|A2:P2|A3:P-1 2-4"
+								       A1:P0|A2:P1|A3:P-2 ."
 	" CX1-3:P1 CX1-3  CX1-3    .      .      .      P1      .    0 A1:1-3|A2:1-3|A3:1-3 \
 								       A1:P1|A2:P0|A3:P-1"
 
@@ -430,6 +426,12 @@ TEST_MATRIX=(
 	# cpuset.cpus can become empty with task in it as it inherits parent's effective CPUs
 	"   C1-3    C2      .      .       .    T:C     .      .     0 A1:1-3|A2:1-3"
 
+	# Creation of root partition under an isolated partition is not allowed
+	"  C1-3:P2  C2      .      .       .     P1     .      .     0 A1:1-3|A2:2 A1:P2|A2:P-1 1-3"
+	"  C1-3:P2  C2      .      .       .     P2     .      .     0 A1:1,3|A2:2 A1:P2|A2:P2  1-3"
+	"  C1-3:P2 C2:P2    .      .       .     P1     .      .     0 A1:1-3|A2:2 A1:P2|A2:P-1 1-3"
+
+	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
 	# Failure cases:
-- 
2.55.0

