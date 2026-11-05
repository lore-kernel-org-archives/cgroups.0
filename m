Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793907258;
	b=vvKWtANgs2myzJrsW595k8CEyOfspnl/zG/5R5oJ6GHhvh+VHwugem7+qQf8X0/1Sh0a
	 mikyO7Fb5Hkxdd93U9zHr42jAyEeyeH+O9vG0WGQMt1BrQOAmkJPO4f8+qtnpvE4flkgW
	 geX5I8dXmfQCnGGkqtw+eKBODKXhK0y5dTxpbD+dwu3gfGxfgs1JWgHMncumSy56s2RJ/
	 qV2Xtg8SJFbKHd7LxmFBIJwrkHqfN2gusUYT6heB12d7r7PTxTecMtKR5eaxfJYvwC1G9
	 YUEE0CuNL+czOrNeNZXWjgT1ze9AdyXc3W9DMN9bHiy+W0eO7r11JY2pQD/gydJEX2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793907258;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=c8+n/+NCH6m2zgdZ+7pBwVY7EPj2sOWeszHDsDG92gI=;
	b=K/s7JeCX/s+Lgh8clSJ0/EInbqW74MZ8K3aVQdNlQLPE3sOXVcnFjEBcG+zWkZ4GSMb6
	 Hq5OBp5Nu/ZlezBkZToPkISnnd3ICYO8SU1uPRzigN6XsJhzN/qJoAbN+/PmyoI5mN70K
	 CCmzv/CpLeUBvLz7RH8zqkwCd4nn9uUxbAwv8b8KcPyuHG2yWOmi+kqBuy6y/ggsgcBwY
	 vKtJ8NHsLko3BgV3Js6vwb7IpZ+jpor7F1+oaZgWKj3Z1LlNH66S31Ygsak4qt22Gfh8g
	 SjzZNgpiLe5cYU0OsZfGQ4+MfVBg32gQFRZRlrGhPStrLUHIx62gVJ8vgr9uCUpZJow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PxbnruTY;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4866606EEB5;
	Thu,  5 Nov 2026 19:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4866606EEB5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=PxbnruTY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793907250;
	bh=c8+n/+NCH6m2zgdZ+7pBwVY7EPj2sOWeszHDsDG92gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxbnruTYkKCNgbPhv6hICHF1X8jvU8KUeIeHm8hs1esLzqkPof7YqAbden5MADWVU
	 VNZJra+DecwYpfM5NnxPnqYGszGzdawaI9Bq1rWdWZHcqfs+tKUuWOHPOs4WS2HuYk
	 rrlsuy2Qru/pUtOaPn0+5DImfKUlV38EDhUk/H3eS0Xd2zm5MkgQ0gXBEq1N18wWHg
	 UT47fCR6W8dRFZLjen80x14sGzBVcWuISPRX3XrdXNgqD1JNFMurd1F8vgdn7fgo/J
	 8odd6J2qsqX+LcqO3ACW7k2HmZVv4qmh7FBUbgKBIEzQBq01/zFXXN1vvH+IUGOKiA
	 WmQ8t3lfcPAkg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLCDL0FwtzLJr;
	Thu, 05 Nov 2026 14:34:10 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	luca.abeni@santannapisa.it,
	mathieu.poirier@linaro.org,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	parri.andrea@gmail.com,
	m.szyprowski@samsung.com,
	kayracizmeci@gmail.com,
	weihengqiuu@gmail.com,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v3 07/24] sched/deadline: Reset the deadline and the runtime with the parameters
Date: Thu,  5 Nov 2026 14:33:42 -0500
Message-Id: <20261105193359.1450487-8-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
References: <20261105193359.1450487-1-mathieu.desnoyers@efficios.com>
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

A task that leaves SCHED_DEADLINE keeps its parameters until its 0-lag
time, so that leaving and coming back gains nothing. __dl_clear_params()
then resets them, in inactive_task_timer() or in task_non_contending(),
but leaves the deadline and the runtime of the period the task was in.

A task that comes back after its 0-lag time, and before that deadline,
is enqueued on them: enqueue_dl_entity() starts a period anew for a
task whose deadline passed, setup_new_dl_entity(), and for no other. The
task spends the runtime of the reservation it gave back before the new
one begins, and a constrained task whose deadline passed before the end
of its period is throttled on them instead, dl_check_constrained_dl()
arming the replenishment timer of the old period. The previous patch
widens the window to a period for a task that was throttled, moving its
deadline on where its timer fires outside the class.

Reset them with the parameters: the next enqueue then starts a period
from the parameters the task has.

Found by the Sashiko AI review of the second posting of this series.

Fixes: 209a0cbda7a0 ("sched/deadline: Improve the tracking of active utilization")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d376cb493a9f..088e84fb9b10 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3969,6 +3969,9 @@ static void __dl_clear_params(struct sched_dl_entity *dl_se)
 	dl_se->dl_bw			= 0;
 	dl_se->dl_density		= 0;
 
+	dl_se->deadline			= 0;
+	dl_se->runtime			= 0;
+
 	dl_se->dl_throttled		= 0;
 	dl_se->dl_yielded		= 0;
 	dl_se->dl_non_contending	= 0;
-- 
2.47.3

