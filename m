From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - "none"
Date: Tue, 20 Jan 2015 09:30:02 -0500
Message-ID: <20150120143002.GB11181@phnom.home.cmpxchg.org>
References: <1421508107-29377-1-git-send-email-hannes@cmpxchg.org>
 <20150120133711.GI25342@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150120133711.GI25342-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 20, 2015 at 02:37:11PM +0100, Michal Hocko wrote:
> On Sat 17-01-15 10:21:47, Johannes Weiner wrote:
> > The "none" name for the low-boundary 0 and the high-boundary maximum
> > value can be confusing.
> > 
> > Just leave the low boundary at 0, and give the highest-possible
> > boundary value the name "max" that means the same for controls.
> 
> max might be confusing as well because it matches with the knob name.
> max_resource or max_memory sounds better to me.

These names are appalling in the same way that memory.limit_in_bytes
is.  They are too long, while their information density is low.  They
make you type out the unit that should be painfully obvious to anybody
doing the typing.  And they still overlap with the knob name!

$ cat memory.max
max_memory

Really?

Another possibility would be "infinity", but tbh I think "max" is just
fine.  It's descriptive, the potential for confusion is low and easily
eliminated with documentation, and it's short and easy to type.

> Btw. I would separate page_counter_memparse change out and
> replace the original 'mm: page_counter: pull "-1" handling out of
> page_counter_memparse()' by it.

Yeah, that would probably make sense, but we can't do it incrementally
anymore.  Andrew, want me to resend these two patches with all fixes
incorporated?

Thanks!
