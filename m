From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v6.1-rc1
Date: Mon, 17 Oct 2022 11:45:47 -1000
Message-ID: <Y03NC6GVxT6iPDsr@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpjDhdEYCevjuzshNCxGyveRGg8J9v5lzGJkYpIm3yo=;
        b=PwfF1qfG7/L22xs/9xUr1w4RjP34Qo/Gja2efbLUE1Vep091V/fXEDwe6ctvoMbo8c
         g3e7Rnysdbf8WgQ8hC86n1iUDvtyKudrI/nvAYZlxINPRhc1gO22EMnvO51aLs+Jvb9i
         x7EzQ1XmFrnH9Zdq/M1Lr4TL3l7mkCOYhioxmL/0d6THKgaJycgj9WpXYzczrKFolWC2
         kb9ew/OwaTvpH/cNwEq6v8mVTupS7OwfX4aEg1YXZcWkkRWytVTgxX+h2e9GiDvQ5qKW
         sm20bt3QYdqPnGAtxVOqIO1Wbp4qI8cQ5yVqqi2VC81MJgj81FhX+ZPbttw/buRsMw4K
         7vRg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following changes since commit 4de65c5830233e7a4adf2e679510089ec4e210c7:

  Merge tag 'livepatching-for-6.1' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/livepatching/livepatching (2022-10-10 11:36:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-=
for-6.1-rc1-fixes

for you to fetch changes up to 79a818b5087393d5a4cb356d4545d02f55bf1a2f:

  blkcg: Update MAINTAINERS entry (2022-10-17 09:27:18 -1000)

----------------------------------------------------------------
cgroup fixes for v6.1-rc1

* Fix a recent regression where a sleeping kernfs function is called with
  css_set_lock (spinlock) held.

* Revert the commit to enable cgroup1 support for cgroup_get_from_fd/file().
  Multiple users assume that the lookup only works for cgroup2 and breaks
  when fed a cgroup1 file. Instead, introduce a separate set of functions to
  lookup both v1 and v2 and use them where the user explicitly wants to
  support both versions.

* Compat update for tools/perf/util/bpf_skel/bperf_cgroup.bpf.c.

* Add Josef Bacik as a blkcg maintainer.

----------------------------------------------------------------
Michal Koutn=FD (1):
      cgroup: Reorganize css_set_lock and kernfs path processing

Namhyung Kim (1):
      perf stat: Support old kernels for bperf cgroup counting

Tejun Heo (2):
      Revert "cgroup: enable cgroup_get_from_file() on cgroup1"
      blkcg: Update MAINTAINERS entry

Yosry Ahmed (3):
      cgroup: add cgroup_v1v2_get_from_[fd/file]()
      bpf: cgroup_iter: support cgroup1 using cgroup fd
      mm: cgroup: fix comments for get from fd/file helpers

 MAINTAINERS                                 |  2 +
 include/linux/cgroup.h                      |  1 +
 kernel/bpf/cgroup_iter.c                    |  2 +-
 kernel/cgroup/cgroup.c                      | 99 +++++++++++++++++++++++--=
----
 tools/perf/util/bpf_skel/bperf_cgroup.bpf.c | 29 ++++++++-
 5 files changed, 111 insertions(+), 22 deletions(-)
