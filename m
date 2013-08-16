From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Fri, 16 Aug 2013 12:02:04 -0400
Message-ID: <20130816160204.GE7878@redhat.com>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
 <20130815195941.GA10977@mtj.dyndns.org>
 <20130815204804.GO7878@redhat.com>
 <20130815210937.GB10977@mtj.dyndns.org>
 <20130816152025.GC7878@redhat.com>
 <20130816154757.GG2505@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130816154757.GG2505-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

Hi Tejun,
On Fri, Aug 16, 2013 at 11:47:57AM -0400, Tejun Heo wrote:
> On Fri, Aug 16, 2013 at 11:20:26AM -0400, Aristeu Rozanski wrote:
> > > e.g. if a cgroup will be allowed to be moved to another position in
> > > the hierarchy, the cgroup shouldn't change its configuration across
> > > such migration, right?  If so, we'd be allowing creating a cgroup
> > > outside the hierarchy with any configuration moving it under another
> > > while disallowing creating it under there and creating the same
> > > configuration, which would be an outright buggy behavior.
> > 
> > Hm, then I think I got the requirements wrong. On my understanding you
> > cannot have a cgroup with more access than its parent. And the reason
> > for that is at that time the idea of having a container able to control
> > its own hierarchy was valid.
> 
> Oh yes, sure, a descendant shouldn't have access to devices which
> aren't allowed by its ancestors but that doesn't mean it can't have a
> rule to allow such access.  It just wouldn't make any difference at
> that point.  If the ancestors later change the configuration such that
> the device is allowed, the cgroup will have access to that
> automatically.  Rules configured and rules being applied need to be
> distinguished and the latter doesn't need to affect the former.
> 
> > The way it is right now, when moved, a cgroup would have its active
> > rules re-checked for permission and it'd be made an attempt to apply
> > local rules if the new parent allows it.
> 
> Yeah, that's the correct behavior, if I'm not misunderstanding you,
> but to be consistent we also need to allow creating rules which allow
> devices which aren't allowed by ancestors.  It won't be applicable at
> rule creation but may later become effective later on.

Oh, I see, it's just matter of allowing to set the desired set or rules
locally even if they're not possible at the moment.

So, considering we drop in sane_behavior the allow + exceptions case,
the interface in sane_behavior mode would look like:
- policy: {allow_all,deny}
	writing either will clear the active aw
- active_whitelist
	list of in effect rules, read only
- whitelist
	list of locally set rules, read only
- whitelist_add
	write only, adds rule to the local list and active lists
- whitelist_remove
	write only, removes rule from the local and active lists

What you think?

-- 
Aristeu
