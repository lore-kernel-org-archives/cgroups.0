From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched/core: Fix cpu controller for !RT_GROUP_SCHED
Date: Wed, 5 Jun 2019 06:34:42 -0700
Message-ID: <20190605133442.GJ374014@devbig004.ftw2.facebook.com>
References: <20190605114935.7683-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=grBBM9ViaanFgHPLnFrQHKU04qolbq9KsWYNsIIwRqA=;
        b=u107NaP8nG876tIG6Q2fL9N9piNv7X1C8ktfs1g7H/hDLqed+pH6cxVRLLRNznbtm7
         Mcs4Os2HbvpEVPU71DOG2dkTQkQFj1DTVQD1xbFBWjw7WF0h97y/V1UlSvaIuFEftNWK
         dbxnDMpwhY3GY20Mb6DEdwg3rrwqciAvdHqjQnpRY/BolbgE4M1jaiF1ZPvawQvLAFJc
         mcV6vpbo4mCioqlrX32FS6meK6OqhxdlRBo/hp2jYyy/9ZG4eFC4e6hRV5mikW8QsOPd
         e+yXKMeMNN+lIamY359iclpNA/oUtZ93ElA4TD7urYgkhnKxGU0Z8kzqejtn6DHL6ifZ
         Vxsg==
Content-Disposition: inline
In-Reply-To: <20190605114935.7683-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, bristot@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org

Hello,

On Wed, Jun 05, 2019 at 01:49:35PM +0200, Juri Lelli wrote:
> On !CONFIG_RT_GROUP_SCHED configurations it is currently not possible to
> move RT tasks between cgroups to which cpu controller has been attached;
> but it is oddly possible to first move tasks around and then make them
> RT (setschedule to FIFO/RR).
> 
> E.g.:
> 
>   # mkdir /sys/fs/cgroup/cpu,cpuacct/group1
>   # chrt -fp 10 $$
>   # echo $$ > /sys/fs/cgroup/cpu,cpuacct/group1/tasks
>   bash: echo: write error: Invalid argument
>   # chrt -op 0 $$
>   # echo $$ > /sys/fs/cgroup/cpu,cpuacct/group1/tasks
>   # chrt -fp 10 $$
>   # cat /sys/fs/cgroup/cpu,cpuacct/group1/tasks
>   2345
>   2598
>   # chrt -p 2345
>   pid 2345's current scheduling policy: SCHED_FIFO
>   pid 2345's current scheduling priority: 10
> 
> Existing code comes with a comment saying the "we don't support RT-tasks
> being in separate groups". Such comment is however stale and belongs to
> pre-RT_GROUP_SCHED times. Also, it doesn't make much sense for
> !RT_GROUP_ SCHED configurations, since checks related to RT bandwidth
> are not performed at all in these cases.
> 
> Make moving RT tasks between cpu controller groups viable by removing
> special case check for RT (and DEADLINE) tasks.
> 
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
> ---
> Hi,
> 
> Although I'm pretty assertive in the changelog, I actually wonder what
> am I missing here and why (if) current behavior is needed and makes
> sense.
> 
> Any input?

Yeah, RT tasks being transprent to the cpu controller when
!RT_GROUP_SCHED makes sense to me, especially given that the rules
around it are already inconsistent.  Please feel free to add

  Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
