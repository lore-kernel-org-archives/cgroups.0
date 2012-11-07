From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/9] cgroup: implement generic child / descendant walk
 macros
Date: Wed, 7 Nov 2012 09:01:18 -0800
Message-ID: <20121107170118.GD2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-4-git-send-email-tj@kernel.org>
 <20121107165457.GD4131@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pbgwUHJ0N5S8wpJeZWef/WP3afgAK0lPhpVLRnXH7Ws=;
        b=yiUCzWk3GsiCA2B5B0nIHIjllXAuviVPNdWtqNdv/1A5VJqHOrJyoSjDYglx1kmsYi
         5TvA8tsmJjJlC8ECgpKX2Zet8A5rIS4kMuM5yEhEHGhXdgwYJGdseb6IxTioDBtUuSAL
         XRr6fRCP+c8JmJYuP5ffg81nXxCpcr5/d9g+pUgZDRYt1zXH2uOGVsJ3hfPzhw/H9gDz
         plf3hGIjo2Z5t5DIOeASf6F63UroxaByQzTs3UPdqQyRNjMxc4uUJ6JPM/ApmZcrx/AT
         YLlvEM+4X1yMdRDUbh/pUuKVwquMr0EUc2KZUG7Nte7gKkktxREEnlxuH44oJhl8iXOo
         b3Kg==
Content-Disposition: inline
In-Reply-To: <20121107165457.GD4131-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello, Michal.

On Wed, Nov 07, 2012 at 05:54:57PM +0100, Michal Hocko wrote:
> > +struct cgroup *cgroup_next_descendant_pre(struct cgroup *pos,
> > +					  struct cgroup *cgroup)
> > +{
> > +	struct cgroup *next;
> > +
> > +	WARN_ON_ONCE(!rcu_read_lock_held());
> > +
> > +	/* if first iteration, pretend we just visited @cgroup */
> > +	if (!pos) {
> > +		if (list_empty(&cgroup->children))
> > +			return NULL;
> > +		pos = cgroup;
> > +	}
> 
> Is there any specific reason why the root of the tree is excluded?
> This is bit impractical because you have to special case the root
> in the code.

Yeah, thought about including it but decided against it for two
reasons.

* To be consistent with cgroup_for_each_children() - it's a bit weird
  for descendants to include self when children don't.

* Iteration root is likely to require different treatment anyway.
  e.g. for cgroup_freezer, the root is updated to the specified config
  while all the descendants inherit config from its immediate parent.
  They are different.

Thanks.

-- 
tejun
