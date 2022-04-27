From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks allocations
Date: Wed, 27 Apr 2022 15:47:32 -0700
Message-ID: <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ@mail.gmail.com>
References: <YmdeCqi6wmgiSiWh@carbon> <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
 <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
 <20220427122232.GA9823@blackbody.suse.cz> <CALvZod7v0taU51TNRu=OM5iJ-bnm1ryu9shjs80PuE-SWobqFg@mail.gmail.com>
 <6b18f82d-1950-b38e-f3f5-94f6c23f0edb@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pYR/QzQe67f9fqV64alfpJ4QrpkISe5OlFL0d1s9oQI=;
        b=Eil46hDjPhuXKtSzUvDnVy1gRIyazn7depZN4dKRbZk3YG/snmXo+NQtocH4TQgRcd
         3TyfzmhJTku3NDJ3F2RHtW96hNyaho9bIZTIbsRwNl3zOp9uwIMIQ22fj087XpU3YSMw
         +b96tr2pL8TvEGaHl3XYTiWXBfNXQrdluMzrGrLzUUpiMXO7F2Gg2Gl403bMWy4muIj9
         t4I8cLWeVdx1rjKEg1w/ae+y06VgA7wEvXWyFAgLtY0GbWtOe1NrDU8G1v57YCYEwAh3
         mKzODEOxygNOtFrB3E5PYOiPCV6XvIlbZo/Ay2crmyCvbppuQQjtZ8CdFdNZzwtxuL4+
         stLw==
In-Reply-To: <6b18f82d-1950-b38e-f3f5-94f6c23f0edb-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Apr 27, 2022 at 3:43 PM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>
> On 4/27/22 18:06, Shakeel Butt wrote:
> > On Wed, Apr 27, 2022 at 5:22 AM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> w=
rote:
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
>
> Shakeel, unfortunately I'm not ready to answer this question right now.
> I even did not noticed that memcg_kmem_enabled() and mem_cgroup_disabled(=
)
> have a different nature.
> If you have no objections I'm going to keep this place as is and investig=
ate
> this question later.
>

Patch is good as is. Just add the documentation to the functions in
the next version and you can keep the ACKs.
