From: linmiaohe <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Correct the comment of mem_cgroup_iter()
Date: Mon, 14 Sep 2020 10:52:08 +0000
Message-ID: <2bcb502990ae44a19ff8b047117758fc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: zh-CN
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> On Sun 13-09-20 05:41:29, Miaohe Lin wrote:
>> Since commit bbec2e15170a ("mm: rename page_counter's count/limit into 
>> usage/max"), the arg @reclaim has no priority field anymore.
>
>The priority field has been removed by 9da83f3fc74b ("mm, memcg: clean up reclaim iter array")
>> 
>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
>Other than that
>Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>
Many thanks for your ack. I have resend the one yesterday:
https://lkml.org/lkml/2020/9/13/69

>
>> ---
>>  mm/memcontrol.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
