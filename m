From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] vmpressure: make sure memcg stays alive until all
 users are signaled
Date: Thu, 11 Jul 2013 09:32:38 -0700
Message-ID: <20130711163238.GC9229@mtj.dyndns.org>
References: <20130710184254.GA16979@mtj.dyndns.org>
 <20130711083110.GC21667@dhcp22.suse.cz>
 <51DE701C.6010800@huawei.com>
 <20130711092542.GD21667@dhcp22.suse.cz>
 <51DE7AAF.6070004@huawei.com>
 <20130711093300.GE21667@dhcp22.suse.cz>
 <20130711154408.GA9229@mtj.dyndns.org>
 <20130711162215.GM21667@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WMJ/TWg2tjrWv7MXLhJXUr+c+k3o/0BCbTDJR6NxCSg=;
        b=ocxrOgtHknz259pjkudGHwG67eZ45LHb7J355AEc1KjYqH40oKqkQEkGw+ItDJ/ctU
         yKD2xJzyAtaONLtxNItUDAiX+zdX9lWF4XA3vqVWSQxbg1rnh2/Oud/B8oelqsZ4ZkiE
         xwgCQ9roQWxj3gd8nZEv0qML4HYRMz95PnyPMDLiuDWRmx7g/oVwvfzJjGeyQt1vzjYt
         Uds7t768I6DW6u6LC0A+G+SE1CGUqZaFjUYyM8BResYxC2FHk6WNcw4ZIMQ74y7f9qf/
         FASc0M3EQT4UJgY6/sAyHUspP25tuEUtVrFrOMF4YEL0nQ4tzl4uLgRh+1Z1ERvH0UfF
         7IeA==
Content-Disposition: inline
In-Reply-To: <20130711162215.GM21667@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Anton Vorontsov <anton.vorontsov@linaro.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Hello,

On Thu, Jul 11, 2013 at 06:22:15PM +0200, Michal Hocko wrote:
> I would rather not put vmpressure clean up code into memcg offlining.
> We have reference counting for exactly this purposes so it feels strange
> to overcome it like that.

It's not something white and black but for things which can be made
trivially synchrnous, it usually is better to do it that way,
especially while shutting down objects as they enter a lingering stage
where they're de-registered but not destroyed and you should be
careful which parts of the object are still accessible.  I haven't
read it carefully but here I'm not sure whether it's safe to do event
related operations after removal.  From cgroup core side, event list
is shut down synchronously from cgroup_destroy_locked().  It doesn't
seem like that part is explicitly built to remain accessible
afterwards.

> Besides that wouldn't be that racy? The work item could be already
> executing and preempted and we do not want vmpr to disappear from under
> our feet. I know this is _highly_ unlikely but why to play games?

Hmmm?  flush_work() and cancel_work_sync() guarantee that the work
item isn't executing on return unless it's being requeued.  There's no
race condition.

> Dunno, to be honest. From a quick look they both can be turned to spin
> locks but events_lock might cause long preempt disabled periods when
> zillions of events are registered.

I see.

> > Also, while at it, can you please remove the work_pending() check?
> > They're almost always spurious or racy and should be avoided in
> > general.
> 
> sure, this really looks bogus. I will cook patches for both issues and
> send them tomorrow.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
