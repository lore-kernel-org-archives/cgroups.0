From: Michal Hocko <mhocko@kernel.org>
Subject: Re: WARNING in try_charge
Date: Thu, 9 Aug 2018 17:07:35 +0200
Message-ID: <20180809150735.GA15611@dhcp22.suse.cz>
References: <0000000000005e979605729c1564@google.com>
 <e2869136-9f59-9ce8-8b9f-f75b157ee31d@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e2869136-9f59-9ce8-8b9f-f75b157ee31d@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>, syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>

On Thu 09-08-18 22:57:43, Tetsuo Handa wrote:
> >From b1f38168f14397c7af9c122cd8207663d96e02ec Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Thu, 9 Aug 2018 22:49:40 +0900
> Subject: [PATCH] mm, oom: task_will_free_mem(current) should retry until
>  memory reserve fails
> 
> Commit 696453e66630ad45 ("mm, oom: task_will_free_mem should skip
> oom_reaped tasks") changed to select next OOM victim as soon as
> MMF_OOM_SKIP is set. But we don't need to select next OOM victim as
> long as ALLOC_OOM allocation can succeed. And syzbot is hitting WARN(1)
> caused by this race window [1].

It is not because the syzbot was exercising a completely different code
path (memcg charge rather than the page allocator).

> Since memcg OOM case uses forced charge if current thread is killed,
> out_of_memory() can return true without selecting next OOM victim.
> Therefore, this patch changes task_will_free_mem(current) to ignore
> MMF_OOM_SKIP unless ALLOC_OOM allocation failed.

And the patch is simply wrong for memcg.
-- 
Michal Hocko
SUSE Labs
