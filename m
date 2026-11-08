Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164068;
	b=CuiFCG2GtA4KtRWWpaWP6ocxM1ErhMTMKG87lr+riZl82xpD6unJHKie4DUyoejFB4f/
	 OBq1SZIVTb85+f7KIVcJ+ceKYPSd1OSrFBVmXaFoY8A9zNzvtZnBF7WB4lo8tI/PhUJ+h
	 nc++G3qn0L3TNgWS+YtbilAp+PdMA9jZcUKemv9iiw0Md1xCkuc7nEPGAlmF3EjXV/bdX
	 0b4KQasX5s9luYn+kaJYG+du26Y0n4WYcxhUWlsypXuRiij2+hi3xckbpT9wTq2aVLuHC
	 asXe1p6mEueHnAn7H/U7x/R0e8tUoaFzJOa/ckweR68TmxIxkf/um7ygjCfrEziJqrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164068;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7m4K/9EeVUGCVB8hgVAEdrBz/PXPTSzMXaoR4ahTjt0=;
	b=T5jOlg+bEW0dtbh7EtG0dzePNGacjYh/tlS+qs1XrKHIJssF56PxMrzBJmD5IBP7ntH9
	 yBBA7kev4smTT+Qri0oHOxELRrXvz7zFNnMmy08X9OTXNmJ9Puoa1EFC0sOlimwzPGhP/
	 R3TW+1hVMfwaD/lDDG+hRYia7UZp5QpqGjSf33DZSfPHfVCpW4O8Wyic5XsZrnVQpF6ZG
	 6m4aLsU1I84pMOT+RiishTm+rFlN+yww0eJCl6K/8abtVH6smtTMRILPsvMhXp0HrKRGv
	 ybyGo5Lu95lPsyLVkekBp0nuY0ktlFz7SO62feN4C2kM2VIWyhAJfTf/PqUFGkQAk2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iBtYLePv;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D3060A2602;
	Sun,  8 Nov 2026 18:54:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03D3060A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=iBtYLePv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794164067;
	bh=7m4K/9EeVUGCVB8hgVAEdrBz/PXPTSzMXaoR4ahTjt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iBtYLePvOUeb4LgLLc124fiAThyOe+C8aC81ZjqF/mElGi8y+mSglXf+SmJY06r2w
	 +woCCkEKpEahQRNg+lo/YfpWVV3chkWkrYC3cFx3iy8ABR063BGRkMXJ7rB5QZB2SM
	 FOJaqhkuPLbcaYAxNDstc9iju6FvOK+8KCdPbx3Y0T9M9vMjt+0cbfFlR0R0FRuNSm
	 T9eeoCgs4UNaqgAOrr4e68sxXKOIFNFK4ULvYtCZ1nHLwFABszxG+F7X6pz0RPJadg
	 EAQU6Xo9j83XG4TmnEheXbtgmvIkzfF+ojL8re5V6RHUidVS7MDrR2Px29odohtXr0
	 4TGy3Q4tBWATw==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN2C70SyqzM62;
	Sun, 08 Nov 2026 13:54:27 -0500 (EST)
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
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v5 26/29] sched/debug: Show the deadline bandwidth of each runqueue
Date: Sun,  8 Nov 2026 13:54:03 -0500
Message-Id: <20261108185406.1549770-27-mathieu.desnoyers@efficios.com>
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

For each CPU, sched_debug prints the deadline bandwidth of its root
domain. It does not print the two sums of its runqueue. this_bw is the
bandwidth of the deadline tasks assigned to the CPU. running_bw is the
part of it that belongs to active tasks.

GRUB reclaiming depends on both sums. grub_reclaim() takes this_bw -
running_bw as the inactive bandwidth of the CPU. The more inactive
bandwidth, the slower a reclaiming task uses up its runtime.

The kernel warns when a sum wraps around, and when running_bw exceeds
this_bw. Bandwidth left behind in this_bw triggers no warning.

Print both sums. The deadline_bw_test selftest added later in this
series reads this_bw in its params_waking and random_mix cases. It
checks that this_bw is back to its first value once their tasks are
gone.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e0d6cd3bd607..3dbe1d7d2d77 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1174,6 +1174,8 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
 	SEQ_printf(m, "  .%-30s: %lu\n", #x, (unsigned long)(dl_rq->x))
 
 	PU(dl_nr_running);
+	PU(running_bw);
+	PU(this_bw);
 	dl_bw = &cpu_rq(cpu)->rd->dl_bw;
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->bw", dl_bw->bw);
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->total_bw", dl_bw->total_bw);
-- 
2.47.3

