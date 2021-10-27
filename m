From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Wed, 27 Oct 2021 19:05:36 -0400
Message-ID: <55402d20-c23e-bb56-6a7a-6e208c08280a@redhat.com>
References: <20211018143619.205065-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635375947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fSEXEHxW0XKJ3A0RuRyJ3sw6tXP96RKh+PO7m5ry7Bs=;
        b=G7NbejCAj3WseCpqOgnYXVVk1jjMOXl/6UZYwKbrM4CqJklU1oyDpCQOnPc8+GrU2FLMTq
        Zggumjyv8XN00fZOOsZsv3+Ew/wc301Injz1EVe7YSjGzn4Gylwo8dnb1lvWvnNkItIeOv
        S7ltcEogvj8dLY4Hi8cRjqkR7tTrz74=
In-Reply-To: <20211018143619.205065-1-longman@redhat.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 10/18/21 10:36 AM, Waiman Long wrote:
> v8:
>   - Reorganize the patch series and rationalize the features and
>     constraints of a partition.
>   - Update patch descriptions and documentation accordingly.
>
> v7:
>   - Simplify the documentation patch (patch 5) as suggested by Tejun.
>   - Fix a typo in patch 2 and improper commit log in patch 3.
>
> v6:
>   - Remove duplicated tmpmask from update_prstate() which should fix the
>     frame size too large problem reported by kernel test robot.
>
> This patchset makes four enhancements to the cpuset v2 code.
>
>   Patch 1: Enable partition with no task to have empty cpuset.cpus.effective.
>
>   Patch 2: Refining the features and constraints of a cpuset partition
>   clarifying what changes are allowed.
>
>   Patch 3: Add a new partition state "isolated" to create a partition
>   root without load balancing. This is for handling intermitten workloads
>   that have a strict low latency requirement.
>
>   Patch 4: Enable the "cpuset.cpus.partition" file to show the reason
>   that causes invalid partition like "root invalid (No cpu available
>   due to hotplug)".
>
> Patch 5 updates the cgroup-v2.rst file accordingly. Patch 6 adds a new
> cpuset test to test the new cpuset partition code.
>
> Waiman Long (6):
>    cgroup/cpuset: Allow no-task partition to have empty
>      cpuset.cpus.effective
>    cgroup/cpuset: Refining features and constraints of a partition
>    cgroup/cpuset: Add a new isolated cpus.partition type
>    cgroup/cpuset: Show invalid partition reason string
>    cgroup/cpuset: Update description of cpuset.cpus.partition in
>      cgroup-v2.rst
>    kselftest/cgroup: Add cpuset v2 partition root state test
>
>   Documentation/admin-guide/cgroup-v2.rst       | 153 ++--
>   kernel/cgroup/cpuset.c                        | 393 +++++++----
>   tools/testing/selftests/cgroup/Makefile       |   5 +-
>   .../selftests/cgroup/test_cpuset_prs.sh       | 664 ++++++++++++++++++
>   tools/testing/selftests/cgroup/wait_inotify.c |  87 +++
>   5 files changed, 1115 insertions(+), 187 deletions(-)
>   create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh
>   create mode 100644 tools/testing/selftests/cgroup/wait_inotify.c

Any feedback on this patch series?

Thanks,
Longman

