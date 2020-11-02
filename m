From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 20/20] mm/lru: revise the comments of lru_lock
Date: Mon, 2 Nov 2020 15:46:07 -0500
Message-ID: <20201102204607.GD740958@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-21-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nj7sBGiH3baY4a625q23mk4W+OwP4KOftkycQT8zu4o=;
        b=AooKG3JKnOmiHLh9nY54aYGlYs4PzFJ7MlNomW/8sYein7Vt3XnigPfayRPJcNRlrK
         ZBsuA/Hs9q+xHuwYyIZ0ExR0cE7+VVHZt8+QOG35Oru++TKZNJidpX/UuW05lxc4lHm1
         ehdA1V95yP0ap2IzhmgDjDrWwUq0Ay+RBeA8L3zPBLBnKSdRN/CPrpWYwOpaPZv6oo+1
         mJE7W5YL4VmmnXWJyxus2MHR2GjslNtuUQXItA05LBYMYAjYwNRjR8WGILXmQjuPsLFf
         tcxxfAY6lCD5wxFXijlzYwfHi+fE43euh1dwJzyDic0uGeDgD+zdvpLKx1MwijGOuhsd
         brUQ==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-21-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jann Horn <jannh@google.com>

On Thu, Oct 29, 2020 at 06:45:05PM +0800, Alex Shi wrote:
> From: Hugh Dickins <hughd@google.com>
> 
> Since we changed the pgdat->lru_lock to lruvec->lru_lock, it's time to
> fix the incorrect comments in code. Also fixed some zone->lru_lock comment
> error from ancient time. etc.
> 
> I struggled to understand the comment above move_pages_to_lru() (surely
> it never calls page_referenced()), and eventually realized that most of
> it had got separated from shrink_active_list(): move that comment back.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> Cc: Jann Horn <jannh@google.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: cgroups@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
