From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v2 0/2] introduce new attribute "priority" to control group
Date: Mon, 12 Apr 2021 17:13:01 -0400
Message-ID: <YHS33Rsj5xZ+nE3u@slm.duckdns.org>
References: <cover.1618219939.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VhpeC0PCBKcKFiAl7ppRsOOB3Otxo0lk7Zd3T6AZwNM=;
        b=WnYKb70Cx5OQVPFK9OAHJNNPUzeGnDdH/lqQWvldpQLwRF0TeKp7OOcCsqrGn3A2fP
         X7JSCUXEAxdUwX1KHddEf8mdYypYI1Ci6RWcdUntTl6Cw/6sJk8aelTufvyKnaQ7dxCt
         gz+qtss9qhGqnhFc9LIGH1/YjGDU+0FCDIYLc0s88lmJDCRdb8dZ1X8X5jwIkS6s8951
         l9UhZ7hwM04XdHi9oH656UT6gi68AWG1vT4xj9tHMWzi5H1bOEKS7ovUc1ein199JqN8
         fnvCnDLiH4d9OLrWJQQeiWKHVhOW49C0ceMO6WOg1eX7qpsG1s7YVA6ziYsqCv1ijwfB
         gg7w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1618219939.git.yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lihaiwei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linussli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, herberthbli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Tue, Apr 13, 2021 at 12:40:09AM +0800, yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> Last time we introduce the idea of adding prioritized tasks management
> to control group. Sometimes we may assign the same amount of resources
> to multiple cgroups due to the environment restriction, but we still 
> hope there are preference order to handle the tasks in those cgroups,
> the 'prio' attribute may help to do the ranking jobs. 
> 
> The default value of "priority" is set to 0 which means the highest
> priority, and the totally levels of priority is defined by
> CGROUP_PRIORITY_MAX. Each subsystem could register callback to receive the
> priority change notification for their own purposes. 
> 
> In this v2 patch we apply a simple rule to the oom hanlder base on the
> order of priority to demonstrate the intention about adding this attribute.
> When enable the prioritized oom, it will perfer to pick up the victim from the
> memory cgroup with lower priority, and try the best to keep the tasks
> alive in high ranked memcg.

I don't think the discussion in the previous thread led anywhere. Please
consider this series nacked for now.

Thanks.

-- 
tejun
