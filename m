From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] Add a __GFP_SLABMEMCG flag
Date: Mon, 11 Jun 2012 09:24:37 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1206110905220.31180@router.home>
References: <1339148601-20096-1-git-send-email-glommer@parallels.com> <1339148601-20096-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206081430380.4213@router.home> <1339203416.6893.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1339424680; bh=inndZdjCiZaZHWhvIDk4ltwpruYyUKRJsKyo1ztlJRE=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=utUSS6Z9VxxE2FFvY3pysfmtoV6ZpzFBKLdRCJr/49VvUks4eKwBy5B7DlA4UJbLZ0zlf9MWIYtReoDpUw7iSIEDpuAGSxDQUuwNAUXkeZHwsZdHhljv5wtRVD/ZQEvhCps9CK/JvEb6OxCyM5Xq6jujC1JeI3W1ZP4l+gM3kmo=
In-Reply-To: <1339203416.6893.10.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbeck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Sat, 9 Jun 2012, James Bottomley wrote:

> On Fri, 2012-06-08 at 14:31 -0500, Christoph Lameter wrote:
> > On Fri, 8 Jun 2012, Glauber Costa wrote:
> >
> > >   */
> > >  #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
> > >
> > > -#define __GFP_BITS_SHIFT 25	/* Room for N __GFP_FOO bits */
> > > +#define __GFP_BITS_SHIFT 26	/* Room for N __GFP_FOO bits */
> > >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
> >
> > Please make this conditional on CONFIG_MEMCG or so. The bit can be useful
> > in particular on 32 bit architectures.
>
> I really don't think that's at all a good idea.  It's asking for trouble
> when we don't spot we have a flag overlap.  It also means that we're
> trusting the reuser to know that their use case can never clash with
> CONFIG_MEMGC and I can't think of any configuration where this is
> possible currently.

Flag overlap can be avoided using the same method as we have done with the
page flags (which uses an enum).  There are other uses of N bits after
GFP_BITS_SHIFT. On first look this looks like its 4 right now so we cannot
go above 28 on 32 bit platforms. It would also be useful to have that
limit in there somehow so that someone modifying the GFP_BITS sees the
danger.

> I think making the flag define of __GFP_SLABMEMCG conditional might be a
> reasonable idea so we get a compile failure if anyone tries to use it
> when !CONFIG_MEMCG.

Ok that is another reason to do so.
