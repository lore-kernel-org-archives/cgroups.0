Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533391;
	b=VSG2JC0ix+/t5KmZpOecjjuhvAQ5gmsimH6o9i5HYiOBeu7I4MYq6O3aDq1Tu4tVUZa4
	 Mdye8t6p4JQW3GhrWY7eo7fTdB/EuS7zA2B61ZpW3Xs9lbkn+syBJ2cGBUjWTEwt6tzXB
	 b5SpzVwY6oN8WBtwdhVP0/yllaJwYCY9xjw/eIoLCHD5vRlPREklqW8uWJBUaSdP44+ZM
	 pAA/zQ/dNfYwVUmmHI9mCbaYyQIPnro5a9jVT7z5iOrFjNk5SxQsh1atFuZqa4jdSZi09
	 aY+DLZiPp7hu5//2PT5pRVSODVzB1UeZFNaj7/DwywBEy880FumsoLOfQKeZSQzQ+mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533391;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=59bxvld7f5q4hZ0sGBlT2N0w8AbxWzaqeqI5nzCfM8g=;
	b=S8G828nf9K9VthiXc3RlRVsGBFRjSwiHvYBWWsrMeSICadUKTvqvX+7t9OriSISjFEth
	 zNSHjHSDT1Ds8uB2PNbM8ZYvm4BXy7fiJgxRL6a3eb52YUkM7swYOFgrFFHhwF3L0+WvF
	 LQvC9f2SawN1X7pAAnKy5aYjXCG4eoQOR2alTGu7697sfKntaQmmj7x28F4ZOsnmN6JBA
	 4M83NchHpfDksVUGAQypCQ1OW10Xs3/W3XV9BVj9ySxcONhyfJQXqeq8T4f8p9a/h5EAH
	 7IhciCostiMbmpEFIC9uxMMNLeo2cudBD0POg2MgOK+HDbIq7vAJzb46q9DJE/VFmGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kYfo+ozh;
	arc=none smtp.remote-ip=95.215.58.124
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B66E606A331
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:43:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B66E606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kYfo+ozh
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=69x8/ARVrYvCYSwVhjuqurDrHb6qDynS3gKPn4uxOP8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533388; v=1; x=1794138188;
 b=kYfo+ozhB0aUaRgkdR0gp7SQ5ekgLLmxe1YRybM0wDEJRriyGSfxs1DHqc316kFPG3wEIHp1
 p1IjhKeYWNklXsaFBrsz0JvvTqRqk9aagmralZnH7xE8eu2UNheFUWG6uAxCzbX3D7+1MtHrqvl
 HIm5wVpFup9vmL+jBIKb8pjU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4f31d7f751b75513;
	Sun, 01 Nov 2026 11:43:08 +0000
X-Mizu-Trace-ID: 4f31d7f751b75513
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
Subject: [RFC PATCH -v4 05/22] cpuset: introduce partition_disable()
Date: Sun,  1 Nov 2026 19:41:49 +0800
Message-Id: <20261101114206.2434398-6-ridong.chen@linux.dev>
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

Add partition_disable() to consolidate updates to key cpuset structures
during partition disablement, including:
1. remote_partition
2. effective_xcpus
3. partition_root_state
4. prs_err

Key operations performed:
1. Cleaning up remote_partition
2. Removing exclusive CPUs via partition_xcpus_del()
3. Recomputing effective exclusive CPUs mask
4. Updating partition state and error status
5. Triggering required scheduler domain rebuilds
6. Sending partition change notifications

Only the CPUs actually granted by the parent are given back, as the
parent may have shrunk. An invalid partition, or a partition under an
invalid parent, has already given back its exclusive CPUs, so there is
nothing to delete. A remote partition gets its CPUs from top_cpuset,
which owns all the CPUs.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 052a131731dd..c0d6dd7297f1 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1767,6 +1767,45 @@ static void partition_enable(struct cpuset *cs, struct cpuset *parent,
 	notify_partition_change(cs, old_prs);
 }
 
+/**
+ * partition_disable - Disable partition root state for a cpuset
+ * @cs: The cpuset to disable partition for
+ * @parent: Parent cpuset of @cs, NULL for remote parent
+ * @new_prs: New partition root state (should be non-positive)
+ * @prs_err: Error code to set if disabling due to validation failure
+ */
+static void partition_disable(struct cpuset *cs, struct cpuset *parent,
+			      int new_prs, enum prs_errcode prs_err)
+{
+	int old_prs = cs->partition_root_state;
+
+	lockdep_assert_cpuset_lock_held();
+	WARN_ON_ONCE(new_prs > 0);
+	WARN_ON_ONCE(!cpuset_v2());
+
+	spin_lock_irq(&callback_lock);
+	cs->remote_partition = false;
+	/*
+	 * Disable a partition should only delete exclusive cpus, and only
+	 * those actually granted by the parent as the parent may have shrunk.
+	 * An invalid partition or an invalid parent has already given back
+	 * its exclusive CPUs, there is nothing to delete. A remote partition
+	 * gets its CPUs from top_cpuset which owns all the CPUs.
+	 */
+	if (is_partition_valid(cs) && (!parent || is_partition_valid(parent))) {
+		if (parent)
+			cpumask_and(cs->effective_xcpus, cs->effective_xcpus,
+				    parent->effective_xcpus);
+		partition_xcpus_del(old_prs, parent, cs->effective_xcpus);
+	}
+	/* effective_xcpus may need to be changed */
+	compute_excpus(cs, cs->effective_xcpus);
+	partition_state_update(cs, new_prs, prs_err);
+	spin_unlock_irq(&callback_lock);
+	cpuset_force_rebuild();
+	notify_partition_change(cs, old_prs);
+}
+
 /*
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
-- 
2.34.1

