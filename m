From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 06/13] slab: Add kmem_cache_gfp_flags() helper function.
Date: Wed, 14 Mar 2012 15:08:13 -0700
Message-ID: <CABCjUKCktPzzZDXMRejDXGXtta=pH5LGHRGU-SjJPuYNkxjH0g@mail.gmail.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
	<1331325556-16447-7-git-send-email-ssouhlal@FreeBSD.org>
	<4F5C8414.5090800@parallels.com>
	<CABCjUKCioWO-F7k=hVs_18B3uyL4zG3-krPFDh++YAnmejKKdg@mail.gmail.com>
	<4F608579.5090109@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=i1sOSFuLOqfKoClngFqZ7/EV3JWZSMZQrTB/cKYy3/U=;
        b=DF8eWdVT/Yx6br/nR0Js4DrSJfeAJEnR2ZtR4pxcdyohUkQeKaL39EbGEqCezIRL/R
         hIuLj8niJ2NeYBjF72DG1xWUfdbxH186yERqH0b4EK9MDdunT4fGQ+Lrkb39buMDdMZ6
         jjhGnd5GSb2rrV7L4OVB9iM05d5x2xSCtG2hQMj6ZBywQuH3IA72pInhRFJOHo7fUy7p
         +Og5WtwFbV4dRXgd7Kp8H6DzxXwVMLEUb3Gvm708B8t6P8i9DjhC5VBSR3DJ/AiD85KP
         2RABdqLoenDJ/4ZXT17DVT9WfHCcDwT17X2epyfSzOp04C/Gx9yQ0nfVJHci5esyjQgD
         9BGg==
In-Reply-To: <4F608579.5090109-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dan.magenheimer-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 14, 2012 at 4:48 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> So what?
> That function is only called from slab.c anyway. Let slab call it
> mem_cgroup_get_kmem_cache(cachep, flags | cachep->allocflags);
> and slub
> mem_cgroup_get_kmem_cache(cachep, flags | cachep->gfpflags);

Ok, I will do that.
I felt like it was better to do it in a single place, instead of doing
it at all the callers.

-- Suleiman
