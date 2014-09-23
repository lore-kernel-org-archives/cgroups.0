From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: support transparent huge pages under
 pressure
Date: Tue, 23 Sep 2014 15:44:38 +0400
Message-ID: <20140923114438.GI18526@esperanza>
References: <1411132840-16025-1-git-send-email-hannes@cmpxchg.org>
 <xr934mvykgiv.fsf@gthelen.mtv.corp.google.com>
 <20140923082927.GG18526@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140923082927.GG18526@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 23, 2014 at 12:29:27PM +0400, Vladimir Davydov wrote:
> On Mon, Sep 22, 2014 at 10:52:50PM -0700, Greg Thelen wrote:
> > In this condition, if res usage is at limit then there's no point in
> > swapping because memsw.usage is already maximal.  Prior to this patch
> > I think the kernel did the right thing, but not afterwards.
> > 
> > Before this patch:
> >   if res.usage == res.limit, try_charge() indirectly calls
> >   try_to_free_mem_cgroup_pages(noswap=true)
> 
> But this is wrong. If we fail to charge res, we should try to do swap
> out along with page cache reclaim. Swap out won't affect memsw.usage,
> but will diminish res.usage so that the allocation may succeed.

Oops, I missed your point, sorry. If we hit the res.limit and
memsw.limit=res.limit, we automatically hit memsw.limit too, so there's
no point swapping out.

Thanks,
Vladimir
