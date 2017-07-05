From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.13-rc1
Date: Wed, 5 Jul 2017 15:29:34 -0400
Message-ID: <20170705192934.GA27242@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=5vYZfZFRNxZET/CAR376gg+MBdkDUwO0YNDrC553WuQ=;
        b=Ny9mHlhHpfcfYS5a0/J/7j1UvJn77jnAnZ3mxEhpkevNFLgLNrLroQTyxjdZXjS5Sp
         B88kzQ3Q+Cx9jjU4e1/zqLtNZVQCByIn9vW5HFt0QRQa6/eGj4f+Teig49HAchSnqRKH
         q9zDad4f5hr5I2F3A11z1SEZe+LqlGRWJjr0OM126fE1tCq/3BY99D/46lyj1cKZPdFg
         r6LBxohcvywh/t2Hn4nXi9GOb1vuIXUIfmALOrek2wsofWSmkkVyIoPrBYw9gsescAq8
         3P2JRE8Xo4VBGHaRzneG/f0ObKQt0G8Pvy/MqIS6b1u1xjnNlOpFhj2L0Qag3YnOuQxD
         j+pw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Linus.

* Waiman made the debug controller work and a lot more useful on
  cgroup2.

* There were a couple issues with cgroup subtree delegation.  The
  documentation on delegating to a !root user was missing some part
  and cgroup namespace support wasn't factoring in delegation at all.
  The documentation is updated and the now there is a mount option to
  make cgroup namespace fit for delegation.

Thanks.

The following changes since commit 63f700aab4c11d46626de3cd051dae56cf7e9056:

  Merge tag 'xtensa-20170612' of git://github.com/jcmvbkbc/linux-xtensa (2017-06-13 15:09:10 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.13

for you to fetch changes up to 5136f6365ce3eace5a926e10f16ed2a233db5ba9:

  cgroup: implement "nsdelegate" mount option (2017-06-28 14:45:21 -0400)

----------------------------------------------------------------
Tejun Heo (6):
      cgroup: make debug an implicit controller on cgroup2
      cgroup: refactor cgroup_masks_read() in the debug controller
      cgroup: fix lockdep warning in debug controller
      cgroup: "cgroup.subtree_control" should be writeable by delegatee
      cgroup: restructure cgroup_procs_write_permission()
      cgroup: implement "nsdelegate" mount option

Waiman Long (4):
      cgroup: Keep accurate count of tasks in each css_set
      cgroup: Move debug cgroup to its own file
      cgroup: Make Kconfig prompt of debug cgroup more accurate
      cgroup: Make debug cgroup support v2 and thread mode

 Documentation/cgroup-v2.txt     |  60 +++++--
 include/linux/cgroup-defs.h     |  12 ++
 init/Kconfig                    |   7 +-
 kernel/cgroup/Makefile          |   1 +
 kernel/cgroup/cgroup-internal.h |   2 +
 kernel/cgroup/cgroup-v1.c       | 155 +----------------
 kernel/cgroup/cgroup.c          | 155 +++++++++++++----
 kernel/cgroup/debug.c           | 357 ++++++++++++++++++++++++++++++++++++++++
 8 files changed, 548 insertions(+), 201 deletions(-)
 create mode 100644 kernel/cgroup/debug.c

-- 
tejun
