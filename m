From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v2 4/8] mm/lru: only change the lru_lock iff page's lruvec
 is different
Date: Thu, 14 Nov 2019 14:01:06 +0800
Message-ID: <ba11d04a-def4-10b3-0b4e-4194e0ee2318@linux.alibaba.com>
References: <1573567588-47048-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573567588-47048-5-git-send-email-alex.shi@linux.alibaba.com>
 <20191112143624.GA7934@bombadil.infradead.org>
 <297ad71c-081c-f7e1-d640-8720a0eeeeba@linux.alibaba.com>
 <20191113134502.GD7934@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191113134502.GD7934@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, yang.shi@linux.alibaba.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Andrey Ryabinin <aryabinin@virtuozzo.com>, swkhack <swkhack@gmail.com>, "Potyra, Stefan" <Stefan.Potyra@elektrobit.com>, Jason Gunthorpe <jgg@ziepe.ca>, Mauro Carvalho Chehab <mchehab+samsung@kernel.org>, Peng Fan <peng.fan@n>



在 2019/11/13 下午9:45, Matthew Wilcox 写道:
>>> Why not simply:
>>>
>>> 	rcu_read_lock();
>>> 	lruvec = mem_cgroup_page_lruvec(page, pgdat);
>>> 	rcu_read_unlock();
>>>
>>> 	if (locked_lruvec == lruvec)
>> The rcu_read_unlock here is for guarding the locked_lruvec/lruvec comparsion.
>> Otherwise memcg/lruvec maybe changed, like, from memcg migration etc. I guess.
> How does holding the RCU lock guard the comparison?  You're comparing two
> pointers for equality.  Nothing any other CPU can do at this point will
> change the results of that comparison.
> 

Hi Matthew, Thanks for reply!

The reason of guarding lruvec compasion here is a bit undistinct, in fact, it guards the page's memcg from free/migrate etc, since the lruvec is kind of binding to each of memcg. The detailed explanation could be found in lock_page_memcg().

Thanks
Alex
