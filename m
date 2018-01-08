From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup fixes for v4.15-rc7
Date: Mon, 8 Jan 2018 06:52:23 -0800
Message-ID: <20180108145223.GS3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=OSwhNPEvocPllhlS3rFQPTd9j8QkfdjRLTeVrvsb4Hc=;
        b=SKSDuStzUIXKgNWePW+xUazoJiE+U23xNfoKfDktsI5H89DZ6N/5Xc1G+ZxtNAXF//
         tcUxBR3XyypNo470+gpilwuXCgufejNay7MMAaQZ1X77gM0zfOmeZEBI0XZhLIVIV090
         mqj3cE9FLMySbqR895T9mOv34XQ1wZa/yVVQMJWn8WByaiG/t/rszgQs1BK80O48VIoG
         sSV3rgTSiVhm8mB2ufIpFjG6DpgnPrhgw6UuAztsEEpFtSiJNDECau3tnFgdoagiBwD9
         Ozv9Cort2C5vH6QFpS7u8h9pcUSylfszed9RYvicjXR2RMtlq3lHkpJ9WYyjNckyP7SV
         z3kg==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

Hello, Linus.

Sorry about the late pull request.  I forgot to send them out before
the holidays.

This pull request contains fixes for the following two non-trivial
issues.

* The task iterator got broken while adding thread mode support for
  v4.14.  It was less visible because it only triggers when both
  cgroup1 and cgroup2 hierarchies are in use.  The recent versions of
  systemd uses cgroup2 for process management even when cgroup1 is
  used for resource control exposing this issue.

* cpuset CPU hotplug path could deadlock when racing against exits.

There also are two patches to replace unlimited strcpy() usages with
strlcpy().

Thanks.

The following changes since commit c2f31b79d510ec1a27138bdcf2d0ece1080be85e:

  cgroup: add warning about RT not being supported on cgroup2 (2017-12-05 11:47:17 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.15-fixes

for you to fetch changes up to 74d0833c659a8a54735e5efdd44f4b225af68586:

  cgroup: fix css_task_iter crash on CSS_TASK_ITER_PROC (2017-12-20 07:09:19 -0800)

----------------------------------------------------------------
Arnd Bergmann (1):
      cgroup: use strlcpy() instead of strscpy() to avoid spurious warning

Ma Shimiao (1):
      cgroup: avoid copying strings longer than the buffers

Prateek Sood (1):
      cgroup: Fix deadlock in cpu hotplug path

Tejun Heo (1):
      cgroup: fix css_task_iter crash on CSS_TASK_ITER_PROC

 kernel/cgroup/cgroup-v1.c |  6 +++++-
 kernel/cgroup/cgroup.c    | 20 +++++++++-----------
 2 files changed, 14 insertions(+), 12 deletions(-)

-- 
tejun
