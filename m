From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Tue, 4 Jun 2013 13:50:25 -0700
Message-ID: <20130604205025.GG14916@htj.dyndns.org>
References: <1370306679-13129-1-git-send-email-tj@kernel.org>
 <1370306679-13129-4-git-send-email-tj@kernel.org>
 <20130604131843.GF31242@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xGtMk181SRjJ1ZkGxZSA0mx+iO7+Ae/sZvnVdmWRu5M=;
        b=ifK5oikgA9YEJMdLhyQf1gkucQKN3bcoCA3BxlNROdsAr2C6CjEo7l4LwX55xvh8pN
         vaBkLImfcGvwIhYli3nI5woRXis9a+3A9r9SBiIueXNCyyqSacPsgVU/k3LXULcxwiRh
         dEhwBbR/w+wxTK9GvBa5/IFIc1hLuKlkhLex4QsqTEF1+77TuH/JnSpWfjl+bRlK97NJ
         6O0vw4wwUVjNYw2XzrTnMRtE9RySXVNhas5DlwUFYjf+bpQ196d1EI+A0h/0pIb7KEK/
         0XR+L6GL7ny+FJ+cqRkKcnYhtCkEVFAWC2O5HJDTAFz2keKGukn9d8LIYlSxVmTtxlbw
         2/RA==
Content-Disposition: inline
In-Reply-To: <20130604131843.GF31242-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello, Michal.

On Tue, Jun 04, 2013 at 03:18:43PM +0200, Michal Hocko wrote:
> > +	if (memcg)
> > +		css_get(&memcg->css);
> 
> This is all good and nice but it re-introduces the same problem which
> has been fixed by (5f578161: memcg: relax memcg iter caching). You are
> pinning memcg in memory for unbounded amount of time because css
> reference will not let object to leave and rest.

I don't get why that is a problem.  Can you please elaborate?  css's
now explicitly allow holding onto them.  We now have clear separation
of "destruction" and "release" and blkcg also depends on it.  If memcg
still doesn't distinguish the two properly, that's where the problem
should be fixed.

> I understand your frustration about the complexity of the current
> synchronization but we didn't come up with anything easier.
> Originally I though that your tree walk updates which allow dropping rcu
> would help here but then I realized that not really because the iterator
> (resp. pos) has to be a valid pointer and there is only one possibility
> to do that AFAICS here and that is css pinning. And is no-go.

I find the above really weird.  If css can't be pinned for position
caching, isn't it natural to ask why it can't be and then fix it?
Because that's what the whole refcnt thing is about and a usage which
cgroup explicitly allows (e.g. blkcg also does it).  Why do you go
from there to "this batshit crazy barrier dancing is the only
solution"?

Can you please explain why memcg css's can't be pinned?

Thanks.

-- 
tejun
