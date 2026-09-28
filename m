Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E7E376A0B
	for <cgroups@vger.kernel.org>; Mon, 28 Sep 2026 23:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790639550; cv=none; b=s18z++dcb548jQ/VduvYOR3JLusNr54e07J8kzEy7Xwr89Xiy1J6FxERzKh2sIRovseLqf3HXI1EIrsZBTvr09xm+lEjl5fm3va5V2ARGXRy+uhURPFKDtiDkVYamjtyrhzIPaVXurQNwAzeJDrVGorM/z02U8kbhZYOXIwdUl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790639550; c=relaxed/simple;
	bh=CHcC2R0/FpBjIYI9QxP7NaTbRmriarLBJYrCjCRrOww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xe5ztJIpDQhoOGW296aQwObBuJVc2qoXgqNZX9kaiDjprt4EhcXsTctUPUdbtyJSsXK6+jM6DDUa+KoXwubiW1yyqNfft3lO92wLL8rnNCAbu+J/mYReK0B/H+iY//nIQk/e7abWopBjSOkKQF4h580pN/z9QQ7wXo6v/ST2rQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GidnOyOD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GidnOyOD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790639548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SoI2AnljE74Mg/9u9kz3KpTxax7C6jzrTY3CpPf5lp0=;
	b=GidnOyODOwrlyOwibB+7MVgMdsxX5yDh/gcRl54tdjbL77Nu31Oszio+d3gMsp/9ZHHuJQ
	V3iW/O0Y8//f3aMaqkvGextBVzbu3uAV4lvu7MMruM85y3q/PPSKYF/VEbdEFplKgMXICO
	3cH8W4E0QyOj3G9WE2aJv77iXaCc5BA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-531-obuXTviePuSGHQeVKy6_4g-1; Mon,
 28 Sep 2026 19:52:24 -0400
X-MC-Unique: obuXTviePuSGHQeVKy6_4g-1
X-Mimecast-MFC-AGG-ID: obuXTviePuSGHQeVKy6_4g_1790639543
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15DEA1828A81;
	Mon, 28 Sep 2026 23:52:23 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9F6C11800345;
	Mon, 28 Sep 2026 23:52:20 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] cgroup/cpuset: Properly disable partition when partition state switching fails
Date: Mon, 28 Sep 2026 19:51:59 -0400
Message-ID: <20260928235159.515654-1-longman@redhat.com>
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

The partition is made invalid when the switch fails. However, the
remote_partition flag for a remote partition can remain set and the CPUs
from the invalidated partition aren't cleared from subpartitions_cpus.
Fix this by properly disable the partition in this case.

In the case of remote_partition flag, it should be cleared for a
invalidated remote partition. To be safe, the reset_partition_data() is
now enhanced to always clear the remote_partition flag. So there is no
need to explicitly clear remote_partition in remote_partition_disable().

On a x86 test system with boot option "isolcpus=10 cgroup_debug" set
and more than 16 cores, the following commands was executed after boot.

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
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4a915da37bb3..9874c25eb83c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1229,6 +1229,7 @@ static void reset_partition_data(struct cpuset *cs)
 
 	lockdep_assert_held(&callback_lock);
 
+	cs->remote_partition = false;
 	if (cpumask_empty(cs->exclusive_cpus))
 		cpumask_clear(cs->effective_xcpus);
 
@@ -1615,7 +1616,6 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 		     !cpumask_empty(subpartitions_cpus));
 
 	spin_lock_irq(&callback_lock);
-	cs->remote_partition = false;
 	partition_xcpus_del(cs->partition_root_state, NULL, cs->effective_xcpus);
 	if (cs->prs_err)
 		cs->partition_root_state = -cs->partition_root_state;
@@ -2892,6 +2892,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
+	bool disable_partition = false;
 
 	if (old_prs == new_prs)
 		return 0;
@@ -2946,27 +2947,32 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 */
 		if (((new_prs == PRS_ISOLATED) &&
 		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
-		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
+		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus)) {
 			err = PERR_HKEEPING;
-		else
+			disable_partition = true;
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
+out:
+	if (disable_partition) {
 		if (is_remote_partition(cs))
 			remote_partition_disable(cs, &tmpmask);
 		else
 			update_parent_effective_cpumask(cs, partcmd_disable,
 							NULL, &tmpmask);
-
 		/*
 		 * Invalidation of child partitions will be done in
-		 * update_cpumasks_hier().
+		 * update_cpumasks_hier() below.
 		 */
 	}
-out:
+
 	/*
 	 * Make partition invalid if an error happens.
 	 */
-- 
2.55.0

