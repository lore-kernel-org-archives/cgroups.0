From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v4 bpf-next 0/4] cgroup bpf auto-detachment
Date: Fri, 24 May 2019 16:51:52 -0700
Message-ID: <20190524235156.4076591-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=XDz+gmj/EBFqZGWRU3jYaIrBb6wF338CvPmYvlgJN2I=;
 b=mv80gHPIWaroUzxkE2SCC1qEQelrZ/H4Chtait3Z/WfTyBoiNBkUGpFAmbr54Bfjk22P
 FLHd4zHolOU9WCSs6wBkPlks1gxF17SNszVMCxVC1pIDDWE/GY4W/4v3kAPxhTgEdOlY
 wP2Og9eLcbW3Ah18O3A+G3tZ20mJDUquOJU= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yhs@fb.com>, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

This patchset implements a cgroup bpf auto-detachment functionality:
bpf programs are detached as soon as possible after removal of the
cgroup, without waiting for the release of all associated resources.

Patches 2 and 3 are required to implement a corresponding kselftest
in patch 4.

v4:
  1) release cgroup bpf data using a workqueue
  2) add test_cgroup_attach to .gitignore

v3:
  1) some minor changes and typo fixes

v2:
  1) removed a bogus check in patch 4
  2) moved buf[len] = 0 in patch 2


Roman Gushchin (4):
  bpf: decouple the lifetime of cgroup_bpf from cgroup itself
  selftests/bpf: convert test_cgrp2_attach2 example into kselftest
  selftests/bpf: enable all available cgroup v2 controllers
  selftests/bpf: add auto-detach test

 include/linux/bpf-cgroup.h                    |  11 +-
 include/linux/cgroup.h                        |  18 +++
 kernel/bpf/cgroup.c                           |  41 ++++-
 kernel/cgroup/cgroup.c                        |  11 +-
 samples/bpf/Makefile                          |   2 -
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/cgroup_helpers.c  |  57 +++++++
 .../selftests/bpf/test_cgroup_attach.c        | 146 ++++++++++++++++--
 9 files changed, 262 insertions(+), 29 deletions(-)
 rename samples/bpf/test_cgrp2_attach2.c => tools/testing/selftests/bpf/test_cgroup_attach.c (79%)

-- 
2.21.0

