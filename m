From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v5 bpf-next 0/4] cgroup bpf auto-detachment
Date: Sat, 25 May 2019 09:37:38 -0700
Message-ID: <20190525163742.2616471-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5RTPfI6UzZo8h/nwiW8QfQd6DBgTvw5sKSvqdQKtb2o=;
 b=TPpiil9iO3VW4SB2PmqCp9qNWGOvc8+rJRLqlnPEeKiuoRpjr1zbk59/iNkN0Td3xokU
 lcEQKnPuwKfjThy0/xEBlee717DwDqV0E5f+cVPd+4LOcwjNI/kCltJLw6FqkghIPQu8
 qY/6g7VDt9ODi0BoBb5ESAfmkFJWRC/OFZw= 
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

v5:
  1) rebase

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
 tools/testing/selftests/bpf/Makefile          |   3 +-
 tools/testing/selftests/bpf/cgroup_helpers.c  |  57 +++++++
 .../selftests/bpf/test_cgroup_attach.c        | 146 ++++++++++++++++--
 9 files changed, 261 insertions(+), 29 deletions(-)
 rename samples/bpf/test_cgrp2_attach2.c => tools/testing/selftests/bpf/test_cgroup_attach.c (79%)

-- 
2.21.0

