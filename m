From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v4 0/7] freezer for cgroup v2
Date: Fri, 30 Nov 2018 15:47:38 -0800
Message-ID: <20181130234745.6756-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8wWgJ9mRatXUK5Ii2MmF/AjR4kqI/jk/sjBZOiW0lNk=;
        b=FB/75V07p4TGJd0um2iwcghXUClp+mgyExRg+GqzYv7+qUJSFl5f2LYgb5w2B0z0bY
         z6ZTJpki25OZwbXX9woJyB8ovQAwyzmGDiIXpUZEmkWxn40vjcYb7BIVLSUMj36YEFTU
         fxEnYULbK4m0yehe93ZlpIEfj/LDUwhHs23IiUPz1wMmmJmO6Anj97vHVhw34NhxQkJl
         oyL0TTX9IdqoRM/uHT5XTFVeWZ3bbWTrD6Mxp0/3y8tAV7VgP273RTAZ4IKCkF5QXQwl
         VhX1heKDXQoIS0kqx36r6XswVWZRVmneOkAYKRj5UAnhyM7vTw4paocU+MuAg/Uloxb5
         actA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

freezer for cgroup v2

This patchset implements freezer for cgroup v2.

It provides similar functionality as v1 freezer, but the interface
conforms to the cgroup v2 interface design principles, and it
provides a better user experience: tasks can be killed, ptrace works,
there is no separate controller, which has to be enabled, etc.

Patches (1), (2) and (3) are some preparational work, patch (4) contains
the implementation, patch (5) is a small cgroup kselftest fix,
patch (6) covers freezer adds 6 new kselftests to cover the freezer
functionality. Patch (7) adds corresponding docs.

v4->v3:
  - fixed cgroup state transitions on task migration (by Tejun Heo)
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
 include/linux/cgroup-defs.h                   |  31 +
 include/linux/cgroup.h                        |  42 ++
 include/linux/sched.h                         |   2 +
 include/linux/sched/jobctl.h                  |   2 +
 include/linux/sched/signal.h                  |   3 +
 kernel/cgroup/Makefile                        |   4 +-
 kernel/cgroup/cgroup-internal.h               |   1 +
 kernel/cgroup/cgroup-v1.c                     |  16 -
 kernel/cgroup/cgroup.c                        | 151 +++-
 kernel/cgroup/freezer.c                       | 653 +++++++----------
 kernel/cgroup/legacy_freezer.c                | 481 ++++++++++++
 kernel/ptrace.c                               |   7 +
 kernel/signal.c                               |  58 +-
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c  |  85 ++-
 tools/testing/selftests/cgroup/cgroup_util.h  |   7 +
 tools/testing/selftests/cgroup/test_freezer.c | 685 ++++++++++++++++++
 19 files changed, 1811 insertions(+), 447 deletions(-)
 create mode 100644 kernel/cgroup/legacy_freezer.c
 create mode 100644 tools/testing/selftests/cgroup/test_freezer.c

-- 
2.17.2

