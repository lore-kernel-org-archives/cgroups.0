Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=158.69.130.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795655337;
	b=OXORZafcuFKM653c5hY1n8llXaO9lLAE+ZazBwuQgakcE7QEXn1suoQBbL+kG3q9xNU+
	 3r9I3o+uOP5t30qGpCS+7mMeaDCdEP1+wEP7xAcj0bpGhpfX5DmEWGkbULiJpUWXUq4tr
	 Se5aXa28DOqQ4ElACM/BJqLO2SXVmQlkoLjlmWKS5B3rMRNjOpZOIvtRuVJb8NXHD9rbB
	 zO7hwZhMAZAUIeRif0glWKMKv1RJRDmsFeoI72k6zA95q9whzZnrvHC4Asxc+cfJql9QZ
	 5nFhOPuRs703kSP2WL8RoLidUaJS+0KAB0mkDZV3mHKfs/CjvaFtY4YSE95KL2RjjTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795655337;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hzsa41AUPGxMKbicWuhJHXgDoVLQnVKC7kj8muH1lB0=;
	b=ooPgP6d4sfn5+1bEoN74Y5GuUnrDw4rIQG3NbmjAAsJ4JM9JOQ9a3ovgJcxqhdODzOHO
	 T2aOjgh+X+y21vcc01VFC8a/DU487y5p9P0Z0MWY6txNaxCnoj6tCqfKL2LLcpErjmjS2
	 Qb7RFVXYZsKpVxFu3eRMsGI3nVKpc5j/QOGSgbUtOfUYIrEX9OLC0YFbbzrLQQppUiF3o
	 vTNl4ru0rumlmEjAn8vsszKs9xolPeE3+3cVhtQ4g1sORu7MIxpFTjYM6jtFcvquqsPwc
	 37ERFjxyq/vYksvJHZfxqJ+d/Fu0opIOd+eVBs/nI3KJW0oa3K0JPB2/dCncXyyF30Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=efficios.com;
	spf=pass smtp.mailfrom=efficios.com;
	dkim=pass header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RQ+oKy42;
	arc=none smtp.remote-ip=158.69.130.18
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF02606A321;
	Thu, 26 Nov 2026 01:08:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AF02606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=efficios.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=efficios.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=RQ+oKy42
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1795655329;
	bh=hzsa41AUPGxMKbicWuhJHXgDoVLQnVKC7kj8muH1lB0=;
	h=From:To:Cc:Subject:Date:From;
	b=RQ+oKy42k+wKfqBbwaKxeUl7tgbWUudUFW2+U7MqnYbKNHx3qJnQmEzuvgbA7KhGT
	 rWXf6qjQLTVliLilFmn/yiY8U5/snhBXsDgz2tmasrCn92Gati1/dsrgWIdd9YtlXS
	 YJ1wDecxjYWiCAlHGNn+Ia2291tXMWB4vIeYeM6LeLhqduUa1VJygNPLwpob3+i+7j
	 +fK3+S4wWrH/Crxwe6ywaBbKMy3lhf8P/g6c3DSZcwSE3xZeTwMkFM71Tqoil2V88E
	 yV6d3aDqq8zPW5n7jcw9viLYRcF0H1dw2tI0IphnxSxglERnSTfmbt1spmpN+dG9O8
	 Llz3Dp78NNTzg==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:cacb:9855:de1f:ded2])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jZdjD4qtYzWx3;
	Wed, 25 Nov 2026 20:08:48 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: juri.lelli@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	vincent.guittot@linaro.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
	tommaso.cucinotta@gmail.com,
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
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v11 00/43] sched/deadline: bandwidth accounting fixes and selftests
Date: Wed, 25 Nov 2026 20:07:59 -0500
Message-ID: <cover.1795646914.git.mathieu.desnoyers@efficios.com>
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
Content-Transfer-Encoding: 8bit

Hi Ingo, Juri,

This series fixes bugs of SCHED_DEADLINE in 35 patches. It applies on
top of the first series [1], with its updated patch 10 [2]. This is
v11. The changes since v10 are at the end.

Most of the bugs are in the bandwidth accounting. They leave total_bw
of a root domain, or this_bw of a runqueue, wrong. The root domain then
admits deadline tasks beyond its capacity, or refuses tasks that would
fit. The other bugs give a task more runtime than its reservation, or
sort the waiters of an rt_mutex in the wrong order. Deadline tasks can
then miss their deadlines.

Three worse outcomes were found by reading, not reproduced:
- A rebuild would hit its BUG_ON() (patch 13).
- An rt_mutex owner can keep as its deadline donor a task that has
  exited. Its next refill would then read freed memory (patches 21 to
  23).
- A task would never run again (patch 27).

Patches 21 and 22 also fix the chain walk bug that patch 11 of the
first series describes.

As Juri asked, the patches come in groups, one per theme. Each group
except extra_bw ends with the test cases of deadline_bw_test that test
its fixes. The test cases of patches 25 and 26 are in patch 42.

