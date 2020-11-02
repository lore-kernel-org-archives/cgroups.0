From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 15/20] mm/lru: introduce TestClearPageLRU
Date: Mon, 2 Nov 2020 10:10:08 -0500
Message-ID: <20201102151008.GH724984@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-16-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UPtv4U9PJYklpaVPZSIF4wy6HpZ+y+9XSdus7akqhs8=;
        b=fvxCbUcg/TaoIHaH+KHaeKyaSujnKcSUTkmfqyKh/QkKJK9U7Sv6hkYTJZuE9PsDOH
         qf1Tnz2zslvTItDBBEGYItyQGojO3aAIR8eUaSJpcqXBn5EEyU5wQLTeRy6/NiByQvOL
         tc249Rsimsi+EMBEKIonliNDNG5ojtn9hnKe3eyWzN95l7neNpaTO8/2yelL57HdyFM/
         ttrYwXC6tcJvxMjYh9r4+Qoj8BFXE/p+GN5LA2/SoF5V7ZReJ2GkiN1jq3m35x2uvVDc
         xTtw2g7qK6VknF3fnO5bwz2y19yw58hf79Y22XgqerPNif0SPlCz8eN78jXHIUeirN0M
         2Ojw==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-16-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com, Michal Hocko <mhocko@kernel.org>

On Thu, Oct 29, 2020 at 06:45:00PM +0800, Alex Shi wrote:
> Currently lru_lock still guards both lru list and page's lru bit, that's
> ok. but if we want to use specific lruvec lock on the page, we need to
> pin down the page's lruvec/memcg during locking. Just taking lruvec
> lock first may be undermined by the page's memcg charge/migration. To
> fix this problem, we could clear the lru bit out of locking and use
> it as pin down action to block the page isolation in memcg changing.

Small nit, but the use of "could" in this sentence sounds like you're
describing one possible solution that isn't being taken, when in fact
you are describing the chosen locking mechanism.

Replacing "could" with "will" would make things a bit clearer IMO.

> So now a standard steps of page isolation is following:
> 	1, get_page(); 	       #pin the page avoid to be free
> 	2, TestClearPageLRU(); #block other isolation like memcg change
> 	3, spin_lock on lru_lock; #serialize lru list access
> 	4, delete page from lru list;
> The step 2 could be optimzed/replaced in scenarios which page is
> unlikely be accessed or be moved between memcgs.

This is a bit ominous. I'd either elaborate / provide an example /
clarify why some sites can deal with races - or just remove that
sentence altogether from this part of the changelog.

> This patch start with the first part: TestClearPageLRU, which combines
> PageLRU check and ClearPageLRU into a macro func TestClearPageLRU. This
> function will be used as page isolation precondition to prevent other
> isolations some where else. Then there are may !PageLRU page on lru
> list, need to remove BUG() checking accordingly.
> 
> There 2 rules for lru bit now:
> 1, the lru bit still indicate if a page on lru list, just in some
>    temporary moment(isolating), the page may have no lru bit when
>    it's on lru list.  but the page still must be on lru list when the
>    lru bit set.
> 2, have to remove lru bit before delete it from lru list.
> 
> As Andrew Morton mentioned this change would dirty cacheline for page
> isn't on LRU. But the lost would be acceptable in Rong Chen
> <rong.a.chen@intel.com> report:
> https://lore.kernel.org/lkml/20200304090301.GB5972@shao2-debian/
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
