From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH 00/14] per memcg lru_lock
Date: Mon, 26 Aug 2019 22:22:46 +0800
Message-ID: <1e2de503-9f53-9c51-f20c-f11a4b9625ed@linux.alibaba.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
 <6ba1ffb0-fce0-c590-c373-7cbc516dbebd@oracle.com>
 <348495d2-b558-fdfd-a411-89c75d4a9c78@linux.alibaba.com>
 <b776032e-eabb-64ff-8aee-acc2b3711717@oracle.com>
 <d5256ebf-8314-8c24-a7ed-e170b7d39b61@yandex-team.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d5256ebf-8314-8c24-a7ed-e170b7d39b61@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Hugh Dickins <hughd@google.com>



在 2019/8/26 下午4:39, Konstantin Khlebnikov 写道:
>>>
> because they mixes pages from different cgroups.
> 
> pagevec_lru_move_fn and friends need better implementation:
> either sorting pages or splitting vectores in per-lruvec basis.

Right, this should be the next step to improve. Maybe we could try the per-lruvec pagevec?

Thanks
Alex
