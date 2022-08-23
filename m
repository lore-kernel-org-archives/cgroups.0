From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for
 low/min
Date: Tue, 23 Aug 2022 11:42:27 +0200
Message-ID: <YwShA6npuK0ZsjPI@dhcp22.suse.cz>
References: <20220822001737.4120417-1-shakeelb@google.com>
 <20220822001737.4120417-2-shakeelb@google.com>
 <YwNSlZFPMgclrSCz@dhcp22.suse.cz>
 <YwNX+vq9svMynVgW@dhcp22.suse.cz>
 <CALvZod720nwfP68OM2QtyyWJpOV5aO8xF6iuN0U2hpX9Pzj8PA@mail.gmail.com>
 <YwOeocdkF/lacpKn@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661247748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a5e+aBtB4V09GgYckhU7qkp/jydUu2L/ktWuXDsvUUg=;
        b=OKRFeR44shGwU0EljaE1Yk98KkScecHFvhrQ5yejUOssX5zl4uJX8SMi15/0k+AdOOx/Il
        1MMu5RDHls3J7toCCAhfVHlseTgH3LpppxNutvATRuchyb5zxA1BYToFrVbXH0DgMKUqVQ
        G28kJ+yPjCDh98TnptwlS13a3X6saZw=
Content-Disposition: inline
In-Reply-To: <YwOeocdkF/lacpKn-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 22-08-22 17:20:02, Michal Hocko wrote:
> On Mon 22-08-22 07:55:58, Shakeel Butt wrote:
> > On Mon, Aug 22, 2022 at 3:18 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
[...]
> > > Unless I have missed anything this shouldn't break the correctness but I
> > > still have to think about the proportional distribution of the
> > > protection because that adds to the complexity here.
> > 
> > The patch is not changing any semantics. It is just removing an
> > unnecessary atomic xchg() for a specific scenario (min > 0 && min <
> > usage). I don't think there will be any change related to proportional
> > distribution of the protection.
> 
> Yes, I suspect you are right. I just remembered previous fixes
> like 503970e42325 ("mm: memcontrol: fix memory.low proportional
> distribution") which just made me nervous that this is a tricky area.
> 
> I will have another look tomorrow with a fresh brain and send an ack.

I cannot spot any problem. But I guess it would be good to have a little
comment to explain that races on the min_usage update (mentioned by Roman)
are acceptable and savings from atomic update are preferred.

The worst case I can imagine would be something like uncharge 4kB racing
with charge 2MB. The first reduces the protection (min_usage) while the other one
misses that update and doesn't increase it. But even then the effect
shouldn't be really large. At least I have hard time imagine this would
throw things off too much.
-- 
Michal Hocko
SUSE Labs
