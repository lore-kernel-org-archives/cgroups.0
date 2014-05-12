From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Date: Mon, 12 May 2014 11:25:07 -0400
Message-ID: <20140512152507.GD1421@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
 <20140512145803.GF9564@dhcp22.suse.cz>
 <20140512150014.GB1421@htj.dyndns.org>
 <20140512152015.GH9564@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vIrZb8Y9Wavtv0pdg32M/LW5CLh1isP+Cj31JwmWnkc=;
        b=YmZ2xcmaBwkKcD+E//Qqjn+f5qbiRM4k2cScSi7TdptAszivwGgNKQ/IBXp/CSw5oC
         nwFsZ9ImYe+pFz8CZlLf5a9z4r1Z6hcA2DxuUURXOBgeX7uEyhEl/7NycuEiRD+zpwUN
         d2+Sq48ieGXwBsOCxkFPyHl7OQkrTGuOBX8s0KKytTsAYZSzLDWbnQ7N6AihT6OOWTrQ
         FhTO+DOD3c9TDlLyA9SwD1iD9MGQcriVmMrXDo8eWBKRKN1hK13CWqqJqhUh4X3SjM/Q
         1cyhF6ZO7bxXmvvpgeHjOZMmR3DTX+2u1MNr7DwWgY87INJtN7K7Dp89Zo816mPVC8/r
         Zu1g==
Content-Disposition: inline
In-Reply-To: <20140512152015.GH9564@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org

On Mon, May 12, 2014 at 05:20:15PM +0200, Michal Hocko wrote:
> On Mon 12-05-14 11:00:14, Tejun Heo wrote:
> > On Mon, May 12, 2014 at 04:58:03PM +0200, Michal Hocko wrote:
> > > @@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
> > >  
> > >  	if (mem_cgroup_is_root(memcg))
> > >  		return -EINVAL;
> > > +	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
> > > +			current->comm, task_pid_nr(current));
> > > +	pr_cont(" Let us know if you know if it needed in your usecase at");
> > > +	pr_cont(" linux-mm@kvack.org\n");
> > >  	return mem_cgroup_force_empty(memcg);
> > 
> > It probably would be way easier to just mark the knob with
> > CFTYPE_INSANE.
> 
> That would prevent from creating the file, right? I do not mind that but
> I would like to see people complaining before.

Oh sure, if you wanna see people complaining before the roll out of
unified hierarchy, but let's make sure it's also marked with
CFTYPE_INSANE.  It's easy to remove the flag afterwards.  The other
way isn't, so...

Thanks.

-- 
tejun
