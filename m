Received: from mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37173D5244
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033632; cv=none; b=ev10gJNmRt2vjtrEqMru/OFBATo4g4SjMmmCfLfC8MdWpmiv3yZqdXhrqx+8aBjdxX70KXmp9BFrQwy3+kxXmcGN3b4HbP6I7yCWa/1B31bOUeWG+IgT/3cPu5QGaZI3oecrYilzKc0EtRVyXuhYoGnX70l31kAeoy6Ximb74ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033632; c=relaxed/simple;
	bh=KGHhFFuOAsPvgHwAFUrFwLqfH+pwxNnBrVU009zmgok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxNeyAZMQuFts3hIPx+S0vkvjlGpnQ8pL7bU4mC+fhNMO7xbJXoo2N2o+nTs+gvZiEad8EOSlm6ov56pBKdi545eMvuVBKS6oTljkipP164epWuEH732hdYG/udyI+1Gg8e21XCF3tNTh8sh3eTrw12PbLtkQfh18TjWXkwe2+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o+/1GAKU; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o+/1GAKU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KGHhFFuOAsPvgHwAFUrFwLqfH+pwxNnBrVU009zmgok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033626; v=1; x=1789638426;
 b=o+/1GAKUleYsMFDDe8zY3zgdUxXCJuwb8heQc1T8YeIpLEuW14CxE+vOyNcwYjpzrn+SStR1
 ExImn8LeXS5vlL+82X2MJlx8ZF6Ef5X02LPYEKF1dRYb1Oa5QkRuTl1mKq02SP06jevL2/pneyH
 w6UvIh0csbQ4DTZNEsNfhdnc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4413365a2b343b91;
	Thu, 10 Sep 2026 09:47:06 +0000
X-Mizu-Trace-ID: 4413365a2b343b91
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v4 5/7] cgroup/cpuset: Fix isolation accounting on propagated invalidation
Date: Thu, 10 Sep 2026 17:45:44 +0800
Message-ID: <20260910094546.5852-6-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910094546.5852-1-guopeng.zhang@linux.dev>
References: <20260910094546.5852-1-guopeng.zhang@linux.dev>
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

This can be reproduced on a cgroup v2 system with CPUs 0-3 online:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir propagation-repro
    echo 0-3 > propagation-repro/cpuset.cpus
    echo root > propagation-repro/cpuset.cpus.partition
    echo +cpuset > propagation-repro/cgroup.subtree_control
    mkdir propagation-repro/child
    echo 2-3 > propagation-repro/child/cpuset.cpus
    echo isolated > propagation-repro/child/cpuset.cpus.partition
    echo member > propagation-repro/cpuset.cpus.partition
    cat cpuset.cpus.isolated

Without this fix, CPUs 2-3 remain isolated even though the child is
invalid and its CPUs have returned to the top partition. The expected
dynamic isolated mask is empty.

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
index 7ba26b924086..bbc4868f026b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2277,9 +2277,12 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
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
@@ -2379,7 +2382,18 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
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
