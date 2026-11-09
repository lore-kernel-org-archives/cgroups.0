Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794242183;
	b=UwAqiOdSPrk03nc1kj2zD7SuZpTzE4i1H2Pxf9/1FSm/iVEk8ZIhmKGP/nLiFltaWdCx
	 ZLpUt5E4e43+6r0ZKJ8QjXzFvnF2+oIqGlUQoD3cxbNX5ojPqCvYbtfl1MbinlwPVtIXJ
	 Q3geabmtAH5eFGQOD84B1ZWbdZG4QGJPE+SGIxTvg4Qe0n3q4WgmrQ6sl4xBPCvzlFmu1
	 8AuNOs0D4gi+eYANhVqZSTcyplxlISArehzPhQu2lKdbECwfvGPm0z460hlxzbWfXUTFV
	 lIiEqcDUufh4et6jhIcBmERXAyg5wFcmRArJiI8I5kmR2PfFWwx29/ITa5RvtKxokOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794242183;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Qz+/NdehmNeFJJoho165gVMOPQyvQojo+qmN1pIP/lc=;
	b=UZRhPSf1YXkFcRUFB1LMPOfGjmWc+cf09za9F9xa6k8Z/FA2fpnkfkfhlKJuFW1IqnKZ
	 9FBPmdmLT06qQACmWMBQDXsacc2KiTsa7V8uMrei7T2XulKwg0w/xeZyt8Be+RwiRu5l7
	 m3IoU22qVlai/onn3qR2jSskno/FvNVD9F0o7a9+qhgtLt0pHOtmOl9HDh8i3/+agMCZi
	 xtSLidD5w4ExhVQUtF9V89Xdg0ZpNK0ICNcodTKe4ZldUqs6J586MlJ3Ge5fL5XP5msiv
	 nRJXRNldmOk+2d+gRUy1KHHdDmfPHWSPgSPl/y0ByUnETr0Fr5xFAii74YhbqUipPGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BOKOvnFR;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E964E606A32A
	for <cgroups@vger.kernel.org>; Mon,  9 Nov 2026 16:36:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E964E606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BOKOvnFR
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a5087a5348so9433815e9.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 08:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794242181; x=1794846981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qz+/NdehmNeFJJoho165gVMOPQyvQojo+qmN1pIP/lc=;
        b=BOKOvnFRxKLvE3Odmne31oU3GxefygTJNqZ4Q3lX+sYg7wNj6PVo0P3ozoEG/8ilcz
         DB7yFBy7pi4xDQSdOHpUNM8O8ysow/UMBXWCGlNdmWYONrwW7Mccl/GUdKXy0VARPX8L
         Jn+bb1okYhxBRWH7AB6YhQz/EmdIFQcgVP5uWE0goT4I+Aw7mklbTpZCvdezkTuMmLnu
         6yOMjUMiqBnbktIXUA2Dfm6npJN7Zn7Sip8BoQYyUTtUMQ66+3DgcPdE+51unRMRpxAj
         cVpQ3F56/RT+64t+D+R/DMedw7uM6iLhZ1yCymZrawPOT3IPeM8PXC31AlEnJ7PccH97
         x6kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242181; x=1794846981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qz+/NdehmNeFJJoho165gVMOPQyvQojo+qmN1pIP/lc=;
        b=WqOwF5YWTOhdBj3yis45tO2Dw5QyNbIAkuH6yavffucvxqIxeIBW52o0LgGvJL1B1c
         3Y8wMyC5H+HXff1rbTSag2A+3ZYw0N9WljfAHUN3iepVOB9inEUAW9Xiq963QWQwBzqC
         eLFXvd9Vqj6JtX3ZaiQZa26fXPhaa28yw2hImbkhgkM0fx33r6H/lsmg9C/KEXFZMKjh
         MNpJnz9tyL5WZRchJADrk60vWEGcPcPSHz7g/nWyw3GwV7KLmsRzNR7XaVjFaVMhI0+I
         9wFTQJi8LqCRR5uhd5hZI/cv0pSZ1Uq45hZW6h/cWH4AXEVOvJNQzanbZ8U2RVbPHJG1
         9L5w==
