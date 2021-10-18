From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type & empty effecitve cpus
Date: Mon, 18 Oct 2021 10:36:13 -0400
Message-ID: <20211018143619.205065-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634567828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ng7Ch+ziTcXFMqpWwHpxE3VZVmB5z0SGbNUXf+BTCIE=;
        b=aqusNoshNtQkoQ9udO8nZrfeb1VTQEoMF/E9i8WM0kyAXR/lkUwgmZZN2Lg7Rerlc9KW24
        6ia3Vs8d8M9d/4rYxO+meqMsspZKxVtciEo+9yzq+GLKwEP1Uv+UNyQm/vpPCJeOGK9GkC
        0f3YGrp0TYul4HgechSkZVL+268cs1Y=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

v8:
 - Reorganize the patch series and rationalize the features and
   constraints of a partition.
 - Update patch descriptions and documentation accordingly.

v7:
 - Simplify the documentation patch (patch 5) as suggested by Tejun.
 - Fix a typo in patch 2 and improper commit log in patch 3.

v6:
 - Remove duplicated tmpmask from update_prstate() which should fix the
   frame size too large problem reported by kernel test robot.

This patchset makes four enhancements to the cpuset v2 code.

 Patch 1: Enable partition with no task to have empty cpuset.cpus.effective.

 Patch 2: Refining the features and constraints of a cpuset partition
 clarifying what changes are allowed.

 Patch 3: Add a new partition state "isolated" to create a partition
 root without load balancing. This is for handling intermitten workloads
 that have a strict low latency requirement.

 Patch 4: Enable the "cpuset.cpus.partition" file to show the reason
 that causes invalid partition like "root invalid (No cpu available
 due to hotplug)".

Patch 5 updates the cgroup-v2.rst file accordingly. Patch 6 adds a new
cpuset test to test the new cpuset partition code.

Waiman Long (6):
  cgroup/cpuset: Allow no-task partition to have empty
    cpuset.cpus.effective
  cgroup/cpuset: Refining features and constraints of a partition
  cgroup/cpuset: Add a new isolated cpus.partition type
  cgroup/cpuset: Show invalid partition reason string
  cgroup/cpuset: Update description of cpuset.cpus.partition in
    cgroup-v2.rst
  kselftest/cgroup: Add cpuset v2 partition root state test

 Documentation/admin-guide/cgroup-v2.rst       | 153 ++--
 kernel/cgroup/cpuset.c                        | 393 +++++++----
 tools/testing/selftests/cgroup/Makefile       |   5 +-
 .../selftests/cgroup/test_cpuset_prs.sh       | 664 ++++++++++++++++++
 tools/testing/selftests/cgroup/wait_inotify.c |  87 +++
 5 files changed, 1115 insertions(+), 187 deletions(-)
 create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh
 create mode 100644 tools/testing/selftests/cgroup/wait_inotify.c

-- 
2.27.0

