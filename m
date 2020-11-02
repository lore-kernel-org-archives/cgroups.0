From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v20 10/20] mm/swap.c: fold vm event PGROTATED into
 pagevec_move_tail_fn
Date: Mon, 2 Nov 2020 09:48:39 -0500
Message-ID: <20201102144839.GD724984@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-11-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JYqsaLDo1+ctYQbIf4q0wk9qZ0QBJ7TUi9/Nha1uioc=;
        b=H5HLQwnJYlowV4BaCrk9lh4Rqv7LFNr1+ef9UuGrfs5uzMNGGH4S3gy1OrnNoSg1n4
         qjp/UBXHnGGn1vs0uilbdhjR/qhdlhJpKTd9NxFS1BE5ZhEW2XuxKOspnRlJ+4skQPuH
         obC3duxwWHpG7NXn6/W1y7hs83JBQN9iCx+IVzi7b9VHiiqPZQpNL+zRrDOUuL88XfNn
         gIb9BTXH9zbiDnNL993P6oZIKIVEApD/z1PUM8nxlTqGIJSpp4aDemPjumqzx4KDDxOX
         oCkknATB88ysU2YL0ak/MykrNAe7SxDvIW8asaLYvRq6wxUgOscIZcZiesigfHfsq590
         6UwQ==
Content-Disposition: inline
In-Reply-To: <1603968305-8026-11-git-send-email-alex.shi@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net, tj@kernel.org, hughd@google.com, khlebnikov@yandex-team.ru, daniel.m.jordan@oracle.com, willy@infradead.org, lkp@intel.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, shakeelb@google.com, iamjoonsoo.kim@lge.com, richard.weiyang@gmail.com, kirill@shutemov.name, alexander.duyck@gmail.com, rong.a.chen@intel.com, mhocko@suse.com, vdavydov.dev@gmail.com, shy828301@gmail.com

On Thu, Oct 29, 2020 at 06:44:55PM +0800, Alex Shi wrote:
> Fold the PGROTATED event collection into pagevec_move_tail_fn call back
> func like other funcs does in pagevec_lru_move_fn. Thus we could save
> func call pagevec_move_tail().
> Now all usage of pagevec_lru_move_fn are same and no needs of its 3rd
> parameter.
> 
> It's just simply the calling. No functional change.
> 
> [lkp@intel.com: found a build issue in the original patch, thanks]
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org

Nice.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
