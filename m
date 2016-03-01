From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: cleanup css_reset callback
Date: Tue, 1 Mar 2016 14:53:33 -0500
Message-ID: <20160301195333.GA22717@cmpxchg.org>
References: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <69629961aefc48c021b895bb0c8297b56c11a577.1456830735.git.vdavydov@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Mar 01, 2016 at 02:13:12PM +0300, Vladimir Davydov wrote:
>  - Do not take memcg_limit_mutex for resetting limits - the cgroup
>    cannot be altered from userspace anymore, so no need to protect them.
> 
>  - Use plain page_counter_limit() for resetting ->memory and ->memsw
>    limits instead of mem_cgrouop_resize_* helpers - we enlarge the
>    limits, so no need in special handling.
> 
>  - Reset ->swap and ->tcpmem limits as well.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
