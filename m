Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164064;
	b=MpO1Jd9bnw+HDa5bXFX0DzKEBa6RsY4EYE06+OgMmK/yBRORyqDw0Pj6CcWGhMNIW9vD
	 rNgDfA1OpRV/jRgmacXZaryvVyTnsfgEeIPLN55SV2jVhoYy65RhV3Ftemp9C0Hz/leGg
	 pYLfihOCTLl7Vh/RcTxxEJZLCbULvJqOmiTJ/Njl3loyNCaCv//89CJPJRqhNYfWALWev
	 6CMJ6FDUFybS7pk8LfWK4pcfW/EjETdAMNZQfK0QNglsPyiP0mpqpWohv4BE1M55oSRMG
	 UsvqGH3nTXyt5qkiC1ZoWQINnx49tQq9X5AmhOJs/0ZbML/kgW2AofchadSusieAvLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164064;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aGqliPBH7RBhZcMNQJM80qMsonLBgk1ozuoUrMKhcSs=;
	b=fdyTjTTP8Ew8n+s/X9qGAg+DEVfyq0TbS443YRdSJL/cTNbHQYU3WHDl4nHXmEPuCrqP
	 0+Fch+SifGMSqCnSR5j7NuyRCcdADRyWttYW/1HmHuJvpeOAmK7N6/y1BN4zrLXW9Cm1u
	 jbW6v/CjW3HC08onOMAOQiKC3MgVurCUnKZHJulZVcs+46zo4uUlE7TWwSKmtdC3NCH44
	 rm3ntGtqQEWPQQCaKdlxtj0ziwbDnQpl1A1V28TvRccPBd0EdTECxKsD2MsBOFN3U8avH
	 qUQgXI9XGuhiMOyW+8EqdQQWDeEomeKTifbsiXld1E6DQEWIygYtqvZD6OYKWr5xAqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m99H8sIG;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BA66082BCC;
	Sun,  8 Nov 2026 18:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58BA66082BCC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=m99H8sIG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164063;
	bh=aGqliPBH7RBhZcMNQJM80qMsonLBgk1ozuoUrMKhcSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m99H8sIGoGahnLVgwyxXr+NGa/YVwG9jSo9kM37G4JVvD1+QrDqo1mKeXY3RLSeJq
	 61c7gMsrlOYaVKZ2GKaTpLs0ePoe85jBYrtWIoSxWx+6XFatEnWeTKWlhA084xAGyD
	 kEkb4CM2Kf8GCY+LtTH6wI0Cn2t3CSxnRE/UoYwh+qs/WKpLHkIbpKuhE+ot9N3ZOx
	 BjO2hkyRXeYYeK3YX9lSsCsjs34NzwiYRTZHlj1dM0WNx/b3tLVFx3C/aVd61o1zD3
	 bt1hXx122cjAyXRLbKqm05RjmaKWx1Oqe+NONMU38syZG9VGoMA+BcnngE3fhNZXX6
	 18aN0AL2PFmLw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C32kdDzMqy;
	Sun, 08 Nov 2026 13:54:23 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH v5 17/29] sched/deadline: Leave a dying task out of a rebuild of the accounting
Date: Sun,  8 Nov 2026 13:53:54 -0500
Message-Id: <20261108185406.1549770-18-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
References: <20261108185406.1549770-1-mathieu.desnoyers@efficios.com>
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

A rebuild of the root domains' accounting takes the pi_lock of each
deadline task, not its rq lock. A dying task past its 0-lag time
releases its bandwidth at its last schedule. It holds its rq lock there,
not its pi_lock. Then it clears dl_bw. The rebuild can find the task
between the two steps.

In this diagram, T is a deadline task that exits on CPU 0 past its 0-lag
time. bw is its dl_bw. CPU 1 rebuilds the accounting:

  CPU 0 (T)                                  CPU 1 (rebuild)

  do_task_dead(): TASK_DEAD, under pi_lock
  __schedule(): T's rq lock taken
    task_non_contending(T)
      dl_task_release_bw(T)
        total_bw -= bw
        dl_bw_gen recorded
        record cleared
                                             dl_rebuild_rd_accounting()
                                               dl_clear_root_domains()
                                                 dl_bw_gen++
                                                 total_bw reset
                                               dl_add_task_root_domain(T)
                                                 T's pi_lock taken
                                                 dl_bw != 0, dl_bw_gen old
                                                 total_bw += bw
      __dl_clear_params(T): dl_bw = 0

dl_bw_gen does not help, since the release came before the rebuild. The
rebuild would count a bandwidth that nothing releases again. The root
domain would then refuse deadline tasks it has room for, until the next
rebuild.

Fix this with the record of the bandwidth, dl_bw_cpu. The release
clears it under dl_departed_lock, which the walk holds. So leave out a
dead task with no record. A dead task with a record has not reached its
last schedule. The walk counts it as a live task. That schedule then
releases the bandwidth, or puts the task on the departed list. A dead
task on the departed list keeps its bandwidth until its timer, and the
rebuild counts it as before.

The Sashiko AI review of v2 of this series found this window. Its review
of v4 found a gap in the first version of this fix. That version also
left out a task between TASK_DEAD and its last schedule, with its 0-lag
time ahead.

Fixes: f9a25f776d78 ("cpusets: Rebuild root domain deadline accounting information")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/deadline.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 4b3713e192b9..84102368822c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3727,6 +3727,17 @@ void dl_add_task_root_domain(struct task_struct *p)
 		if (recorded < 0 || !cpu_active(recorded))
 			goto unlock;
 		cpu = recorded;
+	} else if (READ_ONCE(p->__state) == TASK_DEAD && p->dl.dl_bw_cpu < 0) {
+		/*
+		 * Count nothing for a dead task with no record. Its last
+		 * schedule released the bandwidth under its rq lock, and has
+		 * not cleared dl_bw yet. The release clears the record under
+		 * dl_departed_lock, which this walk holds. A dead task with a
+		 * record has not reached its last schedule. Count it as a
+		 * live task. That schedule then releases what the walk
+		 * counted, or puts the task on the departed list.
+		 */
+		goto unlock;
 	}
 	rq = cpu_rq(cpu);
 	dl_b = &rq->rd->dl_bw;
-- 
2.47.3

