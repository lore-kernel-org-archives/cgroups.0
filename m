From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Wed, 26 Feb 2020 18:56:58 +0100
Message-ID: <20200226175658.GP3771@dhcp22.suse.cz>
References: <20200214071537.GL31689@dhcp22.suse.cz>
 <20200214135728.GK88887@mtj.thefacebook.com>
 <20200214151318.GC31689@dhcp22.suse.cz>
 <20200214165311.GA253674@cmpxchg.org>
 <20200217084100.GE31531@dhcp22.suse.cz>
 <20200218195253.GA13406@cmpxchg.org>
 <20200221101147.GO20509@dhcp22.suse.cz>
 <20200221154359.GA70967@cmpxchg.org>
 <20200225122028.GS22443@dhcp22.suse.cz>
 <20200225181755.GB10257@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200225181755.GB10257-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 25-02-20 13:17:55, Johannes Weiner wrote:
> On Tue, Feb 25, 2020 at 01:20:28PM +0100, Michal Hocko wrote:
> > 
> > On Fri 21-02-20 10:43:59, Johannes Weiner wrote:
> > > On Fri, Feb 21, 2020 at 11:11:47AM +0100, Michal Hocko wrote:
> > [...]
> > > > I also have hard time to grasp what you actually mean by the above.
> > > > Let's say you have hiearchy where you split out low limit unevenly
> > > >               root (5G of memory)
> > > >              /    \
> > > >    (low 3G) A      D (low 1,5G)
> > > >            / \
> > > >  (low 1G) B   C (low 2G)
> > > >
> > > > B gets lower priority than C and D while C gets higher priority than
> > > > D? Is there any problem with such a configuration from the semantic
> > > > point of view?
> > > 
> > > No, that's completely fine.
> > 
> > How is B (low $EPS) C (low 3-$EPS) where $EPS->0 so much different
> > from the above. You prioritize C over B, D over B in both cases under
> > global memory pressure.
> 
> You snipped the explanation for the caveat / the priority inversion
> that followed; it would be good to reply to that instead.

OK, I have misread your response then. Because you were saying that the
above example is perfectly fine while it actually matches your example
of low, mid, high prio example so I was confused.

[...]

I am skipping the large part of your response mostly because I believe
it would make it easier to move this forward.

> > It would be also really appreciated if we have some more specific examples
> > of priority inversion problems you have encountered previously and place
> > them somewhere into our documentation. There is essentially nothing like
> > that in the tree.
> 
> Of course, I wouldn't mind doing that in a separate patch. How about a
> section in cgroup-v2.rst, at "Issues with v1 and Rationales for v2"?

Yes, makes sense. A subsection about examples/best practices/Lessons
learned where we can add more sounds like a very good thing in general.
Because regardless of what tends to work for some deployments it is
always good to give examples of what hasn't worked for others and was
non trivial to find out. This can save countless of hourse for other
people.
-- 
Michal Hocko
SUSE Labs
