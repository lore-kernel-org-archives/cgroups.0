Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794924682;
	b=g1Gp8LRu5/Q/tccarihK0NyiiZ+rk5GV92os743ADAs3zvTitDGSdhEirtfG4bA2HXTU
	 JTQWg1KSy3udFVXeDZFSkHY9eAdcqEUAS5pJataNEn2moRZQgyNqoYaO3R0+rUfBRSI/U
	 SaN0grYJEU4ZfP9+q+X9C3RxwLxLceae9KQNtulmIFvT5X+75rOp6LVWw3lKAJZwBBCl+
	 KZ/MdumD/36PfSaWRxIU/yNLSOW0/b3nyZ2O5MIaF5FccfaS36iuJf01FOtBt9NOnKKrf
	 yX5ks72Sifu7kpQPxlQdPnN6cIs8qbUF3ua6b4WjxWw6njrlFWVm1Y9f7Eu22cH6yGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794924682;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=7m4K/9EeVUGCVB8hgVAEdrBz/PXPTSzMXaoR4ahTjt0=;
	b=M70dIhFJJPS2P02t1F50GAU78OPTTsuKYoNf/n2DpZHq8HZbwn6THlofF+0klH/NENyo
	 IoksvOeJO+qI+Vxe//PK4od0FNJzooowf851aVtpSvEtMbYVf7A9X00QcjDISKkMfsn5G
	 Ch6iOPzSTwQlwZYnXH348/O5M9TM++XVbpvCS5XwmW9T3wcKbAM/ZJ7yjMoaQ6k/sWBeG
	 YmSPqBn4v8H8RwS4LdCTWju7maaLFZynJRH8wl0+eb4ZBdoxAO8zA1RsGQ8gLEFiXUcIn
	 R8TGZ3GibSm2pher/RRt8HVNMoJfzaRyd1QCql7jQfQfWyjqJDUI7VrooQVK7w9GiSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=knk4vtpO;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A36F606FCC4;
	Tue, 17 Nov 2026 14:11:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A36F606FCC4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=knk4vtpO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794924671;
	bh=7m4K/9EeVUGCVB8hgVAEdrBz/PXPTSzMXaoR4ahTjt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knk4vtpOuJPt9SAjztTjjiLEUD+qvbaSp76songDQ3XI3A879OL6r33IL28AhBTw5
	 v/V/wQg/146o+HiXeIfnrEgSEzGAuccwrrZDVx/Lxwtpx0yuEHd+Fo0wYMZ5SbtMSg
	 jvJP3KdV8e95/CWyXv1kfWw0bSQ/nnn3DfsvIai1LkwR60PjyAnWg78Z7TckbXHuAM
	 ywufjP3dZE0zeSLuN0/IJbSv/M4pdFTBYrt3Nh9cV878WlzhYeSYKWYrAPWJ9EHz5P
	 QzVzrXRI88KKEdRYcttETNBLWJ6DaEhoHGpwRM6yoE3XwpNT4AySR+c6Rzc3av2K+a
	 zLtgZCgqtX7BQ==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jTRV70d68zRHV;
	Tue, 17 Nov 2026 09:11:11 -0500 (EST)
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
Subject: [PATCH v7 37/40] sched/debug: Show the deadline bandwidth of each runqueue
Date: Tue, 17 Nov 2026 09:10:58 -0500
Message-Id: <a332a2c174f1c1c0e9350228c6f5bb52fe7b1584.1794922146.git.mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
References: <cover.1794922146.git.mathieu.desnoyers@efficios.com>
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

