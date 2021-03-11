From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 0/9] memcg accounting from OpenVZ
Date: Thu, 11 Mar 2021 09:35:30 +0100
Message-ID: <YEnWUrYOArju66ym@dhcp22.suse.cz>
References: <5affff71-e503-9fb9-50cb-f6d48286dd52@virtuozzo.com>
 <CALvZod5YOtqXcSqn2Zj2Nb_SKgDRKOMW4o5i-u_yj7CanQVtGQ@mail.gmail.com>
 <ad68d004-fa84-3d21-60b7-d4a342ad4007@virtuozzo.com>
 <YEiiQ2TGnJcEtL3d@dhcp22.suse.cz>
 <24a416f7-9def-65c9-599e-d56f7c328d33@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615451731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SPSvV0WAkJhngu3aMbeieIGtboHQE6ozlBVf1GQ8Sww=;
        b=hMByrvkbSYioy7yXZtEnsXK7gQssCDpTUh7KNFoXt5p4SQbgBT8MSPdoyKSf/inCqJUI3u
        SPR5qwEBCYsPA7VxCzZiscKONdpqLeHcJwUVfRfC0MDaZIzS5FX392ldn/NZBvp0ZuhVZB
        pKmxwq+CmSCGhgO0QwbafOqq4vIxjAc=
Content-Disposition: inline
In-Reply-To: <24a416f7-9def-65c9-599e-d56f7c328d33-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu 11-03-21 10:00:17, Vasily Averin wrote:
> On 3/10/21 1:41 PM, Michal Hocko wrote:
[...]
> > That is certainly an interesting information. But for a changelog it
> > would be more appropriate to provide information about how much memory
> > user can induce and whether there is any way to limit that memory by
> > other means. How practical those other means are and which usecases will
> > benefit from the containment.
> 
> Right now I would like to understand how should I argument my requests about
> accounting of new kind of objects.
> 
> Which description it enough to enable object accounting?

Doesn't the above paragraph give you a hint?

> Could you please specify some edge rules?

There are no strong rules AFAIK. I would say that it is important is
that the user can trigger a lot of or unbound amount of objects.

> Should I push such patches trough this list? 

yes linux-mm and ccing memcg maintainers is the proper way. It would be
great to CC maintainers of the affected subsystem as well.

> Is it probably better to send them to mailing lists of according subsystems?

> Should I notify them somehow at least?
> 
> "untrusted netadmin inside memcg-limited container can create unlimited number of routing entries, trigger OOM on host that will be unable to find the reason of memory  shortage and  kill huge"
> 
> "each mount inside memcg-limited container creates non-accounted mount object,
>  but new mount namespace creation consumes huge piece of non-accounted memory for cloned mounts"
> 
> "unprivileged user inside memcg-limited container can create non-accounted multi-page per-thread kernel objects for LDT"
> 
> "non-accounted multi-page tty objects can be created from inside memcg-limited container"
> 
> "unprivileged user inside memcg-limited container can trigger creation of huge number of non-accounted fasync_struct objects"

OK, that sounds better to me. It would be also great if you can mention
whether there are any other means to limit those objects if there are
any.

Thanks!
-- 
Michal Hocko
SUSE Labs
