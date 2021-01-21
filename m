From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH V2] tg: add sched wait_count of a task group
Date: Thu, 21 Jan 2021 14:40:41 +0100
Message-ID: <YAmEWbvVoVEGytiU@hirez.programming.kicks-ass.net>
References: <20210121201157.1933-1-wu860403@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZquWffHuPqJrmXTxVmbVj/6yL4VuB/c9dASx5K+bWfQ=; b=mQrXe4gGqmYWQks/wF9TlqCsw+
        SttnRBknxhPu+lMtW7JnVeQmcOx5Gf9kDvcMuFgv0g4TUVDarUVqr0AKV8wuhZSHCoExHNkFWwTuy
        AWYyuJaTLgLoc8Oe50G6hFkqh81P0hZ7/4CUgxzMdWU254v5D9JS9KafI6uiZxtUNSPLVFaecBDSD
        0pZ/UjwqaSiEE3GM1wuA+8EeCbSG2FxtiFbpP7XwsBmAgQdoMQIkOROzh46GOtlVAcX1OTITz1bKd
        NXr5d6pmw/0oCqjSjI6dnQtJfF+ZHoh4aaE5Wyp0EotGxyuyq7q4kdJBWXImXxhQC2+GvHhHOvyYJ
        HN0BAs0A==;
Content-Disposition: inline
In-Reply-To: <20210121201157.1933-1-wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 398776277-9uewiaClKEY@public.gmane.org


Your subject is wrong; this is 100% a sched patch.

On Fri, Jan 22, 2021 at 04:11:57AM +0800, wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Liming Wu <wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Now we can rely on PSI to reflect whether there is contention in
> the task group, but it cannot reflect the details of the contention.
> Through this metric, we can get avg latency of task group contention
>  from the dimension of scheduling.
>    delta(wait_usec)/delta(nr_waits)

Only if all tasks have the same weight. So in general this is useless.

> Also change wait_sum to wait_usec.

Also patches should do 1 thing, also you can't do that, you'll break
everybody that expect the current value.
