From: Roman Gushchin <guro@fb.com>
Subject: [PATCH bpf-next 0/4] cgroup bpf auto-detachment
Date: Wed, 22 May 2019 14:29:28 -0700
Message-ID: <20190522212932.2646247-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=THkyaL46U42CuIQO/bUMHkqiVtg4R96gtH4e/2sSFSE=;
 b=qKxa6dRDmhGboAf4t93kFw+cSCWjYrMDcCbxKQLXCH1zPD+OGhpMqESwgP3mNyUytAMu
 YR7TwU4WPFDXFEdLDT7MDYoZzwWf4VDTdbvxsg00Rq1epl12obXjfcTEd7liodvtUVOa
 9DvfQiWl6t5I0JjH7Ssid/iPvtC8DIyobEI= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bpf@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

This patchset implements a cgroup bpf auto-detachment functionality:
bpf programs are attached as soon as possible after removal of the
cgroup, without waiting for the release of all associated resources.

Patches 2 and 3 are required to implement a corresponding kselftest
in patch 4.

Roman Gushchin (4):
  bpf: decouple the lifetime of cgroup_bpf from cgroup itself
  selftests/bpf: convert test_cgrp2_attach2 example into kselftest
  selftests/bpf: enable all available cgroup v2 controllers
  selftests/bpf: add auto-detach test

 include/linux/bpf-cgroup.h                    |   8 +-
 include/linux/cgroup.h                        |  18 ++
 kernel/bpf/cgroup.c                           |  25 ++-
 kernel/cgroup/cgroup.c                        |  11 +-
 samples/bpf/Makefile                          |   2 -
 tools/testing/selftests/bpf/Makefile          |   4 +-
 tools/testing/selftests/bpf/cgroup_helpers.c  |  58 +++++++
 .../selftests/bpf/test_cgroup_attach.c        | 154 ++++++++++++++++--
 8 files changed, 253 insertions(+), 27 deletions(-)
 rename samples/bpf/test_cgrp2_attach2.c => tools/testing/selftests/bpf/test_cgroup_attach.c (78%)

-- 
2.20.1