X-Gm-Message-State: APuU4Z8kzLX3J+QK9A4uz2o3QZ889L8dsZ+Ps11XKjMNKvHnC9bv+5gQ
	uh9JG4yYQSUNkR6bGB4uhNtG7ru6PVWoAts51wGkCDDpAvpOQo7DIPRG
X-Gm-Gg: AYBFou1b3ifo8+FaDFcQ60xwhMSP3MPBpWleL+MY5ji5BPOe5zkmM9hf6hf3+6NXJFP
	UAm2lxh6e57X82Nyf/KNEXmzilkZwwATqGASP69Pl0dZYm2Gu5AgnRhbzy3KCG0N7K5kiWm+gB1
	8plTMmxxol1PWIXsvYlw5fuXsuTLIM+iyJlWsR29eS2cdj2r9orZeCsveyFXzFCG99rtBctAJYT
	iPMy7I/keUl54Hxu/aWS2yqJPYCEjufmjqpxCkmkapDcY9E8Jcvxat+FZVeXwb0l2oQHD0wGreD
	BgprQE34IH36qlbtaHQpthaG+ERmlrxbgx6GMhzxDwakTJVacjT64orXqx7z4cc1ScdNmnIwdpx
	EhNc5VomZJzOAIzw9uAf2dX8n0YQZ/uzmG40r1UQvwWhulJ0xOyiNglZ8Gw/UPjzk6mu/sP+hqn
	jTKV3zOxbR2devXYilOBHuseQC8JCYJma0gwzd1AW2LWjf6fU9wQloe1FUFaXmCHBLKhKLwf6gP
	ONyUYKMWP8Flg/9KrIlJMM5GgwZhPB/Q2KYerlOfmLP+yygFcpaO75jf++wx8P28iEitucPwWEM
	1Q+pwObVc+Y5y0sTRnC3u+5tlmI=
X-Received: by 2002:a05:600c:c16b:b0:4a2:167a:c946 with SMTP id 5b1f17b1804b1-4b963c6754fmr82171325e9.13.1794242181011;
        Mon, 09 Nov 2026 08:36:21 -0800 (PST)
