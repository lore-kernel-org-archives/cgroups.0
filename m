From: Glauber Costa <glommer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/11] cgroup: use percpu refcnt for cgroup_subsys_states
Date: Fri, 14 Jun 2013 18:15:12 +0400
Message-ID: <20130614141510.GA19021@localhost.localdomain>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
 <1371096298-24402-12-git-send-email-tj@kernel.org>
 <20130614125539.GC10084@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=5N2AeWCXayYpXCum6Q06/ofmO+Ubawb/WV/mqQqlbEA=;
        b=0OrYH/3+7ERNLv9Pt8LfydEUFMSA7hj1kSyqSWWirY8JT9nd6mm4Q2mU0jW9efuFTM
         Uqw4jRt+AWY+HHHvZDwkqQI8OZ/m02qJVrizQzEk2nhC9mnx8FJ6X6/SyufVhmjVkaUR
         0395u+V/Z8gOv4ElZZhdLfT23YCx1TUhqqNwpLxpGm/dBwNNc0aUAFNdzl07B3QlevGs
         MDXVcHVySj4oOfkdgaJW9136p0NvUdCpBqzfuXjbVs79QnAA+9VOZRksXrHxHucRuf44
         GFrFmmCacNYJeOcr8I2DzGgZtzji64TJs4t2x+fHgAK0qt/D0hQRmvWMKCIE0cGeJJnN
         oVSQ==
Content-Disposition: inline
In-Reply-To: <20130614125539.GC10084-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Alasdair G. Kergon" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Fri, Jun 14, 2013 at 02:55:39PM +0200, Michal Hocko wrote:
> On Wed 12-06-13 21:04:58, Tejun Heo wrote:
> [...]
> > +/**
> > + * cgroup_destroy_locked - the first stage of cgroup destruction
> > + * @cgrp: cgroup to be destroyed
> > + *
> > + * css's make use of percpu refcnts whose killing latency shouldn't be
> > + * exposed to userland and are RCU protected.  Also, cgroup core needs to
> > + * guarantee that css_tryget() won't succeed by the time ->css_offline() is
> > + * invoked.  To satisfy all the requirements, destruction is implemented in
> > + * the following two steps.
> > + *
> > + * s1. Verify @cgrp can be destroyed and mark it dying.  Remove all
> > + *     userland visible parts and start killing the percpu refcnts of
> > + *     css's.  Set up so that the next stage will be kicked off once all
> > + *     the percpu refcnts are confirmed to be killed.
> > + *
> > + * s2. Invoke ->css_offline(), mark the cgroup dead and proceed with the
> > + *     rest of destruction.  Once all cgroup references are gone, the
> > + *     cgroup is RCU-freed.
> > + *
> > + * This function implements s1.  After this step, @cgrp is gone as far as
> > + * the userland is concerned and a new cgroup with the same name may be
> > + * created.  As cgroup doesn't care about the names internally, this
> > + * doesn't cause any problem.
> 
> Glauber is this asumption correct for kmem caches naming scheme?
> I guess it should, but I would rather be sure this won't blow up later
> specially when caches might live longer than css_offline.
> 

We append names to caches, but never the name alone, always (kmemcg_id:name)
So you can reuse the same name as many times as you want (from the kmemcg
perspective), provided you use different kmemcg_ids. Because kmemcg_ids are
dissociated from css_ids (partly because I was already seeing people talking
about wanting to free the css_ids earlier), we should not have any problems
with this.

