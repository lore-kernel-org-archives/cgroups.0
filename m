From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCHSET v2 cgroup/for-4.6] cgroup, perf_event: make perf_event work on v2 hierarchy
Date: Wed, 24 Feb 2016 17:12:53 -0500
Message-ID: <1456351975-1899-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id;
        bh=7ZivDVXyZLoLlwWIuqW6D/Ge49tootlLczzZqERMiXI=;
        b=SwIdEdTdkER+2+KdVgFjvZgltB6Gq8WqsFXju2I1QO2cZwdiynsTtqItvNCOTws8Uc
         MKupRyExUB0NhjH7ZwX6eCJgcDxHIQNiG9hitbFupFfBNU38OB0EPZWj5WXJ+Iax6y3b
         pFg7f7w9H76xM2JVNwoaKDzXRTY6EySsJScMVQ76uOLqdA5gOOYVIpU59wMk5F5tK/qX
         bEPBOJIUqS7o+mxlg9Hny3hhRFhcZgQKsgn4wuG7PpaM4oShBpyRbj/+b+ZZftFZSxQU
         8C+OnqTzpYpA22bwLjnSHkLDjXXqx8P/CIG+XqQ3PIga6Rkr6/xvoL9oQRTZxJEApYFw
         16YA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

Changes from v1[1] are

* cgroup prep patches are applied to cgroup/for-4.6.

* Implicit controller support is reimplemented on top of the modular
  control mask update[2] which makes it simpler and better behaved -
  perf_event can now be returned to v2 hierarchy anytime.

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

This patchset contains the following two patches.

 0001-cgroup-implement-cgroup_subsys-implicit_on_dfl.patch
 0002-cgroup-perf_event-make-perf_event-controller-work-on.patch

This patchset is on top of cgroup/for-4.6 and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-cgroup2-perf_event

As the changes are heavily dependent on updates in cgroup core and
relatively well isolated on perf side, once acked, I think it'd be
best to route this through cgroup tree.

diffstat follows.

 Documentation/cgroup-v2.txt |   12 ++++++++++++
 include/linux/cgroup-defs.h |   13 +++++++++++++
 kernel/cgroup.c             |   38 +++++++++++++++++++++++++++++++-------
 kernel/events/core.c        |    6 ++++++
 tools/perf/util/cgroup.c    |   26 +++++++++++++++++++-------
 5 files changed, 81 insertions(+), 14 deletions(-)

Thanks.

--
tejun

[1] http://lkml.kernel.org/g/1452205790-21331-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
[2] http://lkml.kernel.org/g/1456351368-786-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
