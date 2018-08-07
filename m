From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: WARNING in try_charge
Date: Tue, 7 Aug 2018 19:19:08 +0900
Message-ID: <c1658a69-e6a6-6a0d-0bde-7251f81aa78d@i-love.sakura.ne.jp>
References: <fc6e173e-8bda-269f-d44f-1c5f5215beac@I-love.SAKURA.ne.jp>
 <0000000000006350880572c61e62@google.com>
 <20180806174410.GB10003@dhcp22.suse.cz>
 <20180806175627.GC10003@dhcp22.suse.cz>
 <078bde8d-b1b5-f5ad-ed23-0cd94b579f9e@i-love.sakura.ne.jp>
 <20180806203437.GK10003@dhcp22.suse.cz>
 <3cf8f630-73b7-20d4-8ad1-bb1c657ee30d@i-love.sakura.ne.jp>
 <20180806205519.GO10003@dhcp22.suse.cz>
 <9c03213f-c099-378b-e9fd-ed6f2a2afdc3@i-love.sakura.ne.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9c03213f-c099-378b-e9fd-ed6f2a2afdc3@i-love.sakura.ne.jp>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, dvyukov@google.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com

On 2018/08/07 6:50, Tetsuo Handa wrote:
>  	list_for_each_entry_safe(p, tmp, &oom_victim_list, oom_victim_list) {
>  		struct mm_struct *mm = p->signal->oom_mm;
>  
>  		if (oom_unkillable_task(p, oc->memcg, oc->nodemask))
>  			continue;
>  		ret = true;
> +		/*
> +		 * Since memcg OOM allows forced charge, we can safely wait
> +		 * until __mmput() completes.
> +		 */
> +		if (is_memcg_oom(oc))
> +			return true;

Oops. If this OOM victim was blocked on some lock which current thread is
holding, waiting forever unconditionally is not safe.

>  #ifdef CONFIG_MMU
>  		/*
>  		 * Since the OOM reaper exists, we can safely wait until
>  		 * MMF_OOM_SKIP is set.
>  		 */
>  		if (!test_bit(MMF_OOM_SKIP, &mm->flags)) {
>  			if (!oom_reap_target) {
>  				get_task_struct(p);
>  				oom_reap_target = p;
>  				trace_wake_reaper(p->pid);
>  				wake_up(&oom_reaper_wait);
>  			}
>  #endif
>  			continue;
>  		}
>  #endif
>  		/* We can wait as long as OOM score is decreasing over time. */
>  		if (!victim_mm_stalling(p, mm))
>  			continue;
>  		gaveup = true;
>  		list_del(&p->oom_victim_list);
>  		/* Drop a reference taken by mark_oom_victim(). */
>  		put_task_struct(p);
>  	}
>  	if (gaveup)
>  		debug_show_all_locks();
>  
>  	return ret;
>  }
> 
