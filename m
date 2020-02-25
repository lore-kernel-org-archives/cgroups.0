From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Tue, 25 Feb 2020 13:17:55 -0500
Message-ID: <20200225181755.GB10257@cmpxchg.org>
References: <20200213165711.GJ88887@mtj.thefacebook.com>
 <20200214071537.GL31689@dhcp22.suse.cz>
 <20200214135728.GK88887@mtj.thefacebook.com>
 <20200214151318.GC31689@dhcp22.suse.cz>
 <20200214165311.GA253674@cmpxchg.org>
 <20200217084100.GE31531@dhcp22.suse.cz>
 <20200218195253.GA13406@cmpxchg.org>
 <20200221101147.GO20509@dhcp22.suse.cz>
 <20200221154359.GA70967@cmpxchg.org>
 <20200225122028.GS22443@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=59RFntod1v+Fgi9qWl+7asOr6BjtIFtBcdd9JHf9hGU=;
        b=1a3XSgdyMR9qzU5Ug/y089/dUkV05hE+fRZpzRHXpUmUzT5LcGtKEXuPyr3TRBSf2o
         RQidxg45VKJwEJ3czZ/bQZ1//CUMyJVgv9NfubbsXXa1EoehRgDIfrp6WTHGsHLe/Ujg
         NI0//6M7HB8UHeYcOEI7BcXO/SkUGuzL6kIUyd5mhDoIb0SsW8J4o6NuPGX5d1P97woZ
         /gtbJ0tv4fWdspv61TpTLxSeI1omuRnpPhGM0s4nnT/tAOyaEF99a75ceTAcfm4QQ8Oq
         EI+wDZnlPqfOfKX21p/2wyjiWSdit7UI2rljro1rZTNDMlwY6gGvWo5HBG5oi3DlboZX
         x+Rg==
Content-Disposition: inline
In-Reply-To: <20200225122028.GS22443@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Feb 25, 2020 at 01:20:28PM +0100, Michal Hocko wrote:
> 
> On Fri 21-02-20 10:43:59, Johannes Weiner wrote:
> > On Fri, Feb 21, 2020 at 11:11:47AM +0100, Michal Hocko wrote:
> [...]
> > > I also have hard time to grasp what you actually mean by the above.
> > > Let's say you have hiearchy where you split out low limit unevenly
> > >               root (5G of memory)
> > >              /    \
> > >    (low 3G) A      D (low 1,5G)
> > >            / \
> > >  (low 1G) B   C (low 2G)
> > >
> > > B gets lower priority than C and D while C gets higher priority than
> > > D? Is there any problem with such a configuration from the semantic
> > > point of view?
> > 
> > No, that's completely fine.
> 
> How is B (low $EPS) C (low 3-$EPS) where $EPS->0 so much different
> from the above. You prioritize C over B, D over B in both cases under
> global memory pressure.

You snipped the explanation for the caveat / the priority inversion
that followed; it would be good to reply to that instead.

> > > > However, that doesn't mean this usecase isn't supported. You *can*
> > > > always split cgroups for separate resource policies.
> > > 
> > > What if the split up is not possible or impractical. Let's say you want
> > > to control how much CPU share does your container workload get comparing
> > > to other containers running on the system? Or let's say you want to
> > > treat the whole container as a single entity from the OOM perspective
> > > (this would be an example of the logical organization constrain) because
> > > you do not want to leave any part of that workload lingering behind if
> > > the global OOM kicks in. I am pretty sure there are many other reasons
> > > to run related workload that doesn't really share the memory protection
> > > demand under a shared cgroup hierarchy.
> > 
> > The problem is that your "pretty sure" has been proven to be very
> > wrong in real life. And that's one reason why these arguments are so
> > frustrating: it's your intuition and gut feeling against the
> > experience of using this stuff hands-on in large scale production
> > deployments.
> 
> I am pretty sure you have a lot of experiences from the FB workloads.
> And I haven't ever questioned that. All I am trying to explore here is
> what the consequences of the new proposed semantic are. I have provided
> few examples of when an opt-out from memory protection might be
> practical. You seem to disagree on relevance of those usecases and I can
> live with that.

I didn't dismiss them as irrelevant, I repeatedly gave extensive
explanations based on real world examples for why they cannot work.

Look at the example I gave to Michal K. about the low-priority "donor"
cgroup that gives up memory to the rest of the tree. Not only is that
workload not contained, the low-pri memory setting itself makes life
actively worse for higher priority cgroups due to increasing paging.

You have consistently dismissed or not engaged with this argument of
priority inversions through other resources.

> Not that I am fully convinced because there is a
> different between a very tight resource control which is your primary
> usecase and a much simpler deployments focusing on particular resources
> which tend to work most of the time and occasional failures are
> acceptable.

It's been my experience that "works most of the time" combined with
occasional failure doesn't exist. Failure is immediate once resources
become contended (and you don't need cgroups without contention). And
I have explained why that is the case.

You keep claiming that FB somehow has special requirements that other
users don't have. What is this claim based on? All we're trying to do
is isolate general purpose workloads from each other and/or apply
relative priorities between them.

How would simpler deployments look like?

If I run a simple kernel build job on my system right now, setting a
strict memory limit on it will make performance of the rest of the
system worse than if I didn't set one, due to the IO flood from
paging. (There is no difference between setting a strict memory.max on
the compile job or a very high memory.low protection on the rest of
the system, the end result is that the workload will page trying to
fit into the small amount of space left for it.)

> That being said, the new interface requires an explicit opt-in via mount
> option so there is no risk of regressions. So I can live with it. Please
> make sure to document explicitly that the effective low limit protection
> doesn't allow to opt-out even when the limit is set to 0 and the
> propagated protection is fully assigned to a sibling memcg.

I can mention this in the changelog, no problem.

> It would be also really appreciated if we have some more specific examples
> of priority inversion problems you have encountered previously and place
> them somewhere into our documentation. There is essentially nothing like
> that in the tree.

Of course, I wouldn't mind doing that in a separate patch. How about a
section in cgroup-v2.rst, at "Issues with v1 and Rationales for v2"?