Juri, patch 3 replaces your fix 1/4, which Ingo dropped from
sched/urgent. It records a CPU of the root domain that counts the
bandwidth, instead of taking the first active CPU of the mask. The
other three fixes are in the first series.

The groups
==========

The rebuild of the root domains' accounting (1-6):
 1  Keep the bandwidth of departing tasks across a root domain rebuild.
 2  Rebuild the root domains' accounting from the task list.
 3  Record the root domain that holds a task's bandwidth.
 4  Leave out of a rebuild a dying task that released its bandwidth.
 5  Add deadline_rebuild_test.
 6  Add the 7 test cases of deadline_bw_test for this group.

cpuset attach (7-12):
 7  Move a task's bandwidth only where an attach made room for it.
 8  Wait for an attach before rebuilding the sched domains.
 9  Make a policy or affinity change of a deadline task wait for a
    cpuset attach in progress.
 10 Give back the bandwidth an attach did not move.
 11 Reserve an attach's bandwidth in the root domain each task moves to.
 12 Add the 24 test cases of deadline_bw_test for this group.

The root domain of a task, with partitions and isolcpus=domain (13-18):
 13 Make a rebuild count a task in the root domain it runs in.
 14 Move a task's bandwidth to the root domain it runs in.
 15 Pick a CPU for a task in the root domain that counts its
    bandwidth, if the task's mask has a CPU there.
 16 Refuse to take offline the last CPU a task has in the root domain
    that counts its bandwidth. Also refuse an offline that makes a
    partition invalid and so moves a deadline task to another root
    domain.
 17 Refuse a cpuset change that leaves a deadline task no CPU in the
    root domain that counts its bandwidth.
 18 Add the 32 test cases of deadline_bw_test for this group.

extra_bw (19-20):
 19 Count only the active CPUs when a change of total_bw is spread over
    extra_bw, at an offline migration and at a rebuild.
 20 Divide that change on 64 bits: a sum of bandwidths can pass S32_MAX.

The rtmutex chain walk (21-24):
 21 Continue the chain walk when the deadline donor of a waiter
    changes, so that no owner keeps a donor that can exit.
 22 Do not stop the chain walk at an owner whose top waiter changed.
    The next owner then gets the new priority or donor.
 23 Hold a reference on the deadline donor of a boosted task.
 24 Add the 2 test cases of deadline_bw_test for this group.

Deadline boosts and the 0-lag time (25-33):
 25 Count the 0-lag time from the next period, not from the deadline.
    A constrained task then stays counted until it has paid for what it
    ran.
 26 Keep the bandwidth and the deadline of a constrained task that
    leaves the class until its next period.
 27 Replenish a throttled task that a waiter boosts while it sleeps, so
    that it runs again.
 28 When an owner refilled from its donor is deboosted and stays in the
    class, give it back the deadline and runtime of its own period.
 29 Count in this_bw the bandwidth that sched_setattr() gives a task
    already boosted into the class.
 30 Give a deadline to a task that enters the class while it waits on
    an rt_mutex.
 31 Do the same as 28 at a deboost out of the class, so that the
    task's 0-lag time comes from its own period.
 32 Give a sleeping task that FUTEX_CMP_REQUEUE_PI requeues onto an
    rt_mutex the deadline its wakeup would give it.
 33 Add the 10 test cases of deadline_bw_test for this group.

Parameter changes (34-42):
 34 Cancel the replenishment timer with the parameters.
 35 Cap the runtime left of a constrained task at dl_runtime when its
    parameters change.
 36 Check the runtime left of a task that comes back to the class
    runnable, as a wakeup does.
 37 Apply new parameters to the period in progress, at the change. A
    task that ran ahead of its reservation keeps that debt, and repays
    it at the new bandwidth. A task with no period to apply them to
    gets the check of a wakeup.
 38 Boost an owner that cannot run on its own reservation: one that is
    throttled, or past its deadline and before its next period. Run it
    on a period of its donor, at most one donor runtime per donor
    period.
 39 Boost an owner that is throttled after its waiter blocked.
 40 Reschedule a running task that its enqueue throttles.
 41 Run a boost held at its first refill on a donor period too.
 42 Add the 39 test cases of deadline_bw_test for this group.

Patch 43 moves the helpers that the three deadline selftests share to
a header.

Backporting
===========

The fixes carry Cc: stable. The test patches do not. Some fixes need
other commits:
- Patches 1 to 17 go together. Patch 3 records the root domain that
  counts a task's bandwidth. This record replaces dl_departed_cpu,
  which patch 1 adds. Patch 4 completes the task list walk of patch 2.
  Patches 4, 10, 11 and 13 to 17 use the record of patch 3. Patches 7
  to 9 fix bugs of v7.4-rc2 that patches 10 and 11 rely on.
