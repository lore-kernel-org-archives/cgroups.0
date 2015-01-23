From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - "none"
Date: Fri, 23 Jan 2015 12:03:53 -0500
Message-ID: <20150123170353.GA12036@phnom.home.cmpxchg.org>
References: <1421508107-29377-1-git-send-email-hannes@cmpxchg.org>
 <20150120133711.GI25342@dhcp22.suse.cz>
 <20150120143002.GB11181@phnom.home.cmpxchg.org>
 <20150120143644.GL25342@dhcp22.suse.cz>
 <CAOS58YNZFuSP6cKLAkYKkK+QUDxwngnKE5UGHmAL7n3PygraaQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YNZFuSP6cKLAkYKkK+QUDxwngnKE5UGHmAL7n3PygraaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jan 20, 2015 at 12:00:11PM -0500, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 20, 2015 at 9:36 AM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> > On Tue 20-01-15 09:30:02, Johannes Weiner wrote:
> > [...]
> >> Another possibility would be "infinity",
> >
> > yes infinity definitely sounds much better to me.
> 
> FWIW, I prefer "max". It's shorter and clear enough. I don't think
> there's anything ambiguous about "the memory max limit is at its
> maximum". No need to introduce a different term.

While I don't feel too strongly, I do agree with this.  I don't see
much potential for confusion, and "max" is much shorter and sweeter.

Michal?
