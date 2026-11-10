Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.13.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794308940;
	b=0gnRfRKKCvpH06m1+D2bOYR4gaZCGtDgMx9gccweX0/25NOh8CRXTMecT+I9YDpPVVWO
	 Kd18l1F3buBsylgvRK2BIMDbs12qFjvWTy6Jk5kmp+O7RtLpoYIT50ORF2bPQ8idzPWMB
	 8AQA7jHyLBO76iOZQg+d4mDZayQxnNfnIQUTzNmU4WuHqvErLCpsIRj90tF3wHChP2NIQ
	 QQK5GLj/78Bv+2QTHdo21hfkI6bdQOOTOF5InWtFZMHxMjw+lxYJonpWW80UA2NdObT1V
	 ElEZt2HibdpVQJxorv3ofxudJjbdjwYznPUzaK9D0LtpaRlRf9rmVJx+yExWLnc9jmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794308940;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=KvDrqDegwAYKd7Mcspe68jM1MbJTQ0OJ+8K52CXsHh4=;
	b=U/D1NQfkysXZS9MW4SpvmAPIt4NDVtCJz1Z2pXXsw5cLUaYlqRzV06eECOMiIWAwp2CT
	 6fZJXly4VQu2RnMT6/1pnc1AT7sa+J70FcpD5NyhqzZAo1b49B5v9gufvTozwBrHvTnRq
	 az/1/TxyISxMvHoZN74+d6gpZGjx9s2YMYyqfXiuHlKNp84AruTUFnp0C8t36xqy3qDYF
	 9Tqv6D+/FrrfnD7g69exOEf96FUwslOJNh+Ba4UAKiww8Qgy/thSdYsaA3nP5Jj6koSpo
	 SSwLxlxBOehAm8CzPJTINuCG5+beZiwTz1SsFHJpNybUm/di/BQSZg3DaWCfehjEHvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=V42rJJ0j;
	arc=none smtp.remote-ip=52.13.214.179
Received: from pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.13.214.179])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47845606A32A;
	Tue, 10 Nov 2026 11:09:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47845606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=V42rJJ0j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794308940; x=1825844940;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KvDrqDegwAYKd7Mcspe68jM1MbJTQ0OJ+8K52CXsHh4=;
  b=V42rJJ0jR8jqFWvVFEUbNXwB56P09kkY40h3Pv/wJ7isWdPeaONFfeKq
   3Z9D4dl+Lo+rr5sGGjUBW2NQhOCkg/YaIp5UrKPk7+vL3CMWwyFGRb5vu
   enm52p9tj0WXBFrA2AtaVrPkSozcsacYH6a3MgUKvx6Cip4Twu+nflo77
   /p78vY5im3fySuE4kqwump+ru01cEi60FOGXpTnGoEpjuXOI5uxhBIRGL
   QItnuueptK9p1dJma9E2l4ggQC3m2VhjrbL2uRRdzaDDzyBbSqCuD3+3Z
   WcUY3dALsCCOREnRLQ3r/mLw/K2cg1pLsLlIy8urj+2vKoMGR/qDH6eDy
   A==;
X-CSE-ConnectionGUID: aR6zlIZBQU6vT48FwkCK7Q==
X-CSE-MsgGUID: 6PRGNtUNRxuZpaPh4rMeoQ==
X-IronPort-AV: E=Sophos;i="6.27,205,1787011200"; 
   d="scan'208";a="33581791"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-005.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2026 11:08:57 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:12624]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 207aec50-ca4c-41b6-ad47-e8c3dd67d201; Tue, 10 Nov 2026 11:08:57 +0000 (UTC)
X-Farcaster-Flow-ID: 207aec50-ca4c-41b6-ad47-e8c3dd67d201
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Tue, 10 Nov 2026 11:08:57 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Tue, 10 Nov 2026
 11:08:52 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <tj@kernel.org>
