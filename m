Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9CF52FE5F
	for <cgroups@vger.kernel.org>; Wed, 14 Oct 2026 14:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791986796; cv=none; b=blNBD3F9YrQGt3e60OT1xBdAqAkXiZ7Z/L5ufs4x9CZ5WfPEKT1qSF6qcv1VtwT/1Zxd8BtEaWFUa7t3ngaxPJ+VJ1R9hd8rCWrN7L+3K/oEFxBg/9XySsBSTtZ2Ea4sAjphwE4fUH0leWLHjg9XrtKbfJHLzx/N/cwtx5TsurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791986796; c=relaxed/simple;
	bh=IyaXiRi2vGT4v2v75xUyjIT134CwYrOeclRoHbLRYpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjROwc1xPrz4MQmhwYYFwPnjnxorWD661TP+IlfRRfCX2ROngnuiq2ztPWYqETj4MLA0APw7j0iN7PZtwjVVMDOMmuxV7p6O5OPPoWclz380Tk2UgQ9/dR/Dn39Z/Po4GYISVVhc500UlLce7amNaRE5N5lKseAl82Y3TaaYBvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gJjU70or; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJjU70or"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791986789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BxHO6lz82BJDiiEDCEj3X3Q8OHvZmTIag4+2sa6fuE0=;
	b=gJjU70orbHbyW2HjFmWLz8oLq36suIsgtuMis4180JeY8zisbhQVQjAmCocXRYKjMJBswC
	2aGRUjQZhAibNXCch0ymuAutRvrvuQ47VNJdt5FsCJPAh5fVZHyiSMicXpGusICZ/fq1Yl
	OLIDSgv8Dzz10IAmP8XcI1nS+C3QiVY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-AiygLJUOO66y2JQk0BvtJw-1; Wed,
 14 Oct 2026 14:06:21 +0000
X-MC-Unique: AiygLJUOO66y2JQk0BvtJw-1
X-Mimecast-MFC-AGG-ID: AiygLJUOO66y2JQk0BvtJw_1791986778
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7165D1800651;
	Wed, 14 Oct 2026 14:06:18 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.rmtusnh.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4F262362;
	Wed, 14 Oct 2026 14:06:16 +0000 (UTC)
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
Subject: [PATCH-next v3 5/9] cgroup/cpuset: Properly disabling partition when partition state switching fails
Date: Wed, 14 Oct 2026 10:05:44 -0400
Message-ID: <20261014140548.575122-6-longman@redhat.com>
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
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 51723c299ca5..40c004386af0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2866,6 +2866,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
+	bool disable_partition = false;
 
 	if (old_prs == new_prs)
 		return 0;
@@ -2918,15 +2919,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * A change in load balance state only, no change in cpumasks.
 		 * Need to update isolated_cpus.
 		 */
-		if (prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
+		if (prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
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
@@ -2935,7 +2942,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 		/*
 		 * Invalidation of child partitions will be done in
-		 * update_cpumasks_hier().
+		 * update_cpumasks_hier() below.
 		 */
 	}
 out:
@@ -2954,8 +2961,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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

