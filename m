From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v5.7-rc1
Date: Fri, 3 Apr 2020 11:52:43 -0400
Message-ID: <20200403155243.GF162390@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=Za/htZk64WGRnsEWR8r2929pAGBMjmkKLkKsEbUZhBs=;
        b=D/f3vfZFF1SiLQnrJ7rrb/lAykV3v6OqChYhbcgVee38gxZWZfqb0GD7NQUHUUEVnP
         CotxEZoNUSzeFNJzkp3sTAhsrGhzfdahKtgmqAYQTlFKsUg2QTt6klbDdtCNxX3UKD+A
         HL1AE7mC8xc5PbraXwCj0VYCmbNcFq91kAurjBJOjxbt2m3UDImWk0FWUOlqFeP//Pmp
         OckC5PpYrSEXC7t7QwWuEbz2HOMGVVjhbqZqOPa6opx3L0ghYVH/Ure9CjImZ+4T5LLZ
         ReOeb1smxypWR2ST/UZJICBAKdLT4UkpAUQrx5wlUL+Wl7R7JPmLHY/Vfo7d4V9vMCre
         Ml+A==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello, Linus.

* Christian extended clone3 so that processes can be spawned into cgroups
  directly. This is not only neat in terms of semantics but also avoids gra=
bbing
  the global cgroup_threadgroup_rwsem for migration.

* Daniel added !root xattr support to cgroupfs. Userland already uses xattr=
s on
  cgroupfs for bookkeeping. This will allow delegated cgroups to support su=
ch
  usages.

* Prateek tried to make cpuset hotplug handling synchronous but that led to
  possible deadlock scenarios. Reverted.

* Other minor changes including release_agent_path handling cleanup.

Thanks.

The following changes since commit 2e5383d7904e60529136727e49629a82058a5607:

  cgroup1: don't call release_agent when it is "" (2020-03-04 11:53:33 -050=
0)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.7

for you to fetch changes up to 0c05b9bdbfe52ad9b391a28dd26f047715627e0c:

  docs: cgroup-v1: Document the cpuset_v2_mode mount option (2020-04-03 11:=
42:56 -0400)

----------------------------------------------------------------
Christian Brauner (6):
      cgroup: unify attach permission checking
      cgroup: add cgroup_get_from_file() helper
      cgroup: refactor fork helpers
      cgroup: add cgroup_may_write() helper
      clone3: allow spawning processes into cgroups
      selftests/cgroup: add tests for cloning into cgroups

Daniel Xu (4):
      kernfs: kvmalloc xattr value instead of kmalloc
      kernfs: Add removed_size out param for simple_xattr_set
      kernfs: Add option to enable user xattrs
      cgroupfs: Support user xattrs

Madhuparna Bhowmik (1):
      cgroup.c: Use built-in RCU list checking

Michal Koutn=FD (1):
      cgroup: Clean up css_set task traversal

Prateek Sood (1):
      cpuset: Make cpuset hotplug synchronous

Suren Baghdasaryan (1):
      kselftest/cgroup: add cgroup destruction test

Tejun Heo (3):
      Merge branch 'for-5.6-fixes' into for-5.7
      cgroup: Restructure release_agent_path handling
      Revert "cpuset: Make cpuset hotplug synchronous"

Waiman Long (1):
      docs: cgroup-v1: Document the cpuset_v2_mode mount option

 Documentation/admin-guide/cgroup-v1/cpusets.rst   |  11 +
 fs/kernfs/inode.c                                 |  91 +++++-
 fs/kernfs/kernfs-internal.h                       |   2 +
 fs/xattr.c                                        |  17 +-
 include/linux/cgroup-defs.h                       |   5 +-
 include/linux/cgroup.h                            |  23 +-
 include/linux/kernfs.h                            |  11 +-
 include/linux/sched/task.h                        |   4 +
 include/linux/xattr.h                             |   3 +-
 include/uapi/linux/sched.h                        |   5 +
 kernel/cgroup/cgroup-v1.c                         |  34 +-
 kernel/cgroup/cgroup.c                            | 361 ++++++++++++++++--=
----
 kernel/cgroup/cpuset.c                            |   8 +-
 kernel/cgroup/pids.c                              |  15 +-
 kernel/fork.c                                     |  19 +-
 mm/shmem.c                                        |   2 +-
 tools/testing/selftests/cgroup/Makefile           |   6 +-
 tools/testing/selftests/cgroup/cgroup_util.c      | 126 ++++++++
 tools/testing/selftests/cgroup/cgroup_util.h      |   4 +
 tools/testing/selftests/cgroup/test_core.c        | 177 +++++++++++
 tools/testing/selftests/clone3/clone3_selftests.h |  19 +-
 21 files changed, 795 insertions(+), 148 deletions(-)

--=20
tejun