CC: <bsegall@google.com>, <dietmar.eggemann@arm.com>, <rostedt@goodmis.org>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<hannes@cmpxchg.org>, <mkoutny@suse.com>, <void@manifault.com>,
	<arighi@nvidia.com>, <changwoo@igalia.com>, <skhan@linuxfoundation.org>,
	<corbet@lwn.net>, <rdunlap@infradead.org>, <cgroups@vger.kernel.org>,
	<sched-ext@lists.linux.dev>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>,
	<hborghor@amazon.de>, <fmubeen@amazon.de>, <dwmw@amazon.co.uk>,
	<karataev@amazon.com>, <sieberf@amazon.com>
Subject: [PATCH v2 0/4] sched/fair: cpu.max.runtime and idle refill for CPU credits
Date: Tue, 10 Nov 2026 13:08:47 +0200
Message-ID: <cover.1794303670.git.sieberf@amazon.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This series adds cpu.max.runtime, a cgroup v2 file to read and set the
runtime the CFS bandwidth controller has for a cgroup, lets
cpu.max.burst exceed the quota, and makes an idle group keep earning
quota up to quota + burst. Patch 3 passes the writes on to BPF
schedulers, and patch 4 lets them charge their tasks to the same
runtime.

Use case
========

We run virtual machines whose CPU time is governed by CPU credits, as
burstable instances are. Each instance has a baseline, which is the
share of its vCPUs it may always use. Running below the baseline earns
credits, running above it spends them, and the credits an instance holds
are capped. When it has none left, the instance is held to its baseline.
The starting credits, the baseline and the cap are part of the instance
type's guarantee and must hold whatever the host does to the instance.
An instance must neither lose credits nor gain credits it did not earn.

Each instance's vCPU threads run in their own cgroup, and the CFS
bandwidth controller is that bucket of credits as it stands:

  - quota per period is the rate credits are earned at, the baseline;
  - quota + burst is the cap, the most credits an instance can hold;
  - the runtime is the credit level. The controller refills it by the
    quota every period, up to quota + burst, and throttles the cgroup
    when it runs out.

The controller already does the per-CPU charging and the throttling in
the scheduler, at a granularity that userspace accounting cannot match.
Three things are missing. The cap cannot exceed one quota, because
burst is limited to the quota (patch 1 drops that limit). The level
cannot be read or set (patch 1). An idle group does not earn (patch 2),
because the period timer stops after a period in which the group did
not run, and the periods it sleeps through refill nothing. For example,
an instance that idles for a minute with a 100ms period earns one quota
instead of up to 600.

The level has to be read and set by the host's control software:

  - at launch, an instance starts with the credits its type grants, not
    with one quota;
  - across a host kernel live update (kexec) or a reboot, the cgroups
    are created anew, so their levels have to be read before and
    written back after, or every instance loses or gains credits;
  - a live migration moves the level with the instance to the new host;
  - the control plane raises or lowers the level, for example when
    credits move between instances.

Ben pointed out that a cpu.max or cpu.max.burst write already adds a
quota to the runtime, and that cpuacct gives the usage. That falls
short of the cases above:

  - it can only add, and only one quota per write. Setting a level
    requires writing a temporary quota equal to the difference and then
    the real quota back. Lowering a level, which a restore or a transfer
    may need, requires shrinking the burst until the cap cuts the
    runtime and then widening it again. Each of these leaves the cgroup
    running with the wrong bandwidth in between, and each write goes
    through tg_set_cfs_bandwidth(), which visits every CPU's cfs_rq;
  - usage is not the level. Deriving the level from the usage requires
    replaying every period's refill in userspace, including the periods
    the timer slept through, which duplicates the controller's
    accounting.

Keeping the credits in a BPF scheduler instead (patch 3 lets sched_ext
follow the level) does not remove the need. The credit guarantee has to
hold before a BPF scheduler loads, after it exits or errors out, and on
hosts that run no BPF scheduler. The tasks are then on CFS, where the
bandwidth controller is the only enforcement, and it has no BPF hook to
refill or set the runtime.

