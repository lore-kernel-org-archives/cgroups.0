Received: from mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EAD44064B
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229776; cv=none; b=KMes4sLPPYS7xSfmj8lEHuLJrWLvtwWaf74qru05brPlOVlA3bM1h67SYFdbLtpSrgdrK3GfYxStQ789IV4RXLmrsdatx3n/8vvI0M34QMv99aieJnqS5qrDD5Bs20yIbZnOYa7O6/mvNJ92Ze7AXHEvlOPmjQYJV0Wa7guoSxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229776; c=relaxed/simple;
	bh=8NOSCQyZWZCO7r3LDcjs74rZ9SleA3lk8hhhzRFnsWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEnKYnw1I5vaEtwyome8qw7+dF8mS3a0qOIblXDHuz5QHPLhfzittm8mN5FoCvrGAz7kZxcJ8B7/xpLY2QoLJEGQ3mxZgVwTvSLt8VvBmNd/ywGRuN/6r2gYSZv3Khfp63cZyKKNVyzN9e71bqyFT55TDLX7r125Ohnz8tsJadI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u1eCZ3gC; arc=none smtp.client-ip=95.215.58.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u1eCZ3gC"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=8NOSCQyZWZCO7r3LDcjs74rZ9SleA3lk8hhhzRFnsWI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229772; v=1; x=1787834572;
 b=u1eCZ3gC5IFZ7MjbxfmiofXcLzAaJdQSnvP6KNt7cPoyksoOv0RV3iZ/8e3qp0Y2J8XH9Nqh
 HjfmAGGBaqAN5R9EkN07dVC+rgfQIFZjdiLeHhr2jud+3V+jgwWbyAsYoxCzs49fLPTGL3/sl1p
 kye+w4CkXF6+161SVxcWTqZM=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 443e87af351c599e;
	Thu, 20 Aug 2026 12:42:52 +0000
X-Mizu-Trace-ID: 443e87af351c599e
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
Subject: [PATCH 08/17] cgroup/cpuset: Release CPUs when a type change is rejected
Date: Thu, 20 Aug 2026 20:41:53 +0800
Message-ID: <20260820124202.517160-9-guopeng.zhang@linux.dev>
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

When a housekeeping check rejects a root-to-isolated or isolated-to-root
change, update_prstate() marks the partition invalid but leaves its
effective_xcpus allocated. Those CPUs remain missing from the partition
which owns the invalidated subtree.

Disable a rejected remote partition with remote_partition_disable().
For a local partition, return effective_xcpus to its parent before
recording the invalid state. Use the complete mask because descendants
are invalidated along with the parent and their CPUs return at the same
time.

Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 853942c1afeb..a616012927be 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3020,10 +3020,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		compute_partition_owned_cpumask(cs, tmpmask.new_cpus);
 		if (((new_prs == PRS_ISOLATED) &&
 		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
-		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus))
+		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus)) {
 			err = PERR_HKEEPING;
-		else
+			if (is_remote_partition(cs)) {
+				WRITE_ONCE(cs->prs_err, err);
+				remote_partition_disable(cs, &tmpmask);
+			} else {
+				spin_lock_irq(&callback_lock);
+				partition_xcpus_del(old_prs, parent, cs->effective_xcpus);
+				spin_unlock_irq(&callback_lock);
+				cpuset_update_tasks_cpumask(parent, tmpmask.new_cpus);
+				update_sibling_cpumasks(parent, cs, &tmpmask);
+			}
+		} else {
 			isolcpus_updated = true;
+		}
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
-- 
2.43.0

