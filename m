From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH] mm/memcg: Free percpu stats memory of dying memcg's
Date: Fri, 22 Apr 2022 18:27:22 +0800
Message-ID: <YmKDCjJFYMmfa8sG@FVFYT0MHHV2J.usts.net>
References: <20220421145845.1044652-1-longman@redhat.com>
 <YmGHYNuAp8957ouq@carbon>
 <112a4d7f-bc53-6e59-7bb8-6fecb65d045d@redhat.com>
 <YmGbmrH/Hg1VJlUc@carbon>
 <58c41f14-356e-88dd-54aa-dc6873bf80ff@redhat.com>
 <YmIZ9Lpvx5pY3oTV@carbon>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QiB2o+WdMsJeAeDDSCARTXP2m3be3V0si7VrlcKUU9o=;
        b=EpVOrHjPnfUPosjTlIQ1i2uTS3VaVjSTEsn9fvxTlMiqlmD5AwJQeVwCDiQcArIIKN
         G0U4XrIyJIN3CfVCUIrKzrqmbxecuVOE+Ns+XyT6sLIQq3Sz+vUfV3qF4jkcNVStV+HD
         ohqFPfNeLvtVze2xs3540Uag578+Sa0Tio3U23Oj9fuHVhxC10HtbglTic+F4nkj+rnJ
         uNZ4AmDYyFqaAMKue+LnbfyyCvEFjw3OFO08wu8B27tOJZSsok3aK5Esq1bRVszqWR8L
         yJ2z08rjpeL6YiYDefHLoElqOMY1TQYX5c4B0SjdTEwSs9+LPZm8GPtYD9zlA2w7ZbTc
         jLKw==
Content-Disposition: inline
In-Reply-To: <YmIZ9Lpvx5pY3oTV@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yang Shi <shy828301@gmail.com>, Vlastimil Babka <vbabka@suse.cz>

On Thu, Apr 21, 2022 at 07:59:00PM -0700, Roman Gushchin wrote:
> On Thu, Apr 21, 2022 at 02:46:00PM -0400, Waiman Long wrote:
> > On 4/21/22 13:59, Roman Gushchin wrote:
> > > On Thu, Apr 21, 2022 at 01:28:20PM -0400, Waiman Long wrote:
> > > > On 4/21/22 12:33, Roman Gushchin wrote:
> > > > > On Thu, Apr 21, 2022 at 10:58:45AM -0400, Waiman Long wrote:
> > > > > > For systems with large number of CPUs, the majority of the memory
> > > > > > consumed by the mem_cgroup structure is actually the percpu stats
> > > > > > memory. When a large number of memory cgroups are continuously created
> > > > > > and destroyed (like in a container host), it is possible that more
> > > > > > and more mem_cgroup structures remained in the dying state holding up
> > > > > > increasing amount of percpu memory.
> > > > > > 
> > > > > > We can't free up the memory of the dying mem_cgroup structure due to
> > > > > > active references in some other places. However, the percpu stats memory
> > > > > > allocated to that mem_cgroup is a different story.
> > > > > > 
> > > > > > This patch adds a new percpu_stats_disabled variable to keep track of
> > > > > > the state of the percpu stats memory. If the variable is set, percpu
> > > > > > stats update will be disabled for that particular memcg. All the stats
> > > > > > update will be forward to its parent instead. Reading of the its percpu
> > > > > > stats will return 0.
> > > > > > 
> > > > > > The flushing and freeing of the percpu stats memory is a multi-step
> > > > > > process. The percpu_stats_disabled variable is set when the memcg is
> > > > > > being set to offline state. After a grace period with the help of RCU,
> > > > > > the percpu stats data are flushed and then freed.
> > > > > > 
> > > > > > This will greatly reduce the amount of memory held up by dying memory
> > > > > > cgroups.
> > > > > > 
> > > > > > By running a simple management tool for container 2000 times per test
> > > > > > run, below are the results of increases of percpu memory (as reported
> > > > > > in /proc/meminfo) and nr_dying_descendants in root's cgroup.stat.
> > > > > Hi Waiman!
> > > > > 
> > > > > I've been proposing the same idea some time ago:
> > > > > https://lore.kernel.org/all/20190312223404.28665-7-guro@fb.com/T/ .
> > > > > 
> > > > > However I dropped it with the thinking that with many other fixes
> > > > > preventing the accumulation of the dying cgroups it's not worth the added
> > > > > complexity and a potential cpu overhead.
> > > > > 
> > > > > I think it ultimately comes to the number of dying cgroups. If it's low,
> > > > > memory savings are not worth the cpu overhead. If it's high, they are.
> > > > > I hope long-term to drive it down significantly (with lru-pages reparenting
> > > > > being the first major milestone), but it might take a while.
> > > > > 
> > > > > I don't have a strong opinion either way, just want to dump my thoughts
> > > > > on this.
> > > > I have quite a number of customer cases complaining about increasing percpu
> > > > memory usages. The number of dying memcg's can go to tens of thousands. From
> > > > my own investigation, I believe that those dying memcg's are not freed
> > > > because they are pinned down by references in the page structure. I am aware
> > > > that we support the use of objcg in the page structure which will allow easy
> > > > reparenting, but most pages don't do that and it is not easy to do this
> > > > conversion and it may take quite a while to do that.
> > > The big question is whether there is a memory pressure on those systems.
> > > If yes, and the number of dying cgroups is growing, it's worth investigating.
> > > It might be due to the sharing of pagecache pages and this will be ultimately
> > > fixed with implementing of the pagecache reparenting. But it also might be due
> > > to other bugs, which are fixable, so it would be great to understand.
> > 
> > 
> > Pagecache reparenting will probably fix the problem that I have seen. Is
> > someone working on this?
> 
> Some time ago Muchun posted patches based on the reusing of the obj_cgroup API.
>

Yep. It is here:

https://lore.kernel.org/all/20220216115132.52602-1-songmuchun@bytedance.com/.
 
> I'm not strictly against this approach, but in my opinion it's not the best.
> I suggested to use lru vectors as an intermediate objects. In theory, it might

I remember this.

> allow to avoid bumping reference counters for all charged pages at all: live
> cgroups will be protected by being live, dying cgroups will only need
> a temporarily protection while lru vectors and associated pages are reparenting.
> 
> There are pros and cons:
> + cgroup reference counting becomes simpler and more debuggable
> + potential perf wins from fewer operations with live cgroups css refcounters
> = I hope to see code simplifications (but not guaranteed)
> - deleting cgroups becomes more expensive, but the cost can be spread to
>   asynchronous workers
> 
> Idk if Muchun tried to implement it. If not, I might try myself.
>

Yep. I have implemented a initial version recently. I'll do some stability tests
and send it out ASAP.

Thanks Roman.

