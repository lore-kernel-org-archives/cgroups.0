From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: gamer and memory bandwith control
Date: Mon, 25 Jan 2016 13:46:33 +0100
Message-ID: <20160125124633.GB23939@dhcp22.suse.cz>
References: <20160124195538.52826080@myPC>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160124195538.52826080@myPC>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitri Seletski <drjoms-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun 24-01-16 19:55:38, Dmitri Seletski wrote:
> Hello.
> 
> I don't usually start threads on major forum lists like this one.
> Pardon me if I do something silly or take your valuable time.(i do
> consider it to be valuable)
> 
> I am gamer and I was looking at opportunities to tweak performance
> while I do CPU extensive tasks while playing games.
> 
> My distro is Gentoo.
> When I install anything - it's compiled from source.
> My current compiler settings are '-j 20', since I have 8 core AMD cpu
> with 32 gigs of ram.. I tried to limit CPU usage so games that run in
> parallel don't have Frames Per Second drops - it didn't help.

It would be interesting to debug what is causing the FPS drop. Is the
application waiting for a memory allocation? /proc/PID/stack would tell
you. Regular (per second) snapshots of /proc/vmstat while you see the
FPS drops would be helpful to tell whether there was a disruptive memory
reclaim activity going on and a potential reason for drops.

> On Gentoo forum one of old guys suggested that I should limit memory
> bandwith from being  overused by compilation process. He suggested I
> look into cgroups.
> 
> I looked into it, but I don't see anything specific to limit memory
> bandwidth and some other settings available there, don't seem like
> something that would help me with memory bottleneck, or would it?

There is nothing like memory bandwidth control implemented via cgroups
subsystem. What you can try though is to use memory cgroup controller to
throttle application(s) (compilation in your case) to not push the whole
system under the global memory pressure and reduce the reclaim overhead
to the particular memory cgroup.
In other words start your compilation in a memory cgroup with the hard
limit set to such a value that your game (presumably the only other
significant memory consumer in the system) doesn't see the lack of
memory.
-- 
Michal Hocko
SUSE Labs
