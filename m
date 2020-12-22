From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/3] mm/memcg: revise the using condition of lock_page_lruvec
 function series
Date: Mon, 21 Dec 2020 19:01:37 -0800 (PST)
Message-ID: <alpine.LSU.2.11.2012211827560.1045@eggly.anvils>
References: <1608186532-81218-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=xZEe9nKbt22VK8Tq7L3dwCEv8d6KPrIVgCMxlhwxx3Q=;
        b=ToNIvWYMRuu67rHR26AoZ8LITvFFxwKDzFXUBeCMHNVl9SKWs2JiL/rESRW/P6aWJy
         K6uYZlQtdKrjpUypOhtUEmTbzBVZ1JnAbGM/S6YJMjCxSnF+nSUXZCn3KOFY2LvCS6yz
         yc7Ey0QONEBlbY7YFA13knO/pXtKTn6amSjABq3fNCUIvqUyZI1X2Z8kVdkrs0YKXy/X
         dEzx3hydhKrzU/EAU6oDiekbRHBwAXYr4n9POMB0yGtPsLSNA9+Be7PDY1SzMd5y2a+n
         5SeCwkA5h823mfelQnl3wo05eq4v51qbunVKJ1C1tFvEVszIU8m/T2XG6s27myJXTfMl
         pMlQ==
In-Reply-To: <1608186532-81218-1-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu, 17 Dec 2020, Alex Shi wrote:

> The series function could be used under lock_page_memcg(), add this and
> a bit style changes following commit_charge().
> 
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Hugh Dickins <hughd@google.com>

This patch, or its intention,
Acked-by: Hugh Dickins <hughd@google.com>
but rewording suggested below, and requested above -
which left me very puzzled before eventually I understood it.
I don't think we need to talk about "a bit style changes",
but the cross-reference to commit_charge() is helpful.

"
lock_page_lruvec() and its variants are safe to use under the same
conditions as commit_charge(): add lock_page_memcg() to the comment.
"

> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/memcontrol.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b80328f52fb4..e6b50d068b2f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1345,10 +1345,11 @@ void lruvec_memcg_debug(struct lruvec *lruvec, struct page *page)
>   * lock_page_lruvec - lock and return lruvec for a given page.
>   * @page: the page
>   *
> - * This series functions should be used in either conditions:
> - * PageLRU is cleared or unset
> - * or page->_refcount is zero
> - * or page is locked.
> + * This series functions should be used in any one of following conditions:

These functions are safe to use under any of the following conditions:

> + * - PageLRU is cleared or unset
> + * - page->_refcount is zero
> + * - page is locked.

Remove that full stop...

> + * - lock_page_memcg()

... and, if you wish (I don't care), add full stop at the end of that line.

Maybe reorder those to the same order as listed in commit_charge().
Copy its text exactly? I don't think so, actually, I find your wording
(e.g. _refcount is zero) more explicit: good to have both descriptions.

>   */
>  struct lruvec *lock_page_lruvec(struct page *page)
>  {
> -- 
> 2.29.GIT
