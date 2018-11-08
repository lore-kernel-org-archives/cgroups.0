From: Roman Gushchin <guroan@gmail.com>
Subject: [PATCH 0/5] freezer for cgroup v2
Date: Thu,  8 Nov 2018 15:15:55 -0500
Message-ID: <20181108201600.9129-1-guro@fb.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AVWov9oTOLa0o8ptLdw/1Bm5RUGAQRjdANBdPA/XZu4=;
        b=hvkLkTNKujjz1aQzDBYFbCmLaXzD+yTIu3FChGLjWGDvmmiNsi9heX0jIAjT15BS9e
         qKlaAeXp4T4btrSWM15KEdJKp8CtS99coEP4tLaSKhKL6+ipdm6Ke4lrmRWjIHaRA0wD
         X0zzHC9bsfBQkKi4rsmrTCaUy13i0XJ4f2rSJ2APnyN43mS/LxB69+tZT63X3qzD23Ce
         XgMe/aKfRN/dHFy6rFrOTGaTAHLfq8DHnfaVsPIsJj43R3qUQQJi44+egSm9cEtEBgfe
         H/4R1JDfWvj0ep/0w+9hfNC0ngqCm0AKDbmLJ642Q/r1oX7fAyAqIx4LMULrd9+RuNP5
         sE/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

This patchset implements freezer for cgroup v2.

It provides similar functionality as v1 freezer, but the interface
conforms to the cgroup v2 interface design principles, and it
provides a better user experience: tasks can be killed, ptrace works,
there is no separate controller, which has to be enabled, etc.

Patches (1) and (2) are some preparational work, patch (3) contains
the implementation, patch (4) is a small cgroup kselftest fix,
patch (5) covers freezer adds 6 new kselftests to cover the freezer
functionality.

Roman Gushchin (5):
  cgroup: rename freezer.c into legacy_freezer.c
  cgroup: implement __cgroup_task_count() helper
  cgroup: cgroup v2 freezer
  kselftests: cgroup: don't fail on cg_kill_all() error in cg_destroy()
  kselftests: cgroup: add freezer controller self-tests

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
 kernel/signal.c                               |  51 +-
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c  |  85 ++-
 tools/testing/selftests/cgroup/cgroup_util.h  |   7 +
 tools/testing/selftests/cgroup/test_freezer.c | 685 ++++++++++++++++++
 17 files changed, 1695 insertions(+), 451 deletions(-)
 create mode 100644 kernel/cgroup/legacy_freezer.c
 create mode 100644 tools/testing/selftests/cgroup/test_freezer.c

-- 
2.17.2

