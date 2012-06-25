From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 07/11] mm: Allocate kernel pages to the right memcg
Date: Mon, 25 Jun 2012 11:07:47 -0700
Message-ID: <20120625180747.GE3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-8-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mBA8uysSlZtJw7683cMyW8yhHNByLeKzlTvcXwbKix4=;
        b=fh9RuCxoJxysppaCVdSqwGnqYkB3CQBDmM1l6FxIDgD61BgXQelkjBwrSvNUyW8h/g
         4NQOpnC1+L+s17YgcLha9cTWHSpOw/5vpSpgmYQuwDKLFx7CB9/hN0lfGZ2alpLkG9QI
         alBldcNUz+cIMSCj3Mq+tWfe1CACWAz4/OCUTFzbSse/DJLY03w9I3EBDT5Wi9Lt4Hwx
         BHwaeKxq+Djo+Sk9KUWpgSvK4SsJ7WeCMkXcAX7W9xyvUBiDOhxXKj63BNz5LMmO/SvN
         Uv+Zgxigc/DArnjv+u/fXKpIBlRg+bsdieqW/z6T3BkCwpVxBWHPY64p1JQUKcpflVgW
         CrQg==
Content-Disposition: inline
In-Reply-To: <1340633728-12785-8-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On Mon, Jun 25, 2012 at 06:15:24PM +0400, Glauber Costa wrote:
> When a process tries to allocate a page with the __GFP_KMEMCG flag,
> the page allocator will call the corresponding memcg functions to
> validate the allocation. Tasks in the root memcg can always proceed.
> 
> To avoid adding markers to the page - and a kmem flag that would
> necessarily follow, as much as doing page_cgroup lookups for no
> reason, whoever is marking its allocations with __GFP_KMEMCG flag
> is responsible for telling the page allocator that this is such an
> allocation at free_pages() time. This is done by the invocation of
> __free_accounted_pages() and free_accounted_pages().

Shouldn't we be documenting that in the code somewhere, preferably in
the function comments?

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
