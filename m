From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v8 0/7] freezer for cgroup v2
Date: Tue, 19 Feb 2019 14:02:45 -0800
Message-ID: <20190219220252.4906-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6E4heah3RkEK0Ib7PIsaMfwndGngevIShogBrVDAzDI=;
        b=EeDz3BpBfxyGezTJ65HiBAAgewbd2TF+nZMSaMFCSp+E8KPcByoWZVNyCt5M7fvr+p
         JnI41QsWbXCP7L+rJt3QJLp+Uxc/Gss96uLJdhzi0cwenqSYVuF+SrLYhI3B8wbxcV3u
         KuSm4bLN5/UMO/s5iXBnIV1UVDwfUUqc9SHFMJfBPo/awVpYROCaXx48yhxNKrCGmiL3
         QQU1v5Tx+M7eG26lExcT+Lu6ZtnUwh9BY5aISmks6LArbo2UCFzAYy4GAvBuD+uEt7El
         D5ZV/fmKjWIcm16l3s2pLtybna1VnZfjmPfG9MTUWaPLa7YGv7OyPgY6FcryecYHg42w
         ZHUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

This patchset implements freezer for cgroup v2.

It provides similar functionality as v1 freezer, but the interface
conforms to the cgroup v2 interface design principles, and it
provides a better user experience: tasks can be killed, ptrace works,
there is no separate controller, which has to be enabled, etc.

Patches (1), (2) and (3) are some preparational work, patch (4) contains
the implementation, patch (5) is a small cgroup kselftest fix,
patch (6) covers freezer adds 6 new kselftests to cover the freezer
functionality. Patch (7) adds corresponding docs.

v8->v7:
  - reworked/simplified cgroup frozen task accounting by merging nr_stopped
  and nr_frozen and removing nr_tasks_to_freeze
  - don't notify the parent process if the child is going from the stopped
  to the frozen state

v7->v6:
  - handle properly the case, when a task is both stopped and frozen
  - check for CGRP_FREEZE instead of CGRP_FROZEN in cgroup_exit()
  - minor cosmetic changes and rebase

v6->v5:
  - reverted to clear TIF_SIGPENDING with additional checks before schedule(),
  as proposed by Oleg Nesterov
  - made cgroup v2 freezer working with the system freezer (by using
  freezable_schedule())
  - make freezer working with SIGSTOPped and PTRACEd tasks
  - added tests to cover freezing a cgroup with SIGSTOPped and PTRACEd tasks

v5->v4:
  - rewored cgroup state transition code (suggested by Tejun Heo)
  - look at JOBCTL_TRAP_FREEZE instead of task->frozen in
    recalc_sigpending(), check for task->frozen and JOBCTL_TRAP_FREEZE
    in signal_pending_state() (suggested by Oleg Nesterov)
  - some cosmetic changes in signal.c (suggested by Oleg Nesterov)
  - cleaned up comments

v4->v3:
  - reading nr_descendants doesn't require taking css_set_lock anymore
  - fixed docs based on Mike Rapoport's feedback
  - fixed double irq lock found by Dan Carpenter

v3->v2:
  - dropped TASK_FROZEN for now, frozen tasks are put into TASK_INTERRUPTIBLE
  state; it's probably not the final version, but the API question can be
  discussed separately
  - don't clear TIF_SIGPENDING before going to sleep, instead add
  task->frozen check in signal_pending_state() and recalc_sigpending()
  - cgroup-level counter are now synchronized using css_set_lock,
  which simplified the whole code (e.g. per-cgroup works were removed)
  - the amount of comments increased significantly
  - many other improvements incorporating feedback from Tejun and Oleg

v2->v1:
  - fixed locking aroung calling cgroup_freezer_leave()
  - added docs

Roman Gushchin (7):
  cgroup: rename freezer.c into legacy_freezer.c
  cgroup: implement __cgroup_task_count() helper
  cgroup: protect cgroup->nr_(dying_)descendants by css_set_lock
  cgroup: cgroup v2 freezer
  kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
  kselftests: cgroup: add freezer controller self-tests
  cgroup: document cgroup v2 freezer interface

 Documentation/admin-guide/cgroup-v2.rst       |  27 +
 include/linux/cgroup-defs.h                   |  33 +
 include/linux/cgroup.h                        |  42 +
 include/linux/sched.h                         |   2 +
 include/linux/sched/jobctl.h                  |   2 +
 kernel/cgroup/Makefile                        |   4 +-
 kernel/cgroup/cgroup-internal.h               |   1 +
 kernel/cgroup/cgroup-v1.c                     |  16 -
 kernel/cgroup/cgroup.c                        | 142 ++-
 kernel/cgroup/freezer.c                       | 608 +++++--------
 kernel/cgroup/legacy_freezer.c                | 481 ++++++++++
 kernel/signal.c                               |  84 +-
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c  |  85 +-
 tools/testing/selftests/cgroup/cgroup_util.h  |   7 +
 tools/testing/selftests/cgroup/test_freezer.c | 842 ++++++++++++++++++
 17 files changed, 1943 insertions(+), 436 deletions(-)
 create mode 100644 kernel/cgroup/legacy_freezer.c
 create mode 100644 tools/testing/selftests/cgroup/test_freezer.c

-- 
2.20.1

