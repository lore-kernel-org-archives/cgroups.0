From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: default hierarchy interface for memory
 fix - high reclaim
Date: Tue, 20 Jan 2015 10:44:56 -0500
Message-ID: <20150120154456.GA7130@phnom.home.cmpxchg.org>
References: <1421508079-29293-1-git-send-email-hannes@cmpxchg.org>
 <20150120132519.GH25342@dhcp22.suse.cz>
 <20150120141628.GA11181@phnom.home.cmpxchg.org>
 <20150120143119.GK25342@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150120143119.GK25342-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 20, 2015 at 03:31:19PM +0100, Michal Hocko wrote:
> On Tue 20-01-15 09:16:28, Johannes Weiner wrote:
> > On Tue, Jan 20, 2015 at 02:25:19PM +0100, Michal Hocko wrote:
> [...]
> > > Is this planned to be folded into the original patch or go on its own. I
> > > am OK with both ways, maybe having it separate would be better from
> > > documentation POV.
> > 
> > I submitted them to be folded in.  Which aspect would you like to see
> > documented?
> 
> That the excess target reclaim has been attempted and changed with a
> patch which explains why. So this was kind of "git log as a
> documentation" thing.

I agreed to soften it because you had reasonable concerns and it was
still strong enough for my tests.  But we hardly "attempted" this
version.  Should this turn out to be too weak for other users in
practice we have to reconsider the stronger approach and actually put
your theory to the test and see if it holds up in practice.  There is
no knowledge to record at this point, we just have speculation and no
real need to push the envelope right now.
