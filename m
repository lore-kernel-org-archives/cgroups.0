From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-3.8] netcls_cgroup: implement hierarchy support
Date: Fri, 16 Nov 2012 19:30:59 -0800
Message-ID: <1353123062-23193-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        bh=GRktWmnlS5vqnpyTw9cM/CSCzNyDGzXGTu1EjegZ3m0=;
        b=jyYtRktc9AxhY0+IAjXLL1ql/FQ/sTurBu9TFOXgRZtZjcQRAZK6aKuXl7frZi0LDK
         V0Iuib8kP+y+7OpTVOV4NmYwMpxdgTNy2n/9y3EXNKjtSer9FRN59fVNstdnEaDm9BVO
         161MES81zAYreJzjdFGdU2XRA3JZsts1/kgFFrms0yY2AOWtoJ58aTbvJWcwTWeuTItD
         cI5KDtqAA5s4/D4uHA2xVyHB6xAMhaiOSYW9WX4uh3G2qOpNmuP8hBnk+YeBE5lxiBr9
         R2p+Kdc2aqJYoaVMTuZbLo4MceyaAYqgTqQNNx1FSgUQ1HTHANZTC6OHBiEKzpqFlQqc
         zKeA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, tgraf-G/eBtMaohhA@public.gmane.org
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, guys.

This patchset implements proper hierarchy support for netcls_cgroup.
Pretty simliar to the netprio one[3].  Simpler as each cgroup has
single config value instead of array of them.

This patchset contains the following three patches.

 0001-netcls_cgroup-introduce-netcls_mutex.patch
 0002-netcls_cgroup-introduce-cgroup_cls_state-is_local.patch
 0003-netcls_cgroup-implement-proper-hierarchy-support.patch

This patchset is on top of

cgroup/for-3.8 ef9fe980c6 ("cgroup_freezer: implement proper hierarchy support")
+ [1] "[PATCHSET cgroup/for-3.8] cgroup: allow ->post_create() to fail"
+ [2] "[PATCH 1/2] cgroup: s/CGRP_CLONE_CHILDREN/CGRP_CPUSET_CLONE_CHILDREN/"
      "[PATCH 2/2] cgroup, cpuset: remove cgroup_subsys->post_clone()"
+ [3] "[PATCHSET cgroup/for-3.8] netprio_cgroup: implement hierarchy support"

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-netcls_cgroup-hierarchy

diffstat follows.

 include/net/cls_cgroup.h |    1
 net/sched/cls_cgroup.c   |  102 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 88 insertions(+), 15 deletions(-)

Thanks.

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel.cgroups/5047
[2] http://thread.gmane.org/gmane.linux.kernel/1393151
[3] https://lkml.org/lkml/2012/11/16/514
