Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795096188;
	b=HpvcJxX5ON6nefNnlirVh8/VG/T2JLkB9YwrfJYICAatIzu/Aw9bmEQ5hyinkXMN4sfg
	 eaCWNXtfaI6HZPrmrpCuy9F4+SHhBAtqch3mEq4D+dhFuKgj0jmyPojwKeeDw2CT14LDf
	 X6VxQ/vRUOzgnU1pf9PFg4WjySCiNFpNOsK1WdfZBfCJJbvGTIgSdfyZOxDLe0ljsNNCW
	 QLys3KDwRSoIlsG8BPt5fMLaSh4gQPjyPtaKSclFUZXkxBBLJOlnhQjzx9bC28gASG7cW
	 RJ/JNrZVvYmA9xWVn16AFPak8k9jxFT/EsmwWxBTz5E4M+74imKydmRqFtFn5uviqQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795096188;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6c2WfmmuO5OP5xCe2CrO1/Z/FsV4bpBjjt1tFRNTMew=;
	b=3bYMUfUUHBHCYiu/R2te8GYk3dhJYw7hGlfwvYT/K6lsC7hQ0EjCq07XqXKe6a00OBAt
	 7+uMc9b1d0yQqr7bts/7JMel5UugK+b2sjuuMqJB9K1rIWcZzvZ6odYEGbLbeXy0joFL6
	 ojLAw19lCrBjMU52+80ysfr39IvEw5kJ9sMPP5u0dDbQDk31H036aEZdXOEsyI4B92tiB
	 8i67CgB/v3rseymPB9MBXH6VV1zB19CoWdkw+AV4pV2DqkcILl6emwfZPXRsCOS4uPg6m
	 h2T2JflJq2qdBIVojZAFpthVJjJnV9Vkw/I0LNx1WqeUuiA8AU7emWxQWQXpxjLnRcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=nbAjXoZt;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AEE60A6F48;
	Thu, 19 Nov 2026 13:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80AEE60A6F48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=nbAjXoZt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795096186;
	bh=6c2WfmmuO5OP5xCe2CrO1/Z/FsV4bpBjjt1tFRNTMew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nbAjXoZtX42PeowIIhmpcBkDF8U15tOnggCrszKcifuwlLJnYdgew2IoXBY1Hbszc
	 dBzJ46njTAslmkOEBbESkeHP9cqP3jm89C7X6KHiKDiAg/I3I/YcUH23B6SwnQOn8A
	 KJFQOX0SXBojrzgah9ihf9gCLfOYgTnDS3WNrsCbAeXch+wPM+xcTncGbnVY3iEo7O
	 k1DxK/YoqVBdR/HX8+xaEEU6oxjO5bFTomm0J7cTJvOIwSXY6kTkQetbLNgjp8NvdC
	 VGeurA8w3i3JNYdPT+rK/5QNebwmt/ljB+KxA0p86HqVmjrF5ubSTvW4PEyUf8pGtc
	 xxd1eabf6SwtA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jVfwV2Xt0zSS4;
	Thu, 19 Nov 2026 08:49:46 -0500 (EST)
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
Subject: [PATCH v3 15/17] sched/debug: Show the deadline bandwidth of each runqueue
Date: Thu, 19 Nov 2026 08:49:38 -0500
Message-Id: <4cf619e4c29a370891bb62a0f1fc17e10b0fc943.1795092090.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1795092090.git.mathieu.desnoyers@efficios.com>
References: <cover.1795092090.git.mathieu.desnoyers@efficios.com>
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
series reads this_bw in its params_waking case. It checks that this_bw
is back to its first value once the tasks of the case are gone.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/sched/debug.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ddb382df454b..2c373adf3196 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1175,6 +1175,8 @@ void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
 	SEQ_printf(m, "  .%-30s: %lu\n", #x, (unsigned long)(dl_rq->x))
 
 	PU(dl_nr_running);
+	PU(running_bw);
+	PU(this_bw);
 	dl_bw = &cpu_rq(cpu)->rd->dl_bw;
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->bw", dl_bw->bw);
 	SEQ_printf(m, "  .%-30s: %lld\n", "dl_bw->total_bw", dl_bw->total_bw);
-- 
2.47.3

