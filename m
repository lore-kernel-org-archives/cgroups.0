From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v4.15-rc3
Date: Mon, 11 Dec 2017 13:57:36 -0800
Message-ID: <20171211215736.GR2421075@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=bRvWv/9X5fMGULNuj8GZqbwT4xRhKbSnb2kb/qZGQNc=;
        b=qIdfpUYpMQCW8/lxaSOtxpy8cBHuunIaZ+JhgFErQIRl+tTjK+3ExOUheOSiivbE1v
         qgkQktWXoGxM6XqHCQwJPtaqIZku4ekcHx/tltXNMFj6as1iRd4NtU/ArfJlLzv7J6AI
         oZ/YR0bLKD5E+BA8Ke4SQs4WhJchC6Nh27QW+Xecajm8xEe2QxLUx4sUNpjCLcb6BA++
         1VsFbJztUAfybVTkywN6aI1Wha5oCeqfM2XdT6semHoF7S4fhcQV5Mr1Bcmp+snH0oAS
         wjNjLjZMBBnN4IKXKQW0GyU9odo09wmYo9CJ2jvjQ4Wjc38FF6JlnMducN+5EKEt68Ob
         y+Fw==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello,

* Prateek posted a couple patches to fix a deadlock involving cpuset
  and workqueue.  It unfortunately caused a different deadlock and the
  recent workqueue hotplug simplification removed the original
  deadlock, so Prateek's two patches are reverted for now.

* The new stat code was missing u64_stats initialization.  Fixed.

* Doc and other misc changes.

Thanks.

The following changes since commit 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323:

  Linux 4.15-rc1 (2017-11-26 16:01:47 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.15-fixes

for you to fetch changes up to c2f31b79d510ec1a27138bdcf2d0ece1080be85e:

  cgroup: add warning about RT not being supported on cgroup2 (2017-12-05 11:47:17 -0800)

----------------------------------------------------------------
Lucas Stach (1):
      cgroup: properly init u64_stats

Prateek Sood (2):
      cgroup/cpuset: remove circular dependency deadlock
      cpuset: Make cpuset hotplug synchronous

Tejun Heo (3):
      Revert "cpuset: Make cpuset hotplug synchronous"
      Revert "cgroup/cpuset: remove circular dependency deadlock"
      cgroup: add warning about RT not being supported on cgroup2

Wang Long (1):
      debug cgroup: use task_css_set instead of rcu_dereference

 Documentation/cgroup-v2.txt | 7 +++++++
 kernel/cgroup/debug.c       | 4 ++--
 kernel/cgroup/stat.c        | 8 ++++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

-- 
tejun
