Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793533405;
	b=oIDIdhNWA6EHoq5Dn6vaAUikdVu+6hHDbyPVYo6t5O8N0LwQxp2913VGA78ORyAztqsC
	 WqjpfYz9HtfINfQf1W1vHKzHbYpnS5+M2Zcwq31cBJX5H4HxELFgBngC1GIZNUqZJ+V5z
	 qy58YL1kPREZ05LmdWS9NRftyVYxcB5uNRgJJewrVH1WBsU/CfuWXW2kXDL2NG1NfP5Qo
	 lNf+zXKf9bbheOYb9fb6hdoospWjwGZTC3q3W67Y2Y9DqeUwQA+tw5kU1fvveI95E06fV
	 JDQOKZorFLG9/LWwxHgRx9aWiN6PRt/LfMrujLp6l7+klER76/oBMTgHwIwJxpNREtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793533405;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uFXVdq419ty6aXwABODtX2CFS37/cy9Qx7tAcE1G+Fg=;
	b=pA2HsSIGlfOsOiGxUBPn+xzJ8FI8RH6BZJxxaxisgyiMaY8RyYJ8WfNn3EiDWh1uY1is
	 NIuki557Ws6HNqVR9IvQ81dMzPFwZB2vF+TpTuWAxy8vhqtjtC4ZYGYa9uXj21GWPz+Wl
	 0XkueMz3CmqY9V8Wrk1rd5fUtXBRx6xaLpZEjjnXhW17OMv4/DRXULzeWU8sBhtX4+eBM
	 H6o2QPZDm+LUqxDxiGpeuKdjeceHYA1b39/ckTAKgMIe+aoSWvUDvwyTiCQBIbxpef+Eg
	 dGBzqRAmc18+7lt1HC3CR1VOcIIQSG8ehx4w6BrAI7TWLQwGnOXXGYSh432l1+nC01Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k3pYUiTG;
	arc=none smtp.remote-ip=95.215.58.131
Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEC7606A327
	for <cgroups@vger.kernel.org>; Sun,  1 Nov 2026 11:43:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEEC7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k3pYUiTG
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gq72F+Q9hj/bgdoh631BotOVHmO7MomCAjeajIM0ZT4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793533402; v=1; x=1794138202;
 b=k3pYUiTGJRi3yNky4FhCawPIGzgLoA6aXZOsBOypA/Ma4vef2mFDmUIfSpShsT+vjdPYl27i
 qAh0A3RRJP9PHX7CleOkvOlzNUXM1cgZU4nRCi50MkpOQf0GZbKWFDLmiT2HqHVESndDfOhylLr
 XslYyTTpueGAcD3vRQbjHcio=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c0642ab5c8b62d03;
	Sun, 01 Nov 2026 11:43:22 +0000
X-Mizu-Trace-ID: c0642ab5c8b62d03
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
Subject: [RFC PATCH -v4 07/22] cpuset: use partition_enable() for remote partition enablement
Date: Sun,  1 Nov 2026 19:41:51 +0800
Message-Id: <20261101114206.2434398-8-ridong.chen@linux.dev>
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

Now that the partition_enable() helper is available, replace the
existing implementation for remote partition enablement with this
centralized function to unify the enablement logic.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 kernel/cgroup/cpuset.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 23ae548c3994..d7f9f6e1fa3c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1895,14 +1895,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
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

