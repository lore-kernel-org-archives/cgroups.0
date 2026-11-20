Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207367;
	b=iReuNlP0/AMRT6rHXMKzfeUDi/aZdhL6U9Gs4vAz5nCIgaCUkl1UkT+0Q18d7mopatWn
	 lc5dqhwgMCmwAtzwakdPtIngQgo1Rin9e4FcJ6s8qvZnnrEO7VYdHoIFKENdVtRMBjPq0
	 eyxVEcxC3pAhQulxOsx2NLZHAifpYROFDjV9C5MIw1lWjtpyLRA970PS2svEGLZdZkmlW
	 2Y4VyYdlTIP3kfHqMjELk7kuJ0d/XUG3cifX+35wrTNcsgB6JbBsZN8jUtt5l8saIfIu8
	 NmxI97YQ7haLN3nhwcUE0NMi7mktuRQYa/eBgF93FGJPH2yAGelB6rxkBHd2Vw73uyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207367;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9HHgPnngfANMXf/PtLeRb/ky94A+yHxsRFZy6YViF1s=;
	b=MH8Mp9rz5vtZoILYXtLw4k3Z7c9Hl635rKCLuRlV3j/cFF4scGyYjvoL6jwletV3lIQ3
	 Dya/39uFZRSGuwpMrF3SJK7fbO1rsYL35q4PfRurkGFb0593IzpxINELvjq6D2638rQuj
	 Mbr1x02XQXL57m4W+VNipDbAI3WyxOauTgo8229qMR5xLtzF99lGm2Bg5RijsTVSu7ibS
	 x2YP6uTorRWCaTq6KLkscQY5ZErc4BeMZCXPHgC53/8J6NZn3APKo6ZHvmVDvdYK+8rKS
	 X2cAJ+jHHZtRwc/6JS1ZlCy3Bn2NCMwT7q5u/GK3v7MdmH1FW4+2hL5Yc5zfFpFBDMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=d4htThkj;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD07E60A2625;
	Fri, 20 Nov 2026 20:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD07E60A2625
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=d4htThkj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795207355;
	bh=9HHgPnngfANMXf/PtLeRb/ky94A+yHxsRFZy6YViF1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4htThkjFGl3lC6HPDFXDm++mXCW6kriJbhbV0YL30/EaPjvtZ9/lx9xMi5n491Qw
	 jPMPKhRf4oKxEwwWxjld2drjQotDKZBvOv9c8znciXOXrKMkSUU1LzFxCg87+UKaFk
	 dNd2yrgaq5iDqQwAcRDZaGeS5P8ASW2cEvUHMuMoWq/bsFKDHtQ23jLTQtO1yIsekp
	 bynYSO4+/WaOloi/MnObChqr8UOhHCUH9kwic5tKKPfbuPwWopAn16jHExlzmOLFrK
	 JyEYevfb3uVs/XsX2ZsUCUNo5zzQxKKHlkjcsypi0Poj1TCYn2dvfv81PY1iGgs8fp
	 xoqWXoLIfkang==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jWS2M4538zTqY;
	Fri, 20 Nov 2026 15:42:35 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	tglx@kernel.org,
	will@kernel.org,
	boqun@kernel.org,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v10 20/40] sched/deadline: Do not truncate a bandwidth to 32 bits in __dl_add/sub()
Date: Fri, 20 Nov 2026 15:41:57 -0500
Message-Id: <9f123dcc2d5ccbb4c2e44cedd420a5c363e6ed0c.1795207232.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
References: <cover.1795207232.git.mathieu.desnoyers@efficios.com>
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

__dl_add() and __dl_sub() spread a change of total_bw over the extra_bw
of the active CPUs of the root domain. Commit daec57983670
("sched/deadline: Reclaim bandwidth not used by dl tasks") added this,
for the bandwidth of one task. That is at most 1 << 20, the bandwidth
of one CPU.

But cpuset_can_attach() reserves the sum of the bandwidths of all the
deadline tasks it moves, with dl_bw_alloc(). __dl_add() and __dl_sub()
cast the bandwidth to s32 before the division. Past S32_MAX, more than
2048 CPUs of deadline bandwidth, the cast flips its sign. The extra_bw
of each CPU then moves the wrong way. GRUB lets reclaiming tasks run
more than the free bandwidth, or less. This was found by reading. It
needs a machine with more than 2048 CPUs, so no case tests it.

Fix this by dividing on 64 bits, with div_u64().

The Sashiko AI review of the first series found this.

Fixes: daec57983670 ("sched/deadline: Reclaim bandwidth not used by dl tasks")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
---
 kernel/sched/deadline.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9faaaf665459..cc5be00b2b0c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -205,7 +205,7 @@ void __dl_sub(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
 {
 	dl_b->total_bw -= tsk_bw;
 	if (cpus)
-		__dl_update(dl_b, (s32)tsk_bw / cpus);
+		__dl_update(dl_b, div_u64(tsk_bw, cpus));
 }
 
 static inline
@@ -213,7 +213,7 @@ void __dl_add(struct dl_bw *dl_b, u64 tsk_bw, int cpus)
 {
 	dl_b->total_bw += tsk_bw;
 	if (cpus)
-		__dl_update(dl_b, -((s32)tsk_bw / cpus));
+		__dl_update(dl_b, -(s64)div_u64(tsk_bw, cpus));
 }
 
 static inline bool
-- 
2.47.3