- Patch 19 changes code that patches 1 to 17 rework, so it comes after
  them.
- Patches 21 to 23 go together. Patches 21 and 22 make the chain walk
  reach every owner. Patch 23 covers a walk that comes late.
- Patch 28 adds the held boost: dl_hold_refilled_boost(),
  dl_end_held_boost() and dl_deboost(). Patches 31, 37, 38 and 41
  build on it. Patch 27 relies on patch 21.
- Patches 23 and 39 need commit 8671bad873eb ("sched: Do not call
  __put_task_struct() on rt if pi_blocked_on is set") on stable trees
  older than v6.17.
- A backport of these patches of the first series needs patches 25
  and 26:
  - "sched/deadline: Reset the deadline and the runtime with the
    parameters" (patch 9).
  - "sched/deadline: Release the bandwidth of a task that leaves the
    class asleep" (patch 11).
  Without them, a constrained task can leave the class and come back
  before its next period. It then gets a new period at once, and more
  than its bandwidth. Patch 25 needs patch 10 of the first series,
  which adds dl_time_to_zerolag(). Neither needs another patch of this
  series. On the first series, they apply with git am -3 or a
  cherry-pick. Plain git am fails on a context line from patch 3 of
  this series.
- Patches 37 to 41 go together:
  - Patches 38 and 39 need patch 37. Patch 38 fits the saved period
    with the debt rule of patch 37. Patch 39 throttles an owner in
    dl_setattr_period(), which patch 37 adds.
  - Patch 40 needs patches 38 and 39. Patch 40 stops a running owner at
    once in its constrained gap, between its deadline and its next
    period. Without patches 38 and 39, no waiter boosts that owner. The
    waiter then waits for the owner's next period. So patch 40 comes
    after them.
  - Patch 41 needs patch 38, which adds the donor period.

Notes for the reviewers
=======================

Peter, these patches change the rtmutex code or rt_mutex_setprio():
- 21: a waiter records its deadline donor with its sort keys.
- 22: two early stops of the chain walk are removed. The first one
  also leaves an owner on an old RT priority.
- 23: a boosted task holds a reference on its donor. dl_set_donor()
  takes it with tryget_task_struct(), since it reads the donor without
  the waiter's locks.
- 28: the deadline that a deboost in the class gives back can be later
  than the deadline of the top waiter. rt_mutex_setprio() then boosts
  the task again right away.
- 30: rt_mutex_setprio() starts a period of the new donor for a
  blocked task with no parameters of its own, in dl_boost_blocked().
- 32: __rt_mutex_start_proxy_lock() refreshes the deadline of a task
  that FUTEX_CMP_REQUEUE_PI requeues, before its trylock.
- 37: rt_mutex_setprio() first deboosts a task whose parameters
  changed during the boost. It then compares the task with its top
  waiter.
- 38: rt_mutex_setprio() boosts a deadline owner that cannot run on its
  own reservation. dl_set_donor() now reports a top waiter whose donor
  is the owner itself, in a lock cycle. rt_mutex_setprio() then ends
  the boost of a deadline owner, and sets ENQUEUE_REPLENISH only when
  the owner has a donor. __setscheduler_dl_pi() does the same. A Spin
  model of the chain walk found the case.
- 39: an owner can also lose its own reservation after its waiter
  blocked. An irq_work then calls the new rt_mutex_adjust_owner(). It
  calls rt_mutex_setprio() with the top waiter, under the pi_lock, if
  that waiter must boost the owner. RT_MUTEXES now selects IRQ_WORK for
  this. try_to_take_rt_mutex() and the paths that clear pi_blocked_on
  queue the same irq_work for a deadline task with a deadline top
  waiter: it can be throttled already. The core scheduler change is in
  balance_push(): it returns in hard interrupt context, because the
  irq_work can interrupt the tail of a switch-in on a CPU going offline.

These patches also touch the core scheduler:
- 2: __sched_setscheduler() takes the new dl_accounting_mutex, without
  CONFIG_CPUSETS.
- 3: __sched_setscheduler() and dl_task_check_affinity() check a
  deadline task against the root domain that counts its bandwidth, not
  that of its runqueue.
- 7: the new set_cpus_allowed_bw_reserved() flags a move that reserved
  bandwidth, with SCA_DL_BW_RESERVED. __set_cpus_allowed_ptr_locked()
  does not skip such a move when the mask does not change.
- 9: __sched_setscheduler() and sched_setaffinity() wait for a cpuset
  attach in progress.
- 10: set_cpus_allowed_bw_reserved() reports the bandwidth it moved.
- 11: __set_cpus_allowed_ptr_locked() steers a task to the CPU that an
  attach reserved.
- 15: select_fallback_rq() and __set_cpus_allowed_ptr_locked() keep a
  deadline task in its root domain.
- 37: __setscheduler_params() marks a task that comes back to the
  deadline policy with the same parameters. Its runtime left is then
  checked as at a wakeup.

Waiman, patches 16 and 17 add refusals, with admission control on:
- A CPU offline or a cpuset.cpus write fails with EBUSY if it leaves a
  deadline task no CPU in the root domain that counts it. This needs a
  cpuset with CPUs of two root domains.
- A write that makes a partition root, or makes it grow, still
  succeeds in that case. cpuset then makes the partition invalid, and
  cpuset.cpus.partition reads "root invalid (Deadline task would leave
  its root domain)".
