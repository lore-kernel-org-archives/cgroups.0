From: linmiaohe <linmiaohe@huawei.com>
Subject: Re: [PATCH v2] mm: memcontrol: remove obsolete comment of
 mem_cgroup_unmark_under_oom()
Date: Wed, 30 Sep 2020 01:34:25 +0000
Message-ID: <7d1ea112d8a740cab555eaf7be530286@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: zh-CN
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Michal Hocko <mhocko@suse.com> wrote:
> On Thu 17-09-20 06:59:00, Miaohe Lin wrote:
>> Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather 
>> than counter"), the mem_cgroup_unmark_under_oom() is added and the 
>> comment of the mem_cgroup_oom_unlock() is moved here. But this comment 
>> make no sense here because mem_cgroup_oom_lock() does not operate on under_oom field.
>
>OK, so I've looked into this more deeply and I finally remember why we have this comment here. The point is that under_oom shouldn't underflow and that we have to explicitly check for > 0 because a new child memcg could have been added between mem_cgroup_mark_under_oom and mem_cgroup_unmark_under_oom.
>
>So the comment makes sense although it is not as helpful as it could be.
>I think that changing it to the following will be more usefule
>
>	/*
>	 * Be careful about under_oom underflows becase a child memcg
>	 * could have neem added after mem_cgroup_mark_under_oom

Should it be s/neem/been/ ?

>	 */

Many thanks for detailed explanation. Will fix it in v2. Thanks again.

