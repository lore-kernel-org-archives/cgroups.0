From: David Rientjes <rientjes@google.com>
Subject: Re: [RESEND v12 0/6] cgroup-aware OOM killer
Date: Wed, 25 Oct 2017 13:12:12 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1710251308420.99765@chino.kir.corp.google.com>
References: <20171019185218.12663-1-guro@fb.com> <20171019194534.GA5502@cmpxchg.org> <alpine.DEB.2.10.1710221715010.70210@chino.kir.corp.google.com> <20171023114948.qzmo7emqbigfff7h@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=ig+xRXqFY8H2R/9TxlSre//pfaQfK+4rrONSbcD+DEo=;
        b=Y1xrv74D9F0LkLkS1BLe/lQLfK71vtDxYgGmX8M2jRpKbg/+tmdwew0wy7Ldm2+X6v
         K9D+2GtAonkma48jVth2X9j6Vr/LAVzhfLHJlQf8qs6TVOOAY//u0hFlaq7XmRZbJb9i
         KRLSUmp5wHUorGlyW/edI9wC43BEzOPCboIR6Fc85aQmvlpHaWUpKExnuD7SnIRryKfu
         iS7JWVE9yELNFzIy4F3Nn51f/tyKOYpWTImf2RS9kQe9eZ2LtweMxPrK1S9WijUDESmY
         PlkcmUUOH1Yd1bFlJ/uAyTok7/NgV1JgSN2qEZph8qzqyHusy9HH9ydGw/7+2YtiYDqB
         /xcw==
In-Reply-To: <20171023114948.qzmo7emqbigfff7h@dhcp22.suse.cz>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On Mon, 23 Oct 2017, Michal Hocko wrote:

> On Sun 22-10-17 17:24:51, David Rientjes wrote:
> > On Thu, 19 Oct 2017, Johannes Weiner wrote:
> > 
> > > David would have really liked for this patchset to include knobs to
> > > influence how the algorithm picks cgroup victims. The rest of us
> > > agreed that this is beyond the scope of these patches, that the
> > > patches don't need it to be useful, and that there is nothing
> > > preventing anyone from adding configurability later on. David
> > > subsequently nacked the series as he considers it incomplete. Neither
> > > Michal nor I see technical merit in David's nack.
> > > 
> > 
> > The nack is for three reasons:
> > 
> >  (1) unfair comparison of root mem cgroup usage to bias against that mem 
> >      cgroup from oom kill in system oom conditions,
> 
> Most users who are going to use this feature right now will have
> most of the userspace in their containers rather than in the root
> memcg. The root memcg will always be special and as such there will
> never be a universal best way to handle it. We should to satisfy most of
> usecases. I would consider this something that is an open for a further
> discussion but nothing that should stand in the way.
>  
> >  (2) the ability of users to completely evade the oom killer by attaching
> >      all processes to child cgroups either purposefully or unpurposefully,
> >      and
> 
> This doesn't differ from the current state where a task can purposefully
> or unpurposefully hide itself from the global memory killer by spawning
> new processes.
>  

It cannot hide from the global oom killer if this patchset is used because 
it cannot hide its memory usage beneath cgroup levels.  This comment is in 
support of accounting memory usage up the hierarchy.

> >  (3) the inability of userspace to effectively control oom victim  
> >      selection.
> 
> this is not requested by the current usecase and it has been pointed out
> that this will be possible to implement on top of the foundation of this
> patchset.
> 

There's no reason to not present a complete patchset.  Userspace needs the 
ability to bias or prefer processes (or cgroups, in this case).  That's 
been the case with oom_adj in the past and oom_score_adj with the 
rewritten heuristic.  It's trivial to implement and the only pending 
suggestion to do this influence involves a slightly different scoring 
mechanism than this patchset; it goes back to accounting memory up the 
hierarchy as Roman initially implemented and then biasing between cgroups 
based on an oom_score_adj.  So the proposed influence mechanism cannot be 
implemented on top of this patchset as is, and that gives more reason why 
we cannot merge incomplete patches that can't be extended in the future.
