From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [RFC PATCH] mm: memcontrol: don't account swap failures not due
 to cgroup limits
Date: Fri, 3 Feb 2023 11:19:32 -0800
Message-ID: <Y91eRKKutWBZwmSG@P9FQF9L96D.corp.robot.car>
References: <20230202155626.1829121-1-hannes@cmpxchg.org>
 <Y91ZsDSIr2oFHu3E@P9FQF9L96D.corp.robot.car>
 <CAHbLzkpk+6+kzsxmJ_MK+708rpCEjB2njnarLkzfzXX-MUyG7g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675451977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JBM6UGsWSc/J+v73pZDrkX8oGGd9uvbvRutgj4g0VrU=;
        b=DCWeQAu8NfpO8qhLsTfLFhJ+J7jUlaMIrWlZ6kB/ZDrVTx+o3KY5ABEu2/giYvWnxD8hvG
        vZgj9rde9D3RjMBYR9cUSVlDI72LbrlYTtjC+Izg9jaDCkfBiauCBkEkTdsAjBX0rHa4AD
        q/AXyR4KuBP2dFpdEQCnlJVQs/2vP9c=
Content-Disposition: inline
In-Reply-To: <CAHbLzkpk+6+kzsxmJ_MK+708rpCEjB2njnarLkzfzXX-MUyG7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Fri, Feb 03, 2023 at 11:07:30AM -0800, Yang Shi wrote:
> On Fri, Feb 3, 2023 at 11:00 AM Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> >
> > On Thu, Feb 02, 2023 at 10:56:26AM -0500, Johannes Weiner wrote:
> > > Christian reports the following situation in a cgroup that doesn't
> > > have memory.swap.max configured:
> > >
> > >   $ cat memory.swap.events
> > >   high 0
> > >   max 0
> > >   fail 6218
> > >
> > > Upon closer examination, this is an ARM64 machine that doesn't support
> > > swapping out THPs.
> >
> > Do we expect it to be added any time soon or it's caused by some system
> > limitations?
> 
> AFAIK, it has been supported since 6.0. See commit d0637c505f8a1

Great, thank you for the link!
Then it looks like we have even fewer reasons to change the interface.

Thanks!
