From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3 15/16] memcg: enable accounting for tty-related objects
Date: Thu, 22 Apr 2021 13:44:59 +0200
Message-ID: <YIFhuwlXKaAaY3IU@dhcp22.suse.cz>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
 <da450388-2fbc-1bb8-0839-b6480cb0eead@virtuozzo.com>
 <YIFcqcd4dCiNcILj@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619091900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jMEV+geuzllYzFQ8Z/TUZlHiYsSrdySAp1JVDStV2gA=;
        b=r/6dqE5AP0rYw1YYAbFz66SiZuRW/+7cE1RXdpAHrLWoronP+/qPsCjXgmrL962Qs0ddgu
        ILhPw+2qe/6j93/kY2gJ/q88mYATZKVh8IkYgfpCDb8H9J+sKBBw53rbMStq9WBppnAcWO
        RTLcfE1HrMLwb00nEW69gDg40l4Ie6w=
Content-Disposition: inline
In-Reply-To: <YIFcqcd4dCiNcILj-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu 22-04-21 13:23:21, Greg KH wrote:
> On Thu, Apr 22, 2021 at 01:37:53PM +0300, Vasily Averin wrote:
> > At each login the user forces the kernel to create a new terminal and
> > allocate up to ~1Kb memory for the tty-related structures.
> 
> Does this tiny amount of memory actually matter?

The primary question is whether an untrusted user can trigger an
unbounded amount of these allocations.
-- 
Michal Hocko
SUSE Labs
