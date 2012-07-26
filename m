From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Devel] Re: containers and cgroups mini-summit @ Linux Plumbers
Date: Thu, 26 Jul 2012 12:44:41 -0700
Message-ID: <20120726194441.GB25660@google.com>
References: <4FFDF321.4030103@openvz.org>
 <500FD022.6000608@parallels.com>
 <877gtr6uo5.fsf@xmission.com>
 <50110AE6.2080701@parallels.com>
 <50110D53.2090407@parallels.com>
 <874nou6bx1.fsf@xmission.com>
 <20120726181528.GA25660@google.com>
 <87a9ymwcsv.fsf@xmission.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CqdNwoP+1WX2bBQyw13ipvrkvUuHvyR/tFCIrXf3YBw=;
        b=jwPNA0zWYeAhazMd4mn7/gWEAuLsUW5tmvTncJ8qOBO6RdSEzNdcu3zzBlypOwpy34
         ti3LZB4U7MP7ZIcYR8swg0eBm7PTvftgk2k0naVh2DWkH01sQA49ik1R7ZCReAklr7pA
         93UMhUFd4a7tKelUGb9QTtqnn30UN/V4QIChVhH/5z44vkup2ZMCfMtTMuGZe936YrcC
         pLrobP5DbagDmqK/o/SRj0NjbLb4exNwbB6tKyjl8mPsAoKiyjDBBdn68bbtrgH8fXkI
         89KdVlHZZX9/qcG0B/s7PooJ+seZdrc1TzAWAxMirwAlXPyW+E5k/yrO6goF2XDUI4Ii
         lYBw==
Content-Disposition: inline
In-Reply-To: <87a9ymwcsv.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Suleiman-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>, Dave Kleikamp <dave.kleikamp-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Maxim-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Rohit Seth <rohitseth-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Patlasov <MPatlasov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Hey, Eric.

On Thu, Jul 26, 2012 at 12:19:12PM -0700, Eric W. Biederman wrote:
> > No, any attempt to build namespace support into cgroup core code will
> > be nacked with strong prejudice.
> 
> The cgroup code was only merged with the understanding that this support
> was simple to add and it would be added.  I am sorry that no one had
> the sense to follow up and make certain that promise was not fullfilled.

Good chunk of cgroup is messy and I'm likely to continue to break a
lot of whatever promises that have been made. :)

> > Thankfully, procfs is going the FUSE way.
> 
> No procfs is not going the FUSE way.  Hacks for programs that misuse
> information in procfs is going the FUSE way.

All those were proposed to be solved by "teaching" kernel procfs how
to present itself differently.

> The best example is there currently is not a good method for programs
> to figure out how parellel it is productive to be so the programs
> read /proc/cpuinfo and get the count of cpus.  Control groups can
> limit you to fewer cpus but those programs have figured that out yet.

Yeah, and you can handle that too nicely with FUSE.  More on this
later.

> But ultimately fuse for procfs is about the rare case where people
> want to lie to applications, because it is easier to lie to applications
> then to disabuse the applications of their mistaken asumptions.

I don't think so.  They are necessary parts of representing a properly
scoped environment.

> I have not seen a single suggest that any of the other procfs bits
> can go away.

I think I made that a couple times now.  I definitely intend to push
things that way.  Or, at least, I'll bark as hard as I can against
adding more namespace stuff to system pseudo filesystems.

> > and I hope in time we could convert sysfs to a similar mechanism and
> > deprecate the in-kernel support.
> 
> I have nothing that even suggests there is a reasonable possibility of
> using fuse to deprecate any of the proc or sysfs support.

Why not?  If there's some deficiency in FUSE or notification
mechanisms in pseudo FSes, let's fix them.

> > So, no, no, no, no, no, no, no, no, no, no, no, no. :P
> 
> Bahahahahahahaha! :P

:)

> I sort of wish I had the energy to tackle this.  As it is control groups
> hierarchies have very severe usablilty problems supporting one of their
> core use cases.
> 
> We should have our interfaces designed such that it is possible to run
> nested init's without hacks, and the only significant piece left on the
> hacks pile is control groups.
> 
> Control group hiearchies are are really strange piece of work whose
> design makes very little sense to me.

cgroupfs is riddled with confused designs but this is not it.  The
confusion is that namespace should play a major role in the design of
system pseudo filesystems and that it can be achieved by playing
peekaboo with dentries.

It obfuscates the code for niche use case - which in itself could be
acceptable if that's the only / best way to achieve that - while not
even being able to serve the said use case properly.

Thanks.

-- 
tejun
