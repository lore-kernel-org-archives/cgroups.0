From: linmiaohe <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: correct the comment of
 mem_cgroup_unmark_under_oom()
Date: Thu, 17 Sep 2020 01:41:37 +0000
Message-ID: <e192943774324dc6af20095c0e274dbf@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: zh-CN
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> On Wed 16-09-20 09:19:27, Miaohe Lin wrote:
>> Since commit fb2a6fc56be6 ("mm: memcg: rework and document OOM waiting 
>> and wakeup"), we have renamed mem_cgroup_oom_lock to 
>> mem_cgroup_oom_trylock. So replace mem_cgroup_oom_lock with mem_cgroup_oom_trylock in comment.
>
>While you are right I find the comment more confusing then helpful.
>What does it try to tell us actually? Is it still valid? Shouldn't we rather remove it or make it more clear?
>> 

It seems this comment no long make sense. Many thanks for your nice advise.

