From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH v2 0/6] freezer for cgroup v2
Date: Mon, 12 Nov 2018 15:04:15 -0800
Message-ID: <20181112230422.5911-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tzEE9rZVbKHCXTNXEZ/y2fzBVHQSTX20LWGYSOiRuao=;
        b=smwTSRBdi+IKkbeaEOondPeeZiVEo9frr7KziK9Eg9Ccqpo6K3Bv/C2/6ffkigvtXF
         LUDI0eypzr272BqwdO3aHkj+Y7LExdfVQNJ+V00SumkOIHL7PlMvLc/tHxP5ohoo1rOx
         4hDabA4RlJQoqLMLdy0dWWopAWQJEQjtE3KKoJyjRx/PSWJr1HFTPPxKW4MB1O9blrpc
         DlOlK+67yDIow25KgCsJpFDK60FqzSg4ipk3mMRS96/WJ6OWIQr96RGZD/Ey1o9Vlw5V
         tk6FAufXHVy7GOxdLiUUvcKDrO1FkDbrqI5yrAl4ophMeNc3Mh6gmSmw6NWZqBLKahiK
         4VNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

This patchset implements freezer for cgroup v2.

It provides similar functionality as v1 freezer, but the interface
conforms to the cgroup v2 interface design principles, and it
provides a better user experience: tasks can be killed, ptrace works,
there is no separate controller, which has to be enabled, etc.

Patches (1) and (2) are some preparational work, patch (3) contains
the implementation, patch (4) is a small cgroup kselftest fix,
patch (5) covers freezer adds 6 new kselftests to cover the freezer
functionality. Patch (6) adds corresponding docs.

v2->v1:
  - fixed locking aroung calling cgroup_freezer_leave()
  - added docs

Roman Gushchin 
  cgroup: rename freezer.c into legacy_freezer.c
  cgroup: implement __cgroup_task_count() helper
  cgroup: cgroup v2 freezer
  kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
  kselftests: cgroup: add freezer controller self-tests
  cgroup: document cgroup v2 freezer interface

 Documentation/admin-guide/cgroup-v2.rst       |  26 +
 include/linux/cgroup-defs.h                   |  33 +
 include/linux/cgroup.h                        |  42 ++
 include/linux/sched.h                         |   5 +-
 include/linux/sched/jobctl.h                  |   5 +-
 kernel/cgroup/Makefile                        |   4 +-
 kernel/cgroup/cgroup-internal.h               |   1 +
 kernel/cgroup/cgroup-v1.c                     |  16 -
 kernel/cgroup/cgroup.c                        | 132 +++-
 kernel/cgroup/freezer.c                       | 590 +++++----------
 kernel/cgroup/legacy_freezer.c                | 481 ++++++++++++
 kernel/ptrace.c                               |   6 +
 kernel/signal.c                               |  54 +-
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c  |  85 ++-
 tools/testing/selftests/cgroup/cgroup_util.h  |   7 +
 tools/testing/selftests/cgroup/test_freezer.c | 685 ++++++++++++++++++
 18 files changed, 1724 insertions(+), 451 deletions(-)
 create mode 100644 kernel/cgroup/legacy_freezer.c
 create mode 100644 tools/testing/selftests/cgroup/test_freezer.c

-- 
2.17.2

