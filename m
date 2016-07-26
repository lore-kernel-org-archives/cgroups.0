From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.8-rc1
Date: Tue, 26 Jul 2016 13:10:41 -0400
Message-ID: <20160726171041.GB4144@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=dGSwCMGycMmAGSB93+XQK+p/5Fc5dpCGvp9Yb92JG00=;
        b=eP6r8Yl0VanpGAuu0LqSjc3NiSvHBOKFURIlyYVPMGdpaUp8Y0a09cZ3X3johKS8YK
         bZFOJBDrkM7aYGDBaHH1a1Xi+fjR0LnJAMI+cU3FL1mg+SmzoakUbdi8k90MFTe+OiTa
         SlEl4MCczkHlxDMTQPvke61GJEoDhElyfLLtjw+gBaJDqJxRCqAf2LGdEqpp4Up8idY8
         3/eyXx6HB3UAT030Z8YbA5Y+/zdw0iTcLhBpJCoZN+gaDqpgNuzUIPRuGb3Lxw8REoj/
         TkiJXiGx4V3AP0j1lJluW4zV6p23iK9ipcVoRbgZlXWW8yUKMfjXo2S41b+bjtl1i7Ff
         V/XQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Nothing too exciting.

* Updates to the pids controller so that pid limit breaches can be
  noticed and monitored from userland.

* Cleanups and non-critical bug fixes.

Thanks.

The following changes since commit db06d759d6cf903aeda8c107fd3abd366dd80200:

  Merge branch 'for-4.7-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu (2016-06-13 19:54:46 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.8

for you to fetch changes up to 55094f57535831883b60776de5eb78c6bfb3c16d:

  cgroup: remove duplicated include from cgroup.c (2016-07-19 14:28:04 -0400)

----------------------------------------------------------------
Johannes Weiner (2):
      cgroup: fix idr leak for the first cgroup root
      cgroup: remove unnecessary 0 check from css_from_id()

Kenny Yu (2):
      cgroup: Add pids controller event when fork fails because of pid limit
      cgroup: Use lld instead of ld when printing pids controller events_limit

Tejun Heo (1):
      cgroup: allow NULL return from ss->css_alloc()

Wei Yongjun (1):
      cgroup: remove duplicated include from cgroup.c

 kernel/cgroup.c      | 13 ++++---------
 kernel/cgroup_pids.c | 34 +++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 10 deletions(-)

-- 
tejun
