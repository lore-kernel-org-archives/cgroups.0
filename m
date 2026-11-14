Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794650793;
	b=p6bgLAtdb0MgngbFQ5l7uJqCDeRhc0X8wTzPSu+lQeeXEe+Rl6PTvLZHkOIPoUkwvRf/
	 o1qy7pAIdZF/kw4ljbfTtfu4njCbRr6axt2nsIAIXpoLkfaE0V8O/tsl58EB6kEM1lN+h
	 UX87mHRr1yzOJbuMzmJEngMfwGuZablbVueWN/39DDWP5S7vVZqyoaIDLXJxWi2fsfWVK
	 /Zyp4uMozULG2uB2vd8NSgks7WLANH8Bu6Go0QQ/q16uQEKJyk0CFEZphr0Bql8Ex2So3
	 7fA/PJQ4noiuKmaz/lZXf/vgARUTE6MPC75/N3u3mlaLiP6KuG8ilp0UtikfFtXVPJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794650793;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=oXmeAcj2Cbh5Zp/iYk5hJGCEEYfod4GPg4Tedmnx2Ts=;
	b=KzrZUOeFnwxZE9mL/WaAxJdBOsRatiWDORG9Vgosu1Na9wWARYyBXqoFUe20UPWQxMGb
	 5PbnpVXHisqlsqMqOr/AyGuqIzCP1yCMR2vmN348cu4hRvafWEw5DfTlypIo2ssVCj8yQ
	 XzdqoOMK/ds7Hwr8xcgUgaRFB9+ia+WkZMuSE7CbgZYboJl+5Qnf5W9xAtqwTLrG74luc
	 rUywCK/prBaU2GLD99Xf92hiWeEHX65RY6KJCpJ859XE5CVV1JrZUWNVZJDsHWAPRFCHt
	 fht01nb1HZQQNwbMCjDVU3TkGp0MUwdvM9Br8yb6zo0yTySV8EuGWOHeobLWq9hOuCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WeN8HijB;
	arc=none smtp.remote-ip=95.215.58.35
Received: from mta1.migadu.com (out-35.mta1.migadu.com [95.215.58.35])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF53606A333
	for <cgroups@vger.kernel.org>; Sat, 14 Nov 2026 10:06:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADF53606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WeN8HijB
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/rhGLw24meU+sMkUbuZ7gPKxmb5Uk4Es+hJtvlY0H8Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794650790; v=1; x=1795255590;
 b=WeN8HijB/DA4gW+tCs0wBdxpiQLK4rHPdj7cM/J6TpsG3hqXQ9gw51ZnAskb8qqzoDYangCr
 8mm4t+T7hwVNRZAaGaAGLBzSwv+0oKyQ8msr6bKZjKlb/MqS8LaplyN5bldrsThRGHhGAaUP4Qu
 dnF+74PkhsOotYdk79bg4APU=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 05fe01e8574924a4;
	Sat, 14 Nov 2026 10:06:30 +0000
X-Mizu-Trace-ID: 05fe01e8574924a4
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH for-7.4-fixes] cgroup/cpuset: Remove redundant WARN_ON_ONCE() in remote_cpus_update()
Date: Sat, 14 Nov 2026 18:06:12 +0800
Message-Id: <20261114100612.1380464-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
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

remote_cpus_update() warns if the CPUs to be added to a remote partition
intersect subpartitions_cpus, and then checks the very same condition
right below to set PERR_NOCPUS and invalidate the partition:

	WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
	if (!capable(CAP_SYS_ADMIN))
		WRITE_ONCE(cs->prs_err, PERR_ACCESS);
	else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
		 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
		WRITE_ONCE(cs->prs_err, PERR_NOCPUS);

Sashiko reported that the warning could be triggered by a write to a
cpuset control file, before the CAP_SYS_ADMIN check, which would panic a
system with panic_on_warn set.

The warning was added by commit 86888c7bd117 ("cgroup/cpuset: Add
warnings to catch inconsistency in exclusive CPUs") as an assertion that
such CPUs have been filtered out before. No way to trigger it with the
current interfaces has been found, as these CPUs are rejected when
cpuset.cpus.exclusive is written. But the warning is redundant, as the
conflict is handled right below anyway.

Remove the warning and rely on the PERR_NOCPUS check, the same as
remote_partition_enable() already does for this conflict.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261114083124.1340140-1-ridong.chen%40linux.dev?part=6
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7e374210c123..0be0d26c442b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1833,7 +1833,6 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	 * left in the top cpuset.
 	 */
 	if (adding) {
-		WARN_ON_ONCE(cpumask_intersects(tmp->addmask, subpartitions_cpus));
 		if (!capable(CAP_SYS_ADMIN))
 			WRITE_ONCE(cs->prs_err, PERR_ACCESS);
 		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||

base-commit: e234ed1bb82c96a5643fd70784f16cf3d72eeed3
-- 
2.34.1

