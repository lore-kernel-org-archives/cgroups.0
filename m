From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/workingset: do not forget to unlock page
Date: Thu, 4 Feb 2016 09:19:00 +0900
Message-ID: <20160204001900.GB1861@swordfish>
References: <1454493513-19316-1-git-send-email-sergey.senozhatsky@gmail.com>
 <20160203104136.GA517@swordfish>
 <20160203162400.GB10440@cmpxchg.org>
 <20160203131939.1a35d9bc03f13b2b143d27c0@linux-foundation.org>
 <20160203220253.GA6859@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jaORy6U/RGtHionj2iM0FqbOJMLnXCfm58gf49Ga8Sc=;
        b=m0wsvXQS73t6TF5raaBRll3yJSLihHTYFC6Dyl9lClMy02oRHyACg0u1xnbv+iHmsO
         OgoiXmEILiOzTsZNCN3wNxbzn9pl6f0jX9DCGYGcZTHohRloEuh3l1ZYsJVBFH5j6sx5
         2B13cvNB1IlJFZ5iOLaKkTjvMEXKwISk7sB4WV1HOfVrkAKwjMTTtOTzHXyR4Ga3CKxx
         re50yoe6LkADe4QXAtgpjP6h73mBOljxBlOH4x/gysjimJip8pnoWzWVdi581Vju1ZCq
         gvh99iHnvU/oEdUuzQ/7EO69NIsJMG6Dpqzp711cJgDYXvelqXtlHjbDngfvIntnLLv6
         +5ug==
Content-Disposition: inline
In-Reply-To: <20160203220253.GA6859-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On (02/03/16 17:02), Johannes Weiner wrote:
> On Wed, Feb 03, 2016 at 01:19:39PM -0800, Andrew Morton wrote:
> > Yup.  I turned it into a fix against
> > mm-workingset-per-cgroup-cache-thrash-detection.patch, which is where
> > the bug was added.  And I did the goto thing instead, so the final
> > result will be
> > 
> > void workingset_activation(struct page *page)
> > {
> > 	struct lruvec *lruvec;
> > 
> > 	lock_page_memcg(page);
> > 	/*
> > 	 * Filter non-memcg pages here, e.g. unmap can call
> > 	 * mark_page_accessed() on VDSO pages.
> > 	 *
> > 	 * XXX: See workingset_refault() - this should return
> > 	 * root_mem_cgroup even for !CONFIG_MEMCG.
> > 	 */
> > 	if (!mem_cgroup_disabled() && !page_memcg(page))
> > 		goto out;
> > 	lruvec = mem_cgroup_zone_lruvec(page_zone(page), page_memcg(page));
> > 	atomic_long_inc(&lruvec->inactive_age);
> > out:
> > 	unlock_page_memcg(page);
> > }
> 
> LGTM, thank you.

Thanks!

	-ss
