From: Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 9/9 v2] memcg: never return error at pre_destroy()
Date: Sat, 28 Apr 2012 09:25:00 +0900
Message-ID: <CABEgKgrXqbF8XBc6vHa2b5KQe9E7_+WODvq3hE0vaT0Eyxo5=w@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A375D.7@jp.fujitsu.com>
	<CALWz4iyiM-CFgVaHiE1Lgd1ZwJzHwY3tx9XX6HeDPUV_wVPAtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=gFQMjDVkI8p6trUp0PeUymkp6/qOWfR4SLIowYV8ZAk=;
        b=LJC/XxW89sXu1g/8OVfrvDtgrp5TIwhSsddgPQlv0e+ITETT2xSIlUHfFqNvOb821v
         ntziK6+quKUiuovvFAKTPVFewFaCwnf7JcM1KQ0wU9m9yWA4BLOP1hlW3TsxzQW6pylp
         JXlVMxUs0xN1wEVQupEH1IFl6urPIZOE4Hs8XJpzLdmzPTECEEyEJd1uAUxST6E18qVs
         xHqBT/0ELlmtyON1CBWlHygtSsg1raQ1Nyi+uywhPePZD6eYsRKAJgsTdm68Jmuc2I+W
         /nhxZgQJAY2qQealkBnFbHb9qNHIKOh6/I7qim0A2y/f/vWJ17LlAzmPxX1ZnSNnGFFx
         Dg0A==
In-Reply-To: <CALWz4iyiM-CFgVaHiE1Lgd1ZwJzHwY3tx9XX6HeDPUV_wVPAtQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Sat, Apr 28, 2012 at 6:28 AM, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Apr 26, 2012 at 11:06 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>> When force_empty() called by ->pre_destroy(), no memory reclaim happ=
ens
>> and it doesn't take very long time which requires signal_pending() c=
heck.
>> And if we return -EINTR from pre_destroy(), cgroup.c show warning.
>>
>> This patch removes signal check in force_empty(). By this, ->pre_des=
troy()
>> returns success always.
>>
>> Note: check for 'cgroup is empty' remains for force_empty interface.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> ---
>> =A0mm/hugetlb.c =A0 =A0| =A0 10 +---------
>> =A0mm/memcontrol.c | =A0 14 +++++---------
>> =A02 files changed, 6 insertions(+), 18 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 4dd6b39..770f1642 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1922,20 +1922,12 @@ int hugetlb_force_memcg_empty(struct cgroup =
*cgroup)
>> =A0 =A0 =A0 =A0int ret =3D 0, idx =3D 0;
>>
>> =A0 =A0 =A0 =A0do {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* see memcontrol.c::mem_cgroup_force_=
empty() */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cgroup_task_count(cgroup)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|| !list_empty(&cgrou=
p->children)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -EBUSY;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If the task doing the cgroup_rmdi=
r got a signal
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we don't really need to loop till=
 the hugetlb resource
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* usage become zero.
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (signal_pending(current)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINTR;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for_each_hstate(h) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(&hugetlb_lo=
ck);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each_entry(p=
age, &h->hugepage_activelist, lru) {
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 2715223..ee350c5 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -3852,8 +3852,6 @@ static int mem_cgroup_force_empty_list(struct =
mem_cgroup *memcg,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pc =3D lookup_page_cgroup(page);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D mem_cgroup_move_parent(page, =
pc, memcg, GFP_KERNEL);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret =3D=3D -ENOMEM || ret =3D=3D -=
EINTR)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ret =3D=3D -EBUSY || ret =3D=3D -=
EINVAL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* found lock content=
ion or "pc" is obsolete. */
>> @@ -3863,7 +3861,7 @@ static int mem_cgroup_force_empty_list(struct =
mem_cgroup *memcg,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0busy =3D NULL;
>> =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 if (!ret && !list_empty(list))
>> + =A0 =A0 =A0 if (!loop)
>
> This looks a bit strange to me... why we make the change ?
>
Ah, I should this move to an independet patch.
Because we don't have -ENOMEM path to exit loop, the return value of
this function
is
  0 (if loop !=3D0 this means lru is empty under the lru lock )
  -EBUSY (if loop=3D=3D 0)

I'll move this part out as an independent clean up patch

thanks,
-kame
