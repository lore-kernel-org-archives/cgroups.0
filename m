From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/6] cgroup/cpuset: Add new cpuset partition type & empty effecitve cpus
Date: Mon, 21 Jun 2021 14:49:18 -0400
Message-ID: <20210621184924.27493-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624301389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=8+0lAgdKmEikh/Be8Z1O35k9BkrQgmcKMiwbRtHdQCs=;
        b=dVQdNttU3tKfzfWTvtrWrw+oQBINFyk3UXurvyJv3qP7wAJn2VyH2p+i8nhJOk35qvZKe6
        8sAz2Eqm4QHqx3AR4ScMnlyEO/NT8Tegjy7tWvo8K44zaQcH7q9yFx6Z1zI7aQQr35i6s9
        9xN5aVlP6mAQhSM2TQeGIB7VDuU4mKI=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

v2:
 - Drop v1 patch 1.
 - Break out some cosmetic changes into a separate patch (patch #1).
 - Add a new patch to clarify the transition to invalid partition root
   is mainly caused by hotplug events.
 - Enhance the partition root state test including CPU online/offline
   behavior and fix issues found by the test.

This patchset makes the following three major changes to the cpuset v2 code:

 Patch 2: Clarify the use of invalid partition root and add new checks
 to make sure that normal cpuset control file operations will not be
 allowed to create invalid partition root. It also fixes some of the
 issues in existing code.

 Patch 3: Add a new partition state "isolated" to create a partition
 root without load balancing. This is for handling intermitten workloads
 that have a strict low latency requirement.

 Patch 4: Allow partition roots that are not the top cpuset to distribute
 all its cpus to child partitions as long as there is no task associated
 with that partition root. This allows more flexibility for middleware
 to manage multiple partitions.

Patch 5 updates the cgroup-v2.rst file accordingly. Patch 5 adds a new
cpuset test to test the new cpuset partition code.


Waiman Long (6):
  cgroup/cpuset: Miscellaneous code cleanup
  cgroup/cpuset: Clarify the use of invalid partition root
  cgroup/cpuset: Add a new isolated cpus.partition type
  cgroup/cpuset: Allow non-top parent partition root to distribute out
    all CPUs
  cgroup/cpuset: Update description of cpuset.cpus.partition in
    cgroup-v2.rst
  kselftest/cgroup: Add cpuset v2 partition root state test

 Documentation/admin-guide/cgroup-v2.rst       |  65 +-
 kernel/cgroup/cpuset.c                        | 285 ++++++---
 tools/testing/selftests/cgroup/Makefile       |   2 +-
 .../selftests/cgroup/test_cpuset_prs.sh       | 558 ++++++++++++++++++
 4 files changed, 794 insertions(+), 116 deletions(-)
 create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh

-- 
2.18.1

