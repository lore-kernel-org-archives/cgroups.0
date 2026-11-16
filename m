Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794792248;
	b=1Y0oqSATRh8HZ6HzpeqgqIoaObT6ZvVXdfguc8N2msdA8Vrn6zxXo8IXLTwZmp58WYpS
	 QEHxoeiQhJqtl4jaaJxHiPjk4Mmb102aVsGhXdAOp5K+XtAODhOl2B67XPpgHxhyppfmL
	 yMVYL2zJpNL1eOyRwlzKrq0STN5Q5zAio9Fgzx/gf+pBTarJECPR9owLNzH/KeMiwgPZ1
	 +t6xGvmkvTpJL3kDq8tIYIcTSvi6JarGlckfKEqxi8/T1ZBaktpDGUsisWCNuzDsvIuYm
	 ruG/qmQLTShmG3FmezuNJ+MUpFHT1SqIgbs078Lw+UujHcG529RbdfQY9v3zmjmStCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794792248;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=zScILb2+bdZUax4SsAIDkJqxTMzWrR5rjecRcds0N8o=;
	b=pRquYZ6ehDahLpEqplzEs4IsfoQzHGlF3AHA/WJm4vSuF6oEr/RrUNNxn83PVsDZ2+9Z
	 wIp+dsLN5kDtcyG0H0udvIJ/CpVvlwdXrgsZMQLt5CSXQ4IQ2LGFKbFF5AUBc2qyN2tar
	 f0mTjqObc6fdALOAWjAmu/gJalUISHrAvrhrezzpsc36HlZjqJzG/5C7unE7I6RazMWxp
	 TXU8ir6eGP6yqy1wfIDpiNm2pWvMUJgxYQpKbN6hou+agyOGoaSq3a8ZMFXpoyp9NQl9B
	 +Dek1IztET/7qlor1iDBDydVJ90eAGpo9kc32RerC4+wXEOBNm0Yeyf8dzWxTpY08XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KzgEX1d5;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1269606A881
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 01:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1269606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=KzgEX1d5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794792247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zScILb2+bdZUax4SsAIDkJqxTMzWrR5rjecRcds0N8o=;
	b=KzgEX1d5qtvLIUYkyxIMWBsVHOJfQwBzBt0hh/kZErpLyW+XBCnzcdQpK/uAYHLUlluIJ9
	eVAjlMw5mrmFwUT3bh+GZz83wytY7VywvlsyJ4k2U6lRcmV2YoYw78rkvFwkbUekZiEJR4
	c/uLcU8j6P5+n5aff+d4zbYYEhMv5/E=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-6HUUTPTMOUiktlFV85qaxw-1; Sun,
 15 Nov 2026 20:24:01 -0500
X-MC-Unique: 6HUUTPTMOUiktlFV85qaxw-1
X-Mimecast-MFC-AGG-ID: 6HUUTPTMOUiktlFV85qaxw_1794792240
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6AAD180034E;
	Mon, 16 Nov 2026 01:23:59 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 29CBF589;
	Mon, 16 Nov 2026 01:23:58 +0000 (UTC)
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
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH-next v4 5/6] cgroup/cpuset: Handle remote partitions before local partitions in cpuset_handle_hotplug()
Date: Sun, 15 Nov 2026 20:23:08 -0500
Message-ID: <20261116012330.2271010-6-longman@redhat.com>
In-Reply-To: <20261116012330.2271010-1-longman@redhat.com>
References: <20261116012330.2271010-1-longman@redhat.com>
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

When there is a valid remote partition underneath an invalid local
partition with subpartitions_cpus cleared because of missing active
CPUs in the top_cpuset partition, the current iteration logic in
cpuset_handle_hotplug() will handle the invalid local partition first
and potentially make the local partition valid. The remote partition
will be handled later with the potential that both the local and remote
partitions will be valid with overlapping exclusive CPUs violating the
cpu exclusivity rule.

Fix this problem by adding a new remote_partition_scan() helper to
iterate the existing remote partitions first before iterating down
the hierarchy to handle the local partitions. That also means that
when subpartitions_cpus is cleared, remote partitions have precedence
to acquire the exclusive CPUs first before local partitions. It also
gives remote partition the ability to recover from the clearing of
subpartitions_cpus as all the remote partitions will be disabled before
this commit.

