From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 03/11] memcg: change defines to an enum
Date: Tue, 26 Jun 2012 02:01:54 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206260154360.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-4-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252110470.26640@chino.kir.corp.google.com> <4FE972B2.1020509@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=HLHS5x/W9SJf6OETlYvlWBLpr00zucqaqSDQ/7f2Tv0=;
        b=Ovu+fxmrHwAzNTkLv+305Vww8K0xLgIn/KItsG0TzgZWvTV+XEPdeNRQhYRz+EItC0
         42/+v9i9kTz+RLyEgvyVl84VUJHjuvV62ZAd+5G8gsYFyCP4Jrf5BwHG48UpPM/uiWeq
         xeudHVEZCaAd5LXqfvOguzmy/Slx0Kpn6MLLUG47Fw3QX0i1pwKVaNuQ73LSuRRX0tt/
         RJIjnBIwhSHdiJgJktYrlDpQ95wwRP6Or/K5vZldm2bUyX4LVIgjM10eGT+iw8m+0E5w
         qEmjNC31mAkUz6fnhA1OaKG/4DZEDkyDVKDiw+GAvOlPEjmZm/EpFqyq9/frf/pqeXqx
         Hfzg==
In-Reply-To: <4FE972B2.1020509-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 8e601e8..9352d40 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -387,9 +387,12 @@ enum charge_type {
> > >   };
> > > 
> > >   /* for encoding cft->private value on file */
> > > -#define _MEM			(0)
> > > -#define _MEMSWAP		(1)
> > > -#define _OOM_TYPE		(2)
> > > +enum res_type {
> > > +	_MEM,
> > > +	_MEMSWAP,
> > > +	_OOM_TYPE,
> > > +};
> > > +
> > >   #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
> > >   #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
> > >   #define MEMFILE_ATTR(val)	((val) & 0xffff)
> > 
> > Shouldn't everything that does MEMFILE_TYPE() now be using type
> > enum res_type rather than int?
> > 
> If you mean the following three fields, no, since they are masks and
> operations.
> 

No, I mean everything in mm/memcontrol.c that does

	int type = MEMFILE_TYPE(...).

Why define a non-anonymous enum if you're not going to use its type?  
Either use enum res_type in place of int or define the enum to be 
anonymous.

It's actually quite effective since gcc will warn if you're using the 
value of an enum type in your switch() statements later in this series and 
one of the enum fields is missing (if you avoid using a "default" case 
statement) if you pass -Wswitch, which is included in -Wall.
