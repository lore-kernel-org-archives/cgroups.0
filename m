From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v6.1-rc1
Date: Mon, 3 Oct 2022 08:13:01 -1000
Message-ID: <YzsmLRxPvYQlwtZo@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=qjD9B+YikJdVf0d+9gXelGzE4y1SLS+IR2Z0Xi8fWPo=;
        b=W59UzeWn26yGfJLSBgtmt8RimoEmAFLHyFmzVkIyrM51hr+Mvpv7VoqY+tWFxKBOYK
         SHvkg6AlojI/BY0baSBe1hCEEAY62BhmBkdP30qFBWBtn3OVEHT+1JTixzGwxBfJVDoL
         uUSqaJMSrjF+7l+quNr1qgRpLlZTdaDHcFR4211hDIFuF4CYIp9Pj7gGoW3X1dGTBV2s
         Bo5BqRlCOj+Nn3qudj59ME1tt/QG9XdHFzfy3zUelAC5dqaO7JOLNIoufDj4uuDL7PWB
         wLiv9wXV4w734dz1kFxg3X9jfpSX41/0ncugwAd3hm/oTqXv9zAQOQOqHzZmtZRofwZh
         m5VQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

The following changes since commit df02452f3df069a59bc9e69c84435bf115cb6e37:

  cgroup: cgroup_get_from_id() must check the looked-up kn is a directory (=
2022-09-23 07:18:45 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-=
for-6.1

for you to fetch changes up to 8619e94d3be376bb5e8f20988c0e6e3309d2b09a:

  cgroup: use strscpy() is more robust and safer (2022-09-23 17:27:02 -1000)

----------------------------------------------------------------
cgroup changes for v6.1-rc1.

* cpuset now support isolated cpus.partition type, which will enable dynamic
  CPU isolation.
* pids.peak added to remember the max number of pids used.
* Holes in cgroup namespace plugged.
* Internal cleanups.

Note that for-6.1-fixes was pulled into for-6.1 twice. Both were for
follow-up cleanups and each merge commit has details.

Also, 8a693f7766f9 ("cgroup: Remove CFTYPE_PRESSURE") removes the flag used
by PSI changes in the tip tree and the merged result won't compile due to
the missing flag. Simply removing the struct init lines specifying the flag
is the correct resolution. linux-next already contains the correct fix:

 https://lkml.kernel.org/r/20220912161812.072aaa3b-3FnU+UHB4dNDw9hX6IcOSA@p=
ublic.gmane.org

----------------------------------------------------------------
Elijah Conners (1):
      iocost_monitor: reorder BlkgIterator

Jiapeng Chong (1):
      cgroup/cpuset: remove unreachable code

Josh Don (1):
      cgroup: add pids.peak interface for pids controller

Michal Koutn=FD (3):
      cgroup: Honor caller's cgroup NS when resolving path
      cgroup: cgroup: Honor caller's cgroup NS when resolving cgroup id
      cgroup: Homogenize cgroup_get_from_id() return value

Tejun Heo (8):
      cgroup: Replace cgroup->ancestor_ids[] with ->ancestors[]
      Merge branch 'for-6.0-fixes' into for-6.1
      cgroup: Fix build failure when CONFIG_SHRINKER_DEBUG
      cgroup: Remove data-race around cgrp_dfl_visible
      cgroup: Improve cftype add/rm error handling
      cgroup: Remove CFTYPE_PRESSURE
      Merge branch 'for-6.0-fixes' into for-6.1
      cgroup: Make cgroup_get_from_id() prettier

Tetsuo Handa (1):
      cgroup: Use cgroup_attach_{lock,unlock}() from cgroup_attach_task_all=
()

Waiman Long (10):
      cgroup/cpuset: Enable update_tasks_cpumask() on top_cpuset
      cgroup/cpuset: Miscellaneous cleanups & add helper functions
      cgroup/cpuset: Allow no-task partition to have empty cpuset.cpus.effe=
ctive
      cgroup/cpuset: Relax constraints to partition & cpus changes
      cgroup/cpuset: Add a new isolated cpus.partition type
      cgroup/cpuset: Show invalid partition reason string
      cgroup/cpuset: Relocate a code block in validate_change()
      cgroup/cpuset: Make partition invalid if cpumask change violates excl=
usivity rule
      cgroup/cpuset: Update description of cpuset.cpus.partition in cgroup-=
v2.rst
      kselftest/cgroup: Add cpuset v2 partition root state test

William Dean (1):
      cgroup: simplify code in cgroup_apply_control

ye xingchen (1):
      cgroup: use strscpy() is more robust and safer

 Documentation/admin-guide/cgroup-v2.rst           | 156 +++--
 block/blk-cgroup-fc-appid.c                       |   4 +-
 include/linux/cgroup-defs.h                       |  18 +-
 include/linux/cgroup.h                            |  13 +-
 kernel/cgroup/cgroup-internal.h                   |   2 +
 kernel/cgroup/cgroup-v1.c                         |   6 +-
 kernel/cgroup/cgroup.c                            | 145 ++--
 kernel/cgroup/cpuset.c                            | 815 ++++++++++++++----=
----
 kernel/cgroup/pids.c                              |  37 +-
 mm/memcontrol.c                                   |   4 +-
 net/netfilter/nft_socket.c                        |   9 +-
 tools/cgroup/iocost_monitor.py                    |  10 +-
 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c       |   2 +-
 tools/testing/selftests/cgroup/.gitignore         |   1 +
 tools/testing/selftests/cgroup/Makefile           |   5 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 674 ++++++++++++++++++
 tools/testing/selftests/cgroup/wait_inotify.c     |  87 +++
 17 files changed, 1544 insertions(+), 444 deletions(-)
 create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh
 create mode 100644 tools/testing/selftests/cgroup/wait_inotify.c

--=20
tejun
