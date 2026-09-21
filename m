Received: from mta0.migadu.com (out-135.mta0.migadu.com [91.218.175.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22ED38F249
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790018776; cv=none; b=iVKeXwB4qKhHGVOgrmWtZz4KTjbnpB5Xuv6aHJTsv0YKmZ++8YwXZMwU4oT363iriRN4dLMdrIjClNlR+BETrat7tt+ckRNhFT/El7+H+6i/ezMF7veuBJOCU5FRNdEa5ah+weWFb/q1BTBy0TJguMRMUePKDn3rPgaNy/gsaAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790018776; c=relaxed/simple;
	bh=2pYTdTUDa+84wU/MBEvg0yRS7fWJdgAm4Nn22PbXQOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DLSkkBgXs7KyS1Rt4nZUWPeueHMzqCkH3UEe3wjDDBGXkdwIwDkewtR3gu8j1scpHxm6yoSeiv/11RXRQZLx3559J2EaHaDCpQ7ZeBHTCnbHuH/1NO7g9QS0vACPr+zAnzGHo+rQcHogllvSO4Z1X138w5uVgq5maun+TBW/CD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WJ0vlo2Z; arc=none smtp.client-ip=91.218.175.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WJ0vlo2Z"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2pYTdTUDa+84wU/MBEvg0yRS7fWJdgAm4Nn22PbXQOE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790018770; v=1; x=1790623570;
 b=WJ0vlo2ZQ7viQgGEOnZ3qLJXfuswTpzTZ8OSaIevTOld4GE7QYYF6ScTny6m25PIkJqhtrY3
 O1GJfTnbUONm6wiWNAFLus2gLMSFvuLC4MraMhUxJ0iw9SoDQVLWyvbkMLjX4SGYWuMY3OfkPFZ
 Ef1sx4RueOw+ArgBQyTmjfUk=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7a90df4d3bdf44a9;
	Mon, 21 Sep 2026 19:26:10 +0000
X-Mizu-Trace-ID: 7a90df4d3bdf44a9
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached struct_ops
Date: Mon, 21 Sep 2026 12:25:55 -0700
Message-ID: <20260921192559.2619635-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the first series of memcg_ext, proposed at [1].  It adds
bpf_memcg_ops, a struct_ops type through which memory controller policy is
attached to a cgroup.  A charge runs the policies of its cgroup and of
every ancestor, and the kernel combines what they return.  BPF picks
between things the kernel already does; it never does the work itself and
never touches a page counter.

The plan is to grow this one member at a time, and to add a member only
when there is a concrete problem it solves and a measurement showing it
does.  Nothing is added because it might be useful later.  So this first
series adds one member, for one problem.

The problem
===========

try_charge_memcg() calls __mem_cgroup_handle_over_high() before it returns,
which reclaims and can throttle the task.  That happens wherever the charge
happens, so a task holding a kernel lock can be stuck there, and everything
waiting on that lock is stuck behind it.

One concrete scenario which can be resolved by this new feature is the
kernfs notify worker. It delivers notifications with the cgroup2
kernfs_rwsem held for read, and the charge for the delivery allocation goes
to the cgroup that set the watch, usually one already under pressure. So
the worker reclaims while holding the lock, a waiting writer blocks every
later reader, and anything touching cgroupfs stalls for seconds. The patch
proposed in [2] fixes that one path in the kernel only for kernfs_rwsem.
The same path still takes kernfs_supers_rwsem.

One can make an argument that if we know the source of the issue in the
kernel, why not fix it similarly to [2] instead of having a generic
solution? The reason is that it will be an uphill and continuous battle as
the kernel keeps evolving and new sources of lock holders doing allocations
keep coming up. In addition, there will be cases where it might not be
possible to move the allocations out of locks, or where doing so would
make the code really ugly [3].

high_policy() lets a policy say where memory.high should be enforced
instead.  Its one request, BPF_MEMCG_HIGH_DEFER_INLINE, skips the inline
call, leaving the debt to be paid at the return to userspace.

Results
=======

Measured on a kernel without [2], with a policy that marks cgroupfs kernfs
lock holders.  Reproducer at [4].

                                      baseline    policy    upstream fix
  max kernfs_rwsem hold, worker        2.049 s     199 us   not taken
  max kernfs_supers_rwsem hold         2.049 s     4.8 ms   2.056 s
  max kernfs_rwsem write wait          4.096 s     6.2 ms   8.7 ms
  walker passes over /sys/fs/cgroup        352       5711   6700
  churn mkdir+rmdir ops                 13 059    364 832   415 488
  churn max latency                     30.7 s    15.1 ms   12.7 ms

The policy matches the fix on the bystander numbers, and does better on
kernfs_supers_rwsem, which the fix does not help: it drops kernfs_rwsem
from the delivery loop, while the policy stops the worker stalling at all,
so every lock it holds benefits.

The patches
===========

Patch 1 is a build fix.  __cgroup_bpf_query() only works because
CGROUP_TCP_SOCK_OPS is the one struct_ops attach type; a second one breaks
the build and makes a query for type 0 return the wrong thing.

Patch 2 adds the type and its registration, with no members, so nothing is
dispatched and behaviour does not change.  It also moves the attach type
enum out of CONFIG_CGROUP_BPF and fixes the register_bpf_struct_ops() no-op
stub, which never compiled because no caller reached it.

Patch 3 adds high_policy() and wires it into try_charge_memcg().

Patch 4 is the sample.  It tracks the two cgroupfs kernfs locks by hooking
the rwsem primitives rather than the forty-odd functions that take them.

Known open questions
====================

The semantics of memory.high for remote chargers or kernel threads is a
grey area and this series does not aim to resolve that.

Another open question is whether a bound on debt deferral is needed. At
the moment, we think that rather than putting a limit on deferral for
memory.high, it will be better to handle that through an async worker like
memcg->high_work.  We aim to introduce that later, along with the right CPU
accounting for that async work.

There is no prog_tests harness, so the numbers above come from the
reproducer and not from the test suite.

The sample's lock tracking costs about 8% throughput, because it
instruments every rwsem operation on the system.  That is fine for a sample
that has to cover every path, but it argues for a cheaper way to track
locks that cause isolation problems between unrelated workloads.

Future work
===========

Asking the kernel to reclaim on the policy's behalf, so a task that cannot
be throttled still pays. More members, each with a use case: hard-limit
policy, reclaim shaping, dynamic protection.

This builds on "bpf: A common way to attach struct_ops to a cgroup", which
supplies attach, detach, ordering, update, query and the RCU rules.
bpf_memcg_ops is its second user.

[1] https://lore.kernel.org/20260307182424.2889780-1-shakeel.butt@linux.dev/
[2] https://lore.kernel.org/20260910045406.485295-1-shakeel.butt@linux.dev/
[3] https://lore.kernel.org/20260917-wehten-achtfach-getarnt-c85a4812337d@brauner/
[4] https://github.com/shakeelb/mempressure-repros/tree/main/kernfs-notify-memcg

Shakeel Butt (4):
  bpf, cgroup: fix cgroup struct_ops query for a second attach type
  memcg_ext: add cgroup-attached bpf_memcg_ops
  memcg_ext: allow BPF to defer memory.high enforcement
  selftests/bpf: add a cgroupfs lock-holder bpf_memcg_ops sample

 MAINTAINERS                                   |   1 +
 include/linux/bpf-cgroup-defs.h               |  22 +-
 include/linux/bpf-cgroup.h                    |  14 +-
 include/linux/bpf.h                           |   2 +-
 include/linux/bpf_memcontrol.h                |  66 ++++++
 include/linux/cgroup.h                        |   7 +
 include/linux/sched.h                         |   4 +
 kernel/bpf/cgroup.c                           |   3 +-
 mm/bpf_memcontrol.c                           | 188 ++++++++++++++-
 mm/memcontrol.c                               |  31 ++-
 .../bpf/progs/memcg_ops_lockholder.c          | 222 ++++++++++++++++++
 11 files changed, 546 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/bpf_memcontrol.h
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_lockholder.c


base-commit: 6e36e099b15bed1e8e5b3e3136c5e3eb56a15aa7
-- 
2.53.0-Meta

