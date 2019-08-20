From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 00/14] per memcg lru_lock
Date: Tue, 20 Aug 2019 12:45:32 +0200
Message-ID: <20190820104532.GP3111@dhcp22.suse.cz>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>

On Tue 20-08-19 17:48:23, Alex Shi wrote:
> This patchset move lru_lock into lruvec, give a lru_lock for each of
> lruvec, thus bring a lru_lock for each of memcg.
> 
> Per memcg lru_lock would ease the lru_lock contention a lot in
> this patch series.
> 
> In some data center, containers are used widely to deploy different kind
> of services, then multiple memcgs share per node pgdat->lru_lock which
> cause heavy lock contentions when doing lru operation.

Having some real world workloads numbers would be more than useful
for a non trivial change like this. I believe googlers have tried
something like this in the past but then didn't have really a good
example of workloads that benefit. I might misremember though. Cc Hugh.

-- 
Michal Hocko
SUSE Labs
