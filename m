From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2] slab+slob: dup name string
Date: Wed, 23 May 2012 13:25:23 +0400
Message-ID: <4FBCAD03.5010106@parallels.com>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home> <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1205222048380.28165-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On 05/23/2012 07:55 AM, David Rientjes wrote:
> I hate consistency patches like this because it could potentially fail a
> kmem_cache_create() from a sufficiently long cache name when it wouldn't
> have before, but I'm not really concerned since kmem_cache_create() will
> naturally be followed by kmem_cache_alloc() which is more likely to cause
> the oom anyway.  But it's just another waste of memory for consistency
> sake.
>
> This is much easier to do, just statically allocate the const char *'s
> needed for the boot caches and then set their ->name's manually in
> kmem_cache_init() and then avoid the kfree() in kmem_cache_destroy() if
> the name is between&boot_cache_name[0] and&boot_cache_name[n].

That can be done.

I'll also revisit my memcg patches to see if I can rework it so it 
doesn't care about this particular behavior. We're having a surprisingly 
difficult time reaching consensus on this, so maybe it would be better 
left untouched (if there is a way that makes sense to)
