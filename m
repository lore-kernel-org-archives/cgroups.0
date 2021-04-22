From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg: enable accounting for tty-related objects
Date: Thu, 22 Apr 2021 14:22:10 +0200
Message-ID: <YIFqcr9mYqf+9s1H@dhcp22.suse.cz>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <da450388-2fbc-1bb8-0839-b6480cb0eead@virtuozzo.com>
 <YIFcqcd4dCiNcILj@kroah.com>
 <YIFhuwlXKaAaY3IU@dhcp22.suse.cz>
 <YIFjI3zHVQr4BjHc@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619094136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HgmJ6eYbK2bVLn7ba6Q4A6jznipcJvHPjy1e8O/CEY4=;
        b=o5GLJm3U3s8CkgH8E1ETOR00fZVLg/OrxMM2QhaKp3owlgI151sC9lS2FUnYC0ENt/+mMm
        RetoPyoShDzGyc0OV/sng8gXtNzwp7JCY5ddH9IqziJ71FE/Lby1oYelSkg/MuF4/5dsGt
        S/cgqulLNUvIGewanWWQBE5ED4EsRMg=
Content-Disposition: inline
In-Reply-To: <YIFjI3zHVQr4BjHc-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu 22-04-21 13:50:59, Greg KH wrote:
> On Thu, Apr 22, 2021 at 01:44:59PM +0200, Michal Hocko wrote:
> > On Thu 22-04-21 13:23:21, Greg KH wrote:
> > > On Thu, Apr 22, 2021 at 01:37:53PM +0300, Vasily Averin wrote:
> > > > At each login the user forces the kernel to create a new terminal and
> > > > allocate up to ~1Kb memory for the tty-related structures.
> > > 
> > > Does this tiny amount of memory actually matter?
> > 
> > The primary question is whether an untrusted user can trigger an
> > unbounded amount of these allocations.
> 
> Can they?  They are not bounded by some other resource limit?

I dunno. This is not my area. I am not aware of any direct rlimit (maybe
RLIMIT_NPROC) and maybe pid controller would help. But the changelog
should definitely mention that. Other patches tend to mention the
scenario they protect from this one should be more specific.
-- 
Michal Hocko
SUSE Labs