Patch 2 changes behavior for existing cpu.max.burst users. A group with
a burst that becomes runnable after idling has up to quota + burst, as
if it had been running below its quota throughout, instead of the
runtime it had when the timer stopped. Groups without a burst see no
change.

Testing
=======

On tip/sched/core in qemu with lockdep, the cgroup test_cpu selftests pass,
including eight new ones for patches 1 and 2, and so does the new
sched_ext selftest cgroup_runtime, which covers patches 3 and 4. Every
patch builds with W=1 and no new warnings, with and without
CONFIG_CFS_BANDWIDTH and on 32-bit.

An AI coding assistant (Claude Code) helped write the selftests and
changelogs and ran the build and test matrix; I reviewed all of it.

Changes in v2
=============

- New patch 2: refill the periods the period timer slept through.
- New patch 4: with the new SCX_OPS_CHARGE_CPU_MAX flag, a BPF
  scheduler's tasks are charged to the fair class's runtime, read with
  the new kfunc scx_bpf_task_cpu_max_runtime(); selftest
  cgroup_runtime.
- Patch 1: a write distributes the runtime to throttled cfs_rqs at once
  (Ben); a write moves runtime_snap so it is not counted as burst
  usage; a read is capped at quota + burst so it can be written back;
  a write needs a quota; burst is bounded so quota + burst cannot
  overflow (Ben); cpu.max.runtime needs CONFIG_CFS_BANDWIDTH (v1 did
  not build with CONFIG_EXT_GROUP_SCHED=y and CONFIG_CFS_BANDWIDTH=n);
  documented in cgroup-v2.rst and sched-bwc.rst; four more selftests.
- Patch 3: the callback is invoked on every write, since writing the
  same value again adds back what the cgroup ran; it is serialized with
  cpu.max writes and may be sleepable; the cached value is dropped; the
  cid-form variant, ops.cpuctl_set_runtime(), is added. Both writes hold
  a new mutex across the fair class's update and the callback, so
  cpu.max and cpu.max.runtime writes reach the scheduler in the order
  the fair class applied them.
- Use case described (Tejun). Rebased on tip/sched/core.

v1: https://lore.kernel.org/all/20260525193622.70282-1-sieberf@amazon.com/

Fernand Sieber (4):
  sched/fair: expose cpu.max.runtime to set bandwidth runtime directly
  sched/fair: refill bandwidth for the periods the timer slept through
  sched_ext: add cgroup_set_runtime ops callback
  sched_ext: charge BPF scheduler tasks to cpu.max bandwidth

 Documentation/admin-guide/cgroup-v2.rst       |  27 +-
 Documentation/scheduler/sched-bwc.rst         |  14 +-
 kernel/sched/core.c                           |  61 +-
 kernel/sched/ext/ext.c                        |  53 ++
 kernel/sched/ext/ext.h                        |   2 +
 kernel/sched/ext/internal.h                   |  45 +-
 kernel/sched/fair.c                           | 260 ++++++-
 kernel/sched/sched.h                          |  15 +
 tools/sched_ext/include/scx/common.bpf.h      |   1 +
 tools/sched_ext/include/scx/compat.h          |   1 +
 tools/testing/selftests/cgroup/test_cpu.c     | 519 ++++++++++++++
 tools/testing/selftests/sched_ext/Makefile    |   1 +
 .../selftests/sched_ext/cgroup_runtime.bpf.c  | 195 ++++++
 .../selftests/sched_ext/cgroup_runtime.c      | 652 ++++++++++++++++++
 tools/testing/selftests/sched_ext/config      |   1 +
 15 files changed, 1836 insertions(+), 11 deletions(-)
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_runtime.bpf.c
 create mode 100644 tools/testing/selftests/sched_ext/cgroup_runtime.c


base-commit: d7e670601af6c564ccf6d3b2ddf70ee4f41a6d1c
-- 
2.47.3




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

