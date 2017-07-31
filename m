From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v4.13-rc3
Date: Mon, 31 Jul 2017 08:43:53 -0700
Message-ID: <20170731154353.GD447614@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=L5R/WoE5BqU2tFM4WVR6+WRtT5/D5caTkZBJRoOoyvE=;
        b=Xnw8qMfRgctXwrB5We7jpdGmm4JAi7UpPKQpF4j0IkzQ3nbti1KapbcWLF5KZUYuKY
         pwm4XcrsNNIE+wxmTX7dMQVLVbRexnHd1eHfLUUTtI3VZLeStzO4IY+KfWF6kkitZvlD
         R3DPrW7gTzybzy7IqTImOme3jEjt4pT796iEWWYjU4J2IK3KciUyaMPJQ0qd323F/hwC
         QUVLa5WV4uCYZpE371335b6e8IOWYsX9bnXeHBeahKA6QX2cO1598qLBJweOHkIFfqA3
         ubZwKSjR0v7zNPg9YYH9jRNLl3URJ2ErThv+JWHDtv00bKOGvkuZtTK8JYYWl2R/p22l
         JwBA==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hello, Linus.

Several cgroup bug fixes.

* cgroup core was calling a migration callback on empty migrations,
  which could make cpuset crash.

* There was a very subtle bug where the controller interface files
  aren't created directly when cgroup2 is mounted.  Because later
  operations create them, this bug didn't get noticed earlier.

* Failed writes to cgroup.subtree_control were incorrectly returning
  0.

The following changes since commit cee37d83e6d9ada1c2254c73bac7955f9e048d22:

  Merge branch 'work.read_write' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2017-07-07 21:48:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.13-fixes

for you to fetch changes up to 3c74541777302eec43a0d1327c4d58b8659a776b:

  cgroup: fix error return value from cgroup_subtree_control() (2017-07-23 08:15:17 -0400)

----------------------------------------------------------------
Tejun Heo (3):
      cgroup: don't call migration methods if there are no tasks to migrate
      cgroup: create dfl_root files on subsys registration
      cgroup: fix error return value from cgroup_subtree_control()

 kernel/cgroup/cgroup-internal.h |  3 ++
 kernel/cgroup/cgroup.c          | 66 +++++++++++++++++++++++------------------
 2 files changed, 40 insertions(+), 29 deletions(-)

--
tejun