- Patch 16 also refuses an offline that makes a child or a sibling
  partition invalid, when a deadline task in it would change root
  domain.

An offline can leave a partition root with tasks and no CPU of its own.
cpuset then makes it invalid, and its tasks count in its parent. If the
parent has no CPU of its own either, the order of the cpuset updates
decides where the tasks end. cpuset updates a parent before its
children. So the parent stays valid, with tasks and no CPU. It takes
the CPUs of the next child partition that cpuset updates, if there is
one. Else a later hotplug event decides. In v11, patch 16 no longer
models that order. The known limits below say what it then refuses,
and what it misses.

Questions
=========

Waiman, two questions on patch 16:
- Would you prefer cpuset to offer a dry run of its hotplug update, as
  a follow-up? It would be exact, but too large for stable.
- An offline can leave a partition valid with tasks and no CPU, until
  the next hotplug event. Is that state intended?

Ingo, Juri, a question on patches 25 and 26. Would you rather have
them in the first series, after its patch 10? Patches 9 and 11 there
need them (see Backporting).

Peter, Juri, a question on patch 37. Would you take a follow-up for
tasks with an implicit deadline? It would keep the old bandwidth
counted until the 0-lag time, as the XXX in sched_dl_overflow()
suggests. A change could then start a new period at once. It would
fail with EBUSY when the old and the new bandwidth do not fit together.
In the user-space model of the CBS (see "How this was developed"),
this is sound for an implicit deadline only. For a constrained
deadline, admission by bandwidth needs a whole period between the
releases of two jobs. A period started at the change can release a job
sooner. So a constrained task would keep the rule of patch 37.

Peter, Juri, a question on patch 37. It is large: it adds about 600
lines. It is one rule, applied in several places that depend on each
other, so I kept it whole. Would you like it split?

Juri, a question on the waiters of an rt_mutex (see the known limits).
Should a waiter that gets the lock past its deadline go on with its
late job, as a queued task past its deadline does? That changes the
CBS rules, so I left it out.

Known limits
============

These limits stay open:
- Patch 1: a rebuild still drops the bandwidth that a task keeps after
  it leaves the class or dies. This happens if the CPU recorded with
  that bandwidth is inactive. It also happens if the task dies, or a
  deboost takes it out of the class, while the rebuild runs.
- Patch 14 moves the bandwidth of a task to the root domain it runs in
  with no check for room. dl_task_offline_migration() does the same on
  v7.4-rc2.
- Patch 15: a wakeup inside a rebuild of the sched domains can still
  move a task's bandwidth to another root domain. It moves with no
  check for room. This was found by reading.
- Patches 16 and 17 refuse nothing during a suspend, or with admission
  control off.
- Patch 16 can refuse an offline that keeps each task in its root
  domain. This needs nested partitions whose parents have no CPU of
  their own.
- Patch 16 does not check a deadline task that enters a partition after
  an offline left a parent partition valid with tasks and no CPU. The
  next hotplug event, an online too, can then move it to another root
  domain with no check for room.
- Patch 16 does not see a task that sched_setattr() makes a deadline
  task during the offline. That task can then run in a root domain
  that did not admit it. The bandwidth test of dl_bw_deactivate() has
  the same window. This was found by reading.
- Patch 17 accepts a write that grows a partition root and makes a
  child partition valid. The child takes the CPUs on which the
  parent's deadline tasks were admitted. Those tasks then run on the
  CPUs that the parent just got, in a root domain that did not admit
  them. On v7.4-rc2,
  a rebuild does the same.
- Patch 17 does not count the CPUs that the rebuild gives to an
  isolated partition root. When such a root grows, the check can make
  a valid child partition of it invalid, until the next update of that
  child. So it refuses too much, never too little.
- The XXX in dl_bw_capacity(), which Juri pointed at in the v5 thread,
  stays open. In the default root domain, admission control counts the
  capacity of all its CPUs, not that of the CPU the task runs on. A
  deadline task in a cpuset with isolated and housekeeping CPUs is
  admitted that way.
- A cpuset attach frees the bandwidth of a task in the root domain it
  leaves at once, even before the task's 0-lag time. That root domain
  can then admit a task up to one period too early [3]. A task moved
  while runnable also keeps its runtime and deadline in the root domain
  it arrives in (Example 3 of [4]). Both are as on v7.4-rc2. A
  follow-up series can keep the bandwidth counted in the source until
  the 0-lag time.
