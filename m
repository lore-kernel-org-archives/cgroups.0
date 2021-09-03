From: Hao Xu <haoxu@linux.alibaba.com>
Subject: Re: [PATCH v4 0/2] refactor sqthread cpu binding logic
Date: Fri, 3 Sep 2021 22:43:59 +0800
Message-ID: <b78d63d1-1cd8-a6d0-c26e-3d6c270abbb4@linux.alibaba.com>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
 <20210902164808.GA10014@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
In-Reply-To: <20210902164808.GA10014@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

在 2021/9/3 上午12:48, Michal Koutný 写道:
> Hello Hao.
> 
> On Wed, Sep 01, 2021 at 08:43:20PM +0800, Hao Xu <haoxu@linux.alibaba.com> wrote:
>> This patchset is to enhance sqthread cpu binding logic, we didn't
>> consider cgroup setting before. In container environment, theoretically
>> sqthread is in its container's task group, it shouldn't occupy cpu out
>> of its container.
> 
> I see in the discussions that there's struggle to make
> set_cpus_allowed_ptr() do what's intended under the given constraints.
> 
> IIUC, set_cpus_allowed_ptr() is conventionally used for kernel threads
> [1]. But does the sqthread fall into this category? You want to have it
> _directly_ associated with a container and its cgroups. It looks to me
sqthread is in it's creator's task group, so it is like a userspace
thread from this perspective. When it comes to container environemt
sqthread naturely belongs to a container which also contains its creator
And it has same cgroup setting with it's creator by default.
> more like a userspace thread (from this perspective, not literally). Or
> is there a different intention?
> 
> It seems to me that reusing the sched_setaffinity() (with all its
> checks and race pains/solutions) would be a more universal approach.
> (I don't mean calling sched_setaffinity() directly, some parts would
> need to be factored separately to this end.) WDYT?
> 
> 
> Regards,
> Michal
> 
> [1] Not only spending their life in kernel but providing some
> delocalized kernel service.
> 

