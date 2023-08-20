From: Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 0/6] Backport rework of deadline bandwidth restoration for 6.1.y
Date: Sun, 20 Aug 2023 16:24:11 +0100
Message-ID: <20230820152417.518806-1-qyousef@layalina.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1692545066; x=1693149866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TK555uHCst9oQmvkd3McRBjvZbo0q+tfOD4sf3AzsfM=;
        b=dFp6Pki6lvfmOuTcHpoH0HRKt3dxycOuRkBLc0wkyKBh7yrau69puh0mXYciWBtNhb
         PhW9TLxypWWx0zmT4j6dg6nnOpA+rWW6/nuNwJA5TOb5IRkU3BhBLf7mVhbxuugA54YM
         MZT/e54rzwkjuRm8mIioxlzJf5BrdrMYiJEruzC3HkoqnI7ACDAkoN8v8H89JizsFD4b
         rtx2+gyEWLj3nV+tXWVuYhXw6yarr/D/we9Wi0OClPsd4bUgis7BkOMRY/Z7zivgLpTX
         oL7iGgjruAcNHKuU5ewKsjuo1isX9iJ2MEkGBlObRinRikkBngXTWpsQWaW1PiQtSYyD
         q14A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: stable@vger.kernel.org
Cc: Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@kernel.org>, Hao Luo <haoluo@google.com>, John Stultz <jstultz@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Qais Yousef <qyousef@layalina.io>

This is a backport of the series that fixes the way deadline bandwidth
restoration is done which is causing noticeable delay on resume path. It also
converts the cpuset lock back into a mutex which some users on Android too.
I lack the details but AFAIU the read/write semaphore was slower on high
contention.

Compile tested against some randconfig for different archs and tested against
android14-6.1 GKI kernel.

My testing is limited to resume path only; and general phone usage to make sure
nothing falls apart. Would be good to have some deadline specific testing done
too.

Based on v6.1.46

Original series:

	https://lore.kernel.org/lkml/20230508075854.17215-1-juri.lelli@redhat.com/

Thanks!

--
Qais Yousef

Dietmar Eggemann (2):
  sched/deadline: Create DL BW alloc, free & check overflow interface
  cgroup/cpuset: Free DL BW in case can_attach() fails

Juri Lelli (4):
  cgroup/cpuset: Rename functions dealing with DEADLINE accounting
  sched/cpuset: Bring back cpuset_mutex
  sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets
  cgroup/cpuset: Iterate only if DEADLINE tasks are present

 include/linux/cpuset.h  |  12 +-
 include/linux/sched.h   |   4 +-
 kernel/cgroup/cgroup.c  |   4 +
 kernel/cgroup/cpuset.c  | 246 ++++++++++++++++++++++++++--------------
 kernel/sched/core.c     |  41 +++----
 kernel/sched/deadline.c |  67 ++++++++---
 kernel/sched/sched.h    |   2 +-
 7 files changed, 246 insertions(+), 130 deletions(-)

-- 
2.34.1