- Patch 37: admission control releases the old bandwidth at the
  change. Right after a cut of bandwidth, a task admitted into the
  released bandwidth can rarely miss a deadline near the change.
- Patch 37: two costs fall on the task that changes its parameters.
  With a constrained deadline, a job that already used the new
  dl_runtime ends at the change. A task that waits for its next period
  and changes its constrained dl_deadline back and forth moves that
  period later at each shorter dl_deadline.
- Patch 37: a change of a boosted task applies at its deboost, or at
  the refill that holds the boost. Until then, a lower bandwidth is not
  enforced, as on v7.4-rc2.
- Patch 38 limits the boosts of each owner, not of each donor. A waiter
  that boosts N throttled owners in turn gives them N donor runtimes
  per donor period. The limit also needs a donor with an implicit
  deadline. With a constrained donor, a wakeup after the deadline of
  the donor period still starts a new one, as on v7.4-rc2.
- A waiter of an rt_mutex keeps the deadline it blocked with, as on
  v7.4-rc2. That deadline can pass while it waits, and the waiter still
  sorts first. An unlock wakes the top waiter, which must run to take
  the lock. A constrained waiter woken past its deadline is throttled
  until its next period. Meanwhile the lock has no owner, so no other
  waiter can boost anyone. This lasts up to dl_period - dl_deadline.
  Two other kinds of waiter also sort first with a passed deadline, in
  their constrained gap:
  - a task that FUTEX_CMP_REQUEUE_PI requeues (patch 32). In a test
    outside this series, another waiter then waited 442ms for the lock.
  - a task that comes back to the class while it waits (patch 30).
- Patch 39 does not boost an owner while it waits for another
  rt_mutex, with its pi_blocked_on set. Its new donor would need a
  chain walk, which cannot run in the hard interrupt context of the
  boost. The owner asks again when it takes that lock or stops waiting
  on it. If it is throttled before then, it cannot run to take the
  lock. Its waiters then wait for its next period, as on v7.4-rc2. The
  same holds for an owner throttled after a yield.

Testing
=======

On top of the first series, the 169 test cases of the three deadline
selftests pass wherever they run, with lockdep and no kernel warning.
deadline_bw_test has 161 of them. They ran in 20 QEMU guests of 4 to 8
vCPUs:
- with proxy execution on and off.
- with PREEMPT_RT.
- without CONFIG_CPUSETS.
- with CONFIG_RT_GROUP_SCHED.
- booted with isolcpus=domain on CPUs 1-2, 0-1 or 6-7, some with
  PREEMPT_RT.
The 26 test cases that need isolated CPUs skip in the guests without
them.
No guest combines isolcpus=domain with a kernel without CONFIG_CPUSETS:
such a kernel hits a BUG at boot on v7.4-rc2 [5].

At each test patch, the kernel and the test cases of that patch pass
in 12 guests of the same kinds. Three guests with kmemleak ran the
whole series: no leak.

On top of the first series, the series builds at each of its 43
patches. At each patch, it also builds with tinyconfig, without
CONFIG_RT_MUTEXES. At each test patch, the series also builds without
CONFIG_CPUSETS, with PREEMPT_RT and with CONFIG_RT_GROUP_SCHED. The
selftests build there with no warning. The cpuset selftest
test_cpuset_prs.sh passes, with and without PREEMPT_RT.

Each fix names the test cases that test it. Patch 42 names, for each
test case of its group, the fix it tests. The other test patches list
the test cases that fail on v7.4-rc2. These changes have no test case:
- patches 4, 19 and 27: they were found by reading.
- patch 20: it needs a machine with more than 2048 CPUs.
- the second early stop that patch 22 removes, and patch 23: they need
  a chain walk preempted at the right step.
- patch 29: a reproducer outside the selftests shows it.
- patch 34: it has no reproducer.
- patch 40: its test case passes from patch 37 on, which also
  reschedules a task that sched_setattr() throttles.
- the change of patch 15 in dl_task_offline_migration(): it needs a
  timer that fires between a CPU going inactive and the cpuset update.
- in patch 38, an owner past its deadline and not in its constrained
  gap: it was found by reading.
- one change of v11 in each of patches 3, 13, 16, 28 and 32. They were
  found by reading.

These were not tested:
- cgroup v1 cpusets.
- threaded cgroups: every move is a write to cgroup.procs.
- the sched_ext server.
- CPUs of unequal capacity.

How this was developed
======================

An LLM coding assistant wrote these patches, their messages and the
tests, under my direction and review. I know the concepts behind
SCHED_DEADLINE, but not its implementation well. So I ask those who
know this code for a careful reading of the fixes. A reproducer that
stops failing shows that the symptom goes away. It does not show that
the fix is the one you would have written.

The bugs came from:
- flaky cgroup selftests of a feature I am developing.
- the review of Juri's four fixes, and his review of v5.
- building deadline_bw_test, and reading the code.
- the Sashiko AI reviews of v1 to v10, and of the first series, plus a
  local run on the patches that changed for v11. Each finding was
  checked against the code first.
