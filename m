From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-cgroup v7 0/6] cgroup/cpuset: Support remote partitions
Date: Thu, 17 Aug 2023 09:24:48 -0400
Message-ID: <20230817132454.755459-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692278733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EIvqGNiOYq+EPYGcgkwpvLebPIjD/Gcyc9aldSjDqvY=;
        b=cQKYNwmGmEOHhdd7/EBPa9wZSnJ+sotLLui60GBXFdF3+jyZib5mDLwrE9Jogoqluhv0rB
        m1CPckFeYvjDvwsNuzaLyrQ1cmbEDI6iPZWH/7iVqZPHLElLY7m0l++ejC1pWRA+YvqqFU
        M6cvD1Xk/0lBLZN6unfWjmb7VHrmqwI=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v7:
  - Fix a compilation problem in patch 1 & a memory allocation bug in
    patch 2.
  - Change exclusive_cpus type to cpumask_var_t to match other cpumasks
    and make code more consistent.

 v6:
  - https://lore.kernel.org/lkml/20230713172601.3285847-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
  - Add another read-only cpuset.cpus.exclusive.effective control file
    to expose the effective set of exclusive CPUs.
  - Update the documentation and test accordingly.

 v5:
  - https://lore.kernel.org/lkml/20230713172601.3285847-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
  - Drop the first 4 patches as they had been merged.
  - Make cpuset.cpus.exclusive invariant once it is manually set. This
    also means the cpuset.cpus.exclusive may not show the effective value
    that is actually being used.
  - Update the documentation and test accordingly.


This patch series introduces new cpuset control
files "cpuset.cpus.exclusive" (read-write) and
"cpuset.cpus.exclusive.effective" (read only) for better control of
which exclusive CPUs are being distributed down the cgroup hierarchy
for creating cpuset partition.

Any one of the exclusive CPUs can only be distributed to at most one
child cpuset. Invalid input to "cpuset.cpus.exclusive" that violates the
sibling exclusivity rule will be rejected. This new control files has
no effect on the behavior of the cpuset until it turns into a partition
root. At that point, its effective CPUs will be set to its exclusive
CPUs unless some of them are offline.

This patch series also introduces a new category of cpuset partition
called remote partitions. The existing partition category where the
partition roots have to be clustered around the root cgroup in a
hierarchical way is now referred to as local partitions.

A remote partition can be formed far from the root cgroup with no
partition root parent. While local partitions can be created without
touching "cpuset.cpus.exclusive" as it can be set automatically
if a cpuset becomes a local partition root. Properly setting
"cpuset.cpus.exclusive" values down the hierarchy are required to create
a remote partition.

Both scheduling and isolated partitions can be formed as a remote
partition. A local partition can be created under a remote partition.
A remote partition, however, cannot be formed under a local partition
for now.

Modern container orchestration tools like Kubernetes use the cgroup
hierarchy to manage different containers. And it is relying on other
middleware like systemd to help managing it. If a container needs to
use isolated CPUs, it is hard to get those with the local partitions
as it will require the administrative parent cgroup to be a partition
root too which tool like systemd may not be ready to manage.

With this patch series, we allow the creation of remote partition
far from the root. The container management tool can manage the
"cpuset.cpus.exclusive" file without impacting the other cpuset
files that are managed by other middlewares. Of course, invalid
"cpuset.cpus.exclusive" values will be rejected.

Waiman Long (6):
  cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2
  cgroup/cpuset: Add cpuset.cpus.exclusive for v2
  cgroup/cpuset: Introduce remote partition
  cgroup/cpuset: Check partition conflict with housekeeping setup
  cgroup/cpuset: Documentation update for partition
  cgroup/cpuset: Extend test_cpuset_prs.sh to test remote partition

 Documentation/admin-guide/cgroup-v2.rst       |  123 +-
 kernel/cgroup/cpuset.c                        | 1253 ++++++++++++-----
 .../selftests/cgroup/test_cpuset_prs.sh       |  431 ++++--
 3 files changed, 1317 insertions(+), 490 deletions(-)

-- 
2.31.1

