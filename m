From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET v2 cgroup/for-3.15] cgroup: cleanups after kernfs conversion
Date: Sat,  8 Feb 2014 11:38:21 -0500
Message-ID: <1391877509-10855-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=+6QgnppvYa44LeYAhwQ9/Ax52jUXBRODbTiRL9WS+QE=;
        b=NX1dvl9P6gr8rXv6UFOkBv6aLm0eQzA7Uigl9tjpaLZeVDHi3twKPt0Strcz5eRdXq
         Sf8/bOO+3Lno8Da8WZ3jOxTtdhP+1nl5boMhdtO0C4cLBcfd2MkVbX97qZSV+AsDfssW
         oaZxgjNGWzMAkORENu6+YI0mkqZXECIGjeT2IjRHKwcZg6Bb2Noe+IFzMifQuxLx6jgm
         hRs/lbDX5RYwuHL0gYR1tQxI+yrvV6wm8rOmVKePg+t0h4uEpOs003UQQYKf30B0Js3i
         z0fczcDNdG+6ZIXpFv2zsFsm9h1Wj/RnDxd3/B8m6bVHjvM0CNSwnX9XBXjHiD8yQAjW
         EeQA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

This is v2 of cleanups-after-kernfs-conversion patchset.  Nothing
really changed since the last take[L]. It just got rebased on top of
the updated patches.

This patchset does a number of cleanups which are possible now that
cgroup is converted to kernfs.  This patchset contains the following
eight patches.

 0001-cgroup-warn-if-xattr-is-specified-with-sane_behavior.patch
 0002-cgroup-relocate-cgroup_rm_cftypes.patch
 0003-cgroup-remove-cftype_set.patch
 0004-cgroup-simplify-dynamic-cftype-addition-and-removal.patch
 0005-cgroup-make-cgroup-hold-onto-its-kernfs_node.patch
 0006-cgroup-remove-cgroup-name.patch
 0007-cgroup-rename-cgroupfs_root-number_of_cgroups-to-nr_.patch
 0008-cgroup-remove-cgroupfs_root-refcnt.patch

This patchset is on top of

  cgroup/for-3.15 f7cef064aa01 ("Merge branch 'driver-core-next' into cgroup/for-3.15")
+ [1] [PATCHSET v2 cgroup/for-3.15] cgroup: convert to kernfs

and also available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-post-kernfs-conversion

 fs/kernfs/dir.c        |    1
 include/linux/cgroup.h |   91 ++++------
 kernel/cgroup.c        |  417 +++++++++++++++++--------------------------------
 kernel/cpuset.c        |   27 +--
 kernel/sched/debug.c   |    3
 mm/memcontrol.c        |   68 ++-----
 7 files changed, 229 insertions(+), 390 deletions(-)

Thanks.

--
tejun

[L] http://lkml.kernel.org/g/1390953585-16554-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[1] http://lkml.kernel.org/g/1391876127-7134-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
