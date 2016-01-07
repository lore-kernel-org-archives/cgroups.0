From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET] cgroup, perf_event: make perf_event work on v2 hierarchy
Date: Thu,  7 Jan 2016 17:29:44 -0500
Message-ID: <1452205790-21331-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=KmmgWxvO2N0LW4/fOZFTUZ7xbs1Snb7oB8oCR7WLqVM=;
        b=UiNIE2DeZVWdAC3aiqliMw5IbmV0qz9PWHh6Y3U9JlXrvEvg9Di3BWb8Q4Ng5fuRq4
         t4AyX9oylEFHIlR7S6ZFJ2gVH+hSU25KecedJ9pJKpLLByduPkD0NZt37rNWTpF5EYkq
         aF9lKS4NBbADgRX8nLY7YOlPWSeEeKUAtskCUHtrix3dC0qVkNAOfg4o/6pnvs1b0tGD
         GD5LeDAeYleSn69cnVgpkn8cVASWCA3Ftom0j9MXqK8fYAdxLX3+1SdeHmnUi5jl6Dmo
         732gF3xBWYGXOAUL4NtACq+fVQ/eX8mnN+QEA37lbOSIXGfYWufBkfoQ9a13TRoZ61m3
         FmuQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

perf_event is special in that while it primarily is there to identify
cgroup membership of tasks, it also keeps some per-cgroup state, so
unlike other controllers which are purely for identification, it can't
be replaced by v2 hierarchy membership tests.  At the same time, as it
is primarily used for tagging, doesn't incur meaningful runtime
overhead and doesn't have any interface, it's awkward to control it
via the usual "cgroup.subtree_control" mechanism on the v2 hierarchy.

This patchset makes perf_event implicitly enabled on the v2 hierarchy
so that cgroup v2 path automatically works with "perf record --cgroup"
as long as perf_event controller is available and not mounted on a
legacy hierarchy.  "perf record" is updated so that it searches for
both v1 hierarchy w/ perf_event on it and v2 hierarchy.  The v1
hierarchy is used if exists; otherwise, v2 is used, making the
transition transparent to users.

This patchset contains the following six patches.

 0001-cgroup-s-cgrp_dfl_root_-cgrp_dfl_.patch
 0002-cgroup-convert-cgroup_subsys-flag-fields-to-bool-bit.patch
 0003-cgroup-make-css_tryget_online_from_dir-also-recogniz.patch
 0004-cgroup-use-subtree_control-when-testing-no-internal-.patch
 0005-cgroup-implement-cgroup_subsys-implicit_on_dfl.patch
 0006-cgroup-perf_event-make-perf_event-controller-work-on.patch

0001-0004 are prep patches.

0005 implents implicit controller enabling.

0006 marks perf_event as implicitly enabled on v2 and updates "perf
record"

This patchset is on top of cgroup/for-4.5 and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-perf_event

diffstat follows.  Thanks.

 Documentation/cgroup.txt    |   13 ++++
 include/linux/cgroup-defs.h |   21 ++++++-
 kernel/cgroup.c             |  129 ++++++++++++++++++++++++++++++++++----------
 kernel/cpuset.c             |    2 
 kernel/events/core.c        |    6 ++
 kernel/sched/core.c         |    2 
 kernel/sched/cpuacct.c      |    2 
 tools/perf/util/cgroup.c    |   26 ++++++--
 8 files changed, 160 insertions(+), 41 deletions(-)

--
tejun
