From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v6.2-rc1
Date: Sun, 11 Dec 2022 20:22:14 -1000
Message-ID: <Y5bIlstHSdB7FOID@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=HCii+srz2iaNbP8AXqiOvVaT1PGofZlpv2hPExSpMSA=;
        b=ipIM1jnyyvBEgUwCO1zi9dfHJYO5Xbl/UnjywWopciH/0/URRDOxmphlBjQitN8NEI
         qwFyxECCcFvdCQlK5fqS0+QLWYNBAQSdhCKK1H5CrmnhtYfVKcHvPE+D9xwrCrjnH59Z
         iBTLNsQCz28I+w8Nz/MeNAj0PdP1FCPTbhqCLqYwXsaYo8q0BP6Z0PC8kIlcgz7GdzS4
         4WbGZCJ/hZRSoE/RoovaSLkcSnPjXvLFJGrAAKkoZOCOhk/SzBysY/jRMPoLQLNpZX7Z
         dNBfuT75CLsj8KbqudFcBfFZls8c+/5tiA55z0SCf/vhQVtlRbWt3Ch5zCYIV7vZONP9
         eJyw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following changes since commit 79a818b5087393d5a4cb356d4545d02f55bf1a2f:

  blkcg: Update MAINTAINERS entry (2022-10-17 09:27:18 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.2

for you to fetch changes up to 674b745e22b3caae48ad20422795eefd3f832a7b:

  cgroup: remove rcu_read_lock()/rcu_read_unlock() in critical section of spin_lock_irq() (2022-11-23 07:16:38 -1000)

----------------------------------------------------------------
cgroup changes for v6.2-rc1

Nothing too interesting.

* Add CONFIG_DEBUG_GROUP_REF which makes cgroup refcnt operations kprobable.

* A couple cpuset optimizations.

* Other misc changes including doc and test updates.

----------------------------------------------------------------
Breno Leitao (1):
      kselftest/cgroup: Fix gathering number of CPUs

Kamalesh Babulal (2):
      kselftest/cgroup: Add cleanup() to test_cpuset_prs.sh
      cgroup/cpuset: Improve cpuset_css_alloc() description

Ran Tian (1):
      cgroup: remove rcu_read_lock()/rcu_read_unlock() in critical section of spin_lock_irq()

Tejun Heo (2):
      cgroup: Implement DEBUG_CGROUP_REF
      cgroup: cgroup refcnt functions should be exported when CONFIG_DEBUG_CGROUP_REF

Waiman Long (2):
      cgroup/cpuset: Skip spread flags update on v2
      cgroup/cpuset: Optimize cpuset_attach() on v2

 include/linux/cgroup.h                            | 98 +++--------------------
 include/linux/cgroup_refcnt.h                     | 96 ++++++++++++++++++++++
 kernel/cgroup/cgroup.c                            |  8 +-
 kernel/cgroup/cpuset.c                            | 48 ++++++++---
 lib/Kconfig.debug                                 | 10 +++
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 19 ++++-
 6 files changed, 181 insertions(+), 98 deletions(-)
 create mode 100644 include/linux/cgroup_refcnt.h

-- 
tejun
