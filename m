From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH memcg v3 3/3] memcg: prohibit unconditional exceeding the
 limit of dying tasks
Date: Fri, 29 Oct 2021 09:58:59 +0200
Message-ID: <YXupw761Qtoppm7X@dhcp22.suse.cz>
References: <YXJ/63kIpTq8AOlD@dhcp22.suse.cz>
 <cover.1634994605.git.vvs@virtuozzo.com>
 <8f5cebbb-06da-4902-91f0-6566fc4b4203@virtuozzo.com>
 <YXZ6qaMJBomVfV8O@dhcp22.suse.cz>
 <20211027153608.9910f7db99d5ef574045370e@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635494341; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=odAS8sgFS/yEmejWu7NJNIJLSMk/FVvAVCyrDC5g/Vg=;
        b=tARIzmNRgXCWQw3SqRLM4bM+8BOcV8c26nHWRLEbv5UMpbdC7IM8l2j7fKveYfhp8gG/iF
        tL/wlOiibrOaSq6rbrbEhp+7ap7CV2JAwrJiJ+pLBlJWmNVycJdhoPNUXMPhRQ8IatfB+z
        dZSPt9wxYTmhbIxaU8JZj6jUv5ulxIg=
Content-Disposition: inline
In-Reply-To: <20211027153608.9910f7db99d5ef574045370e-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

On Wed 27-10-21 15:36:08, Andrew Morton wrote:
> On Mon, 25 Oct 2021 11:36:41 +0200 Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > My view on stable backport is similar to the previous patch. If we want
> > to have it there then let's wait for some time to see whether there are
> > any fallouts as this patch depends on the PF_OOM change.
> 
> It's strange that [1/3] doesn't have cc:stable, but [2/3] and [3/3] do
> not.  What is the thinking here?
> 
> I expect we'd be OK with merging these into 5.16-rc1.  This still gives
> another couple of months in -rc to shake out any problems.  But I
> suspect the -stable maintainers will merge and release the patches
> before they are released in 5.16.
> 
> In which case an alternative would be not to mark these patches
> cc:stable and to somehow remember to ask the -stable maintainers to
> merge them after 5.16 has been on the streets for a suitable period.

My take on stable backports is http://lkml.kernel.org/r/YXZ6FMzJLEz4TA2d-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
-- 
Michal Hocko
SUSE Labs
