From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/8] mm: clean up and clarify lruvec lookup procedure
Date: Tue, 22 Oct 2019 17:31:30 -0400
Message-ID: <20191022213130.GA361040@cmpxchg.org>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-3-hannes@cmpxchg.org>
 <20191022192456.GB11461@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=98G4icOId5gRa0BO3+NnJk8SaIphOMOAkR+jC8y01cM=;
        b=Kpeg9R3GFL4QkfZagosY6d53cYjLfU/55y5oiGy1mjM68ATS5EsPMC/b39+CZvdWeM
         8ibBRJ3iDRpWYJTRT5OE2MAc0HRbHMm595crY+xLwbBHRUMsTGMIbg0AntoeOMyUCt+/
         L8qKG9XzwfuKXthd76s7hR9+ewQIJGi5UyQFtq3Us7KZpuY4HdPH6MW0y0ZEnYa/9c63
         ZO4/9+L5Y1ZazxPGB0LMu0hJk9Ap/Z0UgVACp0+rsSjXaz0Ac+1uW4mdQ3ZHCdSPFPXm
         t7w3cYhZSB217CYGAzMq3ziGNwSN3kVFOgs5o5kvEn100lxhMNAhcgNpDaiAD2pOTogb
         u82Q==
Content-Disposition: inline
In-Reply-To: <20191022192456.GB11461@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 07:25:01PM +0000, Roman Gushchin wrote:
> On Tue, Oct 22, 2019 at 10:47:57AM -0400, Johannes Weiner wrote:
> > There is a per-memcg lruvec and a NUMA node lruvec. Which one is being
> > used is somewhat confusing right now, and it's easy to make mistakes -
> > especially when it comes to global reclaim.
> > 
> > How it works: when memory cgroups are enabled, we always use the
> > root_mem_cgroup's per-node lruvecs. When memory cgroups are not
> > compiled in or disabled at runtime, we use pgdat->lruvec.
> > 
> > Document that in a comment.
> > 
> > Due to the way the reclaim code is generalized, all lookups use the
> > mem_cgroup_lruvec() helper function, and nobody should have to find
> > the right lruvec manually right now. But to avoid future mistakes,
> > rename the pgdat->lruvec member to pgdat->__lruvec and delete the
> > convenience wrapper that suggests it's a commonly accessed member.
> 
> This part looks great!

Thanks!

> > While in this area, swap the mem_cgroup_lruvec() argument order. The
> > name suggests a memcg operation, yet it takes a pgdat first and a
> > memcg second. I have to double take every time I call this. Fix that.
> 
> Idk, I agree that the new order makes more sense (slightly), but
> such changes make any backports / git blame searches more complex.
> So, I'm not entirely convinced that it worth it. The compiler will
> prevent passing bad arguments by mistake.

Lol, this has cost me a lot of time since we've had it. It takes you
out of the flow while writing code and make you think about something
stupid and trivial.

The backport period is limited, but the mental overhead of a stupid
interface is forever!
