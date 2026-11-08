Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794149866;
	b=chEqOICGbaXI0tC90TMkx1P5hifU9vHbsxl1gtw8GutVc4DM0HeqdUO5e8CJDbXdi3XN
	 zgWI7tmAI8Uf8y+/K6I731PCEIfxR+aEI0gYRGcfJxBwjvP7loMmGCKEqxovIxJTK0nuY
	 p32uGxniNyr+BvZJu4AdO+ThUDeGRZAdgc7Z6Ihc69UDhW6PawWx4IkTwBrF98j2ZNnKw
	 aVh4hGvV7J4VFWh+doirE2FDJbloqC20Io2CwA/LbhH7HsDq+aDI7mXvuTWlB1fKgxPqy
	 OFzJ4ATuSuDCIY0BjCQ0VsCMcHC11+fLd+STOC4AfbWw0W0O8ZxONj/QJBeQa3J3iRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794149866;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Dylf67nwHfklDea5FFKRq7P4qQLACKoIR1mg5t6+viM=;
	b=Ty6Maw2UlCMK7XaN0bNdmWWBOdzlfCnQ9xPcxpDyzw32nDNqjrjYr41cr968wuUcbbRX
	 AwodsuL36utP+AF6NKq2M4ExXZaAxUPhOSh23ptI/F2yw8M1skKAGs/MVDMVM/wr8jqXg
	 BVU/nMN57kL691v0TC7WXGLpqHPBI5321OLgENPKwJ096rzzbQsJTosm61PHKsjsdA2Bw
	 EERELbGpDnBskxohTBidtwJU69N+2YG/pj1n7Mm6csbePWpEJZPk1/UW9g7ebQiUyaJn+
	 deO24z7l5Mwk1n6YWlFQvNRz9zHDHTsb0HDbrHrWwg3WSLc1XMh5wwHs/KEvqxBbVVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=XXy66fcm;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAC1606A31C;
	Sun,  8 Nov 2026 14:57:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BAC1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=XXy66fcm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794149864;
	bh=Dylf67nwHfklDea5FFKRq7P4qQLACKoIR1mg5t6+viM=;
	h=From:To:Cc:Subject:Date:From;
	b=XXy66fcmcq1LfdIwARVM1BRnYsdc8WwXXOthKe/RZ425zqiI0hvk482lLwexCrlDw
	 aMvQ3qWCH3M84vA73cfqtn+uWozP433zRHDMi1aPEwMkFYoKU/WKh1SECapChgMH81
	 CY98cO2B0VSyL+WtmX5WjlvAXeo0bDFRhoPAVyvA7ZDBqPFc74Kr2O/NvWrvXylwLA
	 xLV3OG9KzsJfirgJQsZbycwCm6TzzjF6QmVd68TH1TcRal5TJKo9yw22ci4hvAGbi2
	 1Sj0urT9b7eWCRA0i4guSTrgEOrWvV9VMd1aFz4pWjGwXRV0nuD14sHu+w8bzTvLDm
	 r0UEJ4ZxpfSgQ==
Received: from thinkos.internal.efficios.com (unknown [64.58.40.251])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jMwy04FnnzMt6;
	Sun, 08 Nov 2026 09:57:44 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Waiman Long <longman@redhat.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Valentin Schneider <vschneid@redhat.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] cpuset: empty sched domain with isolcpus=domain, panic at CPU offline
Date: Sun,  8 Nov 2026 09:57:44 -0500
Message-Id: <20261108145744.1532128-1-mathieu.desnoyers@efficios.com>
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

Hi,

With isolcpus=domain, cpuset partitions can take all the housekeeping
CPUs. The top cpuset then gets an empty sched domain. In a VM, this
gave a WARNING in build_sched_domains(), then a panic at the next CPU
offline. I hit it once, while testing a SCHED_DEADLINE series [1]. The
analysis below is from reading the code after that panic. A proposed
fix follows the scissors line.

The code involved is the same in v7.4-rc1 and in tip sched/urgent
(006991aa8997). The series does not change it.

Trigger
=======

