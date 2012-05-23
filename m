From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Wed, 23 May 2012 13:24:38 +0100
Message-ID: <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com>
	  <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
	  <alpine.DEB.2.00.1205220855470.17600@router.home>
	  <4FBBAE95.6080608@parallels.com>
	  <alpine.DEB.2.00.1205221216050.17721@router.home>
	  <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
	 <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com>
	 <4FBCD328.6060406@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FBCD328.6060406-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Wed, 2012-05-23 at 16:08 +0400, Glauber Costa wrote:
> On 05/23/2012 03:46 PM, James Bottomley wrote:
> >> We can't predict how slab will be extended in the future and this affects
> >> >  anything created before g_cpucache_cpu<= EARLY.  This would introduce the
> >> >  first problem with destroying such caches and is unnecessary if a
> >> >  workaround exists.
> > These problems seem to indicate that the slab behaviour: expecting the
> > string to exist for the lifetime of the cache so there's no need to copy
> > it might be better.
> >
> > This must be the behaviour all users of kmem_cache_create() expect
> > anyway, since all enterprise distributions use slab and they're not
> > getting bugs reported in this area.
> >
> > So, why not simply patch slab to rely on the string lifetime being the
> > cache lifetime (or beyond) and therefore not having it take a copy?
> >
> You mean patch slub? slub is the one that takes a copy currently.

Yes ... a one letter typo.  

James

