From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [Bug] race condition at rebind_subsystems()
Date: Fri, 15 Jul 2022 13:59:38 +0200
Message-ID: <20220715115938.GA8646@blackbody.suse.cz>
References: <1978e209e71905d89651e61abd07285912d412a1.camel@mediatek.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657886379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4RmIBDmA7HuVmZSyUWJ93x5lRlH/NRx1RsQwV9uMu1M=;
        b=AqIscoSlqIjk/nPYNDWwjjd9fWwuEi5DU9TQYGiCa2z4jdMdkfWhltCvjGsN96UZJW0NAs
        6L+wRg97LtJ2t5o+ij77C/gmHsm/RNCv6KvgTwiT1a08v/liV6xg053aQ9bRMAY8GzRHK8
        vQqWrDGD6pEi5J/g/siParyxrugja7U=
Content-Disposition: inline
In-Reply-To: <1978e209e71905d89651e61abd07285912d412a1.camel@mediatek.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jing-Ting Wu <jing-ting.wu@mediatek.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Matthias Brugger <matthias.bgg@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Shakeel Butt <shakeelb@google.com>, wsd_upstream@mediatek.com, lixiong.liu@mediatek.com, wenju.xu@mediatek.com, jonathan.jmchen@mediatek.com

Hello Jing-Ting.

On Thu, Jun 30, 2022 at 06:52:10PM +0800, Jing-Ting Wu <jing-ting.wu@mediatek.com> wrote:
> Root cause:
> The rebind_subsystems() is no lock held when move css object from A
> list to B list,then let B's head be treated as css node at
> list_for_each_entry_rcu().

Nice outcome of the analysis.

> The call stack as following:
> kthread
> -> worker_thread
> -> process_one_work
> -> flush_memcg_stats_dwork
> -> __mem_cgroup_flush_stats
> -> cgroup_rstat_flush_irqsafe
> -> cgroup_rstat_flush_locked
> 
> Detail:
> static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool
> may_sleep)
> {
> ...
>    rcu_read_lock();
>    list_for_each_entry_rcu(css, &pos->rstat_css_list,
>                              rstat_css_node)
>         css->ss->css_rstat_flush(css, cpu);
>    rcu_read_unlock();
> ...
> }
> 
> Because the content of css->ss is not a function address,
> once the css_rstat_flush is called, kernel exception will happen.

I agree with your analysis. The list_for_each_entry_rcu() is not
accounting for the move from A to B and the head's rstat_css_list is
invalid in the cgroup_rstat_flush() context.

> When the issue happened, the list of pos->rstat_css_list at group A is
> empty.
> There must be racing conditions.
> 
> From reviewing code, we find rebind_subsystems() is no lock held when
> move css object to other list.
> 
> int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
> {
> ...
>    if (ss->css_rstat_flush) {
>          list_del_rcu(&css->rstat_css_node);
>          list_add_rcu(&css->rstat_css_node,
>                       &dcgrp->rstat_css_list);
>    }
> ...
> }
> 
> If we held a css object from A group list, at same time this css object
> was moved to B group list.
> [...]
> Do you have any suggestion for this issue?

The css->rstat_css_node should not be modified if there are possible RCU
readers elsewhere.
One way to fix this would be to insert synchronize_rcu() after
list_del_rcu() and before list_add_rcu().
(A further alternative (I've heard about) would be to utilize 'nulls'
RCU lists [1] to make the move between lists detectable.)

But as I'm looking at it from distance, it may be simpler and sufficient
to just take cgroup_rstat_lock around the list migration (the nesting
under cgroup_mutex that's held with rebind_subsystems() is fine).

HTH,
Michal

[1] https://www.kernel.org/doc/html/latest/RCU/rculist_nulls.html

