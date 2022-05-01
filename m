From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks allocations
Date: Sun, 1 May 2022 14:09:49 -0700
Message-ID: <092476D2-C2C4-496C-A92C-EC0B331990ED@linux.dev>
References: <78b556f9-e57b-325d-89ce-7a482ef4ea21@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651439396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WKDIQf5YU17uxh4rrGWr9X3eU/7EjCb3dKHQ+RI13NM=;
        b=ErAYkoy8SGeqig6yJdiYyw7Ot9Lryj1rEO8aAlGEhY/qHTXfpBSqY8LsRp7fqFiv6FkmER
        wff03KP5AxxltMOkRtZmEz9t9u7gmdBgFvOhjJ0ubJH80rA3q3H6f6bAfURXExHlsRS3vz
        CEA3rbbu0cJncAwfrI4SHmiUjFU5DQ0=
In-Reply-To: <78b556f9-e57b-325d-89ce-7a482ef4ea21-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


> On May 1, 2022, at 6:44 AM, Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>=20
> =EF=BB=BFOn 4/28/22 01:47, Shakeel Butt wrote:
>>> On Wed, Apr 27, 2022 at 3:43 PM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>>>=20
>>> On 4/27/22 18:06, Shakeel Butt wrote:
>>>> On Wed, Apr 27, 2022 at 5:22 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> w=
rote:
>>>>>=20
>>>>> On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@googl=
e.com> wrote:
>>>>>> [...]
>>>>>>>=20
>>>>>>> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
>>>>>>> +{
>>>>>>> +       struct mem_cgroup *memcg;
>>>>>>> +
>>>>>>=20
>>>>>> Do we need memcg_kmem_enabled() check here or maybe
>>>>>> mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of=

>>>>>> mem_cgroup_disabled() as we can have "cgroup.memory=3Dnokmem" boot
>>>>>> param.
>>>=20
>>> Shakeel, unfortunately I'm not ready to answer this question right now.
>>> I even did not noticed that memcg_kmem_enabled() and mem_cgroup_disabled=
()
>>> have a different nature.
>>> If you have no objections I'm going to keep this place as is and investi=
gate
>>> this question later.
>>>=20
>>=20
>> Patch is good as is. Just add the documentation to the functions in
>> the next version and you can keep the ACKs.
>=20
> I noticed that the kernel already has a function get_mem_cgroup_from_objcg=
(),
> the name of which is very similar to my new function get_mem_cgroup_from_o=
bj().
> Maybe it's better to rename my function to get_mem_cgroup_from_ptr()?

I don=E2=80=99t think it=E2=80=99s a problem: objcg is a widely used abbrevi=
ation and in my opinion is different enough from obj. I=E2=80=99d keep it fo=
r the consistency with the mem_cgroup_from_obj().

Thanks!=
