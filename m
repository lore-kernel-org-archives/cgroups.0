Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=52.34.181.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400203;
	b=rcxRBe0CeONrrRlJp8CKST1ybn1byG4AJA3rXqjRYyLPH+kDzhB3P+bpci4izToskL/B
	 7SQg32IxBuznT7CdsPCYYL5fwtwDw9IpUldBStIiN82/l86tIgaBZb1E+GvoMeEYTXccb
	 4Ad1lLwTyk1HrsVUQZVKfOiWJgMoLCry1GeVAvrbV9nXX/cKpWL5ftWs2O9/adWQF//nW
	 cnf4WceVvs/WmOmcF/zRFOwUUhmCAzCD6J14YCd+uWUU9wb8CJdNJKhaXK6zNP1uGoBgb
	 I/FW8WvCowKv/uFBHod6gVlrVptNyeKi1i/8EoHDtdzW0SkSJlaS4TmHljWKFD4ytRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400203;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Originating-IP:X-ClientProxiedBy:Content-Type:
	 Content-Transfer-Encoding;
	bh=yKidSItLVp1j8CFzrK2fS2DWMBZXoQ8cqdCTFx+9orQ=;
	b=RHdEKRje/LTvIAwGmE2bzonz9Kjm3lMWC/Vc9v0fmynW7cvs22jmx9XoD44KdGKREwl7
	 ccktgjf0he2iLTX8SaXpz9KBbfn78i8iAqiZQRkqnPiPMtFDpn29mQPKhdJAM8Yqccs85
	 mV/ECyZLPJoeRq2XEJ8uQGkaAUZ46r4AFlsbx2wB85+0eQRRFRi6RzXD43Ap58oWm1boh
	 FFKVCZNFfbpKCcHsB0qy3asyztM8epExX8fL1QMt35vGcxxdzKz5nqXgL051oKonKALE+
	 0PsUzMAMLcHQjpqjCbFymL912Id29IC4aihoNZCAudx1oWy5shKUmAYc37Oe0bi8iQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=qywRoTfs;
	arc=none smtp.remote-ip=52.34.181.151
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C26606A33B;
	Wed, 11 Nov 2026 12:30:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0C26606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=qywRoTfs
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794400202; x=1825936202;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yKidSItLVp1j8CFzrK2fS2DWMBZXoQ8cqdCTFx+9orQ=;
  b=qywRoTfs8AOHY1RN3tT/sgvR5W5VeokYzcfYUT0HoYB66mbpDOnmhlCJ
   rCwAjtQaaHLzBvZtfNfgFqPIGK4ZdIHPS+Z9YuN+aThkHeIVrcNd3iL40
   38ocTAtDufUti00IrtQf+R9vNzGzztIBffcJos7jP31KKAJA5V+VBcnp5
   MIxBEmH0QphnQ/vIDrsiNqeyiuCUn7/9bOIbMmuHLPlcKPkH5VNuCHCVv
   KW5+WwCw523KVtruDdZBusei4V5Cz0pjcm3qtBWcGt/nIPHP7iE72MntO
   T1HTho4eIFuIIvpPZ5QxGmp3kmuoiQeBxv2uHIyjCj49rstDVuyFHPWtu
   g==;
X-CSE-ConnectionGUID: 946Dg+BBSOWP+RyxLKx4jQ==
X-CSE-MsgGUID: /XGFre61RRC8KHN5kOw5hQ==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33707194"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 12:29:55 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:21904]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.50.212:2525] with esmtp (Farcaster)
 id 4c4c3c39-5ab1-4152-ae8a-baf3204da036; Wed, 11 Nov 2026 12:29:55 +0000 (UTC)
X-Farcaster-Flow-ID: 4c4c3c39-5ab1-4152-ae8a-baf3204da036
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 12:29:55 +0000
Received: from dev-dsk-sieberf-metal-1a-7543e84d.eu-west-1.amazon.com
 (172.19.116.227) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 12:29:51 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>
CC: <tj@kernel.org>, <bsegall@google.com>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <mgorman@suse.de>, <vschneid@redhat.com>,
	<kprateek.nayak@amd.com>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<skhan@linuxfoundation.org>, <corbet@lwn.net>, <rdunlap@infradead.org>,
	<cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>, <hborghor@amazon.de>, <fmubeen@amazon.de>,
	<dwmw@amazon.co.uk>, <sieberf@amazon.com>
Subject: [PATCH v3 0/2] sched/fair: cpu.max.runtime and idle refill for a burstable budget
Date: Wed, 11 Nov 2026 14:29:47 +0200
Message-ID: <cover.1794398404.git.sieberf@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1794303670.git.sieberf@amazon.com>
References: <cover.1794303670.git.sieberf@amazon.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ClientProxiedBy: EX19D031UWA001.ant.amazon.com (10.13.139.88) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This series makes the CFS bandwidth controller's bucket a burstable CPU
budget that userspace can save and restore. It lets cpu.max.burst exceed
the quota, so the bucket can hold more than one quota, and adds
cpu.max.runtime to read and set what it holds (patch 1). It makes a
group that is not running keep earning quota up to quota + burst
(patch 2).

