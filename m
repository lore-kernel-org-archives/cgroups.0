From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: fix documentation for compound parameter
Date: Wed, 8 Jun 2016 10:59:09 -0400
Message-ID: <20160608145909.GB6727@cmpxchg.org>
References: <1465368216-9393-1-git-send-email-roy.qing.li@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1465368216-9393-1-git-send-email-roy.qing.li@gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: roy.qing.li@gmail.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, vdavydov@virtuozzo.com

On Wed, Jun 08, 2016 at 02:43:36PM +0800, roy.qing.li@gmail.com wrote:
> From: Li RongQing <roy.qing.li@gmail.com>
> 
> commit f627c2f53786 ("memcg: adjust to support new THP refcounting")
> adds a compound parameter for several functions, and change one as
> compound for mem_cgroup_move_account but it does not change the
> comments.
> 
> Signed-off-by: Li RongQing <roy.qing.li@gmail.com>

Thanks, that's useful.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
