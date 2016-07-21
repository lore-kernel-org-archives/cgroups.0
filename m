From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 08:04:16 -0700
Message-ID: <1469113456.2331.16.camel@HansenPartnership.com>
References: <20160718161816.13040-1-asarai@suse.de>
	 <20160718161816.13040-4-asarai@suse.de>
	 <20160720155147.GG4574@htj.duckdns.org>
	 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
	 <20160720230228.GA19588@mtj.duckdns.org>
	 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
	 <20160720231949.GB19588@mtj.duckdns.org>
	 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
	 <20160721145242.GB22680@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1469113458;
	bh=48fmbNso4MHSWWT1hzjaMzxCm6eEYV70OIqQQdhuo8U=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=woVk4zukd4H/pihWbhSvjuUI9ZSRERS6L7iaTf2J9HOkQh2IKVgkaFpg2DulUSipq
	 9HfotUxO2Hp/fDeRZHGqpD9bhkUNkmi1EtJvIysgWSXC+K/SKSNQZvZxS9cM1zOa/0
	 osEZF1pX/be/kvmuWFH6qn0gahZYG6LEM0lxB6gs=
In-Reply-To: <20160721145242.GB22680-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

On Thu, 2016-07-21 at 10:52 -0400, Tejun Heo wrote:
> Hello, Aleksa.
> 
> On Thu, Jul 21, 2016 at 05:49:36PM +1000, Aleksa Sarai wrote:
> > > > The reason I'm doing this is so that we might be able to 
> > > > _practically_ use cgroups as an unprivileged user (something 
> > > > that will almost certainly be useful to not just the container 
> > > > crowd, but people also planning on using cgroups as advanced
> > > > forms of rlimits).
> > > 
> > > I don't get why we need this fragile dance with permissions at 
> > > all when the same functionality can be achieved by delegating
> > > explicitly.
> > 
> > The key words being "unprivileged user". Currently, if I am a 
> > regular user on a system and I want to use the freezer cgroup to 
> > pause a process I am running, I have to *go to the administrator 
> > and ask them to give me permission to do that*. Why is that 
> > necessary? I find it quite troubling that the usecase of an 
> > ordinary user on a system trying to use something as useful as 
> > cgroups is considered to be "solved" by asking your administrator
> > (or systemd) to do it for you. "Delegating explicitly" is punting 
> > on the problem, by saying "just get the administrator to do the 
> > setup for you". What if you don't have the opportunity to do that, 
> > and it takes you 4 weeks of sending emails for you to get the 
> > administrator to do _anything_?
> > 
> > This is something I'm trying to fix with my recent work with 
> > rootless containers (and quite a few other people are trying to fix 
> > it too). Currently we just simply can't do certain operations as an
> > unprivileged user that would be possible *if we could just use 
> > cgroups*. Things like the freezer cgroup would be invaluable for 
> > containers, and I guarantee that the Chromium and Firefox folks 
> > would find it useful to be able to limit browser processes in a
> > similar way.
> 
> I understand what you're trying to achieve but don't think cgroup's
> filesystem interface can accomodate that.  To support that level of
> automatic delegation, the API should be providing enough isolation so
> that operations in one domain (user-specific operations) are
> transparent from the other (system-wide administration), which simply
> isn't true for cgroupfs.  As a simple example, imagine a process 
> being moved to another cgroup racing against the special operations 
> you're describing ahead.  Both sides are multi-step operations and 
> there are no ways of synchronizing against each other from kernel 
> side and the outcomes can easily be non-sensical.

So if I understand, it's not about actually moving the tasks: echoing
the pid to the tasks file is atomic and we can mediate races there. 
 It's about the debris left behind if the admin (or someone with
delegated authority) moves the task to a wholly different cgroup.

Now we have a cgroup directory in the old cgroup, which the current
task has been removed from, for which the current user has permissions
and could then move the task back to.  Is that the essence of the
problem?

James