Received: from victus-lab ([193.205.81.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b96cd012e1sm138851295e9.8.2026.11.09.08.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 08:36:18 -0800 (PST)
From: Yuri Andriaccio <yurand2000@gmail.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Yuri Andriaccio <yuri.andriaccio@santannapisa.it>
Subject: [RFC PATCH v7 00/29] Hierarchical Constant Bandwidth Server
Date: Mon,  9 Nov 2026 17:35:46 +0100
Message-ID: <20261109163616.195264-1-yurand2000@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Hello,

This is the seventh RFC for Hierarchical Constant Bandwidth Server, aiming at
replacing the current RT_GROUP_SCHED mechanism with something more robust and
theoretically sound. The patchset has been presented at OSPM25 and OSPM26
(https://retis.sssup.it/ospm-summit/), and a summary of its inner workings can
be found at https://lwn.net/Articles/1021332/ and the latest updates and
discussions at https://lwn.net/Articles/1078696/. You can find the previous
versions of this patchset at the bottom of the page, in particular version 1
which talks in more detail what this patchset is all about and how it is
implemented.

Version v7 introduces a lot of changes since v6. First off there have been a
lot of bug fixes from the comments by the reviewers and the automated AI tool
Sashiko, which surprisingly caught a lot of issues. Later, we've finally had
time to add features which were planned a long time ago. The following are the
most meaningful updates since v6 (the complete changelog can be found on the
github readme):
- Rebase to kernel version 7.4-rc1.
- Address (most of) bugs as reported in the v6 reviews.
- Introduce dl_freq_invariant flag for dl_servers.
    + Force fair/ext servers to be frequency/capacity invariant, while allow
      HCBS servers to scale their consumed runtime.
    + This enables capacity-aware bandwidth reservation also for HCBS.
- Rework cgroup-v2 interface:
    + Rename cpu.rt.internal to cpu.rt.effective.local
    + Fix internal runtime rounding errors.
- Update cgroup balance callbacks to allow balancing operation of multiple
  cgroups at the same time.
- Allow unprivileged FIFO/RR tasks inside cgroups.
- Allow HRTICK_DL for HCBS servers.
- Integrate `cpu` and `cpuset` controllers.
- Integrate HCBS with hotplug/hotunplug operations.
- Introduce dl_server overrides (previously known as multi-runtime/multi-CPU).

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Unprivileged FIFO/RR tasks in cgroups:
Version v7 adds a simple patch to the sched_setattr syscall which allows
non-root processes to execute FIFO/RR tasks in already configured HCBS cgroups.
The reasoning follows from the fact that only the administrator is capable of
creating and managing the real-time bandwidth, and, given the isolation
properties of SCHED_DEADLINE, regular users, tied in that specific bandwidth,
cannot cause starvation or steal time to other processes/users.
A non-root user cannot migrate its FIFO/RR task anywhere else in the cgroup
hierarchy due to permissions, thus it is also impossible to move a user-created
HCBS-FIFO task in the root cgroup and steal more bandwidth than the admin
allowed.

`cpu` and `cpuset` controllers integration:
It has been requested by the maintainers to integrate HCBS with the `cpuset`
cgroup controller, and it made a lot of sense since this enables easier
integration with the rest of the scheduler classes in the class-switch code
paths. The integration forces the rt-cgroup to have as active the same CPUs as
those that `cpuset.effective.local` allows, while all the other dl_servers are
by construction never activated. To simplify the code, the administrator must
first setup the `cpuset` cpus and later setup the HCBS bandwidth. The current
integration disallows changing allowed cpus while the HCBS bandwidth is
reserved (thus the admin must first remove the HCBS reservation, change the
cpuset, and re-request real-time bandwidth).

dl_server override feature:
Following the `cpuset` integration, we integrated the multi-runtime/multi-CPU
feature: the admin can request the override of the default runtime/period pair
for a specific set of CPUs. The user interface works still by writing onto the
`cpu.rt.max` file with a new format, which follows the nested-keyed standard.
The original `<runtime>|max <period>` format is still supported, while the new
nested-keyed format is `default runtime=<value_us> period=<value_us>` or
`default runtime=max` for the default config values as in the original,
`<cpuset> runtime=<value_us> period=<value_us>` to set a specific override and
`<cpuset> default` to reset it. Note that the cpusets must be subsets of the
allowed cpus in `cpuset.effective.local`, and that overrides with runtime zero
are disallowed. These strict rules enforce that the active CPUs are exactly
those allowed by the `cpuset` controller, no more no less. The only exception
is a cgroup with zero runtime, which allows execution only if all CPUs are
overridden, i.e. the same restriction as above (zero runtime cgroups simplifies
setup in some cases).
A final note is about `max` cgroups, which are disallowed to have overrides,
i.e. a cgroup is either delegating its FIFO/RR to its nearest active parent or
it is managing these itself, but cannot have a mixed behaviour.

hotplug/hotunplug:
We've also fixed the hotplug/hotunplug failures. Hotunplug is allowed only if
there are no active HCBS cgroups on the specific core that is going offline.
Hotplug does not cause issues but HCBS reservations will need to be updated to
make use of the newly enabled core (the cgroups' HCBS specific cpumask is only
updated when setting the cgroups' bandwidth).

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Summary of the patches:
     1) Introduce dl_freq_invariant flag.
   2-7) Preparation patches, so that the RT classes' code can be used both
        for normal and cgroup scheduling.
  8-18) Implementation of HCBS, no migration.
        The old RT_GROUP_SCHED code is removed.
        15) Remove support for cgroup-v1.
        16) Implement cgroup-v2 cpu.rt.max interface.
 19-23) Add support for tasks migration.
    24) Allow unprivileged FIFO/RR in rt-cgroups.
    25) Enable HRTICK_DL for HCBS.
    26) Documentation for HCBS (no `cpuset` integration yet).
    27) Integrate `cpuset` and `cpu` controllers.
    28) Fix CPU hotplug/hotunplug operations for rt-cgroups.
    29) Introduce multi-cpu (dl_server override) support.

