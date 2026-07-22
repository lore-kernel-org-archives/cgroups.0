Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5065346EF7E
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 11:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784721208; cv=none; b=DQV8MziRWVaOJmwgjDDGthhdl10/WViESrTlJxAzjwv9ORxrIbvY0CM8gdysj8Ls6KaBf363xYiOgAKd94gjbWBOLqjsPiJXCkNtFnwwhNFexAkWpD3pw6H4D8Ism/aCxCVC5bYnON0sjQTON4pBRGLUtnY1pLGybiWvXsQV0yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784721208; c=relaxed/simple;
	bh=0ASyVCnBpvDQqETrHPlDnCS+JY5hzIkBFKk2vQRPmMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TkBPbDKp4hGFiPyNMYTGRoLvsAKBkEYcsm0aBZaneLBBRy3s6QWrIUN1H1YHG2BuJoCIJRk6zmioMSGzukvQeVnuo0gnfwjKTKCLePAZAnC3mkhbI9KJieUlvCILsBDcmsLgxrDPNH74gBjmJT+pkMKwD2hDl68XLinYGOKy6OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IAbc8XXT; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IAbc8XXT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784721203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IPVYjqDfahJcFbFwGdt21KmfFXJDCrmGuU0CvamCVYA=;
	b=IAbc8XXTJJzKb6aUhBw52TRMyivspP/WnCOjurNIHWtgwhNXn9/Ae6B/mECePCQRv10IZp
	NaQ4i/3PCIK/mSu3BkZ8lkSp/DmOn2eXImMCATtTLCLSrO5gcln/wH1QGD5EC3LYc2hCWE
	9Qa8PFtXkkJsOnKuu3gdwAPKBkf73PM=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [RFC PATCH 0/3] sched: Handle CPU freeze without active domain housekeeping CPUs
Date: Wed, 22 Jul 2026 19:52:35 +0800
Message-ID: <20260722115238.351821-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

During suspend, freeze_secondary_cpus() takes every CPU except the
primary offline. With domain isolation, the primary CPU can be excluded
from HK_TYPE_DOMAIN. Offlining the last domain housekeeping CPU then
leaves the frozen hotplug path without an active CPU in that mask.

This exposes three related problems. The frozen cpuset callback asks for
one fallback scheduler domain even though its span is empty. A user task
restricted to the CPUs being frozen can exhaust select_fallback_rq()
because the normal fallback mask has no active CPU. Finally, forcing such
a task onto a temporary CPU clears user_cpus_ptr, so the temporary
affinity can survive after the CPUs are brought back online.

This series preserves and restores user affinity across the frozen CPU
fallback, permits an isolated but task-capable active CPU as a temporary
last resort, and explicitly tears down scheduler domains while no active
HK_TYPE_DOMAIN CPU exists.

I am sending this as an RFC because the first patch adds scheduler state
for the freeze transaction and collects affected tasks during thaw. In
particular, feedback would be useful on the task tracking and restore
scheme, the use of task_cpu_possible_mask() as the temporary fallback,
and the explicit zero-domain request passed to
partition_sched_domains().

Reproduction
============

The problem was reproduced on a 32-CPU x86 physical machine booted with:

    isolcpus=domain,0,3-31

This leaves CPUs 1 and 2 in HK_TYPE_DOMAIN while the suspend primary is
CPU0. On an unpatched 7.2.0-rc3-next-20260716 kernel, with
panic_on_warn=0 and warn_limit=0, the following processor-stage suspend
test crashed the machine:

    echo deep > /sys/power/mem_sleep
    echo processors > /sys/power/pm_test
    echo mem > /sys/power/state

After CPU2 had been taken offline, rebuilding the scheduler domains for
CPU1 produced an empty span warning, followed by a general protection
fault in build_perf_domains():

    smpboot: CPU 2 is now offline
    ------------[ cut here ]------------
    WARNING: kernel/sched/topology.c:3093 at build_sched_domains+0x443/0xa60
    ...
    Call Trace:
     partition_sched_domains_locked+0x2dd/0x710
     partition_sched_domains+0x30/0x40
     cpuset_reset_sched_domains+0x25/0x40
     sched_cpu_deactivate+0x2f2/0x300
    ...
    Oops: general protection fault, probably for non-canonical address ...
    RIP: 0010:build_perf_domains+0x40/0x230
    Call Trace:
     partition_sched_domains_locked+0x3d9/0x710
     partition_sched_domains+0x30/0x40
     cpuset_reset_sched_domains+0x25/0x40
     sched_cpu_deactivate+0x2f2/0x300

Kdump captured a vmcore after the fault. This was not a panic_on_warn
failure.

Testing
=======

With this series applied, the processor-stage test was repeated while
the shell was restricted to the two domain housekeeping CPUs:

    taskset -pc 1,2 $$
    echo deep > /sys/power/mem_sleep
    echo processors > /sys/power/pm_test
    echo mem > /sys/power/state
    ret=$?
    echo none > /sys/power/pm_test
    echo "return=$ret"
    taskset -pc $$
    cat /sys/devices/system/cpu/online

The fallback path was exercised:

    process 7271 (bash) no longer affine to cpu1

The test completed successfully and the requested affinity and online
CPU mask were restored:

    return=0
    pid 7271's current affinity list: 1,2
    0-31

A real S3 cycle was then tested with:

    echo deep > /sys/power/mem_sleep
    echo none > /sys/power/pm_test
    rtcwake -m no -s 10
    echo mem > /sys/power/state
    ret=$?
    echo "return=$ret"
    taskset -pc $$
    cat /sys/devices/system/cpu/online

The machine entered S3, resumed, and brought CPUs 1-31 back online. The
result was again:

    return=0
    pid 7271's current affinity list: 1,2
    0-31

Neither test produced a scheduler-domain warning, GPF, BUG, Oops, or
panic.

Each patch was build-tested in sequence with x86_64_defconfig. The final
series completed a full x86_64 build. The affected objects were also
build-tested with CONFIG_CPUSETS=n and CONFIG_CPU_ISOLATION=y.

Guopeng Zhang (3):
  sched: Preserve user affinity across frozen CPU fallback
  sched: Allow isolated CPUs as a last resort during CPU freeze
  sched/topology: Tear down domains without active domain housekeeping
    CPUs

 include/linux/cpuset.h        |   7 +-
 include/linux/sched/hotplug.h |   2 +
 kernel/cgroup/cpuset.c        |   6 +-
 kernel/cpu.c                  |   2 +
 kernel/sched/core.c           | 191 ++++++++++++++++++++++++++++++++--
 kernel/sched/sched.h          |   4 +-
 kernel/sched/topology.c       |   9 +-
 7 files changed, 207 insertions(+), 14 deletions(-)


base-commit: 0718283ab28bc3907e10b61a6b4be6fefa1cbb2f
-- 
2.43.0
