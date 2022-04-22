From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 0/4] cgroup: Introduce cpu controller test suite
Date: Fri, 22 Apr 2022 10:33:47 -0700
Message-ID: <20220422173349.3394844-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

This patchset introduces a new test_cpu.c test suite as part of
tools/testing/selftests/cgroup. test_cpu.c will contain testcases that
validate the cgroup v2 cpu controller.

This patchset only contains testcases that validate cpu.stat and
cpu.weight, but I'm expecting to send further patchsets after this that
also include testcases that validate other knobs such as cpu.max.

Note that checkpatch complains about a missing MAINTAINERS file entry for
[PATCH 1/4], but Roman Gushchin added that entry in a separate patchset:
https://lore.kernel.org/all/20220415000133.3955987-4-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org/.

Changelog:
v2:
  - s/cgcpu/cpucg for variable names and test names.
  - Pass struct timespec as part of struct cpu_hog_func_param rather than
    stuffing the whole time as nanoseconds in a single long.

David Vernet (4):
  cgroup: Add new test_cpu.c test suite in cgroup selftests
  cgroup: Add test_cpucg_stats() testcase to cgroup cpu selftests
  cgroup: Add test_cpucg_weight_overprovisioned() testcase
  cgroup: Add test_cpucg_weight_underprovisioned() testcase

 tools/testing/selftests/cgroup/.gitignore    |   1 +
 tools/testing/selftests/cgroup/Makefile      |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c |  12 +
 tools/testing/selftests/cgroup/cgroup_util.h |   4 +
 tools/testing/selftests/cgroup/test_cpu.c    | 446 +++++++++++++++++++
 5 files changed, 465 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_cpu.c

-- 
2.30.2

