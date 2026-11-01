Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533466;
	b=A5BnL3lT7hQJMAfU2YUe0M63s537R2AmeomFA4sdKQF66LtwJ7H32fnMcwIHUuElWJUX
	 SRTKfITwb/uhleRmUQtLu3v1wFj0ywf0UXpd8SoFcl9RjzIeZS+VIQpyXl4lSeRzUO6RO
	 Ugk1ppcQteGk3RHCRoKoxT9gV7dEMEIZZS5RG0sawucxWb2LnalrYJApmJSR019X6NJRy
	 TeUhyAXFxZhCuO7F2/sYy1wULykhIesWII6rzsQHDfwdkUBL2V17Qks4XhZSGC94F1GU7
	 CfDKUgjMQdBGK3mRemWcHkAfz9n6wwEfc1teRRyePkixxiqNlw2cNiJKSG5Vzx6NYzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533466;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QjyYeRpX01zGPhJ7pteimmVK5fKDF2+iOMA+tL0n4Io=;
	b=r0K046vKBpa9olpyIRcMDXGSwWMILuuZ3oKuvBckbx4bhMWIgSydrFU1PJuTVb8vsNJQ
	 BfXZ1H2epzExZN4emvnY2fpYiVFZn28AfMxqPhEsRuX4I+mLkkxmS2dGjABqgcVYpGuKM
	 upy9rLFeBSTZk8kMgLUlHLWE7x+7EUIFdancgJON29X38Xnw7G4Cks9HHerhlpmw7R7R4
	 N0Cv+D3T7+Se5a8VEI9syIX4hS+ArhgJAly1XghSBxnaBIlpg5xe9HCO8mL7LEA787wv4
	 UYQYfKFvca16HIxt/HevwXma9GZRIYiDbwE54Z/dWIcxJ3cNyv5ha6HJGykGS4SSFFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IltczfXQ;
	arc=none smtp.remote-ip=91.218.175.118
Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B3B606A324
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:44:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17B3B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IltczfXQ
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kE75AoFTmg6mrXtaSeiGRFK2ei0ZzQhfB6VChVxVMOo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533464; v=1; x=1794138264;
 b=IltczfXQl1+r8IAstmYUNGA+bAAYitXzCt4VHnH8wiPaQZo1L790sXgfJEhYCdURtECNlg3J
 QMXfr7DzntqaZjn1nP+M+KmmB96oDLtGjuJz6OtDFADHZBNIkxBnwGrugqKHFqC3a2ZQfWICd6/
 3CXmLu/5qF2G7MPzDtm0xwFA=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4c4b92d813194bfa;
	Sun, 01 Nov 2026 11:44:24 +0000
X-Mizu-Trace-ID: 4c4b92d813194bfa
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
Subject: [RFC PATCH -v4 15/22] cpuset: remove redundant partition field updates
Date: Sun,  1 Nov 2026 19:41:59 +0800
Message-Id: <20261101114206.2434398-16-ridong.chen@linux.dev>
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

With the previous patch series, partition-related fields are now properly
managed during partition enable, disable, and update operations. There
should be no need to set these fields outside of these dedicated partition
operations.

This patch removes the redundant partition field updates from the cpumask
setting code path. However, one exception remains: when setting
cpuset.cpus.exclusive on a non-partition cpuset, update_exclusive_cpumask()
must still set effective_xcpus directly. This is necessary because no
partition operation is invoked in this scenario, yet effective_xcpus needs
to be properly initialized.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 86d6860a8b15..78a783cb6308 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2563,9 +2563,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
-	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
-	if ((old_prs > 0) && !is_partition_valid(cs))
-		reset_partition_data(cs);
 	spin_unlock_irq(&callback_lock);
 
 	/* effective_cpus/effective_xcpus will be updated here */
@@ -2629,8 +2626,6 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->exclusive_cpus, trialcs->exclusive_cpus);
 	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
-	if ((old_prs > 0) && !is_partition_valid(cs))
-		reset_partition_data(cs);
 	spin_unlock_irq(&callback_lock);
 
 	/*
-- 
2.34.1

