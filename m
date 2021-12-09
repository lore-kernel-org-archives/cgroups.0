From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v9 0/7] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Thu, 9 Dec 2021 10:39:55 -0500
Message-ID: <f74efd4a-eee8-3927-f975-92b4c457cb9c@redhat.com>
References: <20211205183220.818872-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639064404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QT9+Eto76AQyhw6YgaOC53MIX23XQDyrz/FUT+QNKSA=;
        b=dYjylCBIokIyQKxgJ1aSna9N1EbyiHGqWDSQHiIv2r+S3ugqP70v3LYBWJh0+D8FqJ/ln/
        b0RI2zTGOiDY7Z//JWGZduwFgDaF8C0DvtvPqVkSrl1Zh9IGp8nAXWu4RDvqICPaJ0Ohd5
        zAgP906+XSGnxNUc4OUq8u0RdmipaEk=
Content-Language: en-US
In-Reply-To: <20211205183220.818872-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 12/5/21 13:32, Waiman Long wrote:
> v9:
>   - Add a new patch 1 to remove the child cpuset restriction on parent's
>     "cpuset.cpus".
>   - Relax initial root partition entry limitation to allow cpuset.cpus to
>     overlap that of parent's.
>   - An "isolated invalid" displayed type is added to
>     cpuset.cpus.partition.
>   - Resetting partition root to "member" will leave child partition root
>     as invalid.
>   - Update documentation and test accordingly.
>
> v8:
>   - Reorganize the patch series and rationalize the features and
>     constraints of a partition.
>   - Update patch descriptions and documentation accordingly.
>
> v7:
>   - Simplify the documentation patch (patch 5) as suggested by Tejun.
>   - Fix a typo in patch 2 and improper commit log in patch 3.
>
> This patchset includes one bug fix and four enhancements to the cpuset v2 code.
>
>   Patch 1: Allow parent to set "cpuset.cpus" that may not be a superset
>   of children's "cpuset.cpus" for default hierarchy.
>
>   Patch 2: Enable partition with no task to have empty cpuset.cpus.effective.
>
>   Patch 3: Refining the features and constraints of a cpuset partition
>   clarifying what changes are allowed.
>
>   Patch 4: Add a new partition state "isolated" to create a partition
>   root without load balancing. This is for handling intermitten workloads
>   that have a strict low latency requirement.
>
>   Patch 5: Enable the "cpuset.cpus.partition" file to show the reason
>   that causes invalid partition like "root invalid (No cpu available
>   due to hotplug)".
>
> Patch 6 updates the cgroup-v2.rst file accordingly. Patch 7 adds a new
> cpuset test to test the new cpuset partition code.
>
> Waiman Long (7):
>    cgroup/cpuset: Don't let child cpusets restrict parent in default
>      hierarchy
>    cgroup/cpuset: Allow no-task partition to have empty
>      cpuset.cpus.effective
>    cgroup/cpuset: Refining features and constraints of a partition
>    cgroup/cpuset: Add a new isolated cpus.partition type
>    cgroup/cpuset: Show invalid partition reason string
>    cgroup/cpuset: Update description of cpuset.cpus.partition in
>      cgroup-v2.rst
>    kselftest/cgroup: Add cpuset v2 partition root state test
>
>   Documentation/admin-guide/cgroup-v2.rst       | 168 +++--
>   kernel/cgroup/cpuset.c                        | 440 +++++++-----
>   tools/testing/selftests/cgroup/Makefile       |   5 +-
>   .../selftests/cgroup/test_cpuset_prs.sh       | 667 ++++++++++++++++++
>   tools/testing/selftests/cgroup/wait_inotify.c |  87 +++
>   5 files changed, 1142 insertions(+), 225 deletions(-)
>   create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh
>   create mode 100644 tools/testing/selftests/cgroup/wait_inotify.c
>
Hi,

Is this patch series good enough or is there other changes you would 
still like to make in this series?

Cheers,
Longman

