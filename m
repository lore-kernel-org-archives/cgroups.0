From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Wed, 5 Jun 2013 01:20:23 -0700
Message-ID: <20130605082023.GG7303@mtj.dyndns.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-4-git-send-email-tj@kernel.org>
 <20130604131843.GF31242@dhcp22.suse.cz>
 <20130604205025.GG14916@htj.dyndns.org>
 <20130604212808.GB13231@dhcp22.suse.cz>
 <20130604215535.GM14916@htj.dyndns.org>
 <20130605073023.GB15997@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FLdFLAWuhC49jK7huxv8ziIW4gnF6b6fCm4XWkITANI=;
        b=ZAfM/PXN64ZQOdwTwNAQTPc07hCRC6CmIK2mMZPWp7dATkU5DcUrt6syAD6BvnBqVI
         8jb1ylGvD1iIJkCXTuYcOZrA47U5nFmr7Y7rRYI6rUItj5ogkbSWpKVD6/sxaZYx+mMn
         uxpZFe/z4OBxAA8oU7cg7X6g7qt+Up+HTMzXYNU1PmjSlWRdD15n/k3OUSFn3PFqoOSB
         /X3W0/KzN9p5f8BXH69rMkupYC1153ljH4K5CIGw+3hgGNkJA44x0MmsLLTHvkOMyn5D
         TOahoVmrda46DxlbYPVkmRn3d5i4EOnZPNfZ5xDHFGdNDV0rkFRMkey0KvdzNje98HhG
         54Hg==
Content-Disposition: inline
In-Reply-To: <20130605073023.GB15997@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

Hello, Michal.

On Wed, Jun 05, 2013 at 09:30:23AM +0200, Michal Hocko wrote:
> > I don't really get that.  As long as the amount is bound and the
> > overhead negligible / acceptable, why does it matter how long the
> > pinning persists? 
> 
> Because the amount is not bound either. Just create a hierarchy and
> trigger the hard limit and if you are careful enough you can always keep
> some of the children in the cached pointer (with css reference, if you
> will) and then release the hierarchy. You can do that repeatedly and
> leak considerable amount of memory.

It's still bound, no?  Each live memcg can only keep limited number of
cgroups cached, right?

> > We aren't talking about something gigantic or can
> 
> mem_cgroup is 888B now (depending on configuration). So I wouldn't call
> it negligible.

Do you think that the number can actually grow harmful?  Would you be
kind enough to share some calculations with me?

> > In the off chance that this is a real problem, which I strongly doubt,
> > as I wrote to Johannes, we can implement extremely dumb cleanup
> > routine rather than this weak reference beast.
> 
> That was my first version (https://lkml.org/lkml/2013/1/3/298) and
> Johannes didn't like. To be honest I do not care _much_ which way we go
> but we definitely cannot pin those objects for ever.

I'll get to the barrier thread but really complex barrier dancing like
that is only justifiable in extremely hot paths a lot of people pay
attention to.  It doesn't belong inside memcg proper.  If the cached
amount is an actual concern, let's please implement a simple clean up
thing.  All we need is a single delayed_work which scans the tree
periodically.

Johannes, what do you think?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
