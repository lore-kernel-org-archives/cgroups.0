From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] kselftest/cgroup: Add cleanup() to test_cpuset_prs.sh
Date: Fri, 18 Nov 2022 15:22:40 -0500
Message-ID: <5c92d811-63d4-2c92-3018-7ba8d9c4f21a@redhat.com>
References: <20221118101330.251332-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668802970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLNx2lv/9wKRUvF6SaKybhGa6+X/Ftk2qDUqbH/DPVM=;
        b=iXY0Uxjz5AQ9oAosc88+rrELyPfxgfrjWmJrOXWD9TxFLHkbdsdZqaFTju+ZxNpVmhP5jp
        douZMXqiDKRrlbYsPT+40i1rk3XbTODbd6bNpRwxw76eSe/cjFAsQ+BslghbdiHFOjN4+6
        e6c/shEWl1SrTfbDjv5vC06OkPVtH0w=
Content-Language: en-US
In-Reply-To: <20221118101330.251332-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/18/22 05:13, Kamalesh Babulal wrote:
> Install a cleanup function using the trap command for signals EXIT,
> SIGINT, SIGQUIT and SIGABRT.  The cleanup function will perform:
> 1. Online the CPUs that were made offline during the test.
> 2. Removing the cgroups created.
> 3. Restoring the original /sys/kernel/debug/sched/verbose value,
>     currently it's left turned on, irrespective of the original
>     configuration value.
>
> the test performs steps 1 and 2, on the successful runs, but not during
> all of the failed runs.  With the cleanup(), the system will perform all
> three steps during failed/passed test runs.
>
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>   .../testing/selftests/cgroup/test_cpuset_prs.sh | 17 ++++++++++++++++-
>   1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> index 526d2c42d870..b8ed82b55b1d 100755
> --- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> +++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
> @@ -16,7 +16,12 @@ skip_test() {
>   [[ $(id -u) -eq 0 ]] || skip_test "Test must be run as root!"
>   
>   # Set sched verbose flag, if available
> -[[ -d /sys/kernel/debug/sched ]] && echo Y > /sys/kernel/debug/sched/verbose
> +if [[ -d /sys/kernel/debug/sched ]]
> +then
> +	# Used to restore the original setting during cleanup
> +	SCHED_DEBUG=$(cat /sys/kernel/debug/sched/verbose)
> +	echo Y > /sys/kernel/debug/sched/verbose
> +fi
>   
>   # Get wait_inotify location
>   WAIT_INOTIFY=$(cd $(dirname $0); pwd)/wait_inotify
> @@ -54,6 +59,15 @@ echo +cpuset > cgroup.subtree_control
>   [[ -d test ]] || mkdir test
>   cd test
>   
> +cleanup()
> +{
> +	online_cpus
> +	rmdir A1/A2/A3 A1/A2 A1 B1 > /dev/null 2>&1
> +	cd ..
> +	rmdir test > /dev/null 2>&1
> +	echo "$SCHED_DEBUG" > /sys/kernel/debug/sched/verbose
> +}
> +
>   # Pause in ms
>   pause()
>   {
> @@ -666,6 +680,7 @@ test_inotify()
>   	fi
>   }
>   
> +trap cleanup 0 2 3 6
>   run_state_test TEST_MATRIX
>   test_isolated
>   test_inotify

That looks good to me. Thanks for the improvement.

Acked-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