- second LLM reads of the fixes and of the harder findings. They found
  the gaps fixed in patches 15, 16, 23 and 30. One of them also
  proposed the design of patches 38 and 39.
- kmemleak, which found a leaked task_struct in an early version of
  patch 23.

The rule of patch 37 was first checked in a user-space model of the
CBS on one CPU. Two independent LLM reviews of that model found the
problem of a task that moves to a constrained deadline, which patch 37
now covers.

For v11, the assistant extended that model into a simulator of
SCHED_DEADLINE on one CPU. It models these parts:
- EDF over several tasks, and the CBS rules.
- admission control on total_bw.
- class changes, and rt_mutexes with priority inheritance.
It has the rules of this series, transcribed by hand from the code. A
search over small task sets, random and adversarial, checks two
properties:
- no task gets more than its bandwidth.
- an admitted task meets its deadlines.
Without rt_mutexes, the series shows two exceptions only:
- the transient after a cut of bandwidth, which the known limits
  state.
- misses in task sets with a density above 1, which admission by
  bandwidth does not exclude for constrained deadlines.
With rt_mutexes, the search found the cases that the caps of the
runtime in patches 28 and 38 now cover. The search was not run again
after those fixes. The simulator also replays several test cases, and
Example 1 of [4]. It is not part of this series. I can share it.

The assistant also wrote a Spin model of the priority inheritance
boost. It models rt_mutex_setprio(), dl_set_donor(), the rtmutex chain
walk and the boost flags of the series. It has three deadline tasks and
two or three locks, with a step per lock section. Spin found that a
lock cycle can make a boosted owner its own donor with its boost still
held: 9 steps, with no timeout. The fix is in patch 38. The model finds
no error with it, within the bounds searched: 13 steps for three tasks
and two locks. The model was first checked by finding a known bug of
the chain walk again. It is sequentially consistent, so it does not
cover the memory ordering of dl_set_donor(). It is not part of this
series either. I can share it.

Changes since v10
=================

Patch numbers are those of v11. These v10 patches have a new number:
- 25 is now 28, and 26 is now 27.
- 27 to 34 are now 29 to 36.
- 35 and 37 are merged into 37.
- 36 is now 40.
- 38 is now split into 38 and 39.
- 39 and 40 are now 42 and 43.
Patches 25, 26 and 41 are new. Most changes come from the Sashiko AI review
of v10, and most of these come with a new test case. Those marked
"(local)" come from a local Sashiko run on a draft of v11:
- 3: for a task asleep on a CPU that went offline, sched_setattr() now
  tests the root domain of an active CPU of the task's mask.
  sched_setaffinity() tests a task with a bandwidth of 0 the same way.
- 13: a rebuild no longer leaves out a task that left the class before
  its 0-lag time, when its mask has no active CPU. It counts the task
  on the CPU recorded, if that CPU is active. Its comments were also
  fixed (local).
- 14: follows the change of 13. The lock that 13 now takes covers the
  write of dl_bw_skip_gen.
- 16: the order of the cpuset updates is no longer modelled: see the
  paragraph to Waiman. A task with no root-domain bandwidth, such as a
  sugov kthread, does not count.
- 17: a dead task passes the check.
- 28 now gives an owner refilled from its donor the deadline and
  runtime of its own period back, instead of a new period. A new period
  gave it its runtime again, in a period whose runtime it had used.
  task_non_contending() takes a 0-lag time of exactly now as passed
  (local). A refill from a donor whose parameters were cleared counts
  as a refill.
- The order changed in two places, after a review of each patch on
  its own tree. 27 now comes before 28: at 28 alone, a sleeping owner
  could be left throttled with no timer. 40 now comes after 38 and 39:
  before them, a waiter would not boost an owner that 40 stops in its
  constrained gap.
- 30: a task can come back to the class in its constrained gap while
  it waits on an rt_mutex. It keeps its deadline, unless it is boosted.
- 31 does the same as 28 out of the class. The owner's bandwidth then
  stays counted until the 0-lag time of its own period, not released at
  once.
- 32: dl_proxy_block() runs before the trylock of a proxy lock, and
  applies the wakeup rule. futex_lock_pi() does not call it: its task
  is running. The message and a comment say that a requeued task in its
  constrained gap keeps its passed deadline (local).
- 33: three test cases now expect the owner's own period back after a
  refill.
- 37 merges v10's "Check the runtime of a task whose parameters change"
  and "Keep the start of the period across a change of dl_deadline".
  In v10, the first of them broke a test case that passes on v7.4-rc2,
  and the second fixed it again. A change now applies to the period in
  progress at once. A task that comes back to the class with new
  parameters gets its period fitted to them. It no longer also gets the
  check of a wakeup. 37 also changes the expectation of
  params_switched_asleep, a test case of the first series. A task that
  ran ahead and then leaves the class now stays counted by admission
  control until its debt is repaid. This holds for a boosted task too:
  its 0-lag time counts from its period fitted to the new parameters.
