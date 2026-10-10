Received: from mta0.migadu.com (out-230.mta0.migadu.com [91.218.175.230])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A05036728D
	for <cgroups@vger.kernel.org>; Sat, 10 Oct 2026 08:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.230
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791619210; cv=none; b=SyJBoFfpaE3NiFZz/Kix3/3SQDLYw6+LJ+VmWWTbYQgM3erAAD1RZxykfjN3bnu4FeUuiVon4PdBoDn4/nxCZCBQslG8+w35vfRZuZs0Alfn3cdVBteAptYKCx7jqCQpYDOe7tfrR16JlSr46iOqwQ13HGoadEu3deM6GwQdE+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791619210; c=relaxed/simple;
	bh=9RI9Rxjek/Rjq20gXwd4bxTyZLzxajPjH1ECOtDDrOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNF/Wj/ZU456GWnNJh8+b/mobkSfVok+9vqS8D7///WrlEbmrosdSa0RL6dmxmuMQcQ2XFqtDQdN9jChPaIs33G47x7sFyyHIBtn9hbMS/uX8Xr+diEu6IQOwtTXUFI9Aj9ZZrWN5epQI4PcXII0MPdw5A1+b4anWEb/XMM9vQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lJwmWOOJ; arc=none smtp.client-ip=91.218.175.230
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lJwmWOOJ"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9RI9Rxjek/Rjq20gXwd4bxTyZLzxajPjH1ECOtDDrOo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791619206; v=1; x=1792224006;
 b=lJwmWOOJWz0s5YFZZUOXZeD9lmY+JtUTNd2upqJ/ryvQDU5FQ6J3Cbr0r0TDLxD1HLTjfvWo
 KkuR5n2QYvVMMu/7tV7+79LEfc7EyMjunWxegllJ07AJ2Echqf7uiW20EOwTzGhUKv/xWAWc8aE
 1EwyECgF3mls/Bj/DqMGgzqQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a561eab10f80f034;
	Sat, 10 Oct 2026 08:00:06 +0000
X-Mizu-Trace-ID: a561eab10f80f034
X-Migadu-Flow: FLOW_OUT
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH 1/2] cgroup/cpuset: Fix cpuset.cpus update in a remote partition
Date: Sat, 10 Oct 2026 15:59:46 +0800
Message-ID: <20261010075947.333549-2-guopeng.zhang@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010075947.333549-1-guopeng.zhang@linux.dev>
References: <20261010075947.333549-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

When the CPU list of a remote partition is reduced, a removed CPU may
remain unavailable to the top cpuset.

This can be reproduced on a cgroup v2 system with CPUs 0-7 online:

    cd /sys/fs/cgroup
    echo +cpuset > cgroup.subtree_control
    mkdir A
    echo 1-7 > A/cpuset.cpus
    echo 1-7 > A/cpuset.cpus.exclusive
    echo +cpuset > A/cgroup.subtree_control
    mkdir A/B
    echo 1-4 > A/B/cpuset.cpus
    echo root > A/B/cpuset.cpus.partition
    echo 1-3 > A/B/cpuset.cpus
    cat cpuset.cpus.effective

The last command should show 0,4-7, but CPU 4 is missing.

update_cpumask() calls partition_cpus_change() while cs->cpus_allowed
still contains the old mask. remote_cpus_update() first releases CPU 4,
but the hierarchy update revisits B and compute_excpus() still sees the
old mask, so CPU 4 is removed from the top cpuset again.

Move the cpus_allowed update before partition_cpus_change() so that
the hierarchy update sees the new mask when it revisits the cpuset.

Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 kernel/cgroup/cpuset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0ebba2d646c3..de7553459adc 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2478,10 +2478,13 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 */
 	force = !cpumask_equal(cs->effective_xcpus, trialcs->effective_xcpus);
 
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

