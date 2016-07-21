From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 11:16:42 -0700
Message-ID: <1469125002.2331.54.camel@HansenPartnership.com>
References: <20160720230228.GA19588@mtj.duckdns.org>
	 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
	 <20160720231949.GB19588@mtj.duckdns.org>
	 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
	 <20160721145242.GB22680@htj.duckdns.org>
	 <1469113456.2331.16.camel@HansenPartnership.com>
	 <20160721150740.GF22680@htj.duckdns.org>
	 <1469114194.2331.20.camel@HansenPartnership.com>
	 <20160721152648.GA23759@htj.duckdns.org>
	 <1469115276.2331.23.camel@HansenPartnership.com>
	 <20160721155046.GB23759@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1469125004;
	bh=HCf+a8US+zJ7gHRwTANB7BQLGbjd9l14igSTHtKUU0E=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=qsY1mGqgfkYEI2jBNhzCJoIGYgZ2BvfsvoKmWopbC0TQTm4ACulFbMZ6WrYsnRR0A
	 rzsG61nD7qZ5i90VpVTJktxe0HUlJbnZyGFTEjbsunSmK7KNlGo87uJeiVxrfyEVwA
	 8/xXvXM+LCYVJZFD27c5xrIwb/WgErBs3Xpv0HTk=
In-Reply-To: <20160721155046.GB23759-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

On Thu, 2016-07-21 at 11:50 -0400, Tejun Heo wrote:
> Hello, James.
> 
> On Thu, Jul 21, 2016 at 08:34:36AM -0700, James Bottomley wrote:
> > So if I as the cgroup ns owner am moving a task from A to A_subdir, 
> > the admin scanning tasks in all of A may miss this task in motion
> > because all the tasks files can't be scanned atomically?
> 
> So, the admin just wants to move processes from A and only A to B. 
>  It doesn't wanna interfere with processes in the subdirs or on-going 
> ns operations, but if the race occurs, both A -> B migration and ns
> subdir operation would succeed and the end result would be something
> neither expects.

OK so a theoretical (not saying it's implementable, we'll have to
explore that) way of fixing all of this is to have separate views of
the tree.  If the admin always saw everything in A, even if the
cgroupns had created subdirectories in its own namespace.  That way
there'd be no race ever in the admin's view (because it's the view they
created and would expect to see).  All sub cgroup activity would only
be visible to tasks in the new cgroupns (we'd probably have to have
them make this visible by mounting a new cgroup tree).

James



