Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122BA37F73D;
	Sat, 18 Jul 2026 08:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784362652; cv=none; b=butpEHxCNqfRYdZUWExqgOe+W+Ne5Dk623fh7Bg5QboSHHKpwcgAIFuP2Umbc3xSbTiikFHHjDvdEwD5IhXXhfGGB4bCpfwdndB+4jqRmMaipxdP8IZn4WDLehr6+q2ZHcbCVDgTbgQstE+YNsbwYSSTauxlA03rp7KlSMrgZ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784362652; c=relaxed/simple;
	bh=L5Od5RXaM9QagK5KpjwhmkW5Ks6D+G33Zh3m9UYSv7o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X2kU4tso2fjaSTXtd7b2Lx8zMhQ142JvRXQJBJeE4/Fc+MKuraja/NdyNLQrFPTTkaAeB0mQd3XHgjN8Z9Q/v0qScLZ8IPPvAJswcinc8OzOS1cx+cE6O/pduEjfI8D9bMX+Gs4y11Jc0XeeWoUc/7wu41PDcFibbp+zhe8Bi8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U21X4lZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U21X4lZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983FE1F000E9;
	Sat, 18 Jul 2026 08:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784362648;
	bh=40ioCm5nBPbUTSkR+3UtA/kbH2IB2bav7goa3ZimREc=;
	h=From:To:Cc:Subject:Date;
	b=U21X4lZM2YAlcQIR/PebxJmkVwxwARrka3OkbRdeWuhWpKQsJt+mt4oJXBuMpTM/u
	 SaeaFGa41mxhrWK3nqW7WasjyLslnxytympBBt/1bicjfNxx3N+TbltPPdvzZtWN5y
	 4czpCQ+oGm8GFBfEpOY4L9XGmSFCJgauHlhuDD5kyTUlh+NwFSoK7tcZy87WLrTKeB
	 lELupzu9DGGcz3Dq9TNJgpHA/bL8zFUaCnnsYXhzH+ZueTDXALPBlXogaAaRwGDpBc
	 dCzWy5le9xk5rMFEiSKTBmsXTZbjl+KyTbSQZO+KhJbaZ2m8Yj3yGQkH6u4HB8tBap
	 yCKV/Ld3NiNOA==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>
Cc: sched-ext@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCHSET sched_ext/for-7.3] sched_ext: Cgroup migration and op delivery for sub-schedulers
Date: Fri, 17 Jul 2026 22:17:19 -1000
Message-ID: <20260718081727.582037-1-tj@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

A task's sched must match its cgroup's: each sub-scheduler serves the
cgroup2 subtree it is attached to and the root scheduler serves the rest.
Cgroup migration currently breaks this. A task moved across a
sub-scheduler boundary keeps its old sched, leading to wrong-sched
scheduling and, once the stale sched is freed, a use-after-free. Cgroup
ops are also always delivered to the root scheduler no matter which sched
serves the cgroup.

This patchset makes both follow the sub-scheduler topology:

- cgroup gains a task migration notifier (0001). sched_ext uses it to
  re-home tasks whose migration crosses a sched boundary: the destination
  sched runs the fallible ops.init_task() before the migration commits,
  so a rejection fails the cgroup.procs write (0002-0004).

- cgroup_init/exit and the knob ops are delivered to the sched each
  task_group is on. The move ops go to the task's sched, only for
  migrations that don't re-home it (0005).

- Sub-scheduler enable claims the subtree's cgroups from the parent and
  disable returns them. A parent that fails to re-init a returned cgroup
  fails in turn and the cgroups move up the chain, ending at the root
  scheduler (0006).

- scx_qmap consumes cgroup weights through ops.cgroup_set_weight() and
  gains fault injection modes to exercise the failure paths (0007-0008).

Verified with a trace-based suite on the demo scheduler covering op
delivery and routing, handover failures, multi-level punt chains, cgroup1
and stress.

Based on sched_ext/for-7.3 (7c2cd767705d).

Tejun Heo (8):
  cgroup: Add cgroup_task_notifier and task migration events
  sched_ext: Factor out scx_rehome_task() and scx_punt_task()
  sched_ext: Relocate scx_cgroup_enabled
  sched_ext: Re-home tasks on cgroup migration
  sched_ext: Deliver cgroup ops to each task_group's sched
  sched_ext: Hand over cgroups at sub-scheduler enable/disable
  tools/sched_ext: scx_qmap - Consume cgroup weights through set_weight
  tools/sched_ext: scx_qmap - Add init fault injection modes

Git tree: git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext.git scx-cgroup-migration

 include/linux/cgroup.h         |  26 +++
 include/linux/sched/ext.h      |  15 ++
 kernel/cgroup/cgroup.c         |  93 ++++++++-
 kernel/sched/ext/ext.c         | 247 +++++++++++++++++-------
 kernel/sched/ext/internal.h    |  44 ++++-
 kernel/sched/ext/sub.c         | 418 +++++++++++++++++++++++++++++++++++++----
 tools/sched_ext/scx_qmap.bpf.c |  95 ++++++++--
 tools/sched_ext/scx_qmap.c     | 110 +----------
 tools/sched_ext/scx_qmap.h     |   5 +-
 9 files changed, 819 insertions(+), 234 deletions(-)

--
tejun
