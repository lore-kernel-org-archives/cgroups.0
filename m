From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 03/14] lru/memcg: using per lruvec lock in
 un/lock_page_lru
Date: Mon, 26 Aug 2019 22:16:58 +0800
Message-ID: <bd44a613-d820-6085-0145-657078fd79cc@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <1566294517-86418-4-git-send-email-alex.shi@linux.alibaba.com>
 <936eb865-d8da-8e53-3e2b-6858c586aa49@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <936eb865-d8da-8e53-3e2b-6858c586aa49@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>



在 2019/8/26 下午4:30, Konstantin Khlebnikov 写道:
>>
>>   
> 
> What protects lruvec from freeing at this point?
> After reading resolving lruvec page could be moved and cgroup deleted.
> 
> In this old patches I've used RCU for that: https://lkml.org/lkml/2012/2/20/276
> Pointer to lruvec should be resolved under disabled irq.
> Not sure this works these days.

Thanks for reminder! I will reconsider this point and come up with changes.

Thanks
Alex
