From: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 0/2] cpu subsystem for unified hierarchy.
Date: Wed, 13 Jan 2016 16:40:18 +0800
Message-ID: <1452674420-31603-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Hi TJ,
	When I want to improve cpuacct subsystem, you said we are going
to combine cpuacct and cpu subsystem. Then I am here to try to implement
cpu subsystem in unified hierarchy and squash cpuacct in it.

	In [1/2], I implemented the .dfl_cftypes for cpu subsystem. it
includes the all files of cpu subsystem in cgroup1 and some files from
cpuacct subsystem in cgroup1. I did not pick cpuacct.stat from cpuacct
because I am not sure is that necessary.

	In [2/2], I extended the cpu.usage in cpu subsystem, making it
to be able to show user_usage and sys_usage. That's useful in my usecase.

Please help to review, thanx!

Yang

Dongsheng Yang (2):
  sched: implement cpu subsystem for unified hierarchy
  cgroup: cpu subsystem: split cpu usage into user_usage and sys_usage.

 kernel/sched/core.c      | 276 ++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/deadline.c  |   2 +-
 kernel/sched/fair.c      |   2 +-
 kernel/sched/rt.c        |   2 +-
 kernel/sched/sched.h     |  21 ++++
 kernel/sched/stop_task.c |   2 +-
 6 files changed, 299 insertions(+), 6 deletions(-)

-- 
1.8.4.2


