Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800F3446838
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229811; cv=none; b=C5KFsX+TjqaXAvBKOKP7onI6ruonQEYPINlRVBL6OGFINtVlCQ1zV41FVLOIx4S2t7svHlEe/kS37n2RBImN7PveQXuzWepqNIQ3BqFZZQynGeUCfobQlo1qyzgNCkOsrkGoJ4aKenGA4oUJdiUc5uKF5w97NBj0wmjXjTeu8a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229811; c=relaxed/simple;
	bh=oa7CV0E1+lvtQEeDDICkorvhCO/flckvIj0EpmPl71A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbEjdzb5dYn3NR+n5lPpCzGN608DZsxpLMeLdBqRLSPiVWqrRi0drS1ai0BrS9TZ6gLxlh5EeTbYW98hdQoeU5GQbhLsrrafXT1Uonq9B3/4AgGfOgNdtM/nyf7y8Y6nKbOsyceRpG4rqv5cORQeEn3g6Q3n7HKjJypToUp50Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HBoaevG1; arc=none smtp.client-ip=95.215.58.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HBoaevG1"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oa7CV0E1+lvtQEeDDICkorvhCO/flckvIj0EpmPl71A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229807; v=1; x=1787834607;
 b=HBoaevG10QE9Egvnj9FMzskMGtCBMLZzMGyHj+hYqfyeFqoHk5b2e1MZyARGQPu19cHWcst3
 zcDIWO1Fpo8UA7JbTn7oDZBV30k4fYthg5hxwg4CR5XYuQF3fT7MtEmOL/A3ZCL2FO2maw2vswU
 9X1iRCJH2VwP3ivu/LPbBNNY=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 03774eb431ba53d2;
	Thu, 20 Aug 2026 12:43:27 +0000
X-Mizu-Trace-ID: 03774eb431ba53d2
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: longman@redhat.com,
	cgroups@vger.kernel.org
Cc: ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 16/17] cgroup/cpuset: Fix isolated accounting on propagated invalidation
Date: Thu, 20 Aug 2026 20:42:01 +0800
Message-ID: <20260820124202.517160-17-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260820124202.517160-1-guopeng.zhang@linux.dev>
References: <20260820124202.517160-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

update_cpumasks_hier() invalidates a local partition when its parent
becomes a member or an invalid partition. Its CPUs return to the nearest
valid partition ancestor, but isolated_cpus still reflects the old
partition type.

Update isolated_cpus before resetting a local partition whose state
changes from valid to invalid below an invalid parent. Remote partitions
are excluded because remote_partition_disable() already updates their
isolated CPU accounting.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 9e13fc962f41..4af8e348e838 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2236,9 +2236,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
 		struct cpuset *parent = parent_cs(cp);
 		bool remote = is_remote_partition(cp);
+		bool was_remote = remote;
 		bool update_parent = false;
+		int owner_prs;
 
 		old_prs = new_prs = cp->partition_root_state;
+		owner_prs = old_prs;
 
 		/*
 		 * For child remote partition root (!= cs), we need to call
@@ -2338,7 +2341,18 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 			new_prs = cp->partition_root_state;
 		}
 
+		/*
+		 * With no valid parent partition left, this partition's CPUs
+		 * return to the nearest valid partition ancestor.
+		 */
+		if (!was_remote && old_prs > 0 && new_prs < 0 &&
+		    !is_partition_valid(parent))
+			owner_prs = partition_owner(cp)->partition_root_state;
+
 		spin_lock_irq(&callback_lock);
+		if (old_prs != owner_prs)
+			isolated_cpus_update(old_prs, owner_prs,
+					     cp->effective_xcpus);
 		cpumask_copy(cp->effective_cpus, tmp->new_cpus);
 		cp->partition_root_state = new_prs;
 		/*
-- 
2.43.0

