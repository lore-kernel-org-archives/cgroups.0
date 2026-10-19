Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792433453;
	b=VAQT/7Z+7J3R5lAAM68HROQFtq2sM3rzWSSnE4Oj80P4DRoeoTuQqeEOujzROw/5ORdb
	 8RM6Wq9xNTzs7V05pAB1aEMIF86Laa8a2hLsirvasm8f2x+u868rneTwm5ZZK5bLuhPQ3
	 WXSikKZWofEhn4WUuZA0PUIgp5pHyReKd28HccfE0p0YmkdKOPA5ciuuBmspqg/t0pSCh
	 +cQbrOTzfErr0tfXNrduDbVUuTrJgbatg+SJ6wQSlJEdA9lfNTzLfuYv6EE2GkavF/GHd
	 1j7QjJAtIshb11LA2mj5ZygZlnmUToJ3HTrNJilBD0RJIxu2RP8D1mYdrSmS7AKkMSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792433453;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=ZyfpykCvInVMKic3t98t/CnToCYK32/Po5GGPUhKuaE=;
	b=UArkZ9atPvfTa8Zb+mBna5fF7wpuHVFR0ZVUweROfplCwO1kwn8vBe+t0+VjbHNJ9B2x
	 vApQ/W3HB5zWOaWmqJh7PspJJP4hTI6fCRm0T4Osq0Vgpmnclcw6AdyqcbTFtWdQamIAW
	 dh9jnrioGxJq+vdWsG2mOZLyz1UvyJIjvaZM6NbInz0Voc2XBYvQcMbbjfHwMphj0U7F4
	 d86Mr63QRH0cpNJFWdzNtCGw42+VbBhpZkC1Y8ukVGH5laBE9sY0HqdalHbLhyn4ASVZx
	 acHT4+JS3/aqLNseL1KJtt4w5i3Kpm2VEMARopEdpoEhetb03EOBPpstCV9+pO5c9Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DLX1Utpc;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9317460A2636
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 18:10:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9317460A2636
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DLX1Utpc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792433451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZyfpykCvInVMKic3t98t/CnToCYK32/Po5GGPUhKuaE=;
	b=DLX1Utpc2D1eeCYDl01odvdj5VcJ/M0WzaNEAq29OHnjft0Ih0qpkOb3GyCIDC+O4pyZZX
	nZyYUn88dquq+tA/pDyRu9Y8L47p+NIKQzr3NYRTA+AzspbKIYRVB429rTRiurGpYX8RES
	ISnkI8+lU0R7z2p6eLPsJToJ0SNfmYM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-aA_X-Xz1MyGs8CJnOCVWUw-1; Mon,
 19 Oct 2026 18:10:48 +0000
X-MC-Unique: aA_X-Xz1MyGs8CJnOCVWUw-1
X-Mimecast-MFC-AGG-ID: aA_X-Xz1MyGs8CJnOCVWUw_1792433446
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53DEA1956072;
	Mon, 19 Oct 2026 18:10:46 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C5EB6418;
	Mon, 19 Oct 2026 18:10:43 +0000 (UTC)
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
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH-next v4 5/9] cgroup/cpuset: Properly disabling partition when partition state switching fails
Date: Mon, 19 Oct 2026 14:10:16 -0400
Message-ID: <20261019181020.1069325-6-longman@redhat.com>
In-Reply-To: <20261019181020.1069325-1-longman@redhat.com>
References: <20261019181020.1069325-1-longman@redhat.com>
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

Before commit 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full
don't leave any housekeeping"), the partition state can be freely switched
from "root" to "isolated" and vice versa. After that commit, the switch
from "root" to "isolated" can fail if it exhausts all the housekeeping
CPUs. Later on, the switch from "isolated" to "root" can also fail if
some of the partition CPUs are boot-time isolated by "isolcpus".

A local or remote partition is made invalid when the switch fails.
However there are 2 problems with the existing invalidation code.

 1) Both the subpartitions_cpus and isolated_cpus are not properly
    updated.
 2) In the case of remote partition with remote_partition flag set, it
    is not cleared.

Fix this by calling the proper partition disabling function in this case.

On an x86 test system with boot option "isolcpus=10 cgroup_debug" set
and more than 16 cores, the following commands were executed after boot.

  # cd /sys/fs/cgroup
  # echo +cpuset > cgroup.subtree_control
  # cat cpuset.cpus.isolated
  10
  # mkdir A
  # echo 10-12 > A/cpuset.cpus
  # echo isolated > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  isolated

Before the patch:

  # echo root > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  root invalid (partition config conflicts with housekeeping setup)
  # cat cpuset.cpus.isolated .__DEBUG__.cpuset.cpus.subpartitions
  10-12
  10-12

After the patch:

  # echo root > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  root invalid (partition config conflicts with housekeeping setup)
  # cat cpuset.cpus.isolated .__DEBUG__.cpuset.cpus.subpartitions
  10

Reported-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/lkml/7f4c57b26ad120ab30adf35653f1dd94@kernel.org/
Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 046c7ce5a037..5a0a4269e7c0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2928,6 +2928,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
+	bool disable_partition = false;
 
 	if (old_prs == new_prs)
 		return 0;
@@ -2984,15 +2985,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * Need to update isolated_cpus.
 		 */
 		if (prstate_housekeeping_conflict(new_prs, parent_prs,
-						  cs->effective_xcpus, NULL))
+						  cs->effective_xcpus, NULL)) {
+			disable_partition = true;
 			err = PERR_HKEEPING;
-		else
+		} else {
 			isolcpus_updated = true;
+		}
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
 		 * disables child partitions.
 		 */
+		disable_partition = true;
+	}
+
+	if (disable_partition) {
 		if (is_remote_partition(cs))
 			remote_partition_disable(cs, &tmpmask);
 		else
@@ -3001,7 +3008,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 		/*
 		 * Invalidation of child partitions will be done in
-		 * update_cpumasks_hier().
+		 * update_cpumasks_hier() below.
 		 */
 	}
 out:
@@ -3020,8 +3027,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
 	spin_unlock_irq(&callback_lock);
 
-	/* Force update if switching back to member & update effective_xcpus */
-	update_cpumasks_hier(cs, &tmpmask, !new_prs);
+	/* Force update if partition is disabled & update effective_xcpus */
+	update_cpumasks_hier(cs, &tmpmask, disable_partition);
 
 	/* A newly created partition must have effective_xcpus set */
 	WARN_ON_ONCE(!old_prs && (new_prs > 0)
-- 
2.55.0

