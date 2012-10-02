From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup hierarchy changes for v3.7-rc1
Date: Tue, 2 Oct 2012 16:44:07 +0900
Message-ID: <20121002074407.GD6144@localhost>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=NXpGm2Jt7EAsl2DxQi0xGPgaUAOw6vX6e1o+EY96y+E=;
        b=ayNysdrOZby6Ru4K3UIPDDfPD29C223R9AwwekY0yb/YWDwh9/rMOQs/pbg7gOJNc+
         virrAjSw4KD40Sdso5NWC+pe5bRCwbaFzjENnwGk7xvYCqI08+gh0fKQ5LJwp5M7yxSN
         KHo0K6drvokSDL7Poz57Ha54khEDQaWGS13Mt/0a7t6mOrEBvzeScuYBP3Vw4AzcYJ1Q
         4xt91vPw5WGykXaJo/e1CQyeH5GUxPHDkmaBS1Q5FYZ3knAmkmasxpB2bcy4jHN+VXSl
         oVh8DCw1NR8auMv4Sb0qd/WTvmc5vZOotZ3m41htFiRNRGdCaD83fyJweLHX76ZSlTg5
         eEYg==
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, Li Zefan <lizefan@huawei.com>

Hello,

This is another v3.7-rc1 pull request for cgroup.  Currently,
different cgroup subsystems handle nested cgroups completely
differently.  There's no consistency among subsystems and the
behaviors often are outright broken.

People at least seem to agree that the broken hierarhcy behaviors need
to be weeded out if any progress is gonna be made on this front and
that the fallouts from deprecating the broken behaviors should be
acceptable especially given that the current behaviors don't make much
sense when nested.

This patch makes cgroup emit warning messages if cgroups for
subsystems with broken hierarchy behavior are nested to prepare for
fixing them in the future.  This was put in a separate branch because
more related changes were expected (didn't make it this round) and the
memory cgroup wanted to pull in this and make changes on top.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.7-hierarchy

Thanks.

Tejun Heo (1):
      cgroup: mark subsystems with broken hierarchy support and whine if cgroups are nested for them

 block/blk-cgroup.c        |    8 ++++++++
 include/linux/cgroup.h    |   15 +++++++++++++++
 kernel/cgroup.c           |   12 +++++++++++-
 kernel/cgroup_freezer.c   |    8 ++++++++
 kernel/events/core.c      |    7 +++++++
 mm/memcontrol.c           |    7 +++++++
 net/core/netprio_cgroup.c |   12 +++++++++++-
 net/sched/cls_cgroup.c    |    9 +++++++++
 security/device_cgroup.c  |    9 +++++++++
 9 files changed, 85 insertions(+), 2 deletions(-)

--
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
