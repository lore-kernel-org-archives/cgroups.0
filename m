Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104733;
	b=JZla+kjurYt7Bu27IIxmBwQqYsI1Vha7cs3o/6X09f0TuEyf2+HyOzAuutK79us1bPmf
	 HhfuJjyULC9Aem3tdh9ZvCXmwRX950RI3SdllL69x2QMayyIb3Kol19ZMPLzil70/4jzc
	 GzHN8HMFsHmZHl8VP9LYgT8JwzQiep07TZp7mc4x/IFekRFxOqbDhIYpJXWIXIQ/tdvgm
	 XRZM0wW6Y6tjJQJYcU+x5yRIWcogYhGRZer5QTpI6oC3dEQMDhgyoZtRjHTh5s2LdWLW4
	 Mtwjz7Dxhbla4itzdfpMnmFPV0MN5nqgKf0EunPLEdW6FZzz2IIqb2MIRx6JcW3+oFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104733;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zQRlKbdi45Fb4to1TV3mDMDiTTP8xbQo1lX9AeY86T4=;
	b=m6AwiXLWVrpRPk8tW63ev/QOFHluKim5jOguOjIZjMcsxYciCK74PtyP7QC9HHeOaMCj
	 jPa8yDiTZMdCzUu/utq/5isDFKYpX7mqUA/9lfr6Bdf1uNR0d7dWWsSOm4Ag9MsUGlA3L
	 ZUKcClvAlBniT9ZY32KL4epMgJk4uyTjZXEEb89cJyoUlZJw6BB3D32tvOc0e/Kcn14d6
	 cxTNXAqoXcDGUZBQIwRSkjMZi4+MwaZbLzhwIDAxKGqm+QxEKZAXOhO+anOl1ceY6V5BD
	 pjtML+Rl5C1WTfgG0SWe6cVcLh5BAd/qI//g8Dt4vE4o9AZdczunklRs4b/kylcuNkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TmpcqLM9;
	arc=none smtp.remote-ip=91.218.175.87
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB5A606A32C
	for <cgroups@vger.kernel.org>; Tue, 27 Oct 2026 12:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CB5A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TmpcqLM9
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=H5/6cghSYjlUdBX/4hU2ACkhZSzFOjZAQQW0OApn7GA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793104730; v=1; x=1793709530;
 b=TmpcqLM9fPDvgmSkt2jl8vLQ4yeldWK8WHxbmhJPgPGVSN2eONf7WqefPme6rcxjkv4GiIjs
 OsO0k2ajo4sIg1411ztVmIl7ev6qV8bjRxWX9Ic/F18YT4k8NgI3ggmlviUAOpBeSkeK0cYu1ua
 /9wsus3HR8nnWPbNscnOyEsc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1ab54019d47de0d5;
	Tue, 27 Oct 2026 12:38:50 +0000
X-Mizu-Trace-ID: 1ab54019d47de0d5
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] cgroup/cpuset: Fix missing effective_xcpus accounting of child partitions
Date: Tue, 27 Oct 2026 20:38:37 +0800
Message-ID: <20261027123837.100909-1-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

When a partition root expands its exclusive CPUs, a valid child
partition will be able to claim more CPUs from its parent. As
update_cpumasks_hier() always updates a cpuset before its descendants,
the parent has already been committed when the child partition is
reached. Its effective_cpus is computed with the child's old
effective_xcpus subtracted and no further adjustment is made
after the child commits its new effective_xcpus.

The additional CPUs are thus granted to both the parent and the child
partitions. generate_sched_domains() then emits the warning below
about the overlapping sched domains:

  WARNING: kernel/cgroup/cpuset.c:919 at rebuild_sched_domains_locked+0x1ec/0x2e0, CPU#21: bash/1225

Fix that by taking the CPUs newly added to a valid child partition
away from its parent at the commit point of update_cpumasks_hier()
right before the new effective_xcpus is committed. The tasks in the
parent cpuset as well as its other children will be updated if its
effective_cpus is changed.

A new test case is added to test_cpuset_prs.sh to test this patch.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c                        | 25 +++++++++++++++++++
 .../selftests/cgroup/test_cpuset_prs.sh       |  4 +++
 2 files changed, 29 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..ec0ef3ad0726 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2241,6 +2241,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		struct cpuset *parent = parent_cs(cp);
 		bool remote = is_remote_partition(cp);
 		bool update_parent = false;
+		bool xcpus_added = false;
 
 		old_prs = new_prs = cp->partition_root_state;
 
@@ -2356,6 +2357,19 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		}
 
 		spin_lock_irq(&callback_lock);
+		/*
+		 * A child partition may claim more CPUs when its parent expands
+		 * the exclusive CPUs. Take the newly granted CPUs away from the
+		 * parent which was committed earlier in this walk.
+		 */
+		if (!remote && new_prs > 0) {
+			compute_excpus(cp, tmp->addmask);
+			if (cpumask_andnot(tmp->delmask, tmp->addmask,
+					   cp->effective_xcpus)) {
+				partition_xcpus_add(new_prs, parent, tmp->delmask);
+				xcpus_added = true;
+			}
+		}
 		cpumask_copy(cp->effective_cpus, tmp->new_cpus);
 		cp->partition_root_state = new_prs;
 		/*
@@ -2375,6 +2389,17 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 
 		cpuset_update_tasks_cpumask(cp, tmp->new_cpus);
 
+		/*
+		 * The parent's effective_cpus may have been changed by
+		 * partition_xcpus_add() above. Update the tasks in the parent
+		 * cpuset and its other children, if necessary.
+		 */
+		if (xcpus_added) {
+			cpumask_copy(tmp->addmask, parent->effective_cpus);
+			cpuset_update_tasks_cpumask(parent, tmp->addmask);
+			update_sibling_cpumasks(parent, cp, tmp);
+		}
+
 		/*
 		 * On default hierarchy, inherit the CS_SCHED_LOAD_BALANCE
 		 * from parent if current cpuset isn't a valid partition root
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 83ef6c781af3..09e430570815 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -437,6 +437,10 @@ TEST_MATRIX=(
 	" CX1-4:P1 CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
 	" CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
 
+	# The extra CPUs gained by a child partition when its parent expands the
+	# exclusive CPUs have to be taken away from the parent.
+	" C2-6:X2-5:P1 C3-6:X3-6:P1 .      .      X2-6     .      .      .     0 A1:2|A2:3-6|XA2:3-6 A1:P1|A2:P1 ."
+
 	# Taking away all CPUs from parent or itself if there are tasks
 	# will make the partition invalid.
 	"  C2-3:P1   C3:P1  .      .      T     C2-3    .      .     0 A1:2-3|A2:2-3 A1:P1|A2:P-1"
-- 
2.43.0

