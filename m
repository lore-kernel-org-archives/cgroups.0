From: linmiaohe <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: eliminate redundant check in
 __mem_cgroup_insert_exceeded()
Date: Sat, 10 Oct 2020 01:58:23 +0000
Message-ID: <176a5eb5a80d40fdb3fe6e4f460fee08@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: zh-CN
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> On Fri 09-10-20 09:51:04, Miaohe Lin wrote:
>> The mz->usage_in_excess >= mz_node->usage_in_excess check is exactly 
>> the else case of mz->usage_in_excess < mz_node->usage_in_excess. So we 
>> could replace else if (mz->usage_in_excess >= 
>> mz_node->usage_in_excess) with else equally.
>> 
>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
>Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>
>I believe this is a result of a very unreadable code. Resp. the comment makes it hard to follow. It would be slightly better to simply drop the comment which doesn't really explain much IMHO.
>

Agree. Will do it in v2. Many thanks.

