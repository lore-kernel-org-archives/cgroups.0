From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] hugetlb_cgroup: fix offline of hugetlb cgroup with reservations
Date: Thu, 3 Dec 2020 14:11:49 -0800
Message-ID: <CALvZod44ZLA8U=ormvuKZhJ1vCJf8qOHMRSouih4E-oaLihV=Q@mail.gmail.com>
References: <20201203220242.158165-1-mike.kravetz@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QF1ANqOQBqZLcWlpFbE2WrA4M94QqjKls+F32sntMMY=;
        b=T1kC1Kg7NGIo6tMwYyuuSIkbUM2VuNQz7qLiEEJZtDFibEewJn1anNB9g2y80hPxkX
         iuvhJivzZgd6XEn3oUb3bwhkxuLp8C0ke4zyslQ0f29RT2lbodQCYp6n1erOyIs4LoZy
         EUqgqNTRaA9IbgSoFHG/SrrM2zc5q8yCV93/QpCAmfQCi2kdb6q8EmgwRQYRFCvDvS8t
         Bg2+nLT7Gmk2KOP7TRTnEDvSGvD7h+4Nk1weYi2DWGEOEuqKcxzWnMnngV0S8DBlk/Kk
         ToaYG83BoQojs0cXLtz/RJ3CPGKDOIbfzrgK58ch/RGfQUP/Kdm39CIG8jJOESnFVjs8
         0gIg==
In-Reply-To: <20201203220242.158165-1-mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sandipan Das <sandipan-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Adrian Moreno <amorenoz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Dec 3, 2020 at 2:04 PM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> Adrian Moreno was ruuning a kubernetes 1.19 + containerd/docker workload
> using hugetlbfs.  In this environment the issue is reproduced by:
> 1 - Start a simple pod that uses the recently added HugePages medium
>     feature (pod yaml attached)
> 2 - Start a DPDK app. It doesn't need to run successfully (as in transfer
>     packets) nor interact with real hardware. It seems just initializing
>     the EAL layer (which handles hugepage reservation and locking) is
>     enough to trigger the issue
> 3 - Delete the Pod (or let it "Complete").
>
> This would result in a kworker thread going into a tight loop (top output):
>  1425 root      20   0       0      0      0 R  99.7   0.0   5:22.45
> kworker/28:7+cgroup_destroy
>
> 'perf top -g' reports:
> -   63.28%     0.01%  [kernel]                    [k] worker_thread
>    - 49.97% worker_thread
>       - 52.64% process_one_work
>          - 62.08% css_killed_work_fn
>             - hugetlb_cgroup_css_offline
>                  41.52% _raw_spin_lock
>                - 2.82% _cond_resched
>                     rcu_all_qs
>                  2.66% PageHuge
>       - 0.57% schedule
>          - 0.57% __schedule
>
> We are spinning in the do-while loop in hugetlb_cgroup_css_offline.
> Worse yet, we are holding the master cgroup lock (cgroup_mutex) while
> infinitely spinning.  Little else can be done on the system as the
> cgroup_mutex can not be acquired.
>
> Do note that the issue can be reproduced by simply offlining a hugetlb
> cgroup containing pages with reservation counts.
>
> The loop in hugetlb_cgroup_css_offline is moving page counts from the
> cgroup being offlined to the parent cgroup.  This is done for each hstate,
> and is repeated until hugetlb_cgroup_have_usage returns false.  The routine
> moving counts (hugetlb_cgroup_move_parent) is only moving 'usage' counts.
> The routine hugetlb_cgroup_have_usage is checking for both 'usage' and
> 'reservation' counts.  Discussion about what to do with reservation
> counts when reparenting was discussed here:
>
> https://lore.kernel.org/linux-kselftest/CAHS8izMFAYTgxym-Hzb_JmkTK1N_S9tGN71uS6MFV+R7swYu5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
>
> The decision was made to leave a zombie cgroup for with reservation
> counts.  Unfortunately, the code checking reservation counts was
> incorrectly added to hugetlb_cgroup_have_usage.
>
> To fix the issue, simply remove the check for reservation counts.  While
> fixing this issue, a related bug in hugetlb_cgroup_css_offline was noticed.
> The hstate index is not reinitialized each time through the do-while loop.
> Fix this as well.
>
> Fixes: 1adc4d419aa2 ("hugetlb_cgroup: add interface for charge/uncharge hugetlb reservations")
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Reported-by: Adrian Moreno <amorenoz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Tested-by: Adrian Moreno <amorenoz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
