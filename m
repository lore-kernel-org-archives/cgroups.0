From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 0/4] cpuacct cleanup
Date: Thu, 24 Nov 2011 23:33:22 -0200
Message-ID: <1322184806-20421-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Hi,

Leaving aside all the hierarchy walk discussion, I tried to come up
with a series that concentrates only the basic points of it all.
I think we benefit from having it independently of the rest of the work:
in general (comments on the specifics welcome) cpuacct is made more naturally
integrated with the scheduler, and the statistics it collects are now exactly
the same as the system-wide ones for the root cgroup case. I think quite similar
can be done with cpuusage by associating the root cgroup with the main runqueues,
but this here is just me scratching my own itches - we can do it later.

Please let me know if this is acceptable.

Glauber Costa (4):
  Change cpustat fields to an array.
  Reuse cgroup's parent pointer
  Move part of cpuacct code
  cpuacct.stat: re-use scheduler statistics for the root cgroup

 arch/s390/appldata/appldata_os.c       |   16 +-
 arch/x86/include/asm/i387.h            |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |   38 ++---
 drivers/cpufreq/cpufreq_ondemand.c     |   38 ++---
 drivers/macintosh/rack-meter.c         |    8 +-
 fs/proc/stat.c                         |   63 ++++----
 fs/proc/uptime.c                       |    4 +-
 include/linux/kernel_stat.h            |   36 +++--
 kernel/sched.c                         |  270 ++++++++++++++++++--------------
 9 files changed, 252 insertions(+), 223 deletions(-)

-- 
1.7.6.4

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
