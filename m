From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 07/20] mm/vmscan: remove unnecessary lruvec adding
Date: Mon, 2 Nov 2020 09:20:29 -0500
Message-ID: <20201102142029.GA724984@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-8-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RdeHhYw8BZ2CJOSRk/K/2wBpUG/X7Q+JV4i2mCHJHis=;
        b=Bl4aWTuuhh3ejAZOCKHG4CfQeBEfB/JUzCAQAwwU1q27w9LRBHw40b1lYkRV2Z8hA4
         QCcwpiYoEuOFgqnb3iNq28m4KIyBBN5fOyI6VldOmXUxhedZDDNy42rJSFNdtD/CuZJX
         MV7RIrcafzrFPkz0mmz15xMivH5uzP8iAADoZEqaH7kPWlrxOMUuc8BeKWXpHibe0r3p
         fcaA3Qy5+TJ500b6ulilRT0xQoPC9fKNBdxAs1799SKZHJt3n+apv+8+3YA4xNakrj4u
         jL48OgCHNOr5IHRvjp5AZ5+wKcv4WXsDSKH3XjKhupMWKYXAbpQ7cCFP9/THuYXWkqCz
         l7pg==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-8-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Thu, Oct 29, 2020 at 06:44:52PM +0800, Alex Shi wrote:
> We don't have to add a freeable page into lru and then remove from it.
> This change saves a couple of actions and makes the moving more clear.
> 
> The SetPageLRU needs to be kept before put_page_testzero for list
> integrity, otherwise:
> 
>   #0 move_pages_to_lru             #1 release_pages
>   if !put_page_testzero
>      			           if (put_page_testzero())
>      			              !PageLRU //skip lru_lock
>      SetPageLRU()
>      list_add(&page->lru,)
>                                          list_add(&page->lru,)
> 
> [akpm@linux-foundation.org: coding style fixes]
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
