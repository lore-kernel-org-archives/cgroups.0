From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] cgroup changes for v6.4-rc1
Date: Thu, 27 Apr 2023 10:53:51 -1000
Message-ID: <ZErg3xZyhlVx_Mw0@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682628833; x=1685220833;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=/5HWPeVY1MQbyixrvVym4tZ22GEw9R6F1zseVGpafmk=;
        b=emB5v8zA8+Re9OPy+eYSmdTZbC5NAZo0kYdTWKXuC1+PTSPgR9LZnp07/I0f0ex2G2
         o4Bedy0IxCUyuZAm/IjGAz95AVan+L+JB283acbS4a9hjICkG4afU3tRr2wSdBj9HiCh
         G2hQSvfdPP4k9dEguUChEcjfn+P/hQTPisKO50Lz4jMJDiOCv+OmadAwWhAYUSxrr0do
         98BUMbuNcRtlJQK4PAl9KfjI0ZVtcysgNM3JdRIof9jG0pdi7mJatyO4Ip8B1wovVtvZ
         bhIofXEThLitec/y5p1rEDbbo7zc9tJ6ODxoaWYMhXlUoKFkWK6yT6FqeKsME4twVQ45
         ahQA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>

The following changes since commit 292fd843de26c551856e66faf134512c52dd78b4:

  cgroup/cpuset: Fix partition root's cpuset.cpus update bug (2023-03-29 08:37:07 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.4

for you to fetch changes up to 9403d9cb564b6a3af86cb18fe722097ed7620f6f:

  docs: cgroup-v1/cpusets: update libcgroup project link (2023-04-14 06:55:48 -1000)

----------------------------------------------------------------
cgroup changes for v6.4-rc1

* cpuset changes including the fix for an incorrect interaction with CPU
  hotplug and an optimization.

* Other doc and cosmetic changes.

----------------------------------------------------------------
Haifeng Xu (1):
      cpuset: Clean up cpuset_node_allowed

Kamalesh Babulal (2):
      cgroup: bpf: use cgroup_lock()/cgroup_unlock() wrappers
      docs: cgroup-v1/cpusets: update libcgroup project link

Tejun Heo (1):
      Merge branch 'for-6.3-fixes' into for-6.4

Waiman Long (3):
      cgroup/cpuset: Skip task update if hotplug doesn't affect current cpuset
      cgroup/cpuset: Include offline CPUs when tasks' cpumasks in top_cpuset are updated
      cgroup/cpuset: Minor updates to test_cpuset_prs.sh

 Documentation/admin-guide/cgroup-v1/cpusets.rst   |  2 +-
 include/linux/cpuset.h                            | 16 +-----
 kernel/bpf/cgroup.c                               | 38 +++++++-------
 kernel/bpf/cgroup_iter.c                          |  4 +-
 kernel/bpf/local_storage.c                        |  4 +-
 kernel/cgroup/cgroup-v1.c                         | 16 +++---
 kernel/cgroup/cgroup.c                            | 60 +++++++++++------------
 kernel/cgroup/cpuset.c                            | 30 +++++++-----
 mm/page_alloc.c                                   |  4 +-
 tools/testing/selftests/cgroup/test_cpuset_prs.sh | 25 +++++-----
 10 files changed, 99 insertions(+), 100 deletions(-)
