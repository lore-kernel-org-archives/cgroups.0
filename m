From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks allocations
Date: Wed, 27 Apr 2022 08:06:10 -0700
Message-ID: <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
References: <YmdeCqi6wmgiSiWh@carbon> <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com> <20220427122232.GA9823@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XS75V+e2Ct78C2HTr9fzu0rvESRlSHMev5cWIVD79uw=;
        b=r/YR+XZjsNKfW6ntLhVS2qvC7q4aKCieabb65nb4ICf0i6WPU76Rc+tkeTTxtOSp4r
         Cp4ikH5UOnW0RwHI0VWzuKZyB2yx+/3AEW56212jW8nk916NwlrBUrYbb5yh6HFUn/3g
         7C24RG1alHoU/CY45Nv2Q+KqmGQGYipv6EK7gRTDqW9eWMqt2je5/dYX0pSpvobCGJ2U
         T++YUMItnBRWW3mLRtwxTf5lcgwHzksUW2ykha3mFO2hChZdUZ9YL6VgaQRSBgXZJ1CA
         KE42kd5aMrtcbglmkWfum3XmBqsylzcpg0FRfxBDKbVvhz6YeFwQIJ/RD9fCyF/VAJ6e
         4lcA==
In-Reply-To: <20220427122232.GA9823-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 27, 2022 at 5:22 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Tue, Apr 26, 2022 at 10:23:32PM -0700, Shakeel Butt <shakeelb@google.c=
om> wrote:
> > [...]
> > >
> > > +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> > > +{
> > > +       struct mem_cgroup *memcg;
> > > +
> >
> > Do we need memcg_kmem_enabled() check here or maybe
> > mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
> > mem_cgroup_disabled() as we can have "cgroup.memory=3Dnokmem" boot
> > param.
>
> I reckon such a guard is on the charge side and readers should treat
> NULL and root_mem_group equally. Or is there a case when these two are
> different?
>
> (I can see it's different semantics when stored in current->active_memcg
> (and active_memcg() getter) but for such "outer" callers like here it
> seems equal.)

I was more thinking about possible shortcut optimization and unrelated
to this patch.

Vasily, can you please add documentation for get_mem_cgroup_from_obj()
similar to get_mem_cgroup_from_mm()? Also for mem_cgroup_or_root().
Please note that root_mem_cgroup can be NULL during early boot.
