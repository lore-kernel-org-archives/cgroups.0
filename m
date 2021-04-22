From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg: enable accounting for tty-related objects
Date: Thu, 22 Apr 2021 13:50:59 +0200
Message-ID: <YIFjI3zHVQr4BjHc@kroah.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <da450388-2fbc-1bb8-0839-b6480cb0eead@virtuozzo.com>
 <YIFcqcd4dCiNcILj@kroah.com>
 <YIFhuwlXKaAaY3IU@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619092262;
        bh=z3h6YeQAhM+sSuIksdggFIgSAlh6qSpvkJNTNnVlLNo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vYNMr2xWX/yND8JBq0t2hkwmg6pKsHfVnqELHfiuLEDxRGfVkIzHyjzbO6PEkyRKG
         /GTnVv4ea1HEVpVHzCeKw1dtdzypNko79NspvGYUild9WSNvvSPz4Ojv/2xmbGhDkg
         PSooLz/SMRl71Pi48iR81HwqtG62zwOG0dwEMvgU=
Content-Disposition: inline
In-Reply-To: <YIFhuwlXKaAaY3IU-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Apr 22, 2021 at 01:44:59PM +0200, Michal Hocko wrote:
> On Thu 22-04-21 13:23:21, Greg KH wrote:
> > On Thu, Apr 22, 2021 at 01:37:53PM +0300, Vasily Averin wrote:
> > > At each login the user forces the kernel to create a new terminal and
> > > allocate up to ~1Kb memory for the tty-related structures.
> > 
> > Does this tiny amount of memory actually matter?
> 
> The primary question is whether an untrusted user can trigger an
> unbounded amount of these allocations.

Can they?  They are not bounded by some other resource limit?

greg k-h
