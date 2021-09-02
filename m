From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v4 0/2] refactor sqthread cpu binding logic
Date: Thu, 2 Sep 2021 18:48:08 +0200
Message-ID: <20210902164808.GA10014@blackbody.suse.cz>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630601290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5eEaSFkJ0xTGS8oHCd13RxHxJQOpWzHq0hlFTFZ0wR8=;
        b=UEmi6BH6oifmPDQfaYWkIOdPlclsQB9mvkVeHKK8mcvH1JNmCTcsF+/1351+tw7LcZDcWO
        BIpz8D70Zk+VI7dtc4PPJKngxTUjoJv22pwwkSqpm/x71TGKszwa9nkStue7OSbNN3G1V6
        Iuzckd4Z/+yHmuULf4AdmFg/ZDVLE1w=
Content-Disposition: inline
In-Reply-To: <20210901124322.164238-1-haoxu@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Xu <haoxu@linux.alibaba.com>
Cc: Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

Hello Hao.

On Wed, Sep 01, 2021 at 08:43:20PM +0800, Hao Xu <haoxu@linux.alibaba.com> wrote:
> This patchset is to enhance sqthread cpu binding logic, we didn't
> consider cgroup setting before. In container environment, theoretically
> sqthread is in its container's task group, it shouldn't occupy cpu out
> of its container.

I see in the discussions that there's struggle to make
set_cpus_allowed_ptr() do what's intended under the given constraints.

IIUC, set_cpus_allowed_ptr() is conventionally used for kernel threads
[1]. But does the sqthread fall into this category? You want to have it
_directly_ associated with a container and its cgroups. It looks to me
more like a userspace thread (from this perspective, not literally). Or
is there a different intention?

It seems to me that reusing the sched_setaffinity() (with all its
checks and race pains/solutions) would be a more universal approach.
(I don't mean calling sched_setaffinity() directly, some parts would
need to be factored separately to this end.) WDYT?


Regards,
Michal

[1] Not only spending their life in kernel but providing some
delocalized kernel service.
