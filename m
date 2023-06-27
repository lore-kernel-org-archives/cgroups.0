From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/9] cgroup/cpuset: Support remote partitions
Date: Mon, 26 Jun 2023 20:55:20 -0400
Message-ID: <20230627005529.1564984-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687827362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rbG/y9GPhxZI54iVshXHiIlQQfxiaFT7O670ezrv8YA=;
        b=O0ZKk+UuuAv7mCtHLa9/K4ZVuo8jYjB18MmPI/F5IbxSxnEurVF76/6xYDx465ZrmxMG/8
        z31+QBEwdfFdISAgI9FFjbNHsIvAfovTzdF93xuLwi0KW3XX4IT7XVHVwpSuJ53AUaQlAz
        C5B6mstFwIsHOxLzMHKaXWSe9Puv5wI=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mrunal Patel <mpatel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ryan Phillips <rphillips-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brent Rowsell <browsell-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Hunt <pehunt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v3:
  - [v2] https://lore.kernel.org/lkml/20230531163405.2200292-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
  - Change the new control file from root-only "cpuset.cpus.reserve" to
    non-root "cpuset.cpus.exclusive" which lists the set of exclusive
    CPUs distributed down the hierarchy.
  - Add a patch to restrict boot-time isolated CPUs to isolated
    partitions only.
  - Update the test_cpuset_prs.sh test script and documentation
    accordingly.

 v2:
  - [v1] https://lore.kernel.org/lkml/20230412153758.3088111-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
  - Dropped the special "isolcpus" partition in v1
  - Add the root only "cpuset.cpus.reserve" control file for reserving
    CPUs used for remote isolated partitions.
  - Update the test_cpuset_prs.sh test script and documentation
    accordingly.

This patch series introduces a new cpuset control file
"cpuset.cpus.exclusive" which must be a subset of "cpuset.cpus"
and the parent's "cpuset.cpus.exclusive". This control file lists
the exclusive CPUs to be distributed down the hierarchy. Any one
of the exclusive CPUs can only be distributed to at most one child
cpuset. Unlike "cpuset.cpus", invalid input to "cpuset.cpus.exclusive"
will be rejected with an error. This new control file has no effect on
the behavior of the cpuset until it turns into a partition root. At that
point, its effective CPUs will be set to its exclusive CPUs unless some
of them are offline.

This patch series also introduces a new category of cpuset partition
called remote partitions. The existing partition category where the
partition roots have to be clustered around the root cgroup in a
hierarchical way is now referred to as local partitions.

A remote partition can be formed far from the root cgroup
with no partition root parent. While local partitions can be
created without touching "cpuset.cpus.exclusive" as it can be set
automatically if a cpuset becomes a local partition root. Properly set
"cpuset.cpus.exclusive" values down the hierarchy are required to create
a remote partition.

Both scheduling and isolated partitions can be formed in a remote
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
"cpuset.cpus.exclusive" values will be rejected and changes to
"cpuset.cpus" can affect the value of "cpuset.cpus.exclusive" due to
the requirement that it has to be a subset of the former control file.

Waiman Long (9):
  cgroup/cpuset: Inherit parent's load balance state in v2
  cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE
    handling
  cgroup/cpuset: Improve temporary cpumasks handling
  cgroup/cpuset: Allow suppression of sched domain rebuild in
    update_cpumasks_hier()
  cgroup/cpuset: Add cpuset.cpus.exclusive for v2
  cgroup/cpuset: Introduce remote partition
  cgroup/cpuset: Check partition conflict with housekeeping setup
  cgroup/cpuset: Documentation update for partition
  cgroup/cpuset: Extend test_cpuset_prs.sh to test remote partition

 Documentation/admin-guide/cgroup-v2.rst       |  100 +-
 kernel/cgroup/cpuset.c                        | 1352 ++++++++++++-----
 .../selftests/cgroup/test_cpuset_prs.sh       |  398 +++--
 3 files changed, 1297 insertions(+), 553 deletions(-)

-- 
2.31.1

