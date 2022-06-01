From: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Wed, 1 Jun 2022 16:37:17 -0700
Message-ID: <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23@linaro.org>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz> <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <0babd7df-bdef-9edc-3682-1144bc0c2d2b@linaro.org>
 <Ypf0VnKUMiuRgZqT@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=TEAUJ/ucXI4eKAlLgmvtjNFHQlDUXBOnD+LHuiraz3w=;
        b=g+g2a/h5fj4ekdhiBZVoem39IesHnm9DOBXVdr0u+GBT1FfE/6soJZwVcANNucrA2v
         9gLc+e6E0h/HUqewW/gcDTlpIKOE9B/nvi5VkwCdzUboCkGQ8HoHp+k1nY6S6no+hpdd
         R85LIIF3A+LnmFfmdZrp2gXNHbADZQMBIqyAxaLPbFeBYC7LfXf05cPAIJ/HB+YxrG8+
         0AuR6f8wWikFigxTB9vlidalsm5Ip4SDKp+5Jve4ENy8SNmi3hitf5WMdN1FvdBjp6dE
         WbwdwFOlfOUbT+9ZoCMY9tktSqMUi4+SKtRo1qnmshxELME/PknA+zT+oXorZKxdTZtk
         ymBw==
Content-Language: en-US
In-Reply-To: <Ypf0VnKUMiuRgZqT-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On 6/1/22 16:20, Tejun Heo wrote:
> On Wed, Jun 01, 2022 at 04:13:32PM -0700, Tadeusz Struk wrote:
>>> On Thu, May 26, 2022 at 11:56:34AM +0200, Michal Koutn=C3=BD wrote:
>>>> // ref=3DA: initial state
>>>> kill_css()
>>>>     css_get // ref+=3DF =3D=3D A+F: fuse
>>>>     percpu_ref_kill_and_confirm
>>>>       __percpu_ref_switch_to_atomic
>>>>         percpu_ref_get
>>>>           // ref +=3D 1 =3D=3D A+F+1: atomic mode, self-protection
>>>>       percpu_ref_put
>>>>         // ref -=3D 1 =3D=3D A+F: kill the base reference
>>>>     [via rcu]
>>>>     percpu_ref_switch_to_atomic_rcu
>>>>       percpu_ref_call_confirm_rcu
>>>>         css_killed_ref_fn =3D=3D refcnt.confirm_switch
>>>>           queue_work(css->destroy_work)        (1)
>>>>                                                        [via css->destr=
oy_work]
>>>>                                                        css_killed_work=
_fn =3D=3D wq.func
>>>>                                                          offline_css()=
 // needs fuse
>>>>                                                          css_put // re=
f -=3D F =3D=3D A: de-fuse
>>>>         percpu_ref_put
>>>>           // ref -=3D 1 =3D=3D A-1: remove self-protection
>>>>           css_release                                   // A <=3D 1 ->=
 2nd queue_work explodes!
>>>
>>> I'm not sure I'm following it but it's perfectly fine to re-use the work
>>> item at this point. The work item actually can be re-cycled from the ve=
ry
>>> beginning of the work function. The only thing we need to make sure is =
that
>>> we don't css_put() prematurely to avoid it being freed while we're usin=
g it.
>>
>> Yes, it is ok to reuse a work struct, but it's not ok to have the same
>> work struct enqueued twice on the same WQ when list debug is enabled.
>> That's why we are getting this "BUG: corrupted list.."
>=20
> The above scenario isn't that tho. Once the work item starts executing, wq
> doesn't care about what happens to it and as killed_work_fn is holding a
> reference, the release scheduling shouldn't happen before it starts
> executing unless somebody is screwing up the refcnting.
>=20
>> That's right. Michal was on the right track for the kill_css() part.
>> What I think is going on is that once css_create() fails then
>> cgroup_subtree_control_write() ends up calling first kill_css() and
>> then css_put() on the same css, I think it's &cgrp->self of the kernfs_n=
ode.
>> The each_live_descendant_post() also iterates on the root.
>> Here is the call flow (sorry for long lines):
>>
>> cgroup_subtree_control_write(of)->cgroup_apply_control(cgrp)->cgroup_app=
ly_control_enable(cgrp)->css_create() <- fails here and returns error
>>    |
>>    |-> cgroup_finalize_control(cgrp)->cgroup_apply_control_disable(cgrp)=
->each_live_descendant_post(cgrp)->kill_css()->percpu_ref_kill_and_confirm(=
&css->refcnt, css_killed_ref_fn) <- this triggers css_killed_ref_fn() to be=
 called
>>    |
>>    |  css_killed_ref_fn() <- first css->destroy_work enqueue
>>    |    |
>>    |    |->  INIT_WORK(&css->destroy_work, css_killed_work_fn); queue_wo=
rk(cgroup_destroy_wq, &css->destroy_work);
>>    |
>>    |
>>    |-> goto out_unlock;
>>    |     |
>>    |     |-> cgroup_kn_unlock(kernfs_node)->cgroup_put(cgrp)->css_put(&c=
grp->self)->percpu_ref_put(&css->refcnt) <- this triggers css_release() to =
be called
>>    |
>>    |
>>       css_release(percpu_ref) <- second css->destroy_work enqueue
>>         |
>>         |->  INIT_WORK(&css->destroy_work, css_release_work_fn); queue_w=
ork(cgroup_destroy_wq, &css->destroy_work) <- and it fails here with BUG: c=
orrupted list in insert_work; list_add corruption.
>>
>>
>> What seems to work for me as the simplest fix is to prevent enqueuing a =
dying
>> css in css_release() as below. Please let me know if that makes sense to=
 you.
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index 1779ccddb734..5618211487cc 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -5210,8 +5210,10 @@ static void css_release(struct percpu_ref *ref)
>>   	struct cgroup_subsys_state *css =3D
>>   		container_of(ref, struct cgroup_subsys_state, refcnt);
>> -	INIT_WORK(&css->destroy_work, css_release_work_fn);
>> -	queue_work(cgroup_destroy_wq, &css->destroy_work);
>> +	if (!(css->flags & CSS_DYING)) {
>> +		INIT_WORK(&css->destroy_work, css_release_work_fn);
>> +		queue_work(cgroup_destroy_wq, &css->destroy_work);
>> +	}
>=20
> When the problem is ref imbalance, how can above be the solution? Of cour=
se
> release path won't cause an issue if they don't run, but we still need to
> free the thing, right?

Yes, but as far as I can see the percpu_ref_kill_and_confirm(&css->refcnt, =
css_killed_ref_fn)
doesn't change the value of the refcnt, it just causes the css_killed_ref_f=
n() to be called
on it. Only css_get() & css_put() modify the refcnt value.
And for the "free the thing" the css_killed_work_fn() does that.
It calls offline_css(css) and css_put(css) for the whole css hierarchy.

--=20
Thanks,
Tadeusz
