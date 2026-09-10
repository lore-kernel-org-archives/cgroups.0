Received: from mta1.migadu.com (out-113.mta1.migadu.com [95.215.58.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582733D4128
	for <cgroups@vger.kernel.org>; Thu, 10 Sep 2026 09:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033638; cv=none; b=ZOj7phd35TBJEVrbpDmE9+1vMSA84YrdZWL3+uwXNJzHicDr5eEVVLl61MWbKNchdsIuu+lieAaMrEl51zhqkUUBhbG+saTS0+OFllTMAV9KaPMlWy+VjXbzp/YIyJ8c83m5wOqt6lUSD2rbu0wWCll2961Krh9vm37guuqxkTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033638; c=relaxed/simple;
	bh=n38oQvTB3bj6RKoMFOidDkXJyN7EmSAfiUvXEEt0TAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYfOUg5+xCBzE8lYgm8DE4NU5s9DzXu7gdG8fYhqycDPt/RiJ4crcGLcEbIvXurKbvvOEJnweGq/640/FKAyc9uvAkPsIILt3WP/h0xO/h++llBTkPjvdfTP9tR7po9DFhBE+7NlD/I4WoR3HPwdyYDKybdlk0Mcfu/aN1t1BCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kZv+psbl; arc=none smtp.client-ip=95.215.58.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kZv+psbl"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=n38oQvTB3bj6RKoMFOidDkXJyN7EmSAfiUvXEEt0TAc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789033632; v=1; x=1789638432;
 b=kZv+psbla6tZq2ZCOQ6dLJPQbE258xL8+AmrcCHV/ogptNZf6zsASIJ3CZp2+vJdBfC7vU1W
 knO55EppZjtjusaOmy55HJNjnhjKd1xWMDiVquzXL2TyE7Gy4ATP0pYZFiXueXL2+VUqJtHJrhS
 pIWOJXkg5rZE4SN+eqi3sc2U=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 498b728418b7d61c;
	Thu, 10 Sep 2026 09:47:12 +0000
X-Mizu-Trace-ID: 498b728418b7d61c
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
Subject: [PATCH v4 6/7] cgroup/cpuset: Publish cpus_allowed before partition updates
Date: Thu, 10 Sep 2026 17:45:45 +0800
Message-ID: <20260910094546.5852-7-guopeng.zhang@linux.dev>
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

update_cpumask() calls partition_cpus_change() before copying the new
cpus_allowed mask. A remote partition update can propagate through an
ancestor and revisit the cpuset while the old mask is still visible. The
second visit then adds back CPUs that the first visit released.

This can be reproduced on a cgroup v2 system with CPUs 1-7 online:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir remote-repro
    echo 1-7 > remote-repro/cpuset.cpus
    echo 1-7 > remote-repro/cpuset.cpus.exclusive
    echo +cpuset > remote-repro/cgroup.subtree_control
    mkdir remote-repro/part
    echo 1-4 > remote-repro/part/cpuset.cpus
    echo root > remote-repro/part/cpuset.cpus.partition
    echo 1-3 > remote-repro/part/cpuset.cpus
    cat cpuset.cpus.effective

Without this fix, CPU 4 remains missing from the top cpuset after the
remote partition is narrowed.

Copy cpus_allowed before partition_cpus_change(). All checks and
allocations that can fail have completed by this point, and cpuset_mutex
remains held for the rest of the update. Keep effective_xcpus unchanged
until afterward so the partition code can calculate the old-to-new
difference.

Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index bbc4868f026b..80a709bfa4b7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2618,10 +2618,17 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
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