Boot 5 CPUs with isolcpus=domain,0,1. Then, with cgroup v2:

  cd /sys/fs/cgroup
  echo +cpuset > cgroup.subtree_control
  mkdir P Q
  echo 4 > P/cpuset.cpus
  echo root > P/cpuset.cpus.partition
  echo 2-3 > Q/cpuset.cpus
  echo root > Q/cpuset.cpus.partition          # WARNING
  echo 0 > /sys/devices/system/cpu/cpu2/online  # panic

The test that hit it made these writes. It also ran a deadline task in
Q, which the analysis does not need. After the writes, the top cpuset
keeps only CPUs 0 and 1, which are isolated.

Log
===

  WARNING: kernel/sched/topology.c:3111 at build_sched_domains+0x1321/0x1830, CPU#0: orig/91
  CPU: 0 UID: 0 PID: 91 Comm: orig Not tainted 7.4.0-rc1-00300-gc36e8c1d51c9 #98 PREEMPT(lazy)
  Call Trace:
   partition_sched_domains+0x331/0x990
   cpuset_update_sd_hk_unlock+0x76/0x80
   cpuset_partition_write+0x9e/0xe0
   kernfs_fop_write_iter+0x14d/0x210
   vfs_write+0x252/0x550
   ksys_write+0x6c/0xe0
   do_syscall_64+0x109/0x5d0
  [...]
  BUG: unable to handle page fault for address: 0000000083cf6513
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP NOPTI
  CPU: 2 UID: 0 PID: 26 Comm: cpuhp/2 Tainted: G        W           7.4.0-rc1-00300-gc36e8c1d51c9 #98 PREEMPT(lazy)
  RIP: 0010:partition_sched_domains+0x5ee/0x990
  RAX: 0000000083cf58c3 RBX: 0000000000000003 RCX: ff11000004f60b58
  R10: 0000000000000200 R11: 0000000000000004 R12: 0000000000000040
  Call Trace:
   cpuset_update_active_cpus+0x512/0xb00
   sched_cpu_deactivate+0x1f3/0x300
   cpuhp_invoke_callback+0x1b4/0x780
   cpuhp_thread_fun+0x183/0x260
   smpboot_thread_fn+0x143/0x300
   kthread+0xfe/0x130
   ret_from_fork+0x22a/0x330
  Kernel panic - not syncing: Fatal exception

Analysis
========

The top cpuset may hold CPUs isolated at boot. generate_sched_domains()
keeps a partition root if its effective_cpus is not empty. For the top
cpuset, it then builds the domain from effective_cpus without these
CPUs:

	if ((cp->partition_root_state == PRS_ROOT) &&
	    !cpumask_empty(cp->effective_cpus))
		csa[ndoms++] = cp;
	[...]
	if (!csa || csa[i] == &top_cpuset)
		cpumask_and(doms[i], top_cpuset.effective_cpus,
			    housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));

Here effective_cpus is 0-1, so the domain is empty.
build_sched_domains() warns and builds nothing. But
partition_sched_domains_locked() still records the empty mask in
doms_cur.

At the CPU offline, cpuset passes the empty domain again. It matches
the empty one in doms_cur. The reuse branch then reads the runqueue of
the first CPU of the mask:

	int cpu = cpumask_first(doms_cur[j]);

	guard(rcu)();
	sd = rcu_dereference(cpu_rq(cpu)->sd);

On an empty mask, cpumask_first() returns NR_CPUS when NR_CPUS is at
most BITS_PER_LONG. This kernel has NR_CPUS=64. R12 = 0x40 is that
index into __per_cpu_offset[], one entry past its end. The load of
rq->sd then faults.

The partition checks do not refuse Q. tasks_nocpu_error() tests the
effective_cpus of the top cpuset, which still holds CPUs 0 and 1.
prstate_housekeeping_conflict() keeps boot time isolated CPUs out of
root partitions. Nothing asks the top cpuset to keep a housekeeping
CPU.

