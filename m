From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v4.16-rc6
Date: Mon, 19 Mar 2018 14:35:32 -0700
Message-ID: <20180319213532.GK519464@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Gayzzkhwp36XuXO6u3rEouor99oTh2R3+hU9QP8YaAw=;
        b=L848OYVStlJXTjCn+wuBbUy0XNwggRYXR7wnRKfszqnXUnzFGdnpg1Rfi+6neHUKAd
         gJMQPUGp1sdTFjLFEuZEwyJXeXz6uYzo8+IgzyPD+iy4jBwhulid/wEOA0mup/shaBV8
         1x/xzVhGhe269hrTdd3LcXQJKU+u04N7BdWFBNWhN9KQ3Z5BGOlqSrWEbgFO8y4tPFrG
         m3jihKO+GZl/P94nDr51EOiqXAXlUmsCqxiBgqk9dN5aEspPP7ctM8wqUr3NT3a9WAGl
         eM8C8onUd1NeqM1n9kZjkgvCTP1fF642MG5kph/ZUnaArDoC6xgtUYvtoIAudHJHE8ZH
         4QhQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello, Linus.

Two commits to fix the following subtle cgroup2 behavior bugs.

* cpu.max was rejecting config when it shouldn't.

* Thread mode enable was allowed when it shouldn't.

Thanks.

The following changes since commit 7928b2cbe55b2a410a0f5c1f154610059c57b1b2:

  Linux 4.16-rc1 (2018-02-11 15:04:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.16-fixes

for you to fetch changes up to d1897c9538edafd4ae6bbd03cc075962ddde2c21:

  cgroup: fix rule checking for threaded mode switching (2018-02-21 11:39:22 -0800)

----------------------------------------------------------------
Tejun Heo (2):
      sched, cgroup: Don't reject lower cpu.max on ancestors
      cgroup: fix rule checking for threaded mode switching

 kernel/cgroup/cgroup.c | 10 ++++++++++
 kernel/sched/core.c    | 15 ++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

-- 
tejun
