From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH] mm: memcontrol: fix cgroup creation failure after many
 small jobs
Date: Fri, 17 Jun 2016 12:06:55 +0300
Message-ID: <20160617090655.GE13143@esperanza>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=817h3Ito83TG7P9q9S8sDs3yogN6afIhbYrhxmfLBzc=;
 b=IaU6Liag1FtOMr1lK+ESa9y3WXOUd0CL5VfEhrC/73kPJ+e77qygukagT+y9ioawsl75rBLXGvJd33+fEyWDZz7OTRjYl9cypyIVO2xreaRT/rJT7NhdyU4B7Mk20hBvweX1ssAjrNCo7XmN06WlRRQlkxc6M5ksQ2Kbg9jglQU=
Content-Disposition: inline
In-Reply-To: <20160616034244.14839-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Jun 15, 2016 at 11:42:44PM -0400, Johannes Weiner wrote:
> The memory controller has quite a bit of state that usually outlives
> the cgroup and pins its CSS until said state disappears. At the same
> time it imposes a 16-bit limit on the CSS ID space to economically
> store IDs in the wild. Consequently, when we use cgroups to contain
> frequent but small and short-lived jobs that leave behind some page
> cache, we quickly run into the 64k limitations of outstanding CSSs.
> Creating a new cgroup fails with -ENOSPC while there are only a few,
> or even no user-visible cgroups in existence.
> 
> Although pinning CSSs past cgroup removal is common, there are only
> two instances that actually need a CSS ID after a cgroup is deleted:
> cache shadow entries and swapout records.
> 
> Cache shadow entries reference the ID weakly and can deal with the CSS
> having disappeared when it's looked up later. They pose no hurdle.
> 
> Swap-out records do need to pin the css to hierarchically attribute
> swapins after the cgroup has been deleted; though the only pages that
> remain swapped out after a process exits are tmpfs/shmem pages. Those
> references are under the user's control and thus manageable.
> 
> This patch introduces a private 16bit memcg ID and switches swap and
> cache shadow entries over to using that. It then decouples the CSS
> lifetime from the CSS ID lifetime, such that a CSS ID can be recycled
> when the CSS is only pinned by common objects that don't need an ID.

There's already id which is only used for online memory cgroups - it's
kmemcg_id. May be, instead of introducing one more idr, we could name it
generically and reuse it for shadow entries?

Regarding swap entries, would it really make much difference if we used
4 bytes per swap page instead of 2? For a 100 GB swap it'd increase
overhead from 50 MB up to 100 MB, which still doesn't seem too much IMO,
so may be just use plain unrestricted css->id for swap entries?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