Updates from v6:
- Update to kernel version 7.1.
- Refactorings and general cleanups.
- Removal of substantial duplicated code.
- Express more locking constraints in code.
- New cpu.rt.max interface.
- Refactoring of migration code to reduce code duplication.

Updates from v5:
- Rebase to latest master.
- General rebasing/cleanup.
- More locking contraints expressed in code.
- New cpu.rt.max interface.
- Refactoring of migration code.

Updates from v4:
- Rebase to latest tip/master.
- General rebasing/cleanup.
- Update default sysctl_sched_rt_runtime to 1s, same as the period.
- Fix non-deferred deadline server replenishment logic.
- Add missing RCU read sections.
- Account HCBS servers along with their tasks when the servers are active.
- Release bandwidth resources early in unregister_rt_sched_group.
- Drop server_try_pull_task as it is now redundant.
- Remove dl_server_stop call in dequeue_task_rt.
- Update to reuse __checkparam_dl for deadline servers.

Updates from v3:
- Rebase to latest tip/master.
- General rebasing/cleanup.
- Add Documentation.
- Define **live** and **active** groups.
- Introduce server_try_pull_task in place of the removed server_has_task.
- Introduce RELEASE_LOCK helper macro for guard-based locking.
- Update inc/dec_dl_tasks to account for served runqueues regardless of the
  server type.
- Fix computing of new bandwidth values in dl_init_tg.
- Fix check in dl_check_tg to use capacity scaling.
- Fix wakeup_preempt_rt to check if curr is a DEADLINE task.

Updates from v2:
- Rebase to latest tip/master.
- Remove fair-servers' bw reclaiming.
- Fix a check which prevented execution of wakeup_preempt code.
- Fix a priority check in group_pull_rt_task between tasks of different groups.
- Rework allocation/deallocation code for rt-cgroups.
- Update signatures for some group related migration functions.
- Add documentation for wakeup_preempt preemption rules.

Updates from v1:
- Rebase to latest tip/master.
- Add migration code.
- Split big patches for more readability.
- Refactor code to use guarded locks where applicable.
- Remove unnecessary patches from v1 which have been addressed differently by
  mainline updates.
- Remove unnecessary checks and general code cleanup.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Testing v7:

The patchset has been tested with a suite of tests tailored to stress all the
implemented functionalities.
The tests are available at https://github.com/Yurand2000/HCBS-Test-Suite .
Refer to the README of the repository for more details.

Follow these steps to test HCBS v7:
- Get the HCBS patch up and running. Any kernel/disto should work effortlessly.
- Get, compile and _install_ the tests.
- Run the `go_rt.sh` script to set the frequency of the CPUs to a fixed value
  and disable hyperthreading and power saving features.
- Run the `run_tests.sh full` script, to run the whole test suite.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Future Work:

This latest RFC, along with all the new features, is stable on our limited
hardware. The patchset is nonetheless potentially lacking testing of some
specific code paths and features.

We surely expect comments on the `cpuset` integration and the dl_server
override feature, in the hope to find a better solution for the current
limitations.

There is still some pending issues to solve and work to do:
- PI-boosting will cause starvation if cgroups have zero (internal) runtime.
  There are many solutions, such as bandwidth inheritance or forcing cgroups to
  not have zero runtime, but this has yet to be investigated. We are open for
  advice on the matter.
