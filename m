From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 0/5] Fix bugs in memcontroller cgroup tests
Date: Sat, 23 Apr 2022 08:56:15 -0700
Message-ID: <20220423155619.3669555-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org

tools/testing/selftests/cgroup/test_memcontrol.c contains a set of
testcases which validate expected behavior of the cgroup memory controller.
Roman Gushchin recently sent out a patchset that fixed a few issues in the
test. This patchset continues that effort by fixing a few more issues that
were causing non-deterministic failures in the suite. With this patchset,
I'm unable to reproduce any more errors after running the tests in a
continuous loop for many iterations. Before, I was able to reproduce at
least one of the errors fixed in this patchset with just one or two runs.

Changelog:
v2:
  - Fixed the comment headers in test_memcg_min() and test_memcg_low() to
    reflect the new ordering of child cgroups in those tests.
  - Fixed the comment I added in test_memcg_oom_group_leaf_events() to use /* */
    for multiline comments, as is the norm according to the kernel style guide.
  - Changed some of the conditional logic in test_memcg_oom_group_leaf_events()
    that checks for OOM event counts based on memory_localevents to be more
    intuitive.

David Vernet (5):
  cgroups: Refactor children cgroups in memcg tests
  cgroup: Account for memory_recursiveprot in test_memcg_low()
  cgroup: Account for memory_localevents in
    test_memcg_oom_group_leaf_events()
  cgroup: Removing racy check in test_memcg_sock()
  cgroup: Fix racy check in alloc_pagecache_max_30M() helper function

 tools/testing/selftests/cgroup/cgroup_util.c  | 12 +++
 tools/testing/selftests/cgroup/cgroup_util.h  |  1 +
 .../selftests/cgroup/test_memcontrol.c        | 77 ++++++++++++-------
 3 files changed, 64 insertions(+), 26 deletions(-)

-- 
2.30.2

