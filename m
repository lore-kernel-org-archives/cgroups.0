From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup namespace support for v4.6-rc1
Date: Fri, 18 Mar 2016 15:09:19 -0400
Message-ID: <20160318190919.GF20028@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=3LK/KXjSTmMwXmUxP+dIQOHMu2jNUZClW8KSeCZhZWc=;
        b=c2ULC/TfkxpFbG5PrjMvS1v8QUK5+4MTNRQIxnkwXwasN3gGy9NLyZrddYJqXkZVAu
         JVwFgcOe7UvGQPDyesQCsaZCnfQnn7a9hkWyTN0dS+Sb+ANmZ83N1JDduyFNezd8aNSv
         qPwrvtKOC1Zy2xb/VKJMujH+rEzi+A3r4gz7qPN3WDtyMmx2UokeoOBrOdYU5JOKxyMN
         QrbcxEphnmNGgRGT74CbIhuoYJ8yeC6urKrU959W+N3MLXkaJmj2sS+tIAbj2bgywnFw
         Q9du2DrMk6HiIM1BCIvKvHrqJB2k59qvikhbjREyr3z7wlokiojg1N51U1sUGPKVMalr
         E8YQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello, Linus.

These are changes to implement namespace support for cgroup which has
been pending for quite some time now.  It is very straight-forward and
only affects what part of cgroup hierarchies are visible.  After
unsharing, mounting a cgroup fs will be scoped to the cgroups the task
belonged to at the time of unsharing and the cgroup paths exposed to
userland would be adjusted accordingly.

The branch is forked off of cgroup/for-4.6, so it'd be best to pull
cgroup/for-4.6 before this branch.

Thanks.

The following changes since commit 223ffb29f9723a4b485cacf6dc7e6d639fffc322:

  cgroup: provide cgroup_nov1= to disable controllers in v1 mounts (2016-02-12 15:01:45 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.6-ns

for you to fetch changes up to fa5ff8a1c43fc7b78353059899edf3cbedf54e9f:

  cgroup: fix and restructure error handling in copy_cgroup_ns() (2016-02-29 16:22:52 -0500)

----------------------------------------------------------------
Aditya Kali (5):
      kernfs: Add API to generate relative kernfs path
      sched: new clone flag CLONE_NEWCGROUP for cgroup namespace
      cgroup: introduce cgroup namespaces
      cgroup: cgroup namespace setns support
      kernfs: define kernfs_node_dentry

Serge Hallyn (3):
      cgroup: mount cgroupns-root when inside non-init cgroupns
      cgroup: Add documentation for cgroup namespaces
      Add FS_USERNS_FLAG to cgroup fs

Tejun Heo (2):
      cgroup: fix alloc_cgroup_ns() error handling in copy_cgroup_ns()
      cgroup: fix and restructure error handling in copy_cgroup_ns()

 Documentation/cgroup-v2.txt | 147 ++++++++++++++++++++++++++++
 fs/kernfs/dir.c             | 191 ++++++++++++++++++++++++++++++------
 fs/kernfs/mount.c           |  69 +++++++++++++
 fs/proc/namespaces.c        |   3 +
 include/linux/cgroup.h      |  49 ++++++++++
 include/linux/kernfs.h      |  11 ++-
 include/linux/nsproxy.h     |   2 +
 include/linux/proc_ns.h     |   4 +
 include/uapi/linux/sched.h  |   3 +-
 kernel/cgroup.c             | 229 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/cpuset.c             |   8 +-
 kernel/fork.c               |   2 +-
 kernel/nsproxy.c            |  19 +++-
 13 files changed, 689 insertions(+), 48 deletions(-)

-- 
tejun
