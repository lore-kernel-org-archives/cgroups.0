Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240576;
	b=Exsfh4s3D1bpf0/mMOjT7ZeMJ7jsUoUcTK3EIXmuJkFdRkMFPQ07MT3lvn+306ZUenLm
	 1SAGZI9MVkRO39KmFpks04JuW9iHFEdprF7NNkFgHS2yhrYZrwqPj9V57OENZ0MVM/qEU
	 LUkmWe68joovYRlH7K+PqJIgawzY8Aj1dme8ZXzSNMys8VzO5PJNSk1PCC5mAmjc/+m+k
	 Jbbchh4NAjf3dqPsOtJTDrPvmlbZYvFKzFpogk13udobbD5bWvFYYCo3rG/GSAJJHCeO1
	 fShQnPOnSDy1fJ2xZsLqZ+MtZBp96yNDlVr5drgnoaqq9b/Chd0i/UDMbq9F8HhZIdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240576;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=c8hJ4Syg/g0hE3TbMaMdcwj/ifhECY2wBJ1FoLYtHZY=;
	b=22QoScKpCiBYsXOlDUwwNd6ogYPZPd2b3Y/0WtD35M/6V0bCofSu3pz6Lwno9HJVMty4
	 NRDc5AhA9ueR6znIAg/VEfqF48In5TX3K9CMpu4ZJ7jUdX529jyJPPKIAI6pFdDIL9gX6
	 xweePM+ccAO0vxn3KNcNKaKkXRnpYsGp5a5D9GvSXL8l23MNoI2/nRDQ1MkqKJRm+CBMR
	 o2vOXw3XxZ2bXY0+fJU8e2bXTaENERA5otj1m+1z96ckgJFXhGyUCDrq6UwkptKRmbeYb
	 95a6gb1viKMFOk+LmSUagYhqFEeBUXBUsTCJDltjPUvJ2jL4EYpxdLF3PvMvcw9CqYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IBDaptE+;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FBD606A32A
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:09:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9FBD606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IBDaptE+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794240574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c8hJ4Syg/g0hE3TbMaMdcwj/ifhECY2wBJ1FoLYtHZY=;
	b=IBDaptE+71m3ip6biAdnrNR0m10hnKfEt5583XycWhh4NkO2R6sivlWfPNzzUIeCGFCX+J
	vjzBEU4EH5WwFhmhx5B1yR2cSMYDP01JfpFiZzkR6bYcHrY5JFGhA2Lu/8iqGjsoauhx58
	aw2ZMfVUlof22Z1seXY+664BXkEncTA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-364-ntnGMztqNzK18mHC-Wg46g-1; Mon,
 09 Nov 2026 11:09:31 -0500
X-MC-Unique: ntnGMztqNzK18mHC-Wg46g-1
X-Mimecast-MFC-AGG-ID: ntnGMztqNzK18mHC-Wg46g_1794240570
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76732180065F;
	Mon,  9 Nov 2026 16:09:29 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7210339204;
	Mon,  9 Nov 2026 16:09:27 +0000 (UTC)
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
Subject: [PATCH 1/5] selftests/cgroup: Fix "test_cpuset_prs.sh -v" failures
Date: Mon,  9 Nov 2026 11:09:08 -0500
Message-ID: <20261109160912.1369897-2-longman@redhat.com>
In-Reply-To: <20261109160912.1369897-1-longman@redhat.com>
References: <20261109160912.1369897-1-longman@redhat.com>
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

When the -v option is used to run test_cpuset_prs.sh, it activates the
use of sched-debug to determine the set of isolated CPUs which will
also consider 1-CPU partition as being isolated though they will not be
reflected in "cpuset.cpus.isolated". As a result, some of the expected
isolated CPUs values have 2 different set of values to correspond to
these two ways of determining isolated CPUs.

Commit 6e4834ba8986 ("cgroup/cpuset: Fix incorrect CPU accounting with
parent's effective_xcpus expansion") introduces some new test cases
which fail when the -v option is used. Update the test cases to make
them pass with the -v option as well.

Also remove an obsolete comment in update_parent_effective_cpumask()
of cpuset.c.

Reported-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/lkml/886a562b52b1c5094142d547a8336457@kernel.org
Fixes: 6e4834ba8986 ("cgroup/cpuset: Fix incorrect CPU accounting with parent's effective_xcpus expansion")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                            |  6 ------
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 13 ++++++++-----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3052413e41e7..40e7d33847f7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2157,12 +2157,6 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			else
 				part_error = PERR_NOTEXCL;
 		}
-		/*
-		 * When both cs and parent remain valid, parent's
-		 * compute_partition_effective_cpumask() call would have removed
-		 * cs's effective_xcpus from the parent's effective_cpus. So
-		 * there is no need to adjust parent's effective_cpus here.
-		 */
 	}
 
 write_error:
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index bdca6c471f87..3835b97f7a8b 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -534,16 +534,19 @@ TEST_MATRIX=(
 
 	# The extra CPUs gained by a child partition when its parent expands the
 	# exclusive CPUs have to be taken away from the parent.
-	" C2-6:X2-5:P1 CX3-6:P1 \
-	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P1 ."
-	" C2-6:X2-5:P1 CX3-6:P2 \
-	                    .      .    X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P2 3-6"
+	" C2-6:X2-5:P1 CX4-6:P1 \
+	                    .      .    X2-6     .      .      .     0 A1:2-3|A2:4-6|XA2:4-6 \
+								       A1:P1|A2:P1 ."
+	" C2-6:X2-5:P1 CX4-6:P2 \
+	                    .      .    X2-6     .      .      .     0 A1:2-3|A2:4-6|XA2:4-6 \
+								       A1:P1|A2:P2 4-6"
 
 	# Both expansion and contraction of parent's effective_xcpus will be
 	# correctly handled in child partition and the child can be invalidated
 	# if a populated parent could lose all its effective_cpus.
 	" C2-6:X2-5:P1 CX3,5-6:P2 \
-	                    .      .    X4-6     .      .      .     0 A1:4|A2:5-6|XA2:5-6 A1:P1|A2:P2 5-6"
+	                    .      .    X4-6     .      .      .     0 A1:4|A2:5-6|XA2:5-6 \
+								       A1:P1|A2:P2 4-6|5-6"
 	" C2-6:X2-5:P1 CX3-6:P2 \
 	                    .      .   T:X4-6    .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
 
-- 
2.56.0