A remote partition can only be created if there is at least one active
CPU in its effective_xcpus. So remote_partition_scan() will also
invalidate the remote partition if there is no active CPU left in its
effective_xcpus. This requires a minor change in a test_cpuset_prs.sh
test case where a remote partition with no active CPU left will now
be invalidated.

With the addition of the remote_partition_scan() call in
cpuset_handle_hotplug(), there is no longer a need to do a remote
partition check in cpuset_hotplug_update_tasks() and the corresponding
code can be removed.

While at it, the subpartition_cpus clearing logic is enhanced to
clear it when no domain housekeeping CPUs are left in the top_cpuset
partition. When the remote partition is disabled, the effective_cpus
is modified in a such a way that cpus_updated will be set true later
in cpuset_hotplug_update_tasks() so that the CPU affinity of the
tasks within the partition will be updated. This will also fix a
bug reported by sashiko that CPU affinity will not be updated when
remote_partition_disable() is called in such circumstance.

When efffective_cpus is read during this interim period, the content
will be invalid before and after this commit.

Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
Reported-by: Guopeng Zhang <guopeng.zhang@linux.dev>
Link: https://lore.kernel.org/lkml/fe7aa630-d323-4981-9f89-0958cb6204a2@linux.dev
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-ab90f7e8-0d60-40ca-83e9-e405075b24d2
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c                        | 97 ++++++++++++++++---
 .../selftests/cgroup/test_cpuset_prs.sh       |  2 +-
 2 files changed, 84 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0fe9f2731fee..64cbcbdbf6da 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -153,6 +153,12 @@ static cpumask_var_t	isolated_cpus;		/* CSCB */
  */
 static struct list_head remote_children;	/* RWCS */
 
+/*
+ * Temporary cpumask for local cpumask computation
+ * The cpumask may be changed when a cpuset helper is being called.
+ */
+static cpumask_var_t	tmp_cpus;		/* RWCS */
+
 /*
  * Set if housekeeping cpumasks are to be updated.
  */
@@ -1873,6 +1879,67 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	remote_partition_disable(cs, tmp);
 }
 
