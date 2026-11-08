Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794163891;
	b=UPsyOfOh7OlaiGKnVG1cFoCZJ7+Ki251QnIuEZtJvKMGKcUJPbathNceGuAywdc/F99j
	 x0qcOFhzWi5xPeVMjJ6lGduLFpfj7Qyyq43X2H7Z2w0seEc1+x4snxgyk7sa7pY795m4I
	 LhH/rVwgSDi7xv8cZTyjUxf2zejQ499PWto/nDXLz/XfAmz+Rybo3QLTzunHRi54zeVW6
	 Vg/Bvq4kXjETDlrkqLsBVvJ/6yfu8ZimcFSKGdhopg8aTFRTrhcxCwGBrcTxQ55lcRRc2
	 3HIhqZ8u2mAMSLdZOIATg9zA9H8UbiJHSTCba5QxNtB0jIYSuBm+KUPgiGxviqHey2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794163891;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hUOpDAvT+YMtqJM1uLKyhDMMzL6pBi7M7Ox4NWirryU=;
	b=5tixKSO1KMY19wuGzZd8CuF32E/+8wOD0UpDGj8Xd1vhmMb0mgn0GxkODZ3yLSCkCtU6
	 ZxSOcbgqHdDxauyYigsTSRpUylWm+lA1wlJwQ2/p2nfdplTS+5Wmoer167kI+zp5TOpbv
	 fli7pzWE3pOHf/i/MMO87H3OLL7sgvw3D3owrBZlXjXHlsNoAIVVqzqur09cAnlWz66z+
	 zjwz+BTtt2pxW6DGUE7LoaXFFRWVFa9ZfvkrDF4jkT4TfN1vnY2LDG9nKYluiXkljYmW+
	 HeH2PaY7hwbzvWbDzedCs7hpXYB9ocV51ejDH2B8eLVbhbtUcyAGtRimOJU0mdsyTNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZunSun+K;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1FC606A31C;
	Sun,  8 Nov 2026 18:51:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B1FC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=ZunSun+K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794163890;
	bh=hUOpDAvT+YMtqJM1uLKyhDMMzL6pBi7M7Ox4NWirryU=;
	h=From:To:Cc:Subject:Date:From;
	b=ZunSun+KFFRK+AC7fKBT+KrAvvVLHk2t9D9q2JDkXd6VGHh7LmmQzVo/7ncokG8zM
	 m9UC3VJWq03rEGc9arrIvZCc6TEOZBhrSxKGyF7iP+8gHKU9vZsNQCKv8D+SAFxiaK
	 ORolno/M4aBFsVzq2CtR48N2AAlGQ0Syqm0Q6S/9YDQEg5VEUUoJDFw7242N61CPXM
	 dMpW3RD8n/tT8cWKrL34H4c/mAm1Zc6rgOIUoiqPbrzCusR/f2yZ9ngA0fGdE6frlL
	 JY9Hs1OjcVTCuIWkvtqvg01EweQY79ijPJlCHTlsQC1HTpE6RsQ6t6jJ9snjR6jpGS
	 4XEhphPpIPKCA==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jN27j6mp5zMvb;
	Sun, 08 Nov 2026 13:51:29 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: frederic@kernel.org,
	peterz@infradead.org,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	longman@redhat.com,
	ridong.chen@linux.dev,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	bigeasy@linutronix.de,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] sched/isolation: Fix suspicious RCU usage without CONFIG_CPUSETS
Date: Sun,  8 Nov 2026 13:51:29 -0500
Message-Id: <20261108185129.1549419-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
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

Since commit 03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask from
cpuset"), cpuset can change the HK_TYPE_DOMAIN mask at run time. Readers
use RCU. housekeeping_dereference_check() also accepts readers that hold
a lock which keeps cpuset partitions from changing: the CPU hotplug
write lock or cpuset_mutex. During boot, before cpuset is writable, it
accepts all readers.

Without CONFIG_CPUSETS, nothing changes the mask after boot. But the
check still asks for one of these locks. In that configuration,
rebuild_sched_domains() holds only cpus_read_lock(). It calls
partition_sched_domains(1, NULL, NULL). That reads
housekeeping_cpumask(HK_TYPE_DOMAIN). sched_rt_handler() calls
rebuild_sched_domains() on each read or write of sched_rt_period_us and
sched_rt_runtime_us. So with isolcpus=domain, a read of
/proc/sys/kernel/sched_rt_runtime_us gives:

  WARNING: suspicious RCU usage
  kernel/sched/isolation.c:62 suspicious rcu_dereference_check() usage!
  [...]
  locks held by cat/91: 3, last CPU#3:
   [...]
   #1: (cpu_hotplug_lock){++++}-{0:0}, at: sched_rt_handler+0xb5/0xf0
   #2: (sched_domains_mutex){+.+.}-{4:4}, at: partition_sched_domains+0x37/0x990
  [...]
  Call Trace:
   lockdep_rcu_suspicious.cold+0x4e/0x9f
   housekeeping_cpumask+0xaa/0xb0
   partition_sched_domains+0x8e6/0x990
   sched_rt_handler+0xc3/0xf0
   proc_sys_call_handler+0x1cf/0x250

The report is a false positive. It needs CONFIG_PROVE_RCU and isolcpus=
with the domain flag, which is also the default when no flag is given.
Test runs that check the kernel log for lockdep reports flag it.

Fix this by accepting all readers when CONFIG_CPUSETS is off.

This change was developed with assistance from an LLM.

Fixes: 03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset")
Link: https://lore.kernel.org/all/20261108145931.1532447-1-mathieu.desnoyers@efficios.com/
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Waiman Long <longman@redhat.com>
---
This patch was first posted inside the bug report linked above. Since
then, it has Waiman's Reviewed-by. The code is unchanged.

 kernel/sched/isolation.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 156025ef81b7..dac9a1735198 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -43,6 +43,10 @@ static bool housekeeping_dereference_check(enum hk_type type)
 		if (system_state <= SYSTEM_SCHEDULING)
 			return true;
 
+		/* No cpuset, so the mask never changes after boot */
+		if (!IS_ENABLED(CONFIG_CPUSETS))
+			return true;
+
 		/* CPU hotplug write locked, so cpuset partition can't be overwritten */
 		if (IS_ENABLED(CONFIG_HOTPLUG_CPU) && lockdep_is_cpus_write_held())
 			return true;

base-commit: 006991aa89974378ee579416dba87adc22cd60fd
-- 
2.47.3

