From: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 4/7 v2] memcg: use res_counter_uncharge_until in move_parent
Date: Fri, 27 Apr 2012 11:26:19 -0700
Message-ID: <CALWz4izAxDacXrHMbQh=q_WAcs6QeSuaRuma_dymuTvyk+VDSg@mail.gmail.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A34B2.8080103@jp.fujitsu.com>
	<4F9AD455.9030306@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding:x-system-of-record;
        bh=XfyMt8M9mQU/yJEC8ttx88Zs6upmiFJBF/mjPG05ljQ=;
        b=XfN5BHmCpTQvoC+GGFP2ExhQ5wkVMP0orrMxb0pLApAfzqAdBMfGdIw+IelRgFiZKP
         NEcSfBQVQklj270K3JXLA++HqaxdZL911zjx9ZMN3soVSMm2x0Y9uLmOGFLmuFs7DjVY
         kTm1JNwkUuj2GKvcAQzxwLFnGUrrxNpS4xfrj4/IKe06rmyu/MexwN8VwKhjK0Nc+E6i
         IVg2g2YOW8yb2XWPZAiBc8mL3pz1NgHGzWDm7dtCb36Th7RvZLtCMRqWNhPJrQI0l74B
         x61WpoqWAbWIlp64h5jPx6QmoengZuHl15YlMGkDe8vRKDCro3IHQ3MQnnjo0c9hrWmV
         v61g==
In-Reply-To: <4F9AD455.9030306-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Fri, Apr 27, 2012 at 10:16 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>=
 wrote:
> On 04/27/2012 02:54 AM, KAMEZAWA Hiroyuki wrote:
>> By using res_counter_uncharge_until(), we can avoid
>> unnecessary charging.
>>
>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
>> ---
>> =A0 mm/memcontrol.c | =A0 63 ++++++++++++++++++++++++++++++++++++---=
---------------
>> =A0 1 files changed, 42 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 613bb15..ed53d64 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -2420,6 +2420,24 @@ static void __mem_cgroup_cancel_charge(struct=
 mem_cgroup *memcg,
>> =A0 }
>>
>> =A0 /*
>> + * Cancel chages in this cgroup....doesn't propagates to parent cgr=
oup.
>> + * This is useful when moving usage to parent cgroup.
>> + */
>> +static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *mem=
cg,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 unsigned int nr_pages)
>> +{
>> + =A0 =A0 if (!mem_cgroup_is_root(memcg)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 unsigned long bytes =3D nr_pages * PAGE_SI=
ZE;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 res_counter_uncharge_until(&memcg->res,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 memcg->res.parent, bytes);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (do_swap_account)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 res_counter_uncharge_until=
(&memcg->memsw,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 memcg->memsw.parent, bytes);
>> + =A0 =A0 }
>> +}
>
> Kame, this is a nitpick, but I usually prefer to write this like:
>
> if (mem_cgroup_is_root(memcg))
> =A0 return;
>
> res_counter...
>
> Specially with memcg, where function names are bigger than average, i=
n
> comparison.
>
> the code itself seems fine.
>
>> +/*
>> =A0 =A0* A helper function to get mem_cgroup from ID. must be called=
 under
>> =A0 =A0* rcu_read_lock(). The caller must check css_is_removed() or =
some if
>> =A0 =A0* it's concern. (dropping refcnt from swap can be called agai=
nst removed
>> @@ -2677,16 +2695,28 @@ static int mem_cgroup_move_parent(struct pag=
e *page,
>> =A0 =A0 =A0 nr_pages =3D hpage_nr_pages(page);
>>
>> =A0 =A0 =A0 parent =3D mem_cgroup_from_cont(pcg);
>> - =A0 =A0 ret =3D __mem_cgroup_try_charge(NULL, gfp_mask, nr_pages,&=
parent, false);
>> - =A0 =A0 if (ret)
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto put_back;
>> + =A0 =A0 if (!parent->use_hierarchy) {
> Can we avoid testing for use hierarchy ?
> Specially given this might go away.
>
> parent_mem_cgroup() already bundles this information. So maybe we can
> test for parent_mem_cgroup(parent) =3D=3D NULL. It is the same thing =
after all.
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __mem_cgroup_try_charge(NULL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 gfp_mask, nr_pages,&parent, false);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto put_back;
>> + =A0 =A0 }
>
> Why? If we are not hierarchical, we should not charge the parent, rig=
ht?

This is how it is implemented today and I think he changed that to
move to root on the next patch.

>
>> =A0 =A0 =A0 if (nr_pages> =A01)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags =3D compound_lock_irqsave(page);
>>
>> - =A0 =A0 ret =3D mem_cgroup_move_account(page, nr_pages, pc, child,=
 parent, true);
>> - =A0 =A0 if (ret)
>> - =A0 =A0 =A0 =A0 =A0 =A0 __mem_cgroup_cancel_charge(parent, nr_page=
s);
>> + =A0 =A0 if (parent->use_hierarchy) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D mem_cgroup_move_account(page, nr_p=
ages,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 pc, child, parent, false);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __mem_cgroup_cancel_local_=
charge(child, nr_pages);
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ret =3D mem_cgroup_move_account(page, nr_p=
ages,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 pc, child, parent, true);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __mem_cgroup_cancel_charge=
(parent, nr_pages);
>> + =A0 =A0 }
>
> Calling move account also seems not necessary to me. If we are not
> uncharging + charging, we won't even touch the parent.

Today for user_hierarchy =3D 0, the charge is moved to parent as well a=
s
the stats. But that is changed on the following patches.

--Ying
