Received: from mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3053FC5AE
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 09:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787911044; cv=none; b=lN1Bx5myHJMA4MebwuwvETRt9pKUarhHViPVGsKO8GT+WsV0Zw47ggb06aX372ByR3Gkuqsm94RPZa7wa4D6w1pWA3codMNb7LLqBHCtcKydahMVVqLlJE6022AT6UXBP19wDdXDMj4WZAWUOQC8Gp0YTbyRjmK2/AY1R8sytMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787911044; c=relaxed/simple;
	bh=pGxEmFRpokolszVFS0u2XnxlhX29tPsz/IoJLXcZUx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lsyil3KO58yT4RmF/ZW7zGewpD5q7AC3Bbfl10tAlraFfj6gt72q2hpCL0wDB5AEjkg74zv5+OG77vbbNVo9GGyqpHxPBbqu0y1HJIpCxLg5DiV3YqHfGNVvYTejjGPjoaduQm/KSXv8YSIvbnbemwZ0rndtJaMyq7XSVk6CfyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YSDsetv2; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YSDsetv2"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pGxEmFRpokolszVFS0u2XnxlhX29tPsz/IoJLXcZUx4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787911039; v=1; x=1788515839;
 b=YSDsetv25khWmIOtyIJFnvCuZBKduYvbssumMAOMZkbBRkPr5xy8Pu3hkmppbw/BmcFjdEDy
 lhWZe5Oq9YyKV+sYQOiXq1AfbwrwqrYhnpmKqe94Z50YEMbLV1nBNLq4U8Tp9zUlVDkDxGwvaj1
 QBrUdAjc56mEu5gHh7ZR340c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c9b0305f262301bf;
	Fri, 28 Aug 2026 09:57:19 +0000
X-Mizu-Trace-ID: c9b0305f262301bf
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: cgroups@vger.kernel.org,
	longman@redhat.com,
	ridong.chen@linux.dev
Cc: tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH v2 5/6] cgroup/cpuset: Release CPUs when type-change validation fails
Date: Fri, 28 Aug 2026 17:56:42 +0800
Message-ID: <20260828095643.13395-6-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260828095643.13395-1-guopeng.zhang@linux.dev>
References: <20260828095643.13395-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

When housekeeping validation fails during a root-to-isolated or
isolated-to-root change, update_prstate() records the requested partition
type as invalid but leaves its effective_xcpus allocated. Those CPUs are
not returned to the partition which owns the invalidated subtree.

This can be reproduced on a cgroup v2 system booted with
isolcpus=domain,15:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir type-fail-repro
    echo 15 > type-fail-repro/cpuset.cpus
    echo isolated > type-fail-repro/cpuset.cpus.partition
    echo root > type-fail-repro/cpuset.cpus.partition
    cat type-fail-repro/cpuset.cpus.partition
    cat cpuset.cpus.effective

The requested root type is recorded as invalid, but CPU 15 remains
unavailable to the top cpuset.

Use the common partition-disable path when housekeeping validation fails.
Disable a remote partition with remote_partition_disable(); for a local
partition, return effective_xcpus to its parent. If that return would
consume the last housekeeping CPU, invalidate the outermost isolated
ancestor instead.

Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Fixes: b1034a690129 ("cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 32a37d624c6b..fefc0afa93ec 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2990,6 +2990,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *parent = parent_cs(cs);
 	struct cpuset *invalidated = NULL;
 	struct tmpmasks tmpmask;
+	bool disable_partition = false;
 	bool isolcpus_updated = false;
 
 	if (old_prs == new_prs)
@@ -3052,15 +3053,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 						tmpmask.new_cpus);
 		if (((new_prs == PRS_ISOLATED) &&
 		     !isolated_cpus_can_update(tmpmask.new_cpus, NULL)) ||
-		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus))
+		    prstate_housekeeping_conflict(new_prs, tmpmask.new_cpus)) {
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
+
+	if (disable_partition) {
 		if (old_prs == PRS_ROOT &&
 		    parent->partition_root_state == PRS_ISOLATED &&
 		    !isolated_cpus_can_update(cs->effective_xcpus, NULL))
-- 
2.43.0

