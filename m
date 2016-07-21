From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 08:16:34 -0700
Message-ID: <1469114194.2331.20.camel@HansenPartnership.com>
References: <20160718161816.13040-1-asarai@suse.de>
	 <20160718161816.13040-4-asarai@suse.de>
	 <20160720155147.GG4574@htj.duckdns.org>
	 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
	 <20160720230228.GA19588@mtj.duckdns.org>
	 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
	 <20160720231949.GB19588@mtj.duckdns.org>
	 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
	 <20160721145242.GB22680@htj.duckdns.org>
	 <1469113456.2331.16.camel@HansenPartnership.com>
	 <20160721150740.GF22680@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1469114196;
	bh=Gsy/FFQJWME2hltSwiVrLn2t+3yRXIhOQalGfhCXUfo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=iNBDb4ZFT+skivvOnx01GvA5He80j/TOPacFdXjejYItyzhTQarUqaaWorY7BdhVz
	 aMIXE/YKikOiEn6500o35LD5DC0/vindlNXAEOpCmZCOrf+30Y0E4Qm+hpUQYOfXrX
	 N/fuwZdcSz2u+uGiIi9cx+QXiY114XuJ3u/QuprY=
In-Reply-To: <20160721150740.GF22680-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

On Thu, 2016-07-21 at 11:07 -0400, Tejun Heo wrote:
> Hello, James.
> 
> On Thu, Jul 21, 2016 at 08:04:16AM -0700, James Bottomley wrote:
> > > I understand what you're trying to achieve but don't think 
> > > cgroup's filesystem interface can accomodate that.  To support 
> > > that level of automatic delegation, the API should be providing 
> > > enough isolation so that operations in one domain (user-specific 
> > > operations) are transparent from the other (system-wide 
> > > administration), which simply isn't true for cgroupfs.  As a 
> > > simple example, imagine a process being moved to another cgroup 
> > > racing against the special operations you're describing ahead. 
> > >  Both sides are multi-step operations and there are no ways of 
> > > synchronizing against each other from kernel side and the
> > > outcomes can easily be non-sensical.
> > 
> > So if I understand, it's not about actually moving the tasks: 
> > echoing the pid to the tasks file is atomic and we can mediate
> > races there.
 
> 
> Yeah, each operation is atomic but most meaningul operations are
> multi-step.
> 
> >  It's about the debris left behind if the admin (or someone with
> > delegated authority) moves the task to a wholly different cgroup.
> > 
> > Now we have a cgroup directory in the old cgroup, which the current
> > task has been removed from, for which the current user has 
> > permissions and could then move the task back to.  Is that the 
> > essence of the problem?
> 
> That'd be one side.  The other side is the one moving.  Let's say the
> system admin thing wants to move all processe from A proper to B.  It
> would do that by draining processes from A's procs file into B's and
> even that is multistep and can race.

So the second part is that once we allow the creation of
subdirectories, there's no unified tasks file, so there's no way of
draining A proper without enumerating and descending into the cgroupns
created subtrees in A?

James
