From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.19-rc1
Date: Mon, 23 May 2022 13:44:51 -1000
Message-ID: <Yowcc/ZOBIIs2JtZ@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=pDcZJaTRyOHg9w4kEsRf2ua14bTPNjwhSlPe2z4tQPk=;
        b=CTemy5RVJvKRYgzwSyQkolRT2ww2JNpWblhiywZ240VM/rYlcYZWwuLZ2mgYm9ZBbt
         sUFV3gAtRxEeJWf4zH8Mff7XREsuIkAVugVgRP9sU2XeiQ1ZTlbCFIx+pGRYO6UmiFfX
         tHgGHdOcKBcGrbB7aR6DKnckb6aLNlr0VtikD8owymd3x/JF0yIp5VlE9Tin0HvOvTrD
         IkgZfIyUXN4pthTV3uhJiU6PexhFvvaKLR7jfIsEintpD/feIYaVwxVZ833D8fHbR7zU
         cvqE8ayRigy0aL8qo9cfJLMT9/DJl8dOjiWXhN9Bb1AEGT7waxhBSR5XX+uZvzBUE+3Q
         VXXA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Nothing too interesting. It adds cpu controller selftests and there are a
couple code cleanup patches.

Thanks.

The following changes since commit 281b9d9a4b02229b602a14f7540206b0fbe4134f:

  Merge branch 'akpm' (patches from Andrew) (2022-04-22 10:10:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.19

for you to fetch changes up to b154a017c92011d8f71ce804583e5f9c3d90bb9a:

  cgroup: remove the superfluous judgment (2022-05-19 21:49:45 -1000)

----------------------------------------------------------------
David Vernet (9):
      cgroup: Add new test_cpu.c test suite in cgroup selftests
      cgroup: Add test_cpucg_stats() testcase to cgroup cpu selftests
      cgroup: Add test_cpucg_weight_overprovisioned() testcase
      cgroup: Add test_cpucg_weight_underprovisioned() testcase
      cgroup: Adding test_cpucg_nested_weight_overprovisioned() testcase
      cgroup: Add test_cpucg_nested_weight_underprovisioned() testcase
      cgroup: Add test_cpucg_max() testcase
      cgroup: Add test_cpucg_max_nested() testcase
      cgroup: Add config file to cgroup selftest suite

Phil Auld (1):
      kselftest/cgroup: fix test_stress.sh to use OUTPUT dir

Shida Zhang (1):
      cgroup: remove the superfluous judgment

Waiman Long (1):
      kseltest/cgroup: Make test_stress.sh work if run interactively

Xiu Jianfeng (1):
      cgroup: Make cgroup_debug static

 kernel/cgroup/cgroup-internal.h               |   1 -
 kernel/cgroup/cgroup.c                        |   4 +-
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c  |  12 +
 tools/testing/selftests/cgroup/cgroup_util.h  |   4 +
 tools/testing/selftests/cgroup/config         |   8 +
 tools/testing/selftests/cgroup/test_cpu.c     | 726 ++++++++++++++++++++++++++
 tools/testing/selftests/cgroup/test_stress.sh |   2 +-
 9 files changed, 756 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/config
 create mode 100644 tools/testing/selftests/cgroup/test_cpu.c

-- 
tejun
