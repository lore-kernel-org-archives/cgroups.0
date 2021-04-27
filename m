From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.13-rc1
Date: Tue, 27 Apr 2021 10:56:15 -0400
Message-ID: <YIgmD4t2UM7lSXYz@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=NnSA+nWh0rBNTmeoPOnQ0TPq2BsER9tVNRP8Acu7TPc=;
        b=Klrrv9sBhGLpydc+azHgNuqL7vDvN9teKG9RkVbuqgJP81giP/YgVK3DmRnWBNIADw
         5GOMNf36NeA2qawEPgt8o45VsQWr6zSvGT/aaYp4OqykAkIigQvg+0ATahCfX16sVQ+e
         Eqr+URa6kXlw95BD8T3qhZ0qk9+eSwH1VkGzDb5tyRWqMUzNQtdTGLmnCf/d/W3EP3y2
         lwrE5hh1kaZ3UqDUSfG2pbXI8OZmRTnDjWpqAE9CYpWBfvIzfSwg2niE8dCgOVv2egVs
         dzhnipYLxB0wIb5m0u16xgwvHXnG0oq6bszm9UOulXC20pu+0mp2u6uZgazMHgQSBZAu
         zurQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Linus.

The only notable change is Vipin's new misc cgroup controller. This
implements generic support for resources which can be controlled by simply
counting and limiting the number of resource instances - ie. there's X
number of these on the system and this cgroup subtree can have upto Y of
those. The first user is the address space IDs used for virtual machine
memory encryption and expected future usages are similar - niche hardware
features with concrete resource limits and simple usage models.

Thanks.

The following changes since commit 2023a53bdf41b7646b1d384b6816af06309f73a5:

  Merge tag 'for-linus' of git://github.com/openrisc/linux (2021-04-03 15:42:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.13

for you to fetch changes up to ffeee417d97f9171bce9f43c22c9f477e4c84f54:

  cgroup: use tsk->in_iowait instead of delayacct_is_task_waiting_on_io() (2021-04-16 16:49:37 -0400)

----------------------------------------------------------------
Chunguang Xu (1):
      cgroup: use tsk->in_iowait instead of delayacct_is_task_waiting_on_io()

Lu Jialin (1):
      cgroup/cpuset: fix typos in comments

Tejun Heo (1):
      cgroup: misc: mark dummy misc_cg_res_total_usage() static inline

Vipin Sharma (3):
      cgroup: Add misc cgroup controller
      cgroup: Miscellaneous cgroup documentation.
      svm/sev: Register SEV and SEV-ES ASIDs to the misc controller

 Documentation/admin-guide/cgroup-v1/index.rst |   1 +
 Documentation/admin-guide/cgroup-v1/misc.rst  |   4 +
 Documentation/admin-guide/cgroup-v2.rst       |  73 ++++-
 arch/x86/kvm/svm/sev.c                        |  70 ++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/misc_cgroup.h                   | 132 +++++++++
 init/Kconfig                                  |  14 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/cgroup-v1.c                     |   2 +-
 kernel/cgroup/cpuset.c                        |   6 +-
 kernel/cgroup/misc.c                          | 407 ++++++++++++++++++++++++++
 12 files changed, 699 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

-- 
tejun
