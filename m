From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 2/2] blk-cgroup: Flush stats at blkgs destruction path
Date: Thu, 2 Feb 2023 12:35:08 -1000
Message-ID: <Y9w6nDJoekdCYZXr@slm.duckdns.org>
References: <20221215033132.230023-1-longman@redhat.com>
 <20221215033132.230023-3-longman@redhat.com>
 <Y9s4+Nop1eluWmJ4@T590>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I/vBtaUtvuAYUBDEagef+6G4CYpgzu4YV3aIy4NBUrk=;
        b=oq3M/1+tIFcjv9hjEaGa28A24jGTHUseAgRYiuLI/10z8o5Lu4Qv1oa6JxbgQXY8G/
         NWn04KLhk0SYfQ9EGUP/PUl6RXvmhYklHrGecdQSjHvDeGxa+23/5lw2SZDNNpP2G6Ex
         bXiRpKzgO0zlaxeKzE62bplLdiPUyA0NiWPWk6rqquMKzN/+0G1MZJ1g/HBunRJ7Vjpy
         2aF/039Mt6/+eZW5dumlEg3q8OiNbRBwGXKUfUiktWBQpxBo85aRZwaGVCyNPfa7N4HN
         VPiDYCFWuMcfQ64NEL+osMeaqbfpL7BPZy8kkFiWtYnvWtQKN7ZwtotoQmnj8jQ5Dquc
         +NNQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Y9s4+Nop1eluWmJ4@T590>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei@redhat.com>
Cc: Waiman Long <longman@redhat.com>, Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>

On Thu, Feb 02, 2023 at 12:15:52PM +0800, Ming Lei wrote:
> > @@ -1093,6 +1095,20 @@ static void blkcg_destroy_blkgs(struct blkcg *blkcg)
> >  
> >  	might_sleep();
> >  
> > +	/*
> > +	 * Flush all the non-empty percpu lockless lists to release the
> > +	 * blkg references held by those lists which, in turn, will
> > +	 * allow those blkgs to be freed and release their references to
> > +	 * blkcg. Otherwise, they may not be freed at all becase of this
> > +	 * circular dependency resulting in memory leak.
> > +	 */
> > +	for_each_possible_cpu(cpu) {
> > +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
> > +
> > +		if (!llist_empty(lhead))
> > +			cgroup_rstat_css_cpu_flush(&blkcg->css, cpu);
> > +	}
> 
> I guess it is possible for new iostat_cpu to be added just after the
> llist_empty() check.

Ah, good point. Maybe:

* Move flush below the blkg kill loop.

* In blk_cgroup_bio_start(), use percpu_ref_tryget() to decide whether to
  add to llist or not.

-- 
tejun
