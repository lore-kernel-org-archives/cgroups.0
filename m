From: Dennis Zhou <dennisszhou@gmail.com>
Subject: Re: [PATCH 11/15] blkcg: remove additional reference to the css
Date: Thu, 6 Sep 2018 16:45:15 -0400
Message-ID: <20180906204514.GC26048@dennisz-mbp.dhcp.thefacebook.com>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-12-dennisszhou@gmail.com>
 <20180901002603.GI1488037@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z8m+mEIJj3McDnXqQOUT9a15bnp+tQ5IwmM7Yv0JRl4=;
        b=aplzBXnwlI76XyctZYm//zUKqdO0Bscy1fKttYicmoFaQIweIAaTwuYJ6c+e0908L9
         kj3CI+eX7NImufUT2SmVS5tdfW4DBXf6ywReEV49i/D7sScDWBL5doPRZ9gb/m7VHNvE
         JYw80XZL8ho9/N/usYHmK/IrhQ+Zhsx+MJB8IVCndw6/hKp5DBKUk2ZuCdfg1v7u7/yw
         31mtL7wGswKBa6DAyVairUnIdaCthkDGPSv59RhR2CN6SMNPtHdgBdvjWpUnKZw8GsuC
         Hu2lOoGuhjOooSiEVwgfCtsSCamYEOx4Ikactw0ntp9kEJDsz3d9AzvQZmycsBfgJBKH
         bTMg==
Content-Disposition: inline
In-Reply-To: <20180901002603.GI1488037@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Aug 31, 2018 at 05:26:03PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 30, 2018 at 09:53:52PM -0400, Dennis Zhou wrote:
> > -	css = cgroup_get_e_css(page->mem_cgroup->css.cgroup, &io_cgrp_subsys);
> >  
> > -	return __bio_associate_blkg_from_css(bio, css);
> > +	rcu_read_lock();
> > +
> > +	while (true) {
> > +		css = cgroup_e_css(page->mem_cgroup->css.cgroup,
> > +				   &io_cgrp_subsys);
> 
> So, while they seem similar cgroup_e_css() and cgroup_get_e_css()
> behave very differently in terms of locking.  cgroup_e_css() can only
> be used under cgroup_mutex because it is used during migration and has
> to test cgroup_ss_mask().  The right thing to do here would be
> renaming cgroup_e_css() to something else and add a new implementation
> which operates in the same way as cgroup_get_e_css().
> 
> BTW, this should have triggered lockdep warning.  I'd strongly
> recommend testing with lockdep enabled.
> 
> Other than that, looks good to me.
> 

I see. I've renamed the original cgroup_e_css() to
cgroup_e_css_by_mask() and then did what cgroup_get_e_css() did without
the get part in the new cgroup_e_css().

Thanks,
Dennis
