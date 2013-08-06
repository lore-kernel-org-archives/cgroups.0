From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Date: Tue, 6 Aug 2013 17:58:04 +0200
Message-ID: <20130806155804.GC31138@dhcp22.suse.cz>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <20130805160107.GM10146@dhcp22.suse.cz>
 <20130805162958.GF19631@mtj.dyndns.org>
 <20130805191641.GA24003@dhcp22.suse.cz>
 <20130805194431.GD23751@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130805194431.GD23751-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 05-08-13 15:44:31, Tejun Heo wrote:
> Hey, Michal.
> 
> On Mon, Aug 05, 2013 at 09:16:41PM +0200, Michal Hocko wrote:
[...]
> > Besides that, is fsnotify really an interface to be used under memory
> > pressure? I might be wrong but from a quick look fsnotify depends on
> > GFP_KERNEL allocation which would be no-go for oom_control at least.
> 
> Yeap, I'm pretty sure you're wrong.  I didn't follow the development
> but this is wrapper to combine inotify and dnotify and kernel's main
> FS event mechanism and none of the two mechanisms required memory
> allocation during delivery.

I might be really wrong here (I see memory allocations down the
fsnotify_modify callpath) but this is totally irrelevant to the
patchset.

If there is a better interface in the future then I have no objection
to move to it and keep the old one just for legacy usage for certain
amount of time. I am definitely not arguing for eventfd being the best
interface.

I am objecting to moving the generic part of that code into memcg. The
memcg part and the additional complexity (all the parsing and conditions
for signalling) is already in the memcg code.
 
> > How does the reclaim context gets to struct file to notify? I am pretty
> > sure we would get to more and more questions when digging further.
> 
> The file is optional and probably just to extract path for dnotify, I
> think.  Not sure about namespace implications but I'll build cgroup
> level interface for it so that controllers won't have to deal with it
> directly.  ie. there'll be css_notify_file(css, cfe) interface.

Such an interface would be really welcome but I would also ask how
it would implement/allow context passing. E.g. how do we know which
treshold has been reached? How do we find out the vmpressure level? Is
the consumer supposed to do an additional action after it gets
notification?
Etc.

> > I am all for simplifications, but removing interfaces just because you
> > feel they are "over-done" is not a way to go IMHO. In this particular
> 
> We can keep it around but it's a pretty good time to gradually move
> towards something saner as we're essentially doing v2 of the
> interface.  Note that there's no reason for the interface to disappear
> immediately.  You can keep it and there won't be any problem for it to
> co-exist with simpler mechanism.

Yes that is an expectation of the users...

> > case you are removing an interface from cgroup core which has users,
> > and will have to support them for very long time. "It is just memcg
> > so move it there" is not a way that different subsystems should work
> > together and I am _not_ going to ack such a move. All the flexibility that
> > you are so complaining about is hidden from the cgroup core in register
> > callbacks and the rest is only the core infrastructure (registration and
> > unregistration).
> 
> memcg is the only user and will stay that way.  If you wanna keep it
> around, be my guest.

OK, so why do you move the generic part to the memcg then?

> Also, cftype is planned to be simplified so that
> it just provides seq_file interface and the types become helper
> routines like a normal file callback interface.  There'll be nothing
> tying the event file handling to cgroup core and it surely won't be
> used by anyone else.  memcg is and will be the only user.  It's the
> natural place for the code.

Really that natural? So memcg should touch internals like cgroup dentry
reference counting. You seem have forgotten all the hassles with
cgroup_mutex, haven't you?
No that part doesn't belong to memcg! You can discourage from new usage
of this interface of course.
-- 
Michal Hocko
SUSE Labs
