From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 12:14:50 -0700
Message-ID: <20120626191450.GT3869@google.com>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-3-git-send-email-glommer@parallels.com>
 <20120626180451.GP3869@google.com>
 <20120626185542.GE27816@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=bHjo6VZO675KbVz92CRfH1uSia0r1WJtTfHKzg4/l0w=;
        b=i4BDb+KQ6EreYNvo7Qy14LTZjh/0JVl5CVFGobNZu+VcKT22+x77fUN5in2Tl2eES2
         ghB51GmI6GM9hBlGtUy6cL4eXEl7bNC5UAHYIwFctEDAv3aIism/ZCSIa+oQM4WRN1z1
         93OrsknzTYgCMPdDmcpmHl0mj0P/uONV4H169NUupIVLXLVe7ZVkjwiGpbRe+HSYwHeh
         IFzwDATCTC2/toFiKIuKAbVnpcKoTSm69uUZQax38gF4WMIUIecOKY1yQtQUclBS/kVt
         9CDzfhO3tpJJtsMjFEA24EeVNhKsw5+CaX8aTrLDIM+GxUnVw00TowrppN6if2fGbAyu
         v1yw==
Content-Disposition: inline
In-Reply-To: <20120626185542.GE27816-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Johannes.

On Tue, Jun 26, 2012 at 08:55:42PM +0200, Johannes Weiner wrote:
> > 2. Mark flat hierarchy deprecated and produce a warning message if
> >    memcg is mounted w/o hierarchy option for a year or two.
> 
> I think most of us assume that the common case is either not nesting
> directories or still working with hierarchy support actually enabled.

How do we know that?  At least from what I see from blkcg usage,
people do crazy stuff when given crazy interface and we've been
providing completely crazy interface for years.  We cannot switch that
implicitly - the changed default behavior is drastically different and
even could be difficult to chase down.  Transitions towards good
behavior are good but they have to be explicit.

> I would hate if people had to jump through hoops to get the only
> behaviour we want to end up supporting and to not get yelled at, it
> sends all the wrong signals.

It is inconvenient but that's the price that we have to pay for having
been stupid.  Kernel flipping behavior implicitly is far worse than
any such inconvenience.

These default behavior flips are something is better handled by
distros / admins than kernel itself.  They can orchestrate the
userland infrastructure and handle and communicate these flips far
better than kernel alone can do.  We can't send out mails to flat
hierarchy users after all.  That's the reason why I'm suggesting mount
option which can't be flipped (sans remount but that's going away too)
once the system is configured by the distro or admin.

The kernel should nudge mainline users towards new behavior while
providing distros / admins a way to move to the new behavior.  The
kernel itself can't flip it like that.

> > 3. After the existing users had enough chance to move away from flat
> >    hierarchy, rip out flat hierarchy code and error if hierarchy
> >    option is not specified.
> 
> This description sounds much more sane than what we are actually
> trying to ban, which is not a flat structure, but treating groups with
> nested directories as equal siblings.

Ah... yeah, flat hierarchy probably is the wrong way to describe it.
I don't know.  Superficial hierarchy?

Thanks.

-- 
tejun
