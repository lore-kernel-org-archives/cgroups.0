From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol: fix the return in mem_cgroup_margin
Date: Mon, 23 May 2016 14:08:20 +0200
Message-ID: <20160523120820.GQ2278@dhcp22.suse.cz>
References: <1463556255-31892-1-git-send-email-roy.qing.li@gmail.com>
 <20160518073253.GC21654@dhcp22.suse.cz>
 <CAJFZqHwFtZa-Ec_0bie6ORTrgoW1kqGsq49-=ojsT-uyNUBhwg@mail.gmail.com>
 <20160523103758.GB7917@esperanza>
 <20160523120620.GP2278@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160523120620.GP2278@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li RongQing <roy.qing.li@gmail.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>

On Mon 23-05-16 14:06:20, Michal Hocko wrote:
[...]
> I have completely missed a potential interaction with
> __GFP_NOFAIL. We even do not seem to trigger the memcg OOM killer for
> these requests to sort the situation out.

Which is intentional. a0d8b00a3381 ("mm: memcg: do not declare OOM from
__GFP_NOFAIL allocations")

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
