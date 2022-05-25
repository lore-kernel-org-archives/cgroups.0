From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Wed, 25 May 2022 10:59:18 +0200
Message-ID: <Yo3v5k8UBNHF6QRi@dhcp22.suse.cz>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <YoYj4sLJfGke5IGT@dhcp22.suse.cz>
 <87zgjcg4xs.fsf@vajain21.in.ibm.com>
 <YodDaFVeU33bu7yQ@dhcp22.suse.cz>
 <CAJD7tkYwv2LDZeV2F5pxuniw7LCNjBapDCm3WuRhzwTH-jN3PA@mail.gmail.com>
 <YozFZI2euSjWPgDb@cmpxchg.org>
 <CAJD7tkZxvmnrrjc4yAe5mC+SL-MZqMkn21yjetiLYyq0B=AhtA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653469159; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AdJCYZHOyhpjXySt6nTPMBOK5Q7ap+5mhsb0yD0IbJk=;
        b=aiV6xLIl8yHWP30wU/K3GtbE85ZdBM0U1BgBzJcKlHVA+4+eXIlhgfUdcIjT7dEY9LCayY
        qdR0ughVWk+eDMKIj1MpdBpoaBSWF8+Uz2ja25zdBKLZBcBtbHqJdJEWm2SbGqjXX7AsZz
        UMe64oVsol7td+qJimhHkcqUGFKpgnI=
Content-Disposition: inline
In-Reply-To: <CAJD7tkZxvmnrrjc4yAe5mC+SL-MZqMkn21yjetiLYyq0B=AhtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vaibhav Jain <vaibhav-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Aneesh Kumar K . V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue 24-05-22 12:01:01, Yosry Ahmed wrote:
> On Tue, May 24, 2022 at 4:45 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> >
> > On Mon, May 23, 2022 at 03:50:34PM -0700, Yosry Ahmed wrote:
> > > I think it might be useful to have a dedicated entry in memory.stat
> > > for proactively reclaimed memory. A case where this would be useful is
> > > tuning and evaluating userspace proactive reclaimers. For instance, if
> > > a userspace agent is asking the kernel to reclaim 100M, but it could
> > > only reclaim 10M, then most probably the proactive reclaimer is not
> > > using a good methodology to figure out how much memory do we need to
> > > reclaim.
> > >
> > > IMO this is more useful, and a superset of just reading the last
> > > reclaim request status through memory.reclaim (read stat before and
> > > after).
> >
> > +1
> 
> It might also be useful to have a breakdown of this by memory type:
> file, anon, or shrinkers.
> 
> It would also fit in nicely with a potential type=file/anon/shrinker
> argument to memory.reclaim. Thoughts on this?

Can we start simple and see what real usecases actually will need? 
-- 
Michal Hocko
SUSE Labs
