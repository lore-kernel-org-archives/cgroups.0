From: Roberto Sassu <roberto.sassu@huaweicloud.com>
Subject: [PATCH 0/7] bpf: Add fd modes check for map iter and extend libbpf
Date: Tue,  6 Sep 2022 19:02:54 +0200
Message-ID: <20220906170301.256206-1-roberto.sassu@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, jakub@cloudflare.com
Cc: bpf@vger.kernel.org, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, houtao1@huawei.com, Roberto Sassu <roberto.sassu@huawei.com>

From: Roberto Sassu <roberto.sassu@huawei.com>

Add a missing fd modes check in map iterators, potentially causing
unauthorized map writes by eBPF programs attached to the iterator. Use this
patch set as an opportunity to start a discussion with the cgroup
developers about whether a security check is missing or not for their
iterator.

Also, extend libbpf with the _opts variant of bpf_*_get_fd_by_id(). Only
bpf_map_get_fd_by_id_opts() is really useful in this patch set, to ensure
that the creation of a map iterator fails with a read-only fd.

Add all variants in this patch set for symmetry with
bpf_map_get_fd_by_id_opts(), and because all the variants share the same
opts structure. Also, add all the variants here, to shrink the patch set
fixing map permissions requested by bpftool, so that the remaining patches
are only about the latter.

Finally, extend the bpf_iter test with the read-only fd check, and test
each _opts variant of bpf_*_get_fd_by_id().

Roberto Sassu (7):
  bpf: Add missing fd modes check for map iterators
  libbpf: Define bpf_get_fd_opts and introduce
    bpf_map_get_fd_by_id_opts()
  libbpf: Introduce bpf_prog_get_fd_by_id_opts()
  libbpf: Introduce bpf_btf_get_fd_by_id_opts()
  libbpf: Introduce bpf_link_get_fd_by_id_opts()
  selftests/bpf: Ensure fd modes are checked for map iters and destroy
    links
  selftests/bpf: Add tests for _opts variants of libbpf

 include/linux/bpf.h                           |   2 +-
 kernel/bpf/inode.c                            |   2 +-
 kernel/bpf/map_iter.c                         |   3 +-
 kernel/bpf/syscall.c                          |   8 +-
 net/core/bpf_sk_storage.c                     |   3 +-
 net/core/sock_map.c                           |   3 +-
 tools/lib/bpf/bpf.c                           |  47 +++++-
 tools/lib/bpf/bpf.h                           |  16 ++
 tools/lib/bpf/libbpf.map                      |  10 +-
 tools/lib/bpf/libbpf_version.h                |   2 +-
 .../selftests/bpf/prog_tests/bpf_iter.c       |  34 +++-
 .../bpf/prog_tests/libbpf_get_fd_opts.c       | 145 ++++++++++++++++++
 .../bpf/progs/test_libbpf_get_fd_opts.c       |  49 ++++++
 13 files changed, 309 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_libbpf_get_fd_opts.c

-- 
2.25.1