v2 had two further patches that passed the level on to a BPF scheduler.
Tejun asked for the fair side first and on its own, so they are dropped
here and will be proposed separately if this is accepted.

Use case
========

We run virtual machines whose CPU time is governed by CPU credits, as
burstable instances are. An instance earns credits while it runs below
its baseline, spends them above it, and holds at most a capped amount;
with none left it is held to the baseline. The starting credits, the
baseline and the cap are part of the instance type's guarantee and must
hold whatever the host does to the instance.

Each instance's vCPU threads run in their own cgroup, and the controller
already is that bucket of credits: the quota per period is the rate
credits are earned at, quota + burst is the cap, and the runtime is the
level. It does the per-CPU charging and the throttling in the scheduler,
at a granularity userspace accounting cannot match. What is missing is a
cap above one quota, a way to read and write the level, and earning
while idle. An instance that idles for a minute with a 100ms period
earns one quota instead of up to 600.

The level has to be saved and restored by the host's control software:
an instance starts with the credits its type grants, not with one quota;
a host kernel live update (kexec) or a reboot creates the cgroups anew,
so every level has to be read before and written back after, or every
instance loses or gains credits; a live migration moves the level with
the instance; and the control plane raises or lowers it when credits
move between instances. A container checkpoint and restore has the same
problem.

Ben pointed out that a cpu.max or cpu.max.burst write already adds a
quota to the runtime, and that cpuacct gives the usage. That falls
short. A write can only add, and only one quota, so setting a level
means writing a temporary quota equal to the difference and then the
real quota back, and lowering one means shrinking the burst until the
cap cuts the runtime and widening it again; each leaves the cgroup
running with the wrong bandwidth in between, and each write visits every
CPU's cfs_rq. And usage is not the level: deriving it means replaying
every period's refill in userspace, including the periods the timer
slept through, which duplicates the controller's accounting.

Patch 2 changes behavior for existing cpu.max.burst users. A group with
a burst that becomes runnable after idling has up to quota + burst, as
if it had been running below its quota throughout, instead of the
runtime it had when the timer stopped. Groups without a burst see no
change.

Testing
=======

On tip/sched/core in qemu with lockdep, the cgroup test_cpu selftests
pass, 18 of 18, including the nine new ones for these two patches, with
no lockdep report in dmesg. Both patches build with W=1 and no warning
in kernel/sched, with and without CONFIG_CFS_BANDWIDTH and on 32-bit,
and kernel-doc reports nothing on the files they touch.

An AI coding assistant (Claude Code) helped write the selftests and
changelogs and ran the build and test matrix; I reviewed all of it.

Changes in v3
=============

- Patches 3 and 4, the sched_ext side, dropped (Tejun).
- Patch 1: cpu.max.runtime reads 0 while cpu.max is "max" instead of a
  level the group no longer has, and taking a group's quota away drops
  its runtime instead of keeping it for the next quota (kernel-patches
  CI); the lockdep_assert_irqs_disabled() in distribute_cfs_runtime()
  is gone, as both bandwidth timers run with hardirqs enabled on
  PREEMPT_RT, and a comment states the real precondition; the
  burst_kept selftest grants the runtime after a period has started,
  so a hog cannot burn it while the test waits; CONFIG_CFS_BANDWIDTH
  added to tools/testing/selftests/cgroup/config.
- Patch 2: a cpu.max write starts the next period from the write, so
  the first refill under a new period is one new period away and not up
  to one old period away; selftest for it.

v2: https://lore.kernel.org/all/cover.1794303670.git.sieberf@amazon.com/
v1: https://lore.kernel.org/all/20260525193622.70282-1-sieberf@amazon.com/

Fernand Sieber (2):
  sched/fair: expose cpu.max.runtime to set bandwidth runtime directly
  sched/fair: refill bandwidth for the periods the timer slept through

 Documentation/admin-guide/cgroup-v2.rst   |  24 +-
 Documentation/scheduler/sched-bwc.rst     |  14 +-
 kernel/sched/core.c                       |  56 ++-
 kernel/sched/fair.c                       | 163 +++++-
 kernel/sched/sched.h                      |   4 +
 tools/testing/selftests/cgroup/config     |   1 +
 tools/testing/selftests/cgroup/test_cpu.c | 587 ++++++++++++++++++++++
 7 files changed, 839 insertions(+), 10 deletions(-)


base-commit: d7e670601af6c564ccf6d3b2ddf70ee4f41a6d1c
-- 
2.47.3




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07

