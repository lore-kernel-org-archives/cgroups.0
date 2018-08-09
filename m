From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: WARNING in try_charge
Date: Thu, 9 Aug 2018 11:34:30 -0400
Message-ID: <20180809153430.GA17445@cmpxchg.org>
References: <0000000000005e979605729c1564@google.com>
 <e2869136-9f59-9ce8-8b9f-f75b157ee31d@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q+ybpDce2iHfmfRedVYwQZPbXrq5puum25iLpbPcm+k=;
        b=sVQQ1GwbtgjJHMZdFMjdB2wIZHwdFpyHLMH4v4500uAedUyKe/FwD/qhp04Qmb/ymE
         ULUIhXrY/8Duu2bau/6FG0rT9I4LyNU0SVlGeoxf+h3+estv2Ms0PR9OBjAep8djwraH
         TOL1Nih/PSn3RcS7HY9mAPWai3/QA81UIMW9jEUS27RvjcBGY4XKNEazM2555SD6A3Qo
         9XEeqHu6FquupXx9bKRsjCuq4VT6Y3UKgB0IL9cySuPgSAc/Tbb+ViNo3M8OJ2fH4grz
         KHgFYo/jjCA2CX1hyApiknC3Xjn5mj2HUltXlRLvygNnNbIItrieiaXht6tcBnI4TgWq
         DDBQ==
Content-Disposition: inline
In-Reply-To: <e2869136-9f59-9ce8-8b9f-f75b157ee31d@I-love.SAKURA.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: mhocko@kernel.org, Vladimir Davydov <vdavydov@virtuozzo.com>, Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>, syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>

On Thu, Aug 09, 2018 at 10:57:43PM +0900, Tetsuo Handa wrote:
> From b1f38168f14397c7af9c122cd8207663d96e02ec Mon Sep 17 00:00:00 2001
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

Huh? That's the memcg path, it has nothing to do with ALLOC_OOM.

> Since memcg OOM case uses forced charge if current thread is killed,
> out_of_memory() can return true without selecting next OOM victim.
> Therefore, this patch changes task_will_free_mem(current) to ignore
> MMF_OOM_SKIP unless ALLOC_OOM allocation failed.

I have no idea how the first and the second half of this paragraph go
together. They're completely independent code paths.
