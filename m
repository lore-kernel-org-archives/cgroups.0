From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 cgroup/for-4.4 3/3] cgroup: replace
 unified-hierarchy.txt with a proper cgroup v2 documentation
Date: Mon, 26 Oct 2015 10:54:26 +0800
Message-ID: <562D95E2.2000401@huawei.com>
References: <20151022012212.GA20931@mtj.duckdns.org>
 <20151022012302.GB20931@mtj.duckdns.org>
 <20151022012354.GC20931@mtj.duckdns.org>
 <20151023011902.GC5442@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151023011902.GC5442-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

On 2015/10/23 9:19, Tejun Heo wrote:
>>From 10d158783de74ad28454ff54556abf89bd85c756 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Date: Fri, 23 Oct 2015 10:13:35 +0900
>
> Now that cgroup v2 is almost out of the door, replace the development
> documentation unified-hierarchy.txt with Documentation/cgroup.txt
> which is a superset of unified-hierarchy.txt and authoritatively
> describes all userland-visible aspects of cgroup.
>
> v2: Updated to include all information from blkio-controller.txt and
>      list filesystems which support cgroup writeback as suggested by
>      Vivek.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   Documentation/cgroup-legacy/blkio-controller.txt  |   79 --
>   Documentation/cgroup-legacy/unified-hierarchy.txt |  645 ----------
>   Documentation/cgroup.txt                          | 1293 +++++++++++++++++++++
>   3 files changed, 1293 insertions(+), 724 deletions(-)
>   delete mode 100644 Documentation/cgroup-legacy/unified-hierarchy.txt
>   create mode 100644 Documentation/cgroup.txt
>

Looks good to me. For all three patches:

Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
