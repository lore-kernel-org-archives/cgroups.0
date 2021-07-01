From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.14-rc1
Date: Thu, 1 Jul 2021 10:55:40 -1000
Message-ID: <YN4rzCdUR+/2LgaP@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=TQW637DJWCb83mxa1TulL3O+huq6X3gVUkozf2I06Ng=;
        b=gfZSgzXRqgwx54Zblgxw7Xi9NZcW0FpG16mhu1b5ogzLFdIrYmuD6V8X8ax2hz6YdP
         3s1+mx46q6P3hMQGw1rNAw9t3775zD+SZXrYP9krYeVzI2FIDHeCmWlQFaBKzvYE3EUD
         4MxbJRqvVZLYPx2r9+02tsEj09Ys1OQS97u04r9IRwLHm4+FEtBZ/MRiM3EY5lXTlpLe
         /lAIW6fPLkg33RvZdWC5jQyIN5T2zglMEHGdZ5467wV21ekrLDm5ZT+Q6l/7HDJD59WU
         x+UrMAZildRvNBQx3VeD0z3K+FNKXKekGMd3JOk4XsgVkJBmvCRXt8yBruhzdKDhlJT4
         KZyg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

* cgroup.kill is added which implements atomic killing of the whole subtree.
  Down the line, this should be able to replace the multiple userland
  implementations of "keep killing till empty".

* PSI can now be turned off at boot time to avoid overhead for
  configurations which don't care about PSI.

Thank you.

The following changes since commit 08b2b6fdf6b26032f025084ce2893924a0cdb4a2:

  cgroup: fix spelling mistakes (2021-05-24 12:45:26 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.14

for you to fetch changes up to 3958e2d0c34e18c41b60dc01832bd670a59ef70f:

  cgroup: make per-cgroup pressure stall tracking configurable (2021-06-08 14:59:02 -0400)

----------------------------------------------------------------
Christian Brauner (5):
      cgroup: introduce cgroup.kill
      docs/cgroup: add entry for cgroup.kill
      tests/cgroup: use cgroup.kill in cg_killall()
      tests/cgroup: move cg_wait_for(), cg_prepare_for_wait()
      tests/cgroup: test cgroup.kill

Roman Gushchin (1):
      cgroup: inline cgroup_task_freeze()

Suren Baghdasaryan (1):
      cgroup: make per-cgroup pressure stall tracking configurable

Tejun Heo (1):
      Merge branch 'for-5.13-fixes' into for-5.14

Yang Li (1):
      cgroup: Fix kernel-doc

 Documentation/admin-guide/cgroup-v2.rst         |  15 ++
 Documentation/admin-guide/kernel-parameters.txt |   9 +-
 include/linux/cgroup-defs.h                     |   4 +
 include/linux/cgroup.h                          |  25 +-
 kernel/cgroup/cgroup.c                          | 180 ++++++++++++--
 kernel/cgroup/rstat.c                           |   2 +-
 kernel/sched/psi.c                              |  30 +--
 tools/testing/selftests/cgroup/.gitignore       |   3 +-
 tools/testing/selftests/cgroup/Makefile         |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c    |  51 ++++
 tools/testing/selftests/cgroup/cgroup_util.h    |   2 +
 tools/testing/selftests/cgroup/test_freezer.c   |  57 -----
 tools/testing/selftests/cgroup/test_kill.c      | 297 ++++++++++++++++++++++++
 13 files changed, 569 insertions(+), 108 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/test_kill.c

-- 
tejun
