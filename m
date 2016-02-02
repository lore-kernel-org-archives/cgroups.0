From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH v2 5/5] mm: workingset: per-cgroup cache thrash detection
Date: Tue, 2 Feb 2016 17:34:54 +0300
Message-ID: <20160202143454.GC21016@esperanza>
References: <1454090047-1790-1-git-send-email-hannes@cmpxchg.org>
 <1454090047-1790-6-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1454090047-1790-6-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Jan 29, 2016 at 12:54:07PM -0500, Johannes Weiner wrote:
> Cache thrash detection (see a528910e12ec "mm: thrash detection-based
> file cache sizing" for details) currently only works on the system
> level, not inside cgroups. Worse, as the refaults are compared to the
> global number of active cache, cgroups might wrongfully get all their
> refaults activated when their pages are hotter than those of others.
> 
> Move the refault machinery from the zone to the lruvec, and then tag
> eviction entries with the memcg ID. This makes the thrash detection
> work correctly inside cgroups.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
