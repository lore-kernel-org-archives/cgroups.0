Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533481;
	b=47ud1zGW7LNqWfCcJSZWY2ewqdQhwNxW3qLgqJRRnaTYjf10xzNpL2zwCE15vht/2U+O
	 hIuByFrrJzpWBl/ProyInmmNOBypUPCjSzYXfu+Zh4kFmVyDuOY0knfSPfcibpB1zSBln
	 26vW11HS2oaVqRBhBCfrntrsnkzgABHaO2ZJipfVj5/Mtg36sWZpy2EkffeoKB8y2hjR+
	 zLLYIA24uTnJluIlnoOwp8KSx1AP9sXY8vq7u9QkI1Ticyx2dsx6wL5ZdjDfFZELqfl0+
	 uaq/SeRPmGNKNt86sutQ+WCY5gqBYSSeTbiuJawgfqoS7dx71s4A3TFcvMOhdOYHDEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533481;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=jl9q1kPvpfXB9rbcCqx0sRzDo6NRaZhx8sXojJnTnwg=;
	b=tZuZwXvHuNdloXjZGj6gZOziKr0hJvAsuAv9JeBfzrXqKPBQQwa37a+IWbUzJYHQKhHm
	 In4FIu10hSbLs8YTIIpDHb4ZZfxyuG4D4PrWZvbcDo9ygCsLHi+IXBWZwO/MeFxUYJaq3
	 +P3KGE8ihhIpu0j4oKW4zQXQv5PSP9eFd79WSC4/wctuo17nbDDK5+b1or3zCkDVxt6fX
	 Y99qAoxiDKz7gap01msR9/c2wMQ34w3ldY0Mde3ND2KVmb3YxxQvYw/cO1rOeL9WxG2CT
	 mQazm11cCPLYcGE43IXFdAHhOrsU+qg6YQKrqJ3rXLGsg2xB8Pl02SAjmCtmQtO4p0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BYLOWrtK;
	arc=none smtp.remote-ip=95.215.58.175
Received: from mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFD8606A325
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BFD8606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BYLOWrtK
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Wjdn3OQDASdFAWwR2LojczAo2YM/KVjt+TBzyDBfQuE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533479; v=1; x=1794138279;
 b=BYLOWrtKLi/cVO7pkaEGihlE8UGYNxSFo15fPhOt6HnuUjrV0KDpeZATrH1HmjJuTwjNHf+L
 t8s3lkIIPT+O+RE2aSMpwV4oXfwLNw8bCoKIX9NxKOx5m0npy6Ww1fKb1PFfO9H3xFf+jrQIoJS
 sTmwRUy3n0KblRfvhTxYdCaE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id efbb9dede1c58fb4;
	Sun, 01 Nov 2026 11:44:39 +0000
X-Mizu-Trace-ID: efbb9dede1c58fb4
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Michal Koutn?" <mkoutny@suse.com>
Cc: Guopeng Zhang <guopeng.zhang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chen Ridong <chenridong@huawei.com>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH -v4 17/22] cpuset: use partition_disable for compute_partition_effective_cpumask
Date: Sun,  1 Nov 2026 19:42:01 +0800
Message-Id: <20261101114206.2434398-18-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261101114206.2434398-1-ridong.chen@linux.dev>
References: <20261101114206.2434398-1-ridong.chen@linux.dev>
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

From: Chen Ridong <chenridong@huawei.com>

Replace the partition invalidation logic in the
compute_partition_effective_cpumask() with a call to partition_disable().

This centralizes partition state management and ensures consistent
handling of partition disable operations throughout the cpuset subsystem.
The isolated_cpus update that was open-coded here is now done by
partition_xcpus_del() called from partition_disable(). In addition,
partition_disable() gives the exclusive CPUs of the invalidated child
back to the parent and resets the partition data of the child, the
same as other partition invalidation paths.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 00afa4987381..af42666d4530 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1137,6 +1137,8 @@ void cpuset_update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
 
 static void update_sibling_cpumasks(struct cpuset *parent, struct cpuset *cs,
 				    struct tmpmasks *tmp);
+static void partition_disable(struct cpuset *cs, struct cpuset *parent,
+			      int new_prs, enum prs_errcode prs_err);
 
 /*
  * Update partition load balance flag and/or rebuild sched domain
@@ -1642,20 +1644,9 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 		 */
 		WARN_ON_ONCE(is_remote_partition(child));
 		if (populated && cpumask_subset(new_ecpus, child->effective_xcpus)) {
-			int old_prs = child->partition_root_state;
-			int parent_prs = cs->partition_root_state;
-
-			/*
-			 * Invalidate child partition. Its CPUs, including those
-			 * further distributed to its descendants, take the
-			 * isolation state of cs.
-			 */
-			spin_lock_irq(&callback_lock);
-			WRITE_ONCE(child->prs_err, PERR_NOCPUS);
-			isolated_cpus_set_state(parent_prs, child->effective_xcpus);
-			child->partition_root_state = -old_prs;
-			spin_unlock_irq(&callback_lock);
-			notify_partition_change(child, old_prs);
+			/* Invalidate child partition */
+			partition_disable(child, cs, -child->partition_root_state,
+					  PERR_NOCPUS);
 			continue;
 		}
 		cpumask_andnot(new_ecpus, new_ecpus,
-- 
2.34.1

