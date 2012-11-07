From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
Date: Wed, 7 Nov 2012 18:49:58 +0100
Message-ID: <20121107174958.GB24475@dhcp22.suse.cz>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-4-git-send-email-tj@kernel.org>
 <20121107165457.GD4131@dhcp22.suse.cz>
 <20121107170118.GD2660@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=creOGQSZMzAQagNWlO/SmXmwPliRIXwGwAmxxa++vyU=;
        b=g4d1hP3o/2hwLghRqNsa8tTb1J92l1Kv23/Z+as8FXTZl2+sBfBhs0PCkwFi2z4NBW
         9TR7AUkb2D0K/HfqLRkVQTV2bLvVv2B+7AQbqAjj7NNoTqEtZKT9jGpHhz1d38vzcGaR
         9JubQyfJgPbXVo+pRLOjQIbcyh0ZtBrzizmgvM6xD2WU9hefLN/n9pL+dtrrTzQCtbWV
         aF7+dmY2wNtyiR60aNRfINlMeINMzTX6kGfgIMJQkrUL8Ug1a0wQoVydM1y7qtZjfdhj
         smtGEdsrNEhHPrxgCN+HTcMkScZfqJ7xK+DkmYjBwrAbUmT5KWLTbbW70rHiIfLjWXwL
         ilow==
Content-Disposition: inline
In-Reply-To: <20121107170118.GD2660-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed 07-11-12 09:01:18, Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Nov 07, 2012 at 05:54:57PM +0100, Michal Hocko wrote:
> > > +struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
> > > +					  struct cgroup *cgroup)
> > > +{
> > > +	struct cgroup *next;
> > > +
> > > +	WARN_ON_ONCE(!rcu_read_lock_held());
> > > +
> > > +	/* if first iteration, pretend we just visited @cgroup */
> > > +	if (!pos) {
> > > +		if (list_empty(&cgroup->children))
> > > +			return NULL;
> > > +		pos = cgroup;
> > > +	}
> > 
> > Is there any specific reason why the root of the tree is excluded?
> > This is bit impractical because you have to special case the root
> > in the code.
> 
> Yeah, thought about including it but decided against it for two
> reasons.
> 
> * To be consistent with cgroup_for_each_children() - it's a bit weird
>   for descendants to include self when children don't.
> 
> * Iteration root is likely to require different treatment anyway.
>   e.g. for cgroup_freezer, the root is updated to the specified config
>   while all the descendants inherit config from its immediate parent.
>   They are different.

OK if there is a code which handles root differently then let's not
overcomplicate this. The naming should be clear that root needs a
special treatment.

I will continue with the review tomorrow.
-- 
Michal Hocko
SUSE Labs
