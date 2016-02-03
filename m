From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH 3/3] mm: remove unnecessary uses of lock_page_memcg()
Date: Wed, 3 Feb 2016 12:29:26 +0300
Message-ID: <20160203092926.GG21016@esperanza>
References: <1454109573-29235-1-git-send-email-hannes@cmpxchg.org>
 <1454109573-29235-4-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1454109573-29235-4-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Jan 29, 2016 at 06:19:33PM -0500, Johannes Weiner wrote:
> There are several users that nest lock_page_memcg() inside lock_page()
> to prevent page->mem_cgroup from changing. But the page lock prevents
> pages from moving between cgroups, so that is unnecessary overhead.
> 
> Remove lock_page_memcg() in contexts with locked contexts and fix the
> debug code in the page stat functions to be okay with the page lock.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
