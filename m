From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/4] cgroup/cpuset: Miscellaneous updates
Date: Fri, 17 Mar 2023 11:15:04 -0400
Message-ID: <20230317151508.1225282-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679066134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=q7V46Q52rkSh11P7uwpvJlomEOhaWhBzxdnEpXedVNs=;
        b=Su31C9U72/eD+9VorbmgT/gTe7VAKh2SprqW8q7KOSZEpkIvBvddj4BtDLTF8zwHHfPgz8
        x8cUAXCO95VaWGHRfj0mTxszHZ0nyLwlZNyD6KgkSsY+se/ZralYSu8yoN74atiu0++ntf
        UQ19bAkdEErXZmzrhQtv9LqQUtE/+Ak=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v2:
  - Add a new patch 1 that fixes a bug introduced by recent v6.2 commit
    7a2127e66a00 ("cpuset: Call set_cpus_allowed_ptr() with appropriate
    mask for task").
  - Make a small twist and additional comment to patch 2 ("cgroup/cpuset:
    Skip task update if hotplug doesn't affect current cpuset") as
    suggested by Michal.
  - Remove v1 patches 3/4 for now for further discussion.

This patch series includes miscellaneous update to the cpuset and its
testing code.

Patch 1 fixes a bug caused by commit 7a2127e66a00 ("cpuset: Call
set_cpus_allowed_ptr() with appropriate mask for task") in the partition
handling code. This fix was verified by running the test_cpuset_prs.sh
test.

Patch 2 is for a hotplug optimization.

Patch 3 is actually a follow-up of commit 3fb906e7fabb ("cgroup/cpuset:
Don't filter offline CPUs in cpuset_cpus_allowed() for top cpuset tasks").

Patch 4 reduces verbosity when running test_cpuset_prs.sh test script
unless explicitly enabled with the -v option.

Waiman Long (4):
  cgroup/cpuset: Fix partition root's cpuset.cpus update bug
  cgroup/cpuset: Skip task update if hotplug doesn't affect current
    cpuset
  cgroup/cpuset: Include offline CPUs when tasks' cpumasks in top_cpuset
    are updated
  cgroup/cpuset: Minor updates to test_cpuset_prs.sh

 kernel/cgroup/cpuset.c                        | 38 +++++++++++++------
 .../selftests/cgroup/test_cpuset_prs.sh       | 25 ++++++------
 2 files changed, 41 insertions(+), 22 deletions(-)

-- 
2.31.1

