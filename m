From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 0/4] cgroup: Introduce cpu controller test suite
Date: Tue, 19 Apr 2022 14:32:40 -0700
Message-ID: <20220419213244.2104972-1-void@manifault.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kernel-team-b10kYP2dOMg@public.gmane.org

This patchset introduces a new test_cpu.c test suite as part of
tools/testing/selftests/cgroup. test_cpu.c will contain testcases that
validate the cgroup v2 cpu controller.

This patchset only contains testcases that validate cpu.stat and
cpu.weight, but I'm expecting to send further patchsets after this that
also include testcases that validate other knobs such as cpu.max.

Note that checkpatch complains about a missing MAINTAINERS file entry for
[PATCH 1/4], but Roman Gushchin added that entry in a separate patchset:
https://lore.kernel.org/all/20220415000133.3955987-4-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org/.

David Vernet (4):
  cgroup: Add new test_cpu.c test suite in cgroup selftests
  cgroup: Add test_cgcpu_stats() testcase to cgroup cpu selftests
  cgroup: Add test_cgcpu_weight_overprovisioned() testcase
  cgroup: Add new test_cgcpu_weight_underprovisioned() testcase

 tools/testing/selftests/cgroup/.gitignore    |   1 +
 tools/testing/selftests/cgroup/Makefile      |   2 +
 tools/testing/selftests/cgroup/cgroup_util.c |  12 +
 tools/testing/selftests/cgroup/cgroup_util.h |   4 +
 tools/testing/selftests/cgroup/test_cpu.c    | 416 +++++++++++++++++++
 5 files changed, 435 insertions(+)
 create mode 100644 tools/testing/selftests/cgroup/test_cpu.c

-- 
2.30.2

