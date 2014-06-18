From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 00/12] mm: memcontrol: naturalize charge lifetime v3
Date: Wed, 18 Jun 2014 16:31:24 -0400
Message-ID: <20140618203124.GF7331@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <20140617163615.GD9572@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=scmFGUTPrhW1GxTTCaeZLzDWBPMtp8Az/lKFJRVLcRk=;
	b=JdnOl5OdiK+ho2vOWQ9lqe+aD4NAawOO20qn11mf2b2d1sfmEYMPBHKOX99Rr4GqJxm4/MmnZZ8luRHwtbkgaL3yee9h8b/WJAwa8xz+HOFvqQMKjvBwzB6kogEa1gqHk0zzbfEOb1ftCoGfcWRmFJzZd4dqNsBEyVgCeGtAPtk=;
Content-Disposition: inline
In-Reply-To: <20140617163615.GD9572-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 17, 2014 at 06:36:15PM +0200, Michal Hocko wrote:
> On Mon 16-06-14 15:54:20, Johannes Weiner wrote:
> > Hi,
> > 
> > this is v3 of the memcg charge naturalization series.  Changes since
> > v2 include:
> > 
> > o make THP charges use __GFP_NORETRY to prevent excessive reclaim (Michal)
> > o simplify move precharging while in the area
> > o add acks & rebase to v3.16-rc1
> 
> I still didn't get to the last two patches and they need a more
> throughout review. The rest is good and nice on its own and maybe it
> would be easier if those go in first.
> 
> I would like to get to the last two ASAP but this is heavier and I am
> quite swamped by other small tasks last weeks so I do not want to delay
> the whole series.

The merge window just opened so I don't think we are in an extreme
rush to get those in.

If you're worried about conflicts, I think the most potential for that
would be in the last two patches, so not much is saved in that regard
by taking the series apart.

I'm just going to resend the latest version with the acks you already
provided, and then Andrew can decide whether he wants to take the last
two as well right away, depending on testing and conflict resolution
preferences and on how optimistic he is that you'll agree with them ;)
