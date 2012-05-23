From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] slab+slob: dup name string
Date: Wed, 23 May 2012 08:53:29 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205230849410.29893@router.home>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home> <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1337781211; bh=fRmUlbj+OysEM0fQHles3ssT2984vchu7St7f1e6AB8=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=d0QcjEY3ICSrrcT2bk07yaZP6DeNFtRbzr8QVZHn8yttk9UM4cT9R0mhakhpyibrlu90+HvJ1axEOFNBSBboIzzCIqFv7FDJZoGjoysxvgYLyxHxvZV/z9UUqZ9b6QCpgx9VnJkfcPzRBLe0QDUfJHzO0Ml1qKEEEWcCfsDmLeg=
In-Reply-To: <alpine.DEB.2.00.1205222048380.28165-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, 22 May 2012, David Rientjes wrote:

> On Tue, 22 May 2012, Christoph Lameter wrote:
>
> > > [ v2: Also dup string for early caches, requested by David Rientjes ]
> >
> > kstrdups that early could cause additional issues. Its better to leave
> > things as they were.
> >
>
> No, it's not, there's no reason to prevent caches created before
> g_cpucache_up <= EARLY to be destroyed because it makes a patch easier to
> implement and then leave that little gotcha as an undocumented treasure
> for someone to find when they try it later on.

g_cpucache_up <= EARLY is slab bootstrap code and the system is in a
pretty fragile state. Plus the the kmalloc logic *depends* on these
caches being present. Removing those is not a good idea. The other caches
that are created at that point are needed to create more caches.

There is no reason to remove these caches.

> This is much easier to do, just statically allocate the const char *'s
> needed for the boot caches and then set their ->name's manually in
> kmem_cache_init() and then avoid the kfree() in kmem_cache_destroy() if
> the name is between &boot_cache_name[0] and &boot_cache_name[n].

Yeah that is already occurring for some of the boot caches.
