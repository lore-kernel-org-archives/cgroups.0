Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDCF399368
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 08:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791620977; cv=none; b=OJ2iv85svhK+hp65/OYn2NtLoFemIV0o/kXyUlJoeUJMxMm3YwQyBN67dzIGOXDEhrlOIJUHdcqvP7Ie01fvsEfSNBXqGJ0TDYMCETdPDXhchaVfQHMOSBFpJZgUxxokB2U/+bMCHtHtL46lq9yOQQbMe9Ec7IVzbRps2Hhzyhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791620977; c=relaxed/simple;
	bh=69rkU4KdlZXuTy87z2fM1CIDP6n7LHUYy3cvXgrW55Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9SLvow+sXHfievEZIZ6IZ4J0wEBAVt3bv6xHqfgmPfAJ/114eKps6vbyxUEYVhnSYRGy739/JlX27kEgjWve4t7LqlJASYaQJTZhOzYtTqbfRTQaeAatooSJ9v5bgRpWDW9WF/lRK075pch5rlhyixWHsxMmlxSopP9ZdJ0g2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kk/hVnJf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kk/hVnJf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791620975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2YlCKNJrZvtdQd2HF97iV8ae0BEX6MulYJuHEq17D/c=;
	b=Kk/hVnJfdqJ9kD7vFY63LYihfPjfcLCWat5GwPMyjOFAuP9SA7wKBk6w85thN0TPOGeetk
	U9PWSuN8lUN1NLCoyCcJp9spVFLrUgusvfsV0tjepifXdOWnAhZkcM9dRFvOXEX4a6tg4V
	j4mMgIPItMwItKHaBNVpsNh+4kDWP0I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-407-HRFUhnvLMMWIR4Qg9oIIpg-1; Sat,
 10 Oct 2026 08:29:32 +0000
X-MC-Unique: HRFUhnvLMMWIR4Qg9oIIpg-1
X-Mimecast-MFC-AGG-ID: HRFUhnvLMMWIR4Qg9oIIpg_1791620970
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65A941800149;
	Sat, 10 Oct 2026 08:29:30 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 937A618002B1;
	Sat, 10 Oct 2026 08:29:27 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH-next 4/5] cgroup/cpuset: Properly disabling partition when partition state switching fails
Date: Sat, 10 Oct 2026 04:28:47 -0400
Message-ID: <20261010082848.193182-5-longman@redhat.com>
In-Reply-To: <20261010082848.193182-1-longman@redhat.com>
References: <20261010082848.193182-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
index 77cf6e8db0f6..aedf08cc6db5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2853,6 +2853,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
+	bool disable_partition = false;
 
 	if (old_prs == new_prs)
 		return 0;
@@ -2910,15 +2911,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 */
 		compute_excpus(cs, tmpmask.new_cpus);
 		if (prstate_housekeeping_conflict(new_prs, parent_prs,
-						  tmpmask.new_cpus, NULL))
+						  tmpmask.new_cpus, NULL)) {
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
@@ -2927,7 +2934,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 		/*
 		 * Invalidation of child partitions will be done in
-		 * update_cpumasks_hier().
+		 * update_cpumasks_hier() below.
 		 */
 	}
 out:
@@ -2946,8 +2953,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
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

