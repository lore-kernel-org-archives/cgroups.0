From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: add cgroup.signal
Date: Wed, 28 Apr 2021 11:12:57 -0700
Message-ID: <YImlqYSpkAD4uaxG@carbon.dhcp.thefacebook.com>
References: <20210423171351.3614430-1-brauner@kernel.org>
 <YIcOZEbvky7hGbR1@blackbook>
 <20210427093606.kygcgb74otakofes@wittgenstein>
 <YIgfrP5J3aXHfM1i@slm.duckdns.org>
 <20210428143746.p6tjwv6ywgpixnjy@wittgenstein>
 <YImHjGGuIt0ebL0G@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dsHrC0BjbEnRdj2iXri5RWr++ZEC426Y3RuW5qu1hgM=;
 b=iGEfniD9ISsp+l1d1HNw83p1ywSYMBAf8xvMCkGDI0IJ0ZOn1K5kg2riN7exJwNhXxvW
 KOTrAPxUJfE0OOFY0V5/puJWXK2ChqfDIOt6SqwquOdYLXYUds8aXDb11w90BIBiBE0f
 1EIYd3jTV844sY13kyWloD5l8sdUpN0a0Xc= 
Content-Disposition: inline
In-Reply-To: <YImHjGGuIt0ebL0G-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Apr 28, 2021 at 12:04:28PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 28, 2021 at 04:37:46PM +0200, Christian Brauner wrote:
> > > I'd align it with cgroup.procs. Killing is a process-level operation (unlike
> > > arbitrary signal delivery which I think is another reason to confine this to
> > > killing) and threaded cgroups should be invisible to process-level
> > > operations.
> > 
> > Ok, so we make write to cgroup.kill in threaded cgroups EOPNOTSUPP which
> > is equivalent what a read on cgroup.procs would yield.
> 
> Sounds good to me.
> 
> > Tejun, Roman, Michal, I've been thinking a bit about the escaping
> > children during fork() when killing a cgroup and I would like to propose
> > we simply take the write-side of threadgroup_rwsem during cgroup.kill.
> > 
> > This would give us robust protection against escaping children during
> > fork() since fork()ing takes the read-side already in cgroup_can_fork().
> > And cgroup.kill should be sufficiently rare that this isn't an
> > additional burden.
> > 
> > Other ways seems more fragile where the child can potentially escape
> > being killed. The most obvious case is when CLONE_INTO_CGROUP is not
> > used. If a cgroup.kill is initiated after cgroup_can_fork() and after
> > the parent's fatal_signal_pending() check we will wait for the parent to
> > release the siglock in cgroup_kill(). Once it does we deliver the fatal
> > signal to the parent. But if we haven't passed cgroup_post_fork() fast
> > enough the child can be placed into that cgroup right after the kill.
> > That's not super bad per se since the child isn't technically visible in
> > the target cgroup anyway but it feels a bit cleaner if it would die
> > right away. We could minimize the window by raising a flag say CGRP_KILL
> > say:
> 
> So, yeah, I wouldn't worry about the case where migration is competing
> against killing. The order of operations simply isn't defined and any
> outcome is fine. As for the specific synchronization method to use, my gut
> feeling is whatever which aligns better with the freezer implementation but
> I don't have strong feelings otherwise. Roman, what do you think?

I'd introduce a CGRP_KILL flag and check it in cgroup_post_fork(), similar
to how we check CGRP_FREEZE. That would solve the problem with a forking bomb.
Migrations and kills are synchronized via cgroup_mutex. So we guarantee
that all tasks (and their descendants) that were in the cgroup at the moment
when a user asked to kill the cgroup will die. Tasks moved into the cgroup
later shouldn't be killed.

Thanks!