Versions:
- The empty domain comes from 9b496a8bbed9 ("cgroup/cpuset: Prevent
  leakage of isolated CPUs into sched domains"), in v6.13.
- The reuse branch comes from a7660ce1590f ("sched/cache: Fix
  has_multi_llcs iff at least one partition has multiple LLCs"), in
  v7.2.

From v6.13 to v7.1, a similar read would happen elsewhere. This is from
reading only:
- detach_destroy_domains() reads per_cpu() of cpumask_any() of the
  mask, when the empty domain goes away.
- With CONFIG_ENERGY_MODEL, build_perf_domains() reads
  cpu_rq(cpumask_first()) of the mask at its first build.

Where to fix
============

Commit cd1cb3350561 ("sched/topology: Don't try to build empty sched
domains") fixed a crash of this kind in 2019. It made
generate_sched_domains() skip empty masks. Its changelog says that the
scheduler should not have to check cpumask_first() against nr_cpu_ids.
So the patch below fixes cpuset. It keeps a partition root only if its
effective_cpus holds a housekeeping CPU.

Two questions:
- Should cpuset refuse a partition that leaves the top cpuset without
  a housekeeping CPU? The patch keeps the current behaviour. The
  partition is valid. The tasks of the top cpuset run on the isolated
  CPUs.
- Should the scheduler also skip empty masks? The reuse branch, the
  perf domain code and detach_destroy_domains() all take a CPU from
  the mask.

Testing
=======

With the patch on tip sched/urgent (006991aa8997), in a VM with
5 CPUs:
- isolcpus=domain,0,1 and the sequence above. There is no WARNING.
  All CPU offlines and onlines complete. Q gets the domain 2-3, and the
  top cpuset gets none. The top cpuset gets the domain 2-3 back when Q
  becomes a member again.
- The same boot, with P as an isolated partition. Q is a root
  partition first, then isolated too. With both isolated, no partition
  root has a housekeeping CPU. The scheduler then gets no domain, and
  CPU hotplug works. Making Q isolated also warns in
  cpuset_update_sd_hk_unlock(). That is a separate problem, which I
  report separately. The patch does not touch that path.
- No isolcpus, and the same sequence. There is no WARNING. The top
  cpuset keeps its domain 0-1.

test_cpuset_prs.sh passes on 9 CPUs. It also passes on 10 CPUs with
isolcpus=domain,9. I did not run the crash sequence again on a kernel
without the fix.

The analysis and the patch were written by an LLM coding assistant
under my direction and review.

Thanks,

Mathieu

[1] https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/

-- >8 --
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: cgroup/cpuset: Do not build an empty sched domain for the top cpuset

The scheduler expects each sched domain from cpuset to hold at least
one CPU. Commit cd1cb3350561 ("sched/topology: Don't try to build empty
sched domains") made generate_sched_domains() skip a cpuset with an
empty effective_cpus. It also made build_sched_domains() warn on an
empty mask.

The top cpuset may hold CPUs isolated at boot. Commit 9b496a8bbed9
("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
removes them from its sched domain. The check for an empty domain was
not updated. It still tests effective_cpus, which includes the isolated
CPUs.

So partitions that take all the housekeeping CPUs leave the top cpuset
with an empty domain. For example, boot 5 CPUs with isolcpus=domain,0,1.
Then make CPUs 2-3 and 4 root partitions. build_sched_domains() warns.
The scheduler still records the empty mask as a current domain. At the
next rebuild, the new empty domain matches it.
partition_sched_domains_locked() then calls cpu_rq() on cpumask_first()
of the empty mask, which is not a valid CPU. In a VM, the next CPU
offline panicked there.

Fix this by keeping a partition root only if its effective_cpus holds a
housekeeping CPU. This tests the mask that the top cpuset gets.
prstate_housekeeping_conflict() keeps boot time isolated CPUs out of
the other partition roots. So nothing changes for them.

This change was developed with assistance from an LLM.

Fixes: 9b496a8bbed9 ("cgroup/cpuset: Prevent leakage of isolated CPUs into sched domains")
Cc: stable@vger.kernel.org
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/cgroup/cpuset.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..426c98cf4a08 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -894,10 +894,13 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	cpuset_for_each_descendant_pre(cp, pos_css, &top_cpuset) {
 		/*
 		 * Only valid partition roots that are not isolated and with
-		 * non-empty effective_cpus will be saved into csa[].
+		 * housekeeping CPUs in effective_cpus will be saved into csa[].
+		 * The top cpuset may keep only boot time isolated CPUs. It then
+		 * gets no sched domain.
 		 */
 		if ((cp->partition_root_state == PRS_ROOT) &&
-		    !cpumask_empty(cp->effective_cpus))
+		    cpumask_intersects(cp->effective_cpus,
+				       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 			csa[ndoms++] = cp;
 
 		/*