- 38 and 39 were one patch in v10, as 38. An owner boosted while it
  cannot run on its own reservation now gets a period of its donor at
  the boost (38). A new boost within that donor period resumes it. So
  repeated boosts give the owner at most one donor runtime per donor
  period, with the runtime capped by the donor's density. At the
  deboost, an owner whose saved runtime is used up is throttled again.
  It gets a period of its own if the saved one has ended. An owner that
  loses its own reservation after its waiter blocked is now boosted
  then (39). Four events do that:
  - it runs out of runtime.
  - an enqueue in its constrained gap throttles it.
  - sched_setattr() throttles it until it repays its debt.
  - it takes a lock with waiters while throttled, or stops waiting on
    another lock.
  A yield no longer discards the donor period of a held boost.
  A lock cycle can no longer leave the owner its own donor with its
  boost held (see "How this was developed").
- 41 is new. The first refill of any other boost also gets a donor
  period, resumed from the last held boost.
- Tests: deadline_bw_test has 29 new test cases. It drops
  boost_new_params_stale, which tested a boost from pi_top_task. That
  is no longer how patch 38 finds the donor. The test patches pin a
  test to its CPUs, add skips, and fix error paths that could hang. One
  of these fixes (local) ends a hang of deadline_bw_test when a waiter
  is refused the deadline policy. Patch 43 makes the Makefile rebuild
  the tests when their header changes.
- The messages of most fixes were reorganized: the problem and the fix
  first, then the cases as lists.

The first series is based on tip sched/urgent, ec6f6731538e (v7.4-rc2).

[1] https://lore.kernel.org/all/cover.1795115075.git.mathieu.desnoyers@efficios.com/
[2] https://lore.kernel.org/all/d975f317a4f9f79d2300b68ad76664755459ba36.1795181168.git.mathieu.desnoyers@efficios.com/
[3] T. Cucinotta, L. Abeni, "Migrating Constant Bandwidth Servers on
    Multi-Cores", RTNS 2021, section 4
[4] S. Tang, J. H. Anderson, L. Abeni, "On the Defectiveness of
    SCHED_DEADLINE w.r.t. Tardiness and Affinities, and a Partial Fix",
    RTNS 2021, https://doi.org/10.1145/3453417.3453440
[5] https://lore.kernel.org/lkml/20261117144817.265109-1-mathieu.desnoyers@efficios.com/
v10: https://lore.kernel.org/all/cover.1795207232.git.mathieu.desnoyers@efficios.com/
v9: https://lore.kernel.org/all/cover.1795181240.git.mathieu.desnoyers@efficios.com/
v8: https://lore.kernel.org/all/cover.1795116790.git.mathieu.desnoyers@efficios.com/
v7: https://lore.kernel.org/all/cover.1794922146.git.mathieu.desnoyers@efficios.com/
v6: https://lore.kernel.org/all/20261116190549.230119-1-mathieu.desnoyers@efficios.com/
v5: https://lore.kernel.org/all/20261108185406.1549770-1-mathieu.desnoyers@efficios.com/
v4: https://lore.kernel.org/all/20261107014451.1487825-1-mathieu.desnoyers@efficios.com/

