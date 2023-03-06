From: Waiman Long <longman@redhat.com>
Subject: [PATCH 0/5] cgroup/cpuset: Miscellaneous updates
Date: Mon,  6 Mar 2023 15:08:44 -0500
Message-ID: <20230306200849.376804-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678133370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TktQ7QJRxbBjz+L1F60GxDGA9dvv+g9tZaNVQ0g9JWA=;
        b=VqrvHAkQcfJTzGmXrEyX7QYKQeW/VGUYaIPWtD/+3uTkIrXjNwSK8IsVY71C99T/bvQ+bb
        y8g1k7Wo5qZF84TYXwilNf/v0DajUaSBJVdXKIgqGkUNkhlX4b00capGXkJiTy576pvL1w
        5n1SIhYYP6yVOCV3mCjy4H/rK0ztj5A=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Waiman Long <longman@redhat.com>

This patch series includes miscellaneous update to the cpuset and its
testing code.

Patch 2 is actually a follow-up of commit 3fb906e7fabb ("cgroup/cpuset:
Don't filter offline CPUs in cpuset_cpus_allowed() for top cpuset tasks").

Patches 3-4 are for handling corner cases when dealing with
task_cpu_possible_mask().

Waiman Long (5):
  cgroup/cpuset: Skip task update if hotplug doesn't affect current
    cpuset
  cgroup/cpuset: Include offline CPUs when tasks' cpumasks in top_cpuset
    are updated
  cgroup/cpuset: Find another usable CPU if none found in current cpuset
  cgroup/cpuset: Add CONFIG_DEBUG_CPUSETS config for cpuset testing
  cgroup/cpuset: Minor updates to test_cpuset_prs.sh

 init/Kconfig                                  |   5 +
 kernel/cgroup/cpuset.c                        | 155 +++++++++++++++++-
 .../selftests/cgroup/test_cpuset_prs.sh       |  25 +--
 3 files changed, 165 insertions(+), 20 deletions(-)

-- 
2.31.1

