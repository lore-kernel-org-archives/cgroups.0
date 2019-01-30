From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Wed, 30 Jan 2019 11:37:41 -0800
Message-ID: <CALvZod65htZmApWkv-MrAjg6V1OGBLmdyFP_030LARD7ajS3mw@mail.gmail.com>
References: <20190128151859.GO18811@dhcp22.suse.cz> <20190128154150.GQ50184@devbig004.ftw2.facebook.com>
 <20190128170526.GQ18811@dhcp22.suse.cz> <20190128174905.GU50184@devbig004.ftw2.facebook.com>
 <20190129144306.GO18811@dhcp22.suse.cz> <20190129145240.GX50184@devbig004.ftw2.facebook.com>
 <20190130165058.GA18811@dhcp22.suse.cz> <20190130170658.GY50184@devbig004.ftw2.facebook.com>
 <CALvZod5ma62fRKqrAhMcuNT3GYT3FpRX+DCmeVr2nDg1u=9T8w@mail.gmail.com>
 <20190130192712.GA21279@cmpxchg.org> <20190130193026.GA21410@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ynztbY1mL0CpFlAEvrgll//q6zMLgn4eN+pIRdt4AAk=;
        b=hEKKgLcCzb2TF8FQN9P2G70rLcqxOf+LMks/+bF+A75PISRGD8IJ9dC5LM2uk05Xwq
         55VsBJhulcECv3kpovgOaIni5zJcPfJUS59855DCJ7ExDIP5ewLYj3ZjEVsiCG6PTEPM
         Zqiv5d0Kub8BDoQ50wztXVuUhutgHbqGzcZzom1m9me6gBYX7Vl5RrUWDnYxTiznNLZs
         gSZPPN52kSVg6gWY1zJ5H1OUEUDHNjAOiFC+pL2T/p3giL4aVbqLAjXkrufL5hGaOC6Z
         tlCSEkC13nHm6KoldXcMhad4Ey3Nrts77/IJMgMhS0kiTkyCLuCCX209hI2fh1TRz8xD
         uO7Q==
In-Reply-To: <20190130193026.GA21410@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, kernel-team@fb.com

On Wed, Jan 30, 2019 at 11:30 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Wed, Jan 30, 2019 at 02:27:12PM -0500, Johannes Weiner wrote:
> > On Wed, Jan 30, 2019 at 11:11:44AM -0800, Shakeel Butt wrote:
> > > Hi Tejun,
> > >
> > > On Wed, Jan 30, 2019 at 9:07 AM Tejun Heo <tj@kernel.org> wrote:
> > > >
> > > > Hello, Michal.
> > > >
> > > > On Wed, Jan 30, 2019 at 05:50:58PM +0100, Michal Hocko wrote:
> > > > > > Yeah, cgroup.events and .stat files as some of the local stats would
> > > > > > be useful too, so if we don't flip memory.events we'll end up with sth
> > > > > > like cgroup.events.local, memory.events.tree and memory.stats.local,
> > > > > > which is gonna be hilarious.
> > > > >
> > > > > Why cannot we simply have memory.events_tree and be done with it? Sure
> > > > > the file names are not goin to be consistent which is a minus but that
> > > > > ship has already sailed some time ago.
> > > >
> > > > Because the overall cost of shitty interface will be way higher in the
> > > > longer term.  cgroup2 interface is far from perfect but is way better
> > > > than cgroup1 especially for the memory controller.  Why do you think
> > > > that is?
> > > >
> > >
> > > I thought you are fine with the separate interface for the hierarchical events.
> >
> > Every other file in cgroup2 is hierarchical, but for recursive
> > memory.events you'd need to read memory.events_tree?
> >
> > Do we hate our users that much? :(
>
> FTR, I would be okay with adding .local versions to existing files
> where such a behavior could be useful. But that seems to be a separate
> discussion from fixing memory.events here.

Oh ok, the dispute is on the name of the interface. I am fine with
whatever the decision is made as we (Google) are still not using these
interfaces. However what's the way forward here?

thanks,
Shakeel