+/**
+ * remote_partition_scan: scan remote partitions to check exclusive CPUs
+ * @tmpmask: ptr to tmpmasks structure
+ *
+ * This function is called in cpuset_handle_hotplug() after the update on
+ * top_cpuset.effective_cpus when there is cpu online/offline operation.
+ * As subpartitions_cpus may have been cleared, we need to check if the remote
+ * partition should acquire the exclusive CPUs again without impacting
+ * effective_cpus or it needs to be disabled when one or more of the following
+ * conditions is true.
+ * 1) All the domain housekeeping CPUs in the top_cpuset will be taken away
+ * 2) A populated partition with no active CPU or no active CPU in
+ *    effective_xcpus
+ */
+static void remote_partition_scan(struct tmpmasks *tmp)
+{
+	struct cpuset *cs, *next;
+
+	rcu_read_lock();
+	list_for_each_entry_safe(cs, next, &remote_children, remote_sibling) {
+		bool noxcpus = !cpumask_subset(cs->effective_xcpus, subpartitions_cpus);
+		bool nocpus = !cpumask_intersects(cs->effective_xcpus, cpu_active_mask) ||
+			      (!cpumask_intersects(cs->effective_cpus, cpu_active_mask) &&
+			       partition_is_populated(cs, NULL));
+		int cpu;
+
+		cpumask_and(tmp_cpus, top_cpuset.effective_cpus,
+			    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
+		if (noxcpus && !nocpus && !cpumask_subset(tmp_cpus, cs->effective_xcpus)) {
+			/*
+			 * Reacquire exclusive CPUs & update top_cpuset.effective_cpus
+			 */
+			spin_lock_irq(&callback_lock);
+			cpumask_andnot(subpartitions_cpus, subpartitions_cpus,
+				       cs->effective_xcpus);
+			cpumask_andnot(top_cpuset.effective_cpus, top_cpuset.effective_xcpus,
+				       cs->effective_xcpus);
+			spin_unlock_irq(&callback_lock);
+			continue;
+		}
+
+		if (noxcpus || nocpus || cpumask_empty(tmp_cpus)) {
+			/*
+			 * Disable remote partition & modifiy effective_cpus
+			 * so that cpus_updated will be set true in
+			 * cpuset_hotplug_update_tasks().
+			 */
+			WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
+			remote_partition_disable(cs, tmp);
+			cpu = cpumask_first(cs->effective_cpus);
+			spin_lock_irq(&callback_lock);
+			if (cpu < nr_cpu_ids)
+				cpumask_clear_cpu(cpu, cs->effective_cpus);
+			else
+				cpumask_set_cpu(0, cs->effective_cpus);
+			spin_unlock_irq(&callback_lock);
+		}
+	}
+	rcu_read_unlock();
+}
+
 /**
  * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state
@@ -3919,6 +3986,7 @@ int __init cpuset_init(void)
 	BUG_ON(!zalloc_cpumask_var(&subpartitions_cpus, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&isolated_cpus, GFP_KERNEL));
 	BUG_ON(!zalloc_cpumask_var(&isolated_hk_cpus, GFP_KERNEL));
+	BUG_ON(!alloc_cpumask_var(&tmp_cpus, GFP_KERNEL));
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
@@ -3993,14 +4061,6 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	if (!tmp || !cs->partition_root_state)
 		goto update_tasks;
 
-	if (is_remote_partition(cs) &&
-	    (!cpumask_subset(cs->effective_xcpus, subpartitions_cpus) ||
-	     (cpumask_empty(&new_cpus) && partition_is_populated(cs, NULL)))) {
-		WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
-		remote_partition_disable(cs, tmp);
-		compute_effective_cpumask(&new_cpus, cs, parent);
-	}
-
 	/*
 	 * Force the partition to become invalid if either one of
 	 * the following conditions hold:
@@ -4104,22 +4164,31 @@ static void cpuset_handle_hotplug(void)
 		if (!on_dfl)
 			cpumask_copy(top_cpuset.cpus_allowed, &new_cpus);
 		/*
-		 * Make sure that CPUs allocated to child partitions
-		 * do not show up in effective_cpus. If no CPU is left,
-		 * we clear the subpartitions_cpus & let the child partitions
-		 * fight for the CPUs again.
+		 * Make sure that CPUs allocated to child partitions do not
+		 * show up in effective_cpus. If no housekeeping CPU is left,
+		 * we clear the subpartitions_cpus, scan the remote partitions
+		 * to determine if they can remain valid & let the descendant
+		 * local partitions fight for the CPUs again.
 		 */
 		if (!cpumask_empty(subpartitions_cpus)) {
+			cpumask_andnot(&new_cpus, cpu_active_mask,
+				       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 			if (cpumask_subset(&new_cpus, subpartitions_cpus)) {
 				cpumask_clear(subpartitions_cpus);
+				cpumask_copy(&new_cpus, cpu_active_mask);
 			} else {
-				cpumask_andnot(&new_cpus, &new_cpus,
+				cpumask_andnot(&new_cpus, cpu_active_mask,
 					       subpartitions_cpus);
 			}
 		}
 		cpumask_copy(top_cpuset.effective_cpus, &new_cpus);
 		spin_unlock_irq(&callback_lock);
-		/* we don't mess with cpumasks of tasks in top_cpuset */
+		/*
+		 * We don't mess with cpumasks of tasks in top_cpuset, but we
+		 * have to examine impact on remote partition roots if present.
+		 */
+		if (cpuset_v2() && ptmp)
+			remote_partition_scan(ptmp);
 	}
 
 	/* synchronize mems_allowed to N_MEMORY */
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 81f0eecaca80..5c7b583cba18 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -378,7 +378,7 @@ TEST_MATRIX=(
 	# Remote partition offline tests
 	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 .   0 A1:0-1|A2:1|A3:3 A1:P0|A3:P2 2-3"
 	"   C0-3    C1-3  C2-3     .    X2-3   X2-3 X2-3:P2:O2=0 O2=1 0 A1:0-1|A2:1|A3:2-3 A1:P0|A3:P2 2-3"
-	"   C0-3    C1-3   C3      .    X2-3   X2-3    P2:O3=0   .   0 A1:0-2|A2:1-2|A3: A1:P0|A3:P2 3"
+	"   C0-3    C1-3   C3      .    X2-3   X2-3    P2:O3=0   .   0 A1:0-2|A2:1-2|A3:1-2 A1:P0|A3:P-2 3|"
 	"   C0-3    C1-3   C3      .    X2-3   X2-3   T:P2:O3=0  .   0 A1:0-2|A2:1-2|A3:1-2 A1:P0|A3:P-2 3|"
 
 	# An invalidated remote partition cannot self-recover from hotplug
-- 
2.56.0

