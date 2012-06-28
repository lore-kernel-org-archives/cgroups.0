From: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
Date: Thu, 28 Jun 2012 17:33:51 +0900
Message-ID: <4FEC16EF.40408@jp.fujitsu.com>
References: <4FACDED0.3020400@jp.fujitsu.com> <20120621202043.GD4642@google.com> <4FE3ADDD.9060908@jp.fujitsu.com> <20120627175818.GM15811@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120627175818.GM15811-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

(2012/06/28 2:58), Tejun Heo wrote:
> Hello, KAME.
>
> On Fri, Jun 22, 2012 at 08:27:25AM +0900, Kamezawa Hiroyuki wrote:
>> Remaining 20% of work is based on a modification to cgroup layer
>>
>> How do you think this patch ? (This patch is not tested yet...so
>> may have troubles...) I think callers of pre_destory() is not so many...
>>
>> ==
>>  From a28db946f91f3509d25779e8c5db249506cc4b07 Mon Sep 17 00:00:00 2001
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> Date: Fri, 22 Jun 2012 08:38:38 +0900
>> Subject: [PATCH] cgroup: keep cgroup_mutex() while calling ->pre_destroy()
>>
>> In past, memcg's pre_destroy() was verrry slow because of the possibility
>> of page reclaiming in it. So, cgroup_mutex() was released before calling
>> pre_destroy() callbacks. Now, it's enough fast. memcg just scans the list
>> and move pages to other cgroup, no memory reclaim happens.
>> Then, we can keep cgroup_mutex() there.
>>
>> By holding looks, we can avoid following cases
>>     1. new task is attached while rmdir().
>>     2. new child cgroup is created while rmdir()
>>     3. new task is attached to cgroup and removed from cgroup before
>>        checking css's count. So, ->destroy() will be called even if
>>        some trashes by the task remains
>>
>> (3. is terrible case...even if I think it will not happen in real world..)
>
> Ooh, once memcg drops the __DEPRECATED_clear_css_refs, cgroup_rmdir()
> will mark the cgroup dead before start calling pre_destroy() and none
> of the above will happen.
>

Hm, threads which touches memcg should hold memcg's reference count rather than css.
Right ? IIUC, one of reason is a reference from kswapd etc...hm. I'll check it.

Thanks,
-Kame









