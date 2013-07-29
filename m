From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memcg creates an unkillable task in 3.2-rc2
Date: Mon, 29 Jul 2013 13:20:46 -0400
Message-ID: <20130729172046.GI22605@mtj.dyndns.org>
References: <20130723174711.GE21100@mtj.dyndns.org>
 <8761vui4cr.fsf@xmission.com>
 <20130729075939.GA4678@dhcp22.suse.cz>
 <87ehahg312.fsf@xmission.com>
 <20130729095109.GB4678@dhcp22.suse.cz>
 <20130729161026.GD22605@mtj.dyndns.org>
 <87r4eh70yg.fsf@xmission.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=X+X6m751JhhgDmyhmnQ45mNZN/WKhFWP41tJXsGen+I=;
        b=ez10jDvpdXriQbVqhmrUfMYPqyCXrRwXc5YIkR1UF5MxAi/X+ZqxWyd2hpxdJvl2Af
         oNrigQPQWzp++w5UsPsGK/1U0Cus9JLQBdsg0VNuBA7xz59AisfeKfgLaVGxXRkgfv+h
         vCMLaRcIx/YjRHwRCarBEnUlmX9M+rI3va83ORxygBhQIakG+9Ljx3IHnVgQCSA/2aJl
         y+e1NWdk9vlZ3M7GREqaAtofnrRIvtZVb0tajtNJvnTRMPa0kIHrz6IECUC2UbM2Xg7A
         t528LACmaX9epMVrlaDzrfTwOx3NzDBS0P3Ho/CdnlxApT1RWMSOTEYUYB69UKY6Tfur
         LMbQ==
Content-Disposition: inline
In-Reply-To: <87r4eh70yg.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hey, Eric.

On Mon, Jul 29, 2013 at 10:03:35AM -0700, Eric W. Biederman wrote:
> So this is not a simple matter of a frozen task not dying when SIGKILL
> is received.  For the most part not dying when SIGKILL is received seems
> like correct behavior for a frozne task.  Certainly it is correct
> behavior for any other signal.
> 
> The issue is that the tasks don't freeze or that when thawed the SIGKILL
> is still ignored.  It seems a wake up is being missed in there somewhere.

That's actually interesting and shouldn't be happening.  Can you
please provide more data as to what's going on while freezing?  It's
likely that the problem is not caused by freezer per-se, the task
might be stuck elsewhere and just fails to reach the freezing point.

Would it be possible for memcg and freezer to deadlock?  Note that
while freezing is in progress, some tasks will enter freezer earlier
than others (of course) and won't respond to anything.  If memcg adds
wait dependency among the tasks being frozen, it'll surely deadlock.

> A single unified hierarchy is a really nasty idea for the same set of
> reasons. You have to recompile to disable a controller to see if it that
> controller's bugs are what are causing problems on your production
> system.  Compiles or even just a reboot is a very heavy hammer to ask
> people to use when they are triaging a problem.

For Nth time, unified hierarchy doesn't mean all controllers are
enabled on all hierarchies or that controllers can't be bound and
unbound dynamically.  Except for the removal of orthogonal
hierarchies, things actually become a lot more dynamic.

> I am also seeing what looks like a leak somewhere in the cgroup code as
> well.  After some runs of the same reproducer I get into a state where
> after everything is clean up.  All of the control groups have been
> removed and the cgroup filesystem is unmounted, I can mount a cgroup
> filesystem with that same combindation of subsystems, but I can't mount
> a cgroup filesystem with any of those subsystems in any other
> combination.  So I am guessing that the superblock is from the original
> mounting is still lingering for some reason.

Hmmm... yeah, if there are cgroups with refs remaining, that'd happen.
Note that AFAIU memcg keeps the cgroups hangling around until all the
pages are gone from it, so it could just be that it's still draining
which may take a long time.  Maybe dropping cache would work?

Thanks.

-- 
tejun
