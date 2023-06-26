From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup: Changes for v6.5
Date: Mon, 26 Jun 2023 12:30:19 -1000
Message-ID: <ZJoRezbOXRTLIL3T@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687818620; x=1690410620;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=srYH61jPdlaM0MowCsJN0isuziRw2t+pfv2C6FBW2u4=;
        b=oc1Y9ulu/tTCNJdypcysex6m70Pojpf1VuD3SGuFtEhBKrItjq5TNwCpmusDlTXp/r
         1DsH1GcEp1Q4gNQ7VN8sl6aSwaZk0sPZtwMXgcMg0m49KCn1Gl7x1T64mczVXKBChTrR
         hhrVPwOgH6uNBaIfuk4+lDNAe6bc/SjBU6+TcMryHwEYCuE1YLjaugyWZ7Kan/92bvML
         26L/22Hz4aGiCAizqmv/Ha7m5SqFLhPPbj5m7KX10Q6hZB7XUkjKrE2n2Dl98aq4YYiG
         5hDu7/PUnx1Ym0YFPnx37gSBpUpHSPyxF6CgC0c6ucG6Zj9VHEtSb5nZPkrfHLp8Bc66
         So5g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following changes since commit ba0ad6ed89fd5dada3b7b65ef2b08e95d449d4ab:

  media: nxp: imx8-isi: fix buiding on 32-bit (2023-05-08 09:10:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.5

for you to fetch changes up to 81621430c81bb7965c3d5807039bc2b5b3ec87ca:

  Revert "cgroup: Avoid -Wstringop-overflow warnings" (2023-06-22 08:51:14 -1000)

----------------------------------------------------------------
cgroup: Changes for v6.5

* Whenever cpuset needs to rebuild sched_domain, it walked all tasks looking
  for DEADLINE tasks as they need to be accounted on the new domain. Walking
  all tasks can be expensive and there may not be any DEADLINE tasks at all.
  Task iteration is now omitted if there are no DEADLINE tasks.

* Fixes DEADLINE bandwidth misaccounting after task migration failures.

* When no controller is enabled, -Wstringop-overflow warning is triggered.
  The fix patch added an early exit which is too eager and got reverted for
  now. Will fix later.

* Everything else are minor cleanups.

----------------------------------------------------------------
Azeem Shaikh (1):
      cgroup: Replace all non-returning strlcpy with strscpy

Dietmar Eggemann (2):
      sched/deadline: Create DL BW alloc, free & check overflow interface
      cgroup/cpuset: Free DL BW in case can_attach() fails

Gaosheng Cui (2):
      cgroup: Replace the css_set call with cgroup_get
      rdmacg: fix kernel-doc warnings in rdmacg

Gustavo A. R. Silva (1):
      cgroup: Avoid -Wstringop-overflow warnings

Juri Lelli (4):
      cgroup/cpuset: Rename functions dealing with DEADLINE accounting
      sched/cpuset: Bring back cpuset_mutex
      sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets
      cgroup/cpuset: Iterate only if DEADLINE tasks are present

LeiZhou-97 (1):
      cgroup/misc: Expose misc.current on cgroup v2 root

Miaohe Lin (6):
      cgroup/cpuset: remove unneeded header files
      cgroup: remove unused macro for_each_e_css()
      cgroup: make cgroup_is_threaded() and cgroup_is_thread_root() static
      cgroup/cpuset: remove unneeded header files
      cgroup: remove unused task_cgroup_path()
      cgroup: remove obsolete comment on cgroup_on_dfl()

Tejun Heo (1):
      Revert "cgroup: Avoid -Wstringop-overflow warnings"

Xiu Jianfeng (1):
      cgroup: Update out-of-date comment in cgroup_migrate()

 Documentation/admin-guide/cgroup-v2.rst |   2 +-
 include/linux/cgroup.h                  |   1 -
 include/linux/cpuset.h                  |  12 +-
 include/linux/sched.h                   |   4 +-
 kernel/cgroup/cgroup-internal.h         |   2 -
 kernel/cgroup/cgroup-v1.c               |   4 +-
 kernel/cgroup/cgroup.c                  |  72 ++-------
 kernel/cgroup/cpuset.c                  | 267 +++++++++++++++++++-------------
 kernel/cgroup/misc.c                    |   1 -
 kernel/cgroup/rdma.c                    |   2 +
 kernel/sched/core.c                     |  41 +++--
 kernel/sched/deadline.c                 |  67 ++++++--
 kernel/sched/sched.h                    |   2 +-
 13 files changed, 257 insertions(+), 220 deletions(-)
