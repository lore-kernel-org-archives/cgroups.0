From: Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] cgroup/cpuset: Enable cpuset partition with no load
 balancing
Date: Thu, 10 Jun 2021 10:19:47 -0400
Message-ID: <YMIfg0Aa2HZQPEy+@lorien.usersys.redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623334810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vPeoXcqrS3MIzkBmzsxPXiPd+AVSGxxS032+qPVyFQc=;
        b=T6qdBr3FPLk20HMihxZe2RAAurUjN3YdouD4OHt5s7i1lfUAxBlGQivFhGG47hnZMX4Zer
        OFCWpWLy8SJDw4kkbAgyvdGLS103JyusaOpgfxVYMEO/knyRLfn/UgtHcybC81Sk+1Ijw6
        WW4cl0Ki/moQI7j6GLTXqsqFrY+e94U=
Content-Disposition: inline
In-Reply-To: <20210603212416.25934-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Waiman,

On Thu, Jun 03, 2021 at 05:24:11PM -0400 Waiman Long wrote:
> This patchset makes the following two major changes to the cpuset v2 code:
> 
>  Patch 2: Add a new partition state "root-nolb" to create a partition
>  root with load balancing disabled. This is for handling intermitten
>  workloads that have a strict low latency requirement.
> 
>  Patch 3: Allow partition roots that are not the top cpuset to distribute
>  all its cpus to child partitions as long as there is no task associated
>  with that partition root. This allows more flexibility for middleware
>  to manage multiple partitions.

Thanks!  This looks like it will be a usable replacement for the functionality
lost when SD_LOAD_BALANCE went away.


Cheers,
Phil

> 
> Patch 4 updates the cgroup-v2.rst file accordingly. Patch 5 adds a test
> to test the new cpuset partition code.
> 
> Waiman Long (5):
>   cgroup/cpuset: Don't call validate_change() for some flag changes
>   cgroup/cpuset: Add new cpus.partition type with no load balancing
>   cgroup/cpuset: Allow non-top parent partition root to distribute out
>     all CPUs
>   cgroup/cpuset: Update description of cpuset.cpus.partition in
>     cgroup-v2.rst
>   kselftest/cgroup: Add cpuset v2 partition root state test
> 
>  Documentation/admin-guide/cgroup-v2.rst       |  19 ++-
>  kernel/cgroup/cpuset.c                        | 124 +++++++++++----
>  tools/testing/selftests/cgroup/Makefile       |   2 +-
>  .../selftests/cgroup/test_cpuset_prs.sh       | 141 ++++++++++++++++++
>  4 files changed, 247 insertions(+), 39 deletions(-)
>  create mode 100755 tools/testing/selftests/cgroup/test_cpuset_prs.sh
> 
> -- 
> 2.18.1
> 

-- 

