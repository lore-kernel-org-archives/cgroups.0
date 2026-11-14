Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794645120;
	b=ThAaT/cWEJbm3ceEBDyzRiVO++SprOqAb0+1b746nR2DU0jwBz1QZCN9J4KBZruS+1ot
	 5zegRvXk2si0/37Vet1Bhfsx7pKC6nLWUPB+K1jjNVXR+xOaIHYEXZxI2pEWVxr5tzTTw
	 GZikc6bLR7nXQVF356ZwoitCpWAdfkeXEtmp5HKtlicXazY6i3Y3oScMY+gfmSFUwDAjW
	 E3cVd08lUW12cGYZzUkPDHfbLbyDvvHOp5WpMuRj5wcOZ22y7k9euDk8JjSbVirn+bIBB
	 Stkw20+S7SQONR6PAggOmNrXnEr2zTf4R+yq1t5GRJ9w0T4P/vyUPs6w6NDCi+xkZfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794645120;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mvyCE7p2oEzPHjWOtQwRqUFh4k2SnsgMTRUU48ngy1s=;
	b=wxbd9pgZ7MuDj4Du5Jh4W+rtQQcJ5m91W//s0lSMv2Re8hxWX2C2L6wnRzbG4iUgSG3j
	 Ktf8MdXTTST3wTPqgMrFziHPu6yIbp9gAVWb/w2bUFD/xUjcjlV7FqtXa1/nEukmGjlj5
	 Q9QM+iJOS91Z1aavNZc+77KbWR5XiN4oPkr4eyJrT/Ukhc7/nJchIyUS1HsPwbWV812j/
	 D8EH5rceW4214nmE6AWQgW7gAJIKe1sEFR+PiqdYsy+utDmW5CYFjCnpDuboyGchXIln0
	 WhYK1lMa+wj8U4Hzg6VtfG/3/ASgF6+06VltoKuZofhYc2xAAWA56gynaUEpHqOo5rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="mmjD/kDI";
	arc=none smtp.remote-ip=95.215.58.49
Received: from mta1.migadu.com (out-49.mta1.migadu.com [95.215.58.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38DF606A333
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 08:31:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C38DF606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mmjD/kDI
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/NMgXauOwsT913XbtldA3o7W5LOcdXnil2t7yjyQCMk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794645117; v=1; x=1795249917;
 b=mmjD/kDInhYTaneaM4a/oCNyDdOlyr+yLv9OUWOETGwf6ko37/aruU9kgxBbiv2tL/1M4GiW
 PmhVOOhRH32YI1UjXFePDF6dcRAS0PHxsCBBBoukNHNue2awW1lp/IyYIimYbJEwxE+bSYf/85e
 aEeSAUtRZfLOf6e/J7oFLNoE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bf2e0422f0fbd530;
	Sat, 14 Nov 2026 08:31:57 +0000
X-Mizu-Trace-ID: bf2e0422f0fbd530
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v5 04/12] cpuset: use partition_enable() for remote partition enablement
Date: Sat, 14 Nov 2026 16:31:16 +0800
Message-Id: <20261114083124.1340140-5-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261114083124.1340140-1-ridong.chen@linux.dev>
References: <20261114083124.1340140-1-ridong.chen@linux.dev>
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

From: Ridong Chen <chenridong@xiaomi.com>

Now that the partition_enable() helper is available, replace the
existing implementation for remote partition enablement with this
centralized function to unify the enablement logic.

As partition_enable() also sends the partition change notification,
update_prstate() may notify again at its end. cgroup_file_notify()
rate-limits the notifications, and the one in update_prstate() will be
removed later.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c66864faab32..3702e43e95ef 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1725,8 +1725,8 @@ static void partition_state_update(struct cpuset *cs, int new_prs,
  * Transitions a cpuset to a partition root, only for v2.
  * It also supports the transition between root and isolated partition.
  */
-static void __maybe_unused partition_enable(struct cpuset *cs, struct cpuset *parent,
-					    int new_prs, struct cpumask *new_excpus)
+static void partition_enable(struct cpuset *cs, struct cpuset *parent,
+			     int new_prs, struct cpumask *new_excpus)
 {
 	int old_prs = cs->partition_root_state;
 
@@ -1914,14 +1914,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	if (prstate_housekeeping_conflict(new_prs, PRS_ROOT, tmp->new_cpus, NULL))
 		return PERR_HKEEPING;
 
-	spin_lock_irq(&callback_lock);
-	partition_xcpus_add(new_prs, NULL, tmp->new_cpus);
-	cs->remote_partition = true;
-	cpumask_copy(cs->effective_xcpus, tmp->new_cpus);
-	spin_unlock_irq(&callback_lock);
-	cpuset_force_rebuild();
-	WRITE_ONCE(cs->prs_err, 0);
-
+	partition_enable(cs, NULL, new_prs, tmp->new_cpus);
 	/*
 	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
 	 */
-- 
2.34.1

