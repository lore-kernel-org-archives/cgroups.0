From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET cgroup/for-4.2] cgroup: require write perm on common ancestor for migration
Date: Tue, 16 Jun 2015 15:10:13 -0400
Message-ID: <1434481817-32001-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=WHNNciilFwOqm6GRACSPpD/RwDnhV9gkH3GCjIk799A=;
        b=ui/YIw/AdBILTihqMqWUx0tG+rnXmvdasnyDWrh7DTUCjWx2hGpbTmSUknomKdrB9Z
         OktR9yaMhJG4MLqntTqdpoBp75yV91huIlCuUAwNx884M3gt0NoGDwQnPn4RTiLC40dp
         NjpN9vff9D0YfkYrlPWD/rPw9JvP4YdSYf8Zuv68LS18VCO3lwL/XYfLY9MkA/MFr6IN
         RpFKD5HrYtuHe4YFR6VR91pV/+9retBJq8yC9hJFrGMWA0VxwYsQZ+DyWV/WVp+2dQwn
         NNUtq6I2BwqT9jDi+AOJAYGrYTC6prhY++q/jl+Wctx80YLt8dZ5Mz1bjeQaB4lEV1aF
         B/vg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On traditional hierarchies, if a task has write access to "tasks" or
"cgroup.procs" file of a cgroup and its euid agrees with the target,
it can move the target to the cgroup; however, this allows a delegatee
to smuggle processes across disjoint sub-hierarchies violating the
organizational structure and resource restrictions imposed from higher
up.

To prevent these breaches, this patchset makes unified hierarchy
require write access to cgroup.procs of the common ancestor of the
source and destination cgroups.  It also adds documentation on how
delegation of sub-hierarchies should be done on unified hierarchy.

This patchset contains the following four patches.

 0001-kernfs-make-kernfs_get_inode-public.patch
 0002-cgroup-separate-out-cgroup_procs_write_permission-fr.patch
 0003-cgroup-require-write-perm-on-common-ancestor-when-mo.patch
 0004-cgroup-add-delegation-section-to-unified-hierarchy-d.patch

0001-0002 are prep patches.  0003 implements the common ancestor rule
and 0004 documents delegation on unified hierarchy.

This patchset is on top of cgroup/for-4.2 4d205676c102 ("MAINTAINERS:
add a cgroup core co-maintainer") and available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup-delegation

diffstat follows.  Thanks.

 Documentation/cgroups/unified-hierarchy.txt |  102 +++++++++++++++++++++++-----
 fs/kernfs/kernfs-internal.h                 |    1 
 include/linux/cgroup-defs.h                 |    1 
 include/linux/kernfs.h                      |    5 +
 kernel/cgroup.c                             |   64 +++++++++++++----
 5 files changed, 139 insertions(+), 34 deletions(-)

--
tejun
