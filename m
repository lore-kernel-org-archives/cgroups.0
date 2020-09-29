From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Tue, 29 Sep 2020 17:53:41 -0400
Message-ID: <20200929215341.GA408059@cmpxchg.org>
References: <20200909215752.1725525-1-shakeelb@google.com>
 <20200928210216.GA378894@cmpxchg.org>
 <20200929150444.GG2277@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FOJfgf8q5Mwbkl+Uuxbz5zw63i2IkJ9zeF69lh8BTRA=;
        b=Cr1SusruU/siOv5odz2uDawXx3M2StkgpuCnAfnW6HeoN6hGhWlHDj0Yuw8UVH1Sw8
         1GksVWMUs9+v3GTJ+CdJFW7c3cyp9UT0YgqAsJVVL0EFAJKzQmQAKEDlrRRseCqcWspc
         tQN6sxfbzuOQHvS72lZipUN50ZmCvCRqvFbqadYvW4fF7O0sOZb56yY7FSTYeK2R+svl
         EuS9bScs+RhmVHwEn5TpHkQkoddIsO9ZvR063nCXbeiJCp5UNoEce3QhpuikWgitu7y3
         rxtpIYYrTAr9jd80q3mlD0gy05vvCC3Kst+DbBLaWhazqWQ6J9IOpCLDpzzRY+clkJMN
         FXBg==
Content-Disposition: inline
In-Reply-To: <20200929150444.GG2277-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 29, 2020 at 05:04:44PM +0200, Michal Hocko wrote:
> On Mon 28-09-20 17:02:16, Johannes Weiner wrote:
> [...]
> > My take is that a proactive reclaim feature, whose goal is never to
> > thrash or punish but to keep the LRUs warm and the workingset trimmed,
> > would ideally have:
> > 
> > - a pressure or size target specified by userspace but with
> >   enforcement driven inside the kernel from the allocation path
> > 
> > - the enforcement work NOT be done synchronously by the workload
> >   (something I'd argue we want for *all* memory limits)
> > 
> > - the enforcement work ACCOUNTED to the cgroup, though, since it's the
> >   cgroup's memory allocations causing the work (again something I'd
> >   argue we want in general)
> > 
> > - a delegatable knob that is independent of setting the maximum size
> >   of a container, as that expresses a different type of policy
> > 
> > - if size target, self-limiting (ha) enforcement on a pressure
> >   threshold or stop enforcement when the userspace component dies
> > 
> > Thoughts?
> 
> Agreed with above points. What do you think about
> http://lkml.kernel.org/r/20200922190859.GH12990-2MMpYkNvuYA6bu5BqYkRsg@public.gmane.org

I definitely agree with what you wrote in this email for background
reclaim. Indeed, your description sounds like what I proposed in
https://lore.kernel.org/linux-mm/20200219181219.54356-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org/
- what's missing from that patch is proper work attribution.

> I assume that you do not want to override memory.high to implement
> this because that tends to be tricky from the configuration POV as
> you mentioned above. But a new limit (memory.middle for a lack of a
> better name) to define the background reclaim sounds like a good fit
> with above points.

I can see that with a new memory.middle you could kind of sort of do
both - background reclaim and proactive reclaim.

That said, I do see advantages in keeping them separate:

1. Background reclaim is essentially an allocation optimization that
   we may want to provide per default, just like kswapd.

   Kswapd is tweakable of course, but I think actually few users do,
   and it works pretty well out of the box. It would be nice to
   provide the same thing on a per-cgroup basis per default and not
   ask users to make decisions that we are generally better at making.

2. Proactive reclaim may actually be better configured through a
   pressure threshold rather than a size target.

   As per above, the goal is not to be punitive or containing. The
   goal is to keep the LRUs warm and move the colder pages to disk.

   But how aggressively do you run reclaim for this purpose? What
   target value should a user write to such a memory.middle file?

   For one, it depends on the job. A batch job, or a less important
   background job, may tolerate higher paging overhead than an
   interactive job. That means more of its pages could be trimmed from
   RAM and reloaded on-demand from disk.

   But also, it depends on the storage device. If you move a workload
   from a machine with a slow disk to a machine with a fast disk, you
   can page more data in the same amount of time. That means while
   your workload tolerances stays the same, the faster the disk, the
   more aggressively you can do reclaim and offload memory.

   So again, what should a user write to such a control file?

   Of course, you can approximate an optimal target size for the
   workload. You can run a manual workingset analysis with page_idle,
   damon, or similar, determine a hot/cold cutoff based on what you
   know about the storage characteristics, then echo a number of pages
   or a size target into a cgroup file and let kernel do the reclaim
   accordingly. The drawbacks are that the kernel LRU may do a
   different hot/cold classification than you did and evict the wrong
   pages, the storage device latencies may vary based on overall IO
   pattern, and two equally warm pages may have very different paging
   overhead depending on whether readahead can avert a major fault or
   not. So it's easy to overshoot the tolerance target and disrupt the
   workload, or undershoot and have stale LRU data, waste memory etc.

   You can also do a feedback loop, where you guess an optimal size,
   then adjust based on how much paging overhead the workload is
   experiencing, i.e. memory pressure. The drawbacks are that you have
   to monitor pressure closely and react quickly when the workload is
   expanding, as it can be potentially sensitive to latencies in the
   usec range. This can be tricky to do from userspace.

   So instead of asking users for a target size whose suitability
   heavily depends on the kernel's LRU implementation, the readahead
   code, the IO device's capability and general load, why not directly
   ask the user for a pressure level that the workload is comfortable
   with and which captures all of the above factors implicitly? Then
   let the kernel do this feedback loop from a per-cgroup worker.
