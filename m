From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-cgroup v6 0/6] cgroup/cpuset: Add new cpuset partition type & empty effecitve cpus
Date: Sat, 14 Aug 2021 16:57:37 -0400
Message-ID: <20210814205743.3039-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628974749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=hgsxk/ndi9Bc7L/y8Om3JGSTHXU/MJwZP0HoGDhLIw4=;
        b=YVMyuUKdy0p6hj4RaXMEjm7S3uV+htT6bNtcYUR02i8XusQlOWjRY7gimTZrDKaMG5NIXm
        9D4R3VIJmZs3b2Eipl+5vgQLeDeAjGlU17MSNQBQvPPL0bGxtKbHcNXGO0S2/VZ/cjD09q
        0OhxWDCiBnoiuQUkVJETwDU0+16bBnY=
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

v6:
 - Remove duplicated tmpmask from update_prstate() which should fix the
   frame size too large problem reported by kernel test robot.

v5:
 - Rebased to the latest for-5.15 branch of cgroup git tree and drop the
   1st v4 patch as it has been merged.
 - Update patch 1 to always allow changing partition root back to member
   even if it invalidates child partitions undeneath it.
 - Adjust the empty effective cpu partition patch to not allow 0 effective
   cpu for terminal partition which will make it invalid).
 - Add a new patch to enable reading of cpuset.cpus.partition to display
   the reason that causes invalid partition.
 - Adjust the documentation and testing patch accordingly.

v4:
 - Rebased to the for-5.15 branch of cgroup git tree and dropped the
   first 3 patches of v3 series which have been merged.
 - Beside prohibiting violation of cpu exclusivity rule, allow arbitrary
   changes to cpuset.cpus of a partition root and force the partition root
   to become invalid in case any of the partition root constraints
   are violated. The documentation file and self test are modified
   accordingly.

This patchset makes four enhancements to the cpuset v2 code.

 Patch 1: Properly handle partition root tree and make partition
 invalid in case changes to cpuset.cpus violate any of the partition
 root constraints.

 Patch 2: Enable the "cpuset.cpus.partition" file to show the reason
 that causes invalid partition like "root invalid (No cpu available
 due to hotplug)".

 Patch 3: Add a new partition state "isolated" to create a partition
 root without load balancing. This is for handling intermitten workloads
 that have a strict low latency requirement.

 Patch 4: Allow partition roots that are not the top cpuset to distribute
 all its cpus to child partitions as long as there is no task associated
 with that partition root. This allows more flexibility for middleware
 to manage multiple partitions.

Patch 5 updates the cgroup-v2.rst file accordingly. Patch 6 adds a new
cpuset test to test the new cpuset partition code.

Waiman Long (6):
  cgroup/cpuset: Properly transition to invalid partition
  cgroup/cpuset: Show invalid partition reason string
  cgroup/cpuset: Add a new isolated cpus.partition type
  cgroup/cpuset: Allow non-top parent partition to distribute out all
    CPUs
  cgroup/cpuset: Update description of cpuset.cpus.partition in
    cgroup-v2.rst
  kselftest/cgroup: Add cpuset v2 partition root state test

 Documentation/admin-guide/cgroup-v2.rst       | 116 +--
 kernel/cgroup/cpuset.c                        | 337 ++++++---
 tools/testing/selftests/cgroup/Makefile       |   5 +-
 .../selftests/cgroup/test_cpuset_prs.sh       | 663 ++++++++++++++++++
 tools/testing/selftests/cgroup/wait_inotify.c |  86 +++
 5 files changed, 1058 insertions(+), 149 deletions(-)
 create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh
 create mode 100644 tools/testing/selftests/cgroup/wait_inotify.c

-- 
2.18.1

