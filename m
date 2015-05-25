From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
	leader is moved
Date: Mon, 25 May 2015 19:06:01 +0200
Message-ID: <20150525170601.GA438@redhat.com>
References: <20150520131044.GA28678@dhcp22.suse.cz> <20150520132158.GB28678@dhcp22.suse.cz> <20150520175302.GA7287@redhat.com> <20150520202221.GD14256@dhcp22.suse.cz> <20150521192716.GA21304@redhat.com> <20150522093639.GE5109@dhcp22.suse.cz> <20150522162900.GA8955@redhat.com> <20150522165734.GH5109@dhcp22.suse.cz> <20150522183042.GF26770@redhat.com> <20150525160626.GC19389@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150525160626.GC19389-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 05/25, Michal Hocko wrote:
>
> On Fri 22-05-15 20:30:42, Oleg Nesterov wrote:
> > On 05/22, Michal Hocko wrote:
> > >
> > > On Fri 22-05-15 18:29:00, Oleg Nesterov wrote:
> > > >
> > > > In the likely case (if CLONE_VM without CLONE_THREAD was not used) the
> > > > last for_each_process() in mm_update_next_owner() will find another thread
> > > > from the same group.
> > >
> > > My understanding was that for_each_process will iterate only over
> > > processes (represented by the thread group leaders).
> >
> > Yes. But note the inner for_each_thread() loop. And note that we
> > we need this loop exactly because the leader can be zombie.
>
> I was too vague, sorry about that.

Looks like, we confused each other somehow ;) Not sure I understand your
concerns...

But,

> What I meant was that
> for_each_process would pick up a group leader

Yes. In the case above it will find the caller (current) too,

> and the inner
> for_each_thread will return it as the first element in the list.

Yes, and this will be "current" task. But current->mm == NULL, so
for_each_thread() will continue and find another thread which becomes
the new mm->owner.

Just in case, note the BUG_ON(c == p). I think that BUG_ON(p->mm) at
the start will look much better. This is what mm_update_next_owner()
actually assumes.

Oleg.
