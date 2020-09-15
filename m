From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 0/8] Return head pages from find_*_entry
Date: Tue, 15 Sep 2020 01:10:05 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.2009150059310.1550@eggly.anvils>
References: <20200910183318.20139-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:in-reply-to:message-id:references
 :user-agent:mime-version;
 bh=+JVatOz5/Dh/xyAg85UUTlc2Kova9GVo8Ydw6vbee8g=;
 b=nIyTzeIBrWUervNx+ZYSIQs3H/l6i7vwus2Ha3I8FVsJWME+6Q6zBuLHukcO1Xcij/
 j5R4e/ZCmOxtNw9oAWHeZq7ZmEeuOE1wVGnjbF/JEFb/h3Gpyr0zY82TI5IU8HJa3iwt
 wI+5RRixk+oQKYUF3g9xUmcY8v+Lbh/cTzjxMNENwyG+h/fSBMLQK4/VS47P+Igi7oZ1
 9UckvC1TShzWV6/MknJfpHzSm2rh16Zq6E3B4Oi9mvYBkd/oM5Ats+6fyFmiLQab2Du2
 7pn/Dd1cLCSugZFKNESH19JPHq/CXBJqNAhX10PcHYs8QaZCnL/QDibmKOhKsKMRnISA
 U9IA==
In-Reply-To: <20200910183318.20139-1-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>, intel-gfx@lists.freedesktop.org, Huang Ying <ying.huang@intel.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, linux-mm@kvack.org, Matthew Auld <matthew.auld@intel.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>

On Thu, 10 Sep 2020, Matthew Wilcox (Oracle) wrote:

> This patch series started out as part of the THP patch set, but it has
> some nice effects along the way and it seems worth splitting it out and
> submitting separately.
> 
> Currently find_get_entry() and find_lock_entry() return the page
> corresponding to the requested index, but the first thing most callers do
> is find the head page, which we just threw away.  As part of auditing
> all the callers, I found some misuses of the APIs and some plain
> inefficiencies that I've fixed.
> 
> The diffstat is unflattering, but I added more kernel-doc and a new wrapper.
> 
> v2:
>  - Rework how shmem_getpage_gfp() handles getting a head page back from
>    find_lock_entry()
>  - Renamed find_get_swap_page() to find_get_incore_page()
>  - Make sure find_get_incore_page() doesn't return a head page
>  - Fix the missing include of linux/shmem_fs.h
>  - Move find_get_entry and find_lock_entry prototypes to mm/internal.h
>  - Rename thp_valid_index() to thp_contains()
>  - Fix thp_contains() for hugetlbfs and swapcache
>  - Add find_lock_head() wrapper around pagecache_get_page()
> 
> Matthew Wilcox (Oracle) (8):
>   mm: Factor find_get_incore_page out of mincore_page
>   mm: Use find_get_incore_page in memcontrol
>   mm: Optimise madvise WILLNEED
>   proc: Optimise smaps for shmem entries
>   i915: Use find_lock_page instead of find_lock_entry
>   mm: Convert find_get_entry to return the head page
>   mm/shmem: Return head page from find_lock_entry
>   mm: Add find_lock_head
> 
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c |  4 +--
>  fs/proc/task_mmu.c                        |  8 +----
>  include/linux/pagemap.h                   | 43 +++++++++++++++++-----
>  include/linux/swap.h                      |  7 ++++
>  mm/filemap.c                              | 44 +++++++++++------------
>  mm/internal.h                             |  3 ++
>  mm/madvise.c                              | 21 ++++++-----
>  mm/memcontrol.c                           | 24 ++-----------
>  mm/mincore.c                              | 28 ++-------------
>  mm/shmem.c                                | 20 +++++------
>  mm/swap_state.c                           | 32 +++++++++++++++++
>  11 files changed, 127 insertions(+), 107 deletions(-)
> 
> -- 
> 2.28.0

I was testing mmotm today (plus the shmem.c and swap_state.c
fixes that you posted, but I did not try the madvise.c one) -
my usual tmpfs swapping loads (plus hyperactive khugepaged to
maximize the THPs).  It behaved well, no problems found.

But I probably won't get to try your series of 12 for a few days.

Hugh
