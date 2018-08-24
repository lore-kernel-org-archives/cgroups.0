From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v4.19-rc1
Date: Fri, 24 Aug 2018 11:46:56 -0700
Message-ID: <20180824184656.GX3978217@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=4lIYOQNAJ/SvFT4BpHwj/tw6JnH50j7Nlqzxh6kS2EU=;
        b=tmOU9bkcgkKrddtNAMGJAuKlXnIH87w/pshcyUjZwr613VSWnQCgM0zi7gxM7e60Vk
         JA53FlueFh+/0aJibt5QBDIdz6EDDX9Hev04vOJ3OYrfd9L5Zzma4DlbdDW7syx+0ozO
         qHbZHbLzUGLGv8RACCsDxp7uIfp/F8mI2DuYjV0MiHCkFgJtjY01o0Wa7IfxLkmrxs/B
         lF1YOetwcyTvgkBusDGh7D9rawuVPxi8OmmnDEhKCXUOOMapvd52wTV/Fra/6o/iV1nq
         eYLiuF3b9lLWkNeucSTj/6jEruGp7cf6jZ/DkP9O5wPVfsfaTTj0EUdv9okQGF/2/7Ek
         diVQ==
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

Just one commit from Steven to take out spin lock from trace event
handlers.

Thanks.

The following changes since commit 1e09177acae32a61586af26d83ca5ef591cdcaf5:

  Merge tag 'mips_fixes_4.18_3' of git://git.kernel.org/pub/scm/linux/kernel/git/mips/linux (2018-07-10 16:18:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.19

for you to fetch changes up to e4f8d81c738db6d3ffdabfb8329aa2feaa310699:

  cgroup/tracing: Move taking of spin lock out of trace event handlers (2018-07-11 10:48:47 -0700)

----------------------------------------------------------------
Steven Rostedt (VMware) (1):
      cgroup/tracing: Move taking of spin lock out of trace event handlers

 include/trace/events/cgroup.h   | 47 ++++++++++++++++++++---------------------
 kernel/cgroup/cgroup-internal.h | 26 +++++++++++++++++++++++
 kernel/cgroup/cgroup-v1.c       |  4 ++--
 kernel/cgroup/cgroup.c          | 12 ++++++-----
 4 files changed, 58 insertions(+), 31 deletions(-)

-- 
tejun