Mathieu Desnoyers (43):
  sched/deadline: Keep departing bandwidth across a root domain rebuild
  sched/deadline: Rebuild the root domains' accounting from the task
    list
  sched/deadline: Record the root domain holding a task's bandwidth
  sched/deadline: Leave a dying task out of a rebuild of the accounting
  selftests/sched: Test SCHED_DEADLINE bandwidth across a root domain
    rebuild
  selftests/sched: Test the root domain rebuild in deadline_bw_test
  sched/deadline: Move a task's bandwidth only where room was made
  cgroup/cpuset: Wait for an attach before rebuilding the sched domains
  sched: Make deadline policy and affinity changes wait for a cpuset
    attach
  cgroup/cpuset: Give back the bandwidth an attach did not move
  cgroup/cpuset: Reserve the bandwidth in the root domain a task moves
    to
  selftests/sched: Test cpuset moves in deadline_bw_test
  sched/deadline: Make a rebuild count a task in the root domain it runs
    in
  sched/deadline: Move a task's bandwidth to the root domain it runs in
  sched/deadline: Keep a task in the root domain that counts its
    bandwidth
  sched/deadline: Keep the last CPU a task has in its root domain
  cgroup/cpuset: Refuse to take a deadline task out of its root domain
  selftests/sched: Test the root domain of a task in deadline_bw_test
  sched/deadline: Count only active CPUs when spreading extra_bw
  sched/deadline: Do not truncate a bandwidth to 32 bits in
    __dl_add/sub()
  rtmutex: Continue the chain walk when a waiter's deadline donor
    changes
  rtmutex: Do not stop the chain walk at an owner whose top waiter
    changed
  sched/deadline: Hold a reference on the deadline donor of a boosted
    task
  selftests/sched: Test the rtmutex chain walk in deadline_bw_test
  sched/deadline: Count the 0-lag time from the next period
  sched/deadline: Keep a departing constrained task until its next
    period
  sched/deadline: Replenish a throttled task boosted while asleep
  sched/deadline: Restore the owner's period at a deboost in the class
  sched/deadline: Count the bandwidth a boosted task is given
  sched/deadline: Start a period for a task that enters the class
    blocked
  sched/deadline: Restore the owner's period at a deboost out of the
    class
  sched/deadline: Start a period for a task requeued onto an rt_mutex
  selftests/sched: Test deadline boosts in deadline_bw_test
  sched/deadline: Cancel the replenishment timer with the parameters
  sched/deadline: Cap the runtime left of a constrained task at
    dl_runtime
  sched/deadline: Check the runtime of a task that comes back runnable
  sched/deadline: Keep the debt of a task across a change of parameters
  sched/deadline: Boost an owner that cannot run on its own reservation
  sched/deadline: Boost an owner throttled after its waiter blocked
  sched/deadline: Reschedule a running task throttled at its enqueue
  sched/deadline: Run a boost held at its first refill on a donor period
  selftests/sched: Test parameter changes in deadline_bw_test
  selftests/sched: Share the helpers of the deadline tests

 Documentation/scheduler/sched-deadline.rst    |    12 +-
 include/linux/cpuset.h                        |    28 +-
 include/linux/sched.h                         |   106 +
 include/linux/sched/deadline.h                |    42 +-
 include/linux/sched/rt.h                      |     4 +
 init/Kconfig                                  |     1 +
 kernel/cgroup/cgroup.c                        |     3 -
 kernel/cgroup/cpuset-internal.h               |    15 +-
 kernel/cgroup/cpuset.c                        |   825 +-
 kernel/locking/rtmutex.c                      |    76 +-
 kernel/locking/rtmutex_api.c                  |    41 +-
 kernel/locking/rtmutex_common.h               |     3 +
 kernel/sched/core.c                           |   193 +-
 kernel/sched/deadline.c                       |  2507 +++-
 kernel/sched/sched.h                          |    94 +
 kernel/sched/syscalls.c                       |   126 +-
 kernel/sched/topology.c                       |    11 +
 .../selftests/sched/deadline/.gitignore       |     1 +
 .../testing/selftests/sched/deadline/Makefile |     4 +-
 .../sched/deadline/deadline_bw_test.c         | 10849 +++++++++++++++-
 .../sched/deadline/deadline_rebuild_test.c    |   501 +
 .../sched/deadline/deadline_switch_test.c     |    36 +-
 .../selftests/sched/deadline/deadline_util.h  |   106 +
 23 files changed, 14998 insertions(+), 586 deletions(-)
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_rebuild_test.c
 create mode 100644 tools/testing/selftests/sched/deadline/deadline_util.h


base-commit: ec6f6731538e0d45872eb279fdeb477bed152d6f
prerequisite-patch-id: 5e2478ffdfb7583751bf44bdf87fb930bc23551b
prerequisite-patch-id: d5e5ef986ff2d9bc39a87b56e96a2acbd3158687
prerequisite-patch-id: 99e47f80396008ee2b2576157d37842481ce52d2
prerequisite-patch-id: a10824f98c11a4c902dad55cab3ec03b3dbe2c8a
prerequisite-patch-id: 8959e5a408641b4fa81bc79737cd17d5f1b03389
prerequisite-patch-id: 16acf1d18f01d20310d6db767dfbec2f072e0372
prerequisite-patch-id: e1946bb015a7b14ed4e2cd0421e5e30b0c7afdda
prerequisite-patch-id: 4daf48a89779fbd8c8bc5fc1d7a7d6df9bca2d9d
prerequisite-patch-id: 980d8045f9fe8c3757bb3d82c61d68e321cf74bb
prerequisite-patch-id: b2d75d7b3eebbda11af43b3917b1c99e0cce2725
prerequisite-patch-id: fb69a0665dc38ca9022cc2bd75234a90e2035b7f
prerequisite-patch-id: 7a115ab83ad96ffaf8e833e0eaeb75f859af2e79
prerequisite-patch-id: 8574b50d81a09ec6091e42d65338adcab2986d71
prerequisite-patch-id: 1aa25df96d60d30f549c71fdfba5589cb239928f
prerequisite-patch-id: d38384e0b7d043a3556ee02fb09316a6227038da
prerequisite-patch-id: 83ded04a76ecf973e2b8c6e04ff83c2b7278915a
prerequisite-patch-id: b8f5d9f9146e887050bbd8ad30463fd81cad9411
-- 
2.47.3

