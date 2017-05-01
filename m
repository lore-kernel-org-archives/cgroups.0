From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.12-rc1
Date: Mon, 1 May 2017 15:58:23 -0400
Message-ID: <20170501195823.GA19079@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=xf+fXkuzVNO8lJHWNkK1YiKP9tYHQoLle0V5zJb5BUw=;
        b=TUR7oRJfO+ACv/IZt8lECwF6TrgNIChJmWoAlUKdj85vKicyck/c8F87fff8PlVSd2
         VlaZYHdluZ/yDAxTmkxulo9UO+LKt00Crx8HG8KNbpipqPFUDkaCRykCFCFTdyDnY5uo
         DISSWyKSfjwKHDZioL6gRXU7f0VTGGTlHi5euIjIsylSpwzzzle1b5A0nqnD+jCs5VGB
         14aS3f4kmlNYd/PCcjCDfkqHJ6AU3oKeIETjSodZC6Cg64WAEsYq/ksXJqmxvarcHTLF
         qL9OKOJ9B1KMSIxOFfhkcavFziCw34osZOHhiE7hYTp0gTVmsIovaDrNnD0bF/+tCqqn
         R9PA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

Nothing major.  Two notable fixes are Li's second stab at fixing the
long-standing race condition in the mount path and suppression of
spurious warning from cgroup_get().  All other changes are trivial.

Thanks.

The following changes since commit c1ae3cfa0e89fa1a7ecc4c99031f5e9ae99d9201:

  Linux 4.11-rc1 (2017-03-05 12:59:56 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.12

for you to fetch changes up to 310b4816a5d8082416b4ab83e5a7b3cb92883a4d:

  cgroup: mark cgroup_get() with __maybe_unused (2017-05-01 15:24:14 -0400)

----------------------------------------------------------------
Elena Reshetova (2):
      kernel: convert cgroup_namespace.count from atomic_t to refcount_t
      kernel: convert css_set.refcount from atomic_t to refcount_t

Geliang Tang (1):
      cgroup: drop duplicate header nsproxy.h

Nicholas Mc Guire (1):
      cgroup: switch to BUG_ON()

Rakib Mullick (1):
      cpuset: Remove cpuset_update_active_cpus()'s parameter.

Tejun Heo (2):
      cgroup: fix spurious warnings on cgroup_is_dead() from cgroup_sk_alloc()
      cgroup: mark cgroup_get() with __maybe_unused

Todd Poynor (1):
      cgroup: move cgroup_subsys_state parent field for cache locality

Zefan Li (1):
      cgroup: avoid attaching a cgroup root to two different superblocks, take 2

 include/linux/cgroup-defs.h     | 12 ++++++++----
 include/linux/cgroup.h          |  8 ++++----
 include/linux/cpuset.h          |  4 ++--
 kernel/cgroup/cgroup-internal.h |  7 ++++---
 kernel/cgroup/cgroup-v1.c       | 20 +++++++++++++++++---
 kernel/cgroup/cgroup.c          | 40 +++++++++++++++++++++++++---------------
 kernel/cgroup/cpuset.c          | 11 ++++-------
 kernel/cgroup/namespace.c       |  2 +-
 kernel/sched/core.c             |  4 ++--
 9 files changed, 67 insertions(+), 41 deletions(-)

-- 
tejun
