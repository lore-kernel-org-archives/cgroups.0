From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: fix cgroup creation failure after many
 small jobs
Date: Thu, 14 Jul 2016 11:37:23 -0400
Message-ID: <20160714153723.GA9840@cmpxchg.org>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qHmh5zBLmiDDhEMmBaD1AJaUw1qN002XIbBm+3Zumd0=; b=I0bi4aKMMn6+svBQAaCR3Y3qq/
	cnjS8Db0TJ20qrCMyVgo/KR+7QQ/vZAgszYctl04MZ3bDspBz2Xxd6WQNtMVXKVE7Zvjyc1dHaNzG
	YJ0CfTiv7nnRAdDLj4ds/Bc+oPTkcChprXIrhG/3W53a+Nl/v/bbqeWopKrNALXW7rqY=;
Content-Disposition: inline
In-Reply-To: <20160616034244.14839-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hi Andrew,

this issue dates back quite a bit and wasn't reported until now, so I
didn't tag it for stable. However, it seems that larger scale setups
are now running into this as they upgrade their kernels, and several
people have run into this independently now. Could you please add:

Reported-by: John Garcia <john.garcia@mesosphere.io>
Fixes: b2052564e66d ("mm: memcontrol: continue cache reclaim from offlined groups")
CC: stable@kernel.org # 3.19+

and send it linusward?

Thank you

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
> 
> This script demonstrates the problem by faulting one cache page in a
> new cgroup and deleting it again:
> 
> set -e
> mkdir -p pages
> for x in `seq 128000`; do
>   [ $((x % 1000)) -eq 0 ] && echo $x
>   mkdir /cgroup/foo
>   echo $$ >/cgroup/foo/cgroup.procs
>   echo trex >pages/$x
>   echo $$ >/cgroup/cgroup.procs
>   rmdir /cgroup/foo
> done
> 
> When run on an unpatched kernel, we eventually run out of possible CSS
> IDs even though there is no visible cgroup existing anymore:
> 
> [root@ham ~]# ./cssidstress.sh
> [...]
> 65000
> mkdir: cannot create directory '/cgroup/foo': No space left on device
> 
> After this patch, the CSS IDs get released upon cgroup destruction and
> the cache and css objects get released once memory reclaim kicks in.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
