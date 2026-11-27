Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790180;
	b=IQXRLQHt8hHazJZTB6f9yLeRn8n43Pc7zjQ4natDWsAnCZOHI4ARfCjxEMxEQj8WdKVV
	 wgR/QCVu5RLonh2tyYAajt7BIkX5NS/QofV88T8UqIMBqvlbFkL176Md8qHX6KcgKXORJ
	 TZxWIyUXN8rjXD04n0ruoGA4km/JMBZQl1PpO+5j0NL/112GAZqheYNu13WpbZeUcxh1L
	 DMh1OK10HaG78Rg+0z57oG406jd/mXeZIpNHPXgelm4TBcPssDcgUeARW2sE3dKlXX4hp
	 rPSSrBI8XolLZ0Ig9Q/GvaSMz4/nFee2TBs9HPv/6iidDvwtbcN0ptcw6gB0gOtZA9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790180;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xlit8UDlMgjmL1LAqwBre9uYWNjfJ8TZHFuYyxZD4Po=;
	b=jYQVaxqYXOFffSKsG6JQp+M1Soe+vA00j3zh2h1xBj76hq8bw32sCsfW2o3LRx+5+xBc
	 YKDcxzj/IE4sJVSIhgmP1NNGQ/H6OTqcGjKCpxFIRjW9Doo2Gv/ZK980jjd5Heat1wajt
	 GNir/SesnGNmXeFXdavH6ZZjdb9CAvtS4vgvlr8EYP9UFcGVrhNkx8Es7AKcYUyf983/L
	 YxalUsR9r3Rq/Nz6+kvHCZKoMBsX8Z4MYaaRBipgA1IyrwLhlY390bi1TTCblbSDi0h0m
	 k0aeX1Wk1RSS/X56uZB8gJoY7svVIqIGo4xMGxExzOaYMa7gIZoCCaumOVoRK5hL+Jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FnZvydeN;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EB360A5BD4;
	Fri, 27 Nov 2026 14:36:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97EB360A5BD4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=FnZvydeN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795790177;
	bh=xlit8UDlMgjmL1LAqwBre9uYWNjfJ8TZHFuYyxZD4Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FnZvydeNbOp/s4qJEjcZHaiNxr8GXCHNhCzAHyioMVElvRA0zqOeJ2bePfHA7Z6a/
	 EqHxHuWDSu2Zi4vwGp5jjiZl3mmX1vyXrXm9HYHpkrsPyRitgD6lKdoSJUKj6MQorE
	 6Kv7wT5HciYSs9znRUpr328giGu4xxAEcX5b7mueuJg4qraThmcn/RMN0z8LvufEBx
	 ECU3cghNAyZ/N/KpiCPaZ5FVOiwCpn2bL3vTmIfhKNpS3lj/xvU6cZxWyoOoiMawhD
	 REwxJWdzdPZijOoIhxKG14uTFRoYrkgYJuhA+Q4r9wmPnNF8SsZg4Q5FEyUuje/J6r
	 PJ+kQDqrrWoag==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jbbZT0FTyzXFY;
	Fri, 27 Nov 2026 09:36:17 -0500 (EST)
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
	tommaso.cucinotta@gmail.com,
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
Subject: [PATCH v12 20/43] sched/deadline: Do not truncate a bandwidth to 32 bits in __dl_add/sub()
Date: Fri, 27 Nov 2026 09:35:47 -0500
Message-ID: <3300daac81b2483e451bca006dfaa2da5b21fced.1795771148.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
References: <cover.1795771147.git.mathieu.desnoyers@efficios.com>
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
index 3f02d150e15d..7a6057326611 100644
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

