From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 10:52:42 -0400
Message-ID: <20160721145242.GB22680@htj.duckdns.org>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hbIetNlx9XRpGCuKlssVFOGqZI9f6rlwSPjV2STEtaE=;
        b=ID+SbTSOMGAcPv1kzLpb5StiSq0lrZOUukw/vP9RW5WVF6Pt5csnkvcftaogqJwoR+
         pjx61BHAg9K7PnX0XBg2OV4tzIYLApdmRSvanLRYxxyQLCEUViUQmoKWgphmcI0fM3Jm
         uoEnha3IrpUgiGPArh9oqGXqVnUcuBOQMNkNuZLbt0lADzza11A65sChB21prAJfgxiR
         nw8BS2F5hY9vK92KWvMZRdh0Ed0oe113YnXWCfr0LJw7Zqoi4TSZwTilCDORdyAFq0Rq
         nn+JAFJKR5C9vm/iJWBLHljuzKGFB9oB6xpNUs729vPVSMr9ApzGs+SzHA/pYweUg6ds
         +K7A==
Content-Disposition: inline
In-Reply-To: <379e5b13-29d4-ca75-1935-0a64f3db8d27-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Hello, Aleksa.

On Thu, Jul 21, 2016 at 05:49:36PM +1000, Aleksa Sarai wrote:
> > > The reason I'm doing this is so that we might be able to _practically_ use
> > > cgroups as an unprivileged user (something that will almost certainly be
> > > useful to not just the container crowd, but people also planning on using
> > > cgroups as advanced forms of rlimits).
> > 
> > I don't get why we need this fragile dance with permissions at all
> > when the same functionality can be achieved by delegating explicitly.
> 
> The key words being "unprivileged user". Currently, if I am a regular user
> on a system and I want to use the freezer cgroup to pause a process I am
> running, I have to *go to the administrator and ask them to give me
> permission to do that*. Why is that necessary? I find it quite troubling
> that the usecase of an ordinary user on a system trying to use something as
> useful as cgroups is considered to be "solved" by asking your administrator
> (or systemd) to do it for you. "Delegating explicitly" is punting on the
> problem, by saying "just get the administrator to do the setup for you".
> What if you don't have the opportunity to do that, and it takes you 4 weeks
> of sending emails for you to get the administrator to do _anything_?
> 
> This is something I'm trying to fix with my recent work with rootless
> containers (and quite a few other people are trying to fix it too).
> Currently we just simply can't do certain operations as an unprivileged user
> that would be possible *if we could just use cgroups*. Things like the
> freezer cgroup would be invaluable for containers, and I guarantee that the
> Chromium and Firefox folks would find it useful to be able to limit browser
> processes in a similar way.

I understand what you're trying to achieve but don't think cgroup's
filesystem interface can accomodate that.  To support that level of
automatic delegation, the API should be providing enough isolation so
that operations in one domain (user-specific operations) are
transparent from the other (system-wide administration), which simply
isn't true for cgroupfs.  As a simple example, imagine a process being
moved to another cgroup racing against the special operations you're
describing ahead.  Both sides are multi-step operations and there are
no ways of synchronizing against each other from kernel side and the
outcomes can easily be non-sensical.

It is unfortunate but we started with and are bound to carry the
current vfs based interface which was never designed to support the
use cases you're describing in a seamless way and that's why cgroup
supports explicit delegation so that userland can take over the
necessary coordination and implement more complex operations atop.

Thanks.

-- 
tejun
