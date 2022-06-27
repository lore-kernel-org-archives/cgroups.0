From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v5 0/9] memcg: accounting for objects allocated by
 mkdir, cgroup
Date: Mon, 27 Jun 2022 09:37:14 -0700
Message-ID: <CALvZod6U8DvMUcuUNfpQRwfkevQB7=nP4ZLA2gWGNf_JGdyARQ@mail.gmail.com>
References: <4e685057-b07d-745d-fdaa-1a6a5a681060@openvz.org>
 <0fe836b4-5c0f-0e32-d511-db816d359748@openvz.org> <c516033f-a9e4-3485-26d9-a68afa694c1d@openvz.org>
 <YrSP25ebDmXE+kPS@dhcp22.suse.cz> <CALvZod4WsmrpfZtfnP4AmvtnkvBRngXXGyhM6+aQzkdfjsinAQ@mail.gmail.com>
 <YrXDV7uPpmDigh3G@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2vRONC13amhSE1W+iisI+raE+PvPU52ESA4pnszZg8=;
        b=UEcpkmCqZthqdDmCcJb/GHcW0WYvQnSCthVpaKsdmJhtGXLqN7CSupnYP/T9EPiFCT
         dpWNdyhfR++Q5OkhmkqsGWC8xP+zsLjqe1hZEPiTRDPwzXUixzZdYN+OrQiKxHD6+YND
         syqoKAJUsXT0A6UFFYH6qKrCaYiRvAEakeCdLDH8ogsyCp24jeLat9pAf8A3f5Kaa916
         Ne+P4JzkAkzuD8jViCtMZRJ9dzBpqQSf0OwuZA8SljXz57Vy4S+6COF26L6Jk7HDX7m7
         cflaOdwbvTx9eRoOi8K6EYa7WK7WZCXi9s387y7i3owFFtCUK9XdXU/EVohHplY0b3pr
         tt2w==
In-Reply-To: <YrXDV7uPpmDigh3G-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jun 24, 2022 at 6:59 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Thu 23-06-22 09:55:33, Shakeel Butt wrote:
> > On Thu, Jun 23, 2022 at 9:07 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Thu 23-06-22 18:03:31, Vasily Averin wrote:
> > > > Dear Michal,
> > > > do you still have any concerns about this patch set?
> > >
> > > Yes, I do not think we have concluded this to be really necessary. IIRC
> > > Roman would like to see lingering cgroups addressed in not-so-distant
> > > future (http://lkml.kernel.org/r/Ypd2DW7id4M3KJJW@carbon) and we already
> > > have a limit for the number of cgroups in the tree. So why should we
> > > chase after allocations that correspond the cgroups and somehow try to
> > > cap their number via the memory consumption. This looks like something
> > > that will get out of sync eventually and it also doesn't seem like the
> > > best control to me (comparing to an explicit limit to prevent runaways).
> > > --
> >
> > Let me give a counter argument to that. On a system running multiple
> > workloads, how can the admin come up with a sensible limit for the
> > number of cgroups?
>
> How is that any easier through memory consumption? Something that might
> change between kernel versions?

In v2, we do provide a way for admins to right size the containers
without killing them. Actually we are trying to use memory.high for
right sizing the jobs. (It is not the best but workable and there are
opportunities to improve it).

Similar mechanisms for other types of limits are lacking. Usually the
application would be getting the error for which it can not do
anything most of the time.

> Is it even possible to prevent from id
> depletion by the memory consumption? Any medium sized memcg can easily
> consume all the ids AFAICS.

Though the patch series is pitched as protection against OOMs, I think
it is beneficial irrespective. Protection against an adversarial actor
should not be the aim here. IMO this patch series improves the memory
association to the actual user which is better than unattributed
memory treated as system overhead.
