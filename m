From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] memcg: reparent charges of children before
 processing parent
Date: Thu, 13 Feb 2014 10:35:01 -0500
Message-ID: <20140213153501.GA17608@htj.dyndns.org>
References: <alpine.LSU.2.11.1402121500070.5029@eggly.anvils>
 <20140213152745.GE11986@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=27gcFiHsKf9YFxu5KxxjNgbXusucoQxC22nxCu/jk0Q=;
        b=ftPKWuIFGEXKTiPUvAs0Yv19I9v1G8nZ+sQF/Fwji9fmUO8012PWAWA9EMGBbR47Kp
         9/ZT80VqEWkoJ8hXY7BPiSw/CIO2Ls4CMN77as6RL0LEyw8Y6DMBVDTvjxhvdIo/xZne
         apeqBnO20+0AURPStFP0VEIOTBP2ms4Bso7vUS/n7+3W2sG9Po+E5rNqdceKHT6ogSn/
         bfDyXFjHhutCK51ZokgDfCg0+igyPjBgOZ1D+214KvHTnclfztcIwUnlpUo06SZvUDTa
         yVqW/nW2QtC8jJF+ACRqvoJXcNxziJ4vvf+9AHYkgCfX2dg5srdxXicZQ8ifOZteSFGf
         jxRg==
Content-Disposition: inline
In-Reply-To: <20140213152745.GE11986@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Filipe Brandenburger <filbranden@google.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, Markus Blank-Burian <burian@muenster.de>, Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Hello,

On Thu, Feb 13, 2014 at 04:27:45PM +0100, Michal Hocko wrote:
> > Further testing showed that an ordered workqueue for cgroup_destroy_wq
> > is not always good enough: percpu_ref_kill_and_confirm's call_rcu_sched
> > stage on the way can mess up the order before reaching the workqueue.
> 
> This whole code path is so complicated by different types of delayed
> work that I am not wondering that we have missed that :/

Yeah, I know.  Good part of the complexity comes from RCU -> wq
bouncing.  I wonder whether we just should bite the bullet and add
something along the line of call_rcu_work().  The other part is percpu
ref shutdown.  For me that part is easier to swallow, as the benefits
are quite clear.

> > Instead, when offlining a memcg, call mem_cgroup_reparent_charges() on
> > all its children (and grandchildren, in the correct order) to have their
> > charges reparented first.
> 
> That is basically what I was suggesting
> http://marc.info/?l=linux-mm&m=139178386407184&w=2 as #1 option. I
> cannot say I would like it and I think that reparenting LRUs in
> css_offline and then reparent the remaining charges from css_free is a
> better solution but let's keep this for later.

I'm kinda wishing the reparenting things works out.  Even if that
involves a bit of overhead at offline, I think it'd be worthwhile to
be able to follow the same object lifetime rules as other controllers,
as long as the overhead is reasonable.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
