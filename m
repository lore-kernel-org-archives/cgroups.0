From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: kernfs memcg accounting
Date: Wed, 4 May 2022 12:00:18 +0300
Message-ID: <52a9f35b-458b-44c4-7fc8-d05c8db0c73f@openvz.org>
References: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
 <20220427140153.GC9823@blackbody.suse.cz>
 <7509fa9f-9d15-2f29-cb2f-ac0e8d99a948@openvz.org>
 <YnBLge4ZQNbbxufc@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9h40UHG4+Vlt8Ck/eT8J9TW5C6yu4qO7t/1/LFEGiqY=;
        b=WV8AFjx0yOFxd5rVjjr2sLJ5mz+V5+uLTb8SILkuM1yrcMqzUSvPWiS2mpZw8xGb4r
         9qZ4I/VkzSXsP28HaPRPIrFVlF/ASJZx9O7CTX8EzLap0XCMvySddHQy7j98gc1T3N+w
         5C6I73NA84YBQltR4hG9pjh9Ip9cTCZicfKpbFFzp0NtpwgxPD/AH1MC8Lp0hvqVwJqC
         YXkbk/fZs0S5ef8KwZ0KTWOZHNzZiICXs9YcutrZ5rkun9sYbnD8JpXfWJgA8fFTrzFD
         MpWCsX9wWoxokW6zDRuaLX48cKgi+EoPmdbIPxi1GGEW7QJDhnMkWuLmbpidhOenlIf4
         rdUw==
Content-Language: en-US
In-Reply-To: <YnBLge4ZQNbbxufc@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 5/3/22 00:22, Michal Koutn=C3=BD wrote:
> When struct mem_cgroup charging was introduced, there was a similar
> discussion [1].

Thank you, I'm missed this patch, it was very interesting and useful.
I would note though, that OpenVZ and LXC have another usecase:
we have separate and independent systemd instances inside OS containers.
So container's cgroups are created not in host's root memcg but=20
inside accountable container's root memcg. =20

> I can see following aspects here:
> 1) absolute size of kernfs_objects,
> 2) practical difference between a) and b),
> 3) consistency with memcg,
> 4) v1 vs v2 behavior.
...
> How do these reasonings align with your original intention of net
> devices accounting? (Are the creators of net devices inside the
> container?)

It is possible to create netdevice in one namespace/container=20
and then move them to another one, and this possibility is widely used.
With my patch memory allocated by these devices will be not accounted
to new memcg, however I do not think it is a problem.
My patches protect the host mostly from misuse, when someone creates
a huge number of nedevices inside a container.

>> Do you think it is incorrect and new kernfs node should be accounted
>> to memcg of parent cgroup, as mem_cgroup_css_alloc()-> mem_cgroup_alloc(=
) does?
>=20
> I don't think either variant is incorrect. I'd very much prefer the
> consistency with memcg behavior (variant a)) but as I've listed the
> arguments above, it seems such a consistency can't be easily justified.

From my point of view it is most important to account allocated memory
to any cgroup inside container. Select of proper memcg is a secondary goal =
here.
Frankly speaking I do not see a big difference between memcg of current pro=
cess,
memcg of newly created child and memcg of its parent.

As far as I understand, Roman chose the parent memcg because it was a speci=
al
case of creating a new memory group. He temporally changed active memcg
in mem_cgroup_css_alloc() and properly accounted all required memcg-specific
allocations.
However, he ignored accounting for a rather large struct mem_cgroup
therefore I think we can do not worry about 128 bytes of kernfs node.
Yes, it will be accounted to some other memcg, but the same thing
happens with kernfs nodes of other groups.
I don't think that's a problem.

>> Perhaps you mean that in this case kernfs should not be counted at all,
>> as almost all neighboring allocations do?
>=20
> No, I think it wouldn't help here [2]. (Or which neighboring allocations
> do you mean? There must be at least nr_cgroups of them.)

Primary I mean here struct mem_cgroup allocation in mem_cgroup_alloc().
However, I think we need to take into account any other distributions called
inside cgroup_mkdir: struct cgroup and kernefs node in common part and=20
any other cgroup-cpecific allocations in other .css_alloc functions.
They all can be called from inside container, allocates non-accountable
memory and by this way theoretically can be misused.
So I'm going to check this scenario a bit later.

Thank you,
	Vasily Averin
