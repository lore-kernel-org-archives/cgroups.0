From: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 8/9 v2] cgroup: avoid creating new cgroup under a
 cgroup being destroyed
Date: Sat, 28 Apr 2012 09:20:52 +0900
Message-ID: <CABEgKgrJ68wU-L17zwN4_htX948TNFnLVgts=hFeY7QG3etwCA@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A36DE.30301@jp.fujitsu.com>
	<20120427204035.GN26595@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=52HqLSrWmN0nP9AMFIp6ATfhnnGVI/3cOzXy4Pl3XuA=;
        b=CwsT5xu0/XocJn3aPcZEHAT3O1AhpglC2c6xA6ylZamk3GmfqqPWnpAHZ4S4FY2IpA
         PtSauMoBphLA0YMIX5ERQ2dK2UulJiPl6ndx63wYOfRSZpfJeDAEVPG9ScGUtRiuqy4X
         RBBDm6zdC0J5zR9BpPQIoyVIdOHNhbsZJar5/fdCiJHzyKV4f80osaH1U+o1/LQZMBTu
         IX1+1khOmfAQkHiKa0dviJFs6FGeHTqUEviicufwJncHZ36ER65FLMYuhNdw+ZOSLizv
         gIZmt82nBxGjdisPtSCs79h/XLMv/yaksbh1D88c5COXzgAyO36pfoHI0fyV7jfCVJ5O
         HBDg==
In-Reply-To: <20120427204035.GN26595-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat, Apr 28, 2012 at 5:40 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Apr 27, 2012 at 03:04:14PM +0900, KAMEZAWA Hiroyuki wrote:
>> When ->pre_destroy() is called, it should be guaranteed that
>> new child cgroup is not created under a cgroup, where pre_destroy()
>> is running. If not, ->pre_destroy() must check children and
>> return -EBUSY, which causes warning.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>
> Hmm... I'm getting confused more. =A0Why do we need these cgroup chan=
ges
> at all? =A0cgroup still has cgrp->count check and
> cgroup_clear_css_refs() after pre_destroy() calls. =A0The order of
> changes should be,
>
> * Make memcg pre_destroy() not fail; however, pre_destroy() should
> =A0still be ready to be retried. =A0That's the defined interface.
>
> * cgroup core updated to drop pre_destroy() retrying and guarantee
> =A0that pre_destroy() invocation will happen only once.
>
> * memcg and other cgroups can update their pre_destroy() if the "won'=
t
> =A0be retried" part can simplify their implementations.
>

What I thought was...
Assume a memory cgoup A, with use_hierarchy=3D=3D1.

1.  thread:0   start calling pre->destroy of cgroup A
2.  thread:0   it sometimes calls cond_resched or other sleep functions=
=2E
3.  thread:1   create a cgroup B under "A"
4.  thread:1   attach a thread X to cgroup A/B
5.  res_counter of A charged up. but pre_destroy() can't find what happ=
ens
    because it scans LRU of A.

So, we have -EBUSY now. I considered some options to fix this.

option 1) just return 0 instead of -EBUSY when pre_destroy() finds a
task or a child.

There is a race....even if we return 0 here and expects cgroup code
can catch it,
the thread or a child we found may be moved to other cgroup before we c=
heck it
in cgroup's final check.
In that case, the cgroup will be freed before full-ack of
pre_destory() and the charges
will be lost.

option 2) move all codes to ->destory()
That was previous version of this set.

This is option3 that preventing creation of new child.

If you don't like this, I'll move all codes to ->destroy() and use
asynchronous again.

Thanks,
-Kame
