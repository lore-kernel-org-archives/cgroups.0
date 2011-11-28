From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2 0/3] cpuacct cgroup refactoring
Date: Mon, 28 Nov 2011 14:45:16 -0200
Message-ID: <1322498719-2255-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

Hi,

This is the same series I've already sent before. Just sending again
after the conflict with the code that was in tip.git

Best regards,

Glauber Costa (3):
  Change cpustat fields to an array.
  Reuse cgroup's parent pointer
  cpuacct.stat: re-use scheduler statistics for the root cgroup

 arch/s390/appldata/appldata_os.c       |   16 +-
 arch/x86/include/asm/i387.h            |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |   38 +++---
 drivers/cpufreq/cpufreq_ondemand.c     |   38 +++---
 drivers/macintosh/rack-meter.c         |    8 +-
 fs/proc/stat.c                         |   63 ++++-----
 fs/proc/uptime.c                       |    4 +-
 include/linux/kernel_stat.h            |   36 +++--
 kernel/sched/core.c                    |  242 +++++++++++++++----------------
 kernel/sched/sched.h                   |   33 ++++-
 10 files changed, 248 insertions(+), 232 deletions(-)

-- 
1.7.6.4

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
