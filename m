From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH] slab+slob: dup name string
Date: Thu, 24 May 2012 10:18:31 +1000
Message-ID: <20120524001831.GQ25351@dastard>
References: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1205220855470.17600@router.home>
 <4FBBAE95.6080608@parallels.com>
 <alpine.DEB.2.00.1205221216050.17721@router.home>
 <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
 <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com>
 <4FBCD328.6060406@parallels.com>
 <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com>
 <alpine.DEB.2.00.1205230947490.30940@router.home>
 <4FBCF951.3040105@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FBCF951.3040105-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Wed, May 23, 2012 at 06:50:57PM +0400, Glauber Costa wrote:
> On 05/23/2012 06:48 PM, Christoph Lameter wrote:
> >On Wed, 23 May 2012, James Bottomley wrote:
> >
> >>>>So, why not simply patch slab to rely on the string lifetime being the
> >>>>cache lifetime (or beyond) and therefore not having it take a copy?
> >
> >Well thats they way it was for a long time. There must be some reason that
> >someone started to add this copying business....  Pekka?
> >
> The question is less why we added, but rather why we're keeping.
> 
> Of course reasoning about why it was added helps (so let's try to
> determine that), but so far the only reasonably strong argument in
> favor of keeping it was robustness.

I'm pretty sure it was added because there are slab names
constructed by snprintf on a stack buffer, so the name doesn't exist
beyond the slab initialisation function call...

Cheers,

Dave.

-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
