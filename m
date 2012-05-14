From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v3 1/6] memcg: fix error code in hugetlb_force_memcg_empty()
Date: Mon, 14 May 2012 10:07:34 +0900
Message-ID: <4FB05AD6.1090400@jp.fujitsu.com>
References: <4FACDED0.3020400@jp.fujitsu.com> <4FACDFAE.5050808@jp.fujitsu.com> <20120511141754.e0719c26.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120511141754.e0719c26.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

(2012/05/12 6:17), Andrew Morton wrote:

> On Fri, 11 May 2012 18:45:18 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> 
>> The conditions are handled as -EBUSY, _now_.
> 
> The changelog is poor.  I rewrote it to
> 
> : hugetlb_force_memcg_empty() incorrectly returns 0 (success) when the
> : cgroup is found to be busy.  Return -EBUSY instead.
> 
> But it still doesn't tell us the end-user-visible effects of the bug. 
> It should.
> 


Ah, sorry. How about this ?



The force_empty interface allows to make the memcg only when the cgroup
doesn't include any tasks.

	# echo 0 > /cgroup/xxxx/memory.force_empty

If cgroup isn't empty, force_empty does nothing and retruns -EBUSY in usual
memcg, memcontrol.c. But hugetlb implementation has inconsitency with
it and returns 0 and do nothing. Fix it to return -EBUSY.

Thanks,
-Kame

