From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks
 allocations
Date: Wed, 27 Apr 2022 15:36:03 -0700
Message-ID: <YmnFUwhmqJwYGQ5j@carbon>
References: <YmdeCqi6wmgiSiWh@carbon>
 <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
 <20220427122232.GA9823@blackbody.suse.cz>
 <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
 <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651098970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YptwFdA8KWuDmjvuchBNuhhYcNiTn83Pm656usmn0sI=;
        b=xurUMpP3QLqUoZxw1BdoFkYM+0wVMIHfRfnM/Miz+pyrSnam+pUfOqzeu4w7WEtz+vscdO
        t8sZhvk29FJHTf9oMznLUlDzxrKSBESrMWIxTbOsTmuGq6MX7UWPvgVN2r6Q4pckJigj3y
        prcDwZAQTSSNCJlRUCceBDukatZZNz4=
Content-Disposition: inline
In-Reply-To: <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Vasily Averin <vvs@openvz.org>
Cc: Shakeel Butt <shakeelb@google.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, kernel@openvz.org, Florian Westphal <fw@strlen.de>, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

On Thu, Apr 28, 2022 at 01:16:53AM +0300, Vasily Averin wrote:
> On 4/27/22 18:06, Shakeel Butt wrote:
> > On Wed, Apr 27, 2022 at 5:22 AM Michal Koutn=FD <mkoutny@suse.com> wrot=
e:
> >>
> >> On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@googl=
e.com> wrote:
> >>> [...]
> >>>>
> >>>> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> >>>> +{
> >>>> +       struct mem_cgroup *memcg;
> >>>> +
> >>>
> >>> Do we need memcg_kmem_enabled() check here or maybe
> >>> mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
> >>> mem_cgroup_disabled() as we can have "cgroup.memory=3Dnokmem" boot
> >>> param.
>=20
> Shakeel, unfortunately I'm not ready to answer this question right now.
> I even did not noticed that memcg_kmem_enabled() and mem_cgroup_disabled()
> have a different nature.
> If you have no objections I'm going to keep this place as is and investig=
ate
> this question later.=20
>=20
> >> I reckon such a guard is on the charge side and readers should treat
> >> NULL and root_mem_group equally. Or is there a case when these two are
> >> different?
> >>
> >> (I can see it's different semantics when stored in current->active_mem=
cg
> >> (and active_memcg() getter) but for such "outer" callers like here it
> >> seems equal.)
>=20
> Dear Michal,
> I may have misunderstood your point of view, so let me explain my vision
> in more detail.
> I do not think that NULL and root_mem_cgroup are equal here:
> - we have enabled cgroups and well-defined root_mem_cgroup,
> - this function is called from inside memcg-limited container,
> - we tried to get memcg from net, but without success,
>   and as result got NULL from  mem_cgroup_from_obj()
>   (frankly speaking I do not think this situation is really possible)
> If we keep memcg =3D NULL, then current's memcg will not be masked and
> net_init's allocations will be accounted to current's memcg.=20
> So we need to set active_memcg to root_mem_cgroup, it helps to avoid
> incorrect accounting.

It's way out of scope of this patch, but I think we need to stop
using NULL as root_mem_cgroup/system scope indicator. Remaining use cases
will be like end of cgroup iteration, active memcg not set, parent of the
root memcg, etc.
We can point root_mem_cgroup at a statically allocated structure
on both CONFIG_MEMCG and !CONFIG_MEMCG.
Does it sound reasonable or I'm missing some important points?

Thanks!
