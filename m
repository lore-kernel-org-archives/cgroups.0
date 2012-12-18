From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] memcg: don't register hotcpu notifier from ->css_alloc()
Date: Tue, 18 Dec 2012 08:47:47 -0800
Message-ID: <20121218164747.GJ1844@htj.dyndns.org>
References: <20121214012436.GA25481@localhost>
 <20121218154030.GC10220@mtj.dyndns.org>
 <20121218164022.GB25208@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=05vyBt00kyFwU2h9eGh580TE6M8HVlynUsU0CwtwqZw=;
        b=h5e5VKm9jK1W9Rzf1PMFg2AX0xFm5J5KysTSZxuZGdqNAC0AUUaCUgDqykWgxMmH5N
         4IepAD/CVbSgtndKO+IPF2Qz+Q5BexY/aYVGu51ePKfs0kwkdpwCB6G5zs90tvC9LFrx
         wJPXswl+uuCwFG7K+dwRk0cziuviLyCCZhYiErg6RXUg4N/x50xdoKzhlMHxryeForfS
         uEQETeCvz/IG2yzruSFCjanrfVc8MCm8CvQngEyYGfpB6qSHcCi3G4GOvgpNDyipuFUM
         h0C3TZQLbWe5c69v3AMssflwilclo8r7rUojD8JWQNEmDSF/RB25215bnrUI4g6gFeTp
         pKfA==
Content-Disposition: inline
In-Reply-To: <20121218164022.GB25208@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Fengguang Wu <fengguang.wu@intel.com>, cgroups@vger.kernel.org, linux-mm@kvack.org

Hey, Michal.

On Tue, Dec 18, 2012 at 05:40:22PM +0100, Michal Hocko wrote:
> > +/*
> > + * The rest of init is performed during ->css_alloc() for root css which
> > + * happens before initcalls.  hotcpu_notifier() can't be done together as
> > + * it would introduce circular locking by adding cgroup_lock -> cpu hotplug
> > + * dependency.  Do it from a subsys_initcall().
> > + */
> > +static int __init mem_cgroup_init(void)
> > +{
> > +	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
> 
> Hmm, we can move enable_swap_cgroup() and per-cpu memcg_stock
> initialization here as well to make the css_alloc a bit cleaner.
> mem_cgroup_soft_limit_tree_init with a trivial BUG_ON() on allocation
> failure can go there as well. 
> 
> I will do it.

The thing was that cgroup_init() happens before any initcalls so
you'll end up with root css being set up before other stuff gets
initialized, which could be okay but a bit nasty.  I'm wondering why
cgroup_init() has to happen so early.  The cpu one is already taking
an early init path, but the rest doesn't seem to need such early init.

Anyways, yeap, no objection to cleaning up anyway which fits memcg.
We can deal with the whole init order thing later.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
