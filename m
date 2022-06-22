From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2] sched: RT bandwidth interface for cgroup unified
 hierarchy
Date: Tue, 21 Jun 2022 19:06:50 -0700
Message-ID: <862ed496-921f-b21e-48e8-123422b33b4a@infradead.org>
References: <20220622015557.7497-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=ORveCGym512RighQmyJ26uQ7Z38tEMS5jxlZdRzFA0Q=; b=Q7LfXcfM66qM2ZE6ZtDOCsVX9e
        kMsBRa3Z3eceP8zsLvQg40WnFWBHhJQ6yxgoxnBy5WZTQVppD/4GxA/Kfu56zw6VZXCHH9MQmhQ75
        TKDpfFYuTRTNtimXzdV4nwHmTDgFecSjLdynmneJsID+G1JByy83Y562K4jUhBO7SYjRymx9J5CTI
        ceRuscfMK9Jvpog2Xi36ira6n1gF1Vdt7LHxe8g8sl/dxW1hk7keL33aNKMbKncWwxNbrjM7Wd8x9
        ZMoBo0HluFzzqPppIgYBOeUotvAICwenA7LXtaFDCTfrpLp1aotWJLXU2aBdzLlI7N7P4JVRBpq+Z
        iSYb03CQ==;
Content-Language: en-US
In-Reply-To: <20220622015557.7497-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 6/21/22 18:55, Chengming Zhou wrote:
> We need to run RT threads in cgroup unified hierarchy, but we can't
> since the default rt_bandwidth.rt_runtime of non-root task_group is 0
> and we haven't interface to update it.
> 
> This patch add RT bandwidth interface "cpu.max.rt" and update the
> documentation accordingly.
> 
> Signed-off-by: Chengming Zhou<zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
> v2:
>   - minor fix for documentation per Randy's review. Thanks.

Documentation changes look good. Thanks.

> ---
>   Documentation/admin-guide/cgroup-v2.rst | 13 +++++++++++
>   kernel/sched/core.c                     | 31 +++++++++++++++++++++++++
>   kernel/sched/rt.c                       |  2 +-
>   kernel/sched/sched.h                    |  1 +
>   4 files changed, 46 insertions(+), 1 deletion(-)
