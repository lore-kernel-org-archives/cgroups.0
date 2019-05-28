From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH v5 7/7] mm: fix /proc/kpagecgroup interface for slab pages
Date: Tue, 28 May 2019 20:38:16 +0300
Message-ID: <20190528173815.2km65nchedfumslt@esperanza>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-8-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r8PmQcft5RJ51eoZR31WNho/xyilsVu7uCLR1yi4QeM=;
        b=JT4C1GZ5u716MuG38oMA8m4kjqZNa8qKH9ij5bmN31mD37QnGs2q/DkpLNNQT54Zah
         rUr1i5yoLx+yn8qZ9Z6/k+NXbn69dEk4UXskpJRCo4dqFVYZi1Gp9O+oNSmX7wtFtmTW
         i41ZJ+O6WEW+B/XteUFnOgI6Ny+omV83U8+9UxpLp7+YOX51rxGfMYlVkqNg9scqKNfI
         WJIUBk6E9hEM4Vz1E/YKBi102DMg1BYgG9OCd3G59CHXnh2xpEjE3S386PD07hkNTX/E
         2OeALMR2jlduzQUdutJqLwqHpL4y34Re7iAU4oyso+lxa2BJz+GZ5rAHJg7MSOyUyYXg
         XYOg==
Content-Disposition: inline
In-Reply-To: <20190521200735.2603003-8-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, cgroups@vger.kernel.org, Waiman Long <longman@redhat.com>

On Tue, May 21, 2019 at 01:07:35PM -0700, Roman Gushchin wrote:
> Switching to an indirect scheme of getting mem_cgroup pointer for
> !root slab pages broke /proc/kpagecgroup interface for them.
> 
> Let's fix it by learning page_cgroup_ino() how to get memcg
> pointer for slab pages.
> 
> Reported-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> ---
>  mm/memcontrol.c  |  5 ++++-
>  mm/slab.h        | 25 +++++++++++++++++++++++++
>  mm/slab_common.c |  1 +
>  3 files changed, 30 insertions(+), 1 deletion(-)

What about mem_cgroup_from_kmem, see mm/list_lru.c?
Shouldn't we fix it, too?