- As Tejun Heo pointed out, it maybe be possible to remove the forceful global
  reservation of cgroup bandwidth in the root cgroup, while still being
  compliant with real-time schedulability theory and related SCHED_DEADLINE
  admission tests.
- There are some potential performance improvements in the migration code that
  are yet to be implemented (rto_masks).
- Integration with the old v1 cgroup? Maybe disallow HCBS/RT_GROUP_SCHED in
  cgroups-v1 entirely? There has also been ongoing discussion at
  https://lore.kernel.org/all/20261105164724.yxONBd03@linutronix.de/

Have a nice day,
Yuri

v1: https://lore.kernel.org/all/20250605071412.139240-1-yurand2000@gmail.com/
v2: https://lore.kernel.org/all/20250731105543.40832-1-yurand2000@gmail.com/
v3: https://lore.kernel.org/all/20250929092221.10947-1-yurand2000@gmail.com/
v4: https://lore.kernel.org/all/20251201124205.11169-1-yurand2000@gmail.com/
v5: https://lore.kernel.org/all/20260430213835.62217-1-yurand2000@gmail.com/
v6: https://lore.kernel.org/all/20260608121546.69910-1-yurand2000@gmail.com/

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Yuri Andriaccio (18):
  sched/deadline: Introduce dl_freq_invariant flag for fair/ext servers
  sched/rt: Disable RT_GROUP_SCHED
  sched/rt: Remove unnecessary runqueue pointer in struct rt_rq
  sched/rt: Add {alloc/unregister/free}_rt_sched_group
  sched/rt: Implement dl-server operations for rt-cgroups.
  sched/rt: Update task event callbacks for HCBS scheduling
  sched/rt: Remove support for cgroups-v1
  sched/rt: Update task's RT runqueue when switching scheduling class
  sched/rt: Add HCBS migration code to related functions
  sched/rt: Hook HCBS migration functions
  sched/rt: Try pull task on empty server pick.
  sched/core: Execute enqueued balance callbacks after
    migrate_disable_switch
  sched/syscalls: Allow unpriviledged tasks to set RT priority inside
    cgroups.
  sched/rt: Enable HRTICK_DL for HCBS servers.
  Documentation: Update documentation for real-time cgroups
  sched/rt: Integrate cpuset and cpu controllers
  sched/rt: Prevent CPU offline operation on active rt-cgroups.
  sched/rt: Introduce multi-cpu support

luca abeni (11):
  sched/deadline: Do not access dl_se->rq directly
  sched/deadline: Distinguish between dl_rq and my_q
  sched/rt: Pass an rt_rq instead of an rq where needed
  sched/rt: Move functions from rt.c to sched.h
  sched/rt: Introduce HCBS specific structs in task_group
  sched/core: Initialize HCBS specific structures.
  sched/deadline: Add dl_init_tg
  sched/deadline: Account rt-cgroups bandwidth in deadline tasks
    schedulability tests.
  sched/rt: Update rt-cgroup schedulability checks
  sched/rt: Remove old RT_GROUP_SCHED data structures
  sched/core: Execute enqueued balance callbacks when changing allowed
    CPUs

 Documentation/scheduler/sched-rt-group.rst |  471 +++-
 include/linux/cpuset.h                     |    2 +
 include/linux/rcupdate.h                   |    1 +
 include/linux/sched.h                      |   16 +-
 kernel/cgroup/cpuset.c                     |   31 +
 kernel/sched/autogroup.c                   |    4 +-
 kernel/sched/core.c                        |  239 +-
 kernel/sched/deadline.c                    |  324 ++-
 kernel/sched/debug.c                       |    6 -
 kernel/sched/ext/ext.c                     |    4 +-
 kernel/sched/fair.c                        |    4 +-
 kernel/sched/rt.c                          | 2725 +++++++++++---------
 kernel/sched/sched.h                       |  225 +-
 kernel/sched/syscalls.c                    |   37 +-
 14 files changed, 2540 insertions(+), 1549 deletions(-)


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
--
2.56.0

