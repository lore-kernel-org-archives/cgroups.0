Received: from mta1.migadu.com (out-86.mta1.migadu.com [95.215.58.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8E44457BE
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 12:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229802; cv=none; b=k7g3rEa/yyNuhO6POX5pcfJmkVLoPXZpgw2Cya5iIEQcJQgPDA8B2Sj1in9L5EJEvzH1Cc2cQvzwcw6U9HAZOSnu1+Sx+TAkH0O8rx5lUGJWaLx4jh1gxjmEHebu2nco3bShVDPMwijW+jU2bSZv9QfmgBzmlYqF9njl1tqd7T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229802; c=relaxed/simple;
	bh=JuP+1kjQQwdTsfr92sjE4FlWTQ/bj9G+UnXL3bHY01k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJ6jgdR6L37x1VsQV7BBR5OkQaLQx88uVACf2PhOtUilqEQn+VoskQa2jR/MGDw+9/LRZZ2X49ONxZTa0nl0+p5eBX/8ll2os+5Y4upb/TWS1UMo9N+q0z7iyM+9ReGY3sUJ/WzYer5ySrICyLsJZqk1IpdM1Edq7r1cUj/VGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X2MRMAyU; arc=none smtp.client-ip=95.215.58.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X2MRMAyU"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JuP+1kjQQwdTsfr92sjE4FlWTQ/bj9G+UnXL3bHY01k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787229798; v=1; x=1787834598;
 b=X2MRMAyUchO3DxE95833DcS7ABQwg+1TD1kioknXAFzCmHuUtZT4nrs2zLh/vISNzK0Id5L9
 ceWUF32/QExprEkaA94jc2MXo1Xwr3pVYIEYnC5VZ/GlmXuxiKM1nmzgjU8Z0W9+SQwLxg8ywdR
 qmFX5DRPbW3vqw1rNHKfTrIc=
X-Envelope-To: cgroups@vger.kernel.org
Received: from zgp.. (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 37dffba7958dff60;
	Thu, 20 Aug 2026 12:43:18 +0000
X-Mizu-Trace-ID: 37dffba7958dff60
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
Subject: [PATCH 14/17] cgroup/cpuset: Publish cpus_allowed before partition updates
Date: Thu, 20 Aug 2026 20:41:59 +0800
Message-ID: <20260820124202.517160-15-guopeng.zhang@linux.dev>
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

update_cpumask() calls partition_cpus_change() before copying the new
cpus_allowed mask. A remote partition update can propagate through an
ancestor and revisit the cpuset while the old mask is still visible. The
second visit then adds back CPUs that the first visit released, leaving
them allocated after the cpuset is removed.

Copy cpus_allowed before partition_cpus_change(). All checks and
allocations that can fail have completed by this point, and cpuset_mutex
remains held for the rest of the update, so the early copy needs no
rollback. Keep effective_xcpus unchanged until afterward so the partition
code can still calculate the old-to-new difference.

Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b3e749ede7d1..9e13fc962f41 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2555,10 +2555,17 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 */
 	force = !cpumask_equal(cs->effective_xcpus, trialcs->effective_xcpus);
 
+	/*
+	 * remote_cpus_update() can propagate through an ancestor and revisit
+	 * this cpuset. Make sure that it sees the new configured CPU mask.
+	 */
+	spin_lock_irq(&callback_lock);
+	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
+	spin_unlock_irq(&callback_lock);
+
 	partition_cpus_change(cs, trialcs, &tmp);
 
 	spin_lock_irq(&callback_lock);
-	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
 	if ((old_prs > 0) && !is_partition_valid(cs))
 		reset_partition_data(cs);
-- 
2.43.0

