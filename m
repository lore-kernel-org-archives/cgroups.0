From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v2 bpf-next 0/4] cgroup bpf auto-detachment
Date: Wed, 22 May 2019 16:20:47 -0700
Message-ID: <20190522232051.2938491-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=X6P44zjZ47fHY3Lb/kucsCI8qXASyw0JnvINTZV+gOs=;
 b=TfuFpW4L8bxHJ7DQctRXJeWF5d9O646Y+aS27Chd/28P9CVv6t73NQ4c7xRQ73ukJrkX
 94xZ2jUNnZcPR0c63EwPB539Tga5PwRMfVTNrKhOX6AtyJJW+mOLsvTYA6sYnRrKfi45
 M8K1GAEAMpyiDdMc/mZyKFvil+qWfczQg0U= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, Stanislav Fomichev <sdf@fomichev.me>, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

This patchset implements a cgroup bpf auto-detachment functionality:
bpf programs are attached as soon as possible after removal of the
cgroup, without waiting for the release of all associated resources.

Patches 2 and 3 are required to implement a corresponding kselftest
in patch 4.

v2:
  1) removed a bogus check in patch 4
  2) moved buf[len] = 0 in patch 2


Roman Gushchin (4):
  bpf: decouple the lifetime of cgroup_bpf from cgroup itself
  selftests/bpf: convert test_cgrp2_attach2 example into kselftest
  selftests/bpf: enable all available cgroup v2 controllers
  selftests/bpf: add auto-detach test

 include/linux/bpf-cgroup.h                    |   8 +-
 include/linux/cgroup.h                        |  18 +++
 kernel/bpf/cgroup.c                           |  25 ++-
 kernel/cgroup/cgroup.c                        |  11 +-
 samples/bpf/Makefile                          |   2 -
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/cgroup_helpers.c  |  57 +++++++
 .../selftests/bpf/test_cgroup_attach.c        | 145 ++++++++++++++++--
 8 files changed, 243 insertions(+), 27 deletions(-)
 rename samples/bpf/test_cgrp2_attach2.c => tools/testing/selftests/bpf/test_cgroup_attach.c (79%)

-- 
2.20.1

