From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH v17 19/21] mm/vmscan: use relock for move_pages_to_lru
Date: Mon, 3 Aug 2020 15:49:59 -0700
Message-ID: <CAKgT0UebLfdju0Ny9ad5bigzAazqpzfwk2_JNQQ9yEHYyVm5-Q@mail.gmail.com>
References: <1595681998-19193-1-git-send-email-alex.shi@linux.alibaba.com> <1595681998-19193-20-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MAO+PpuYLBX0uefa2B1NpsdRhW1fJ0Gox2/GooMZOIM=;
        b=KoPTr2noAD6XVqblQ0ZDm8p+m1GxTbJgLxmKlP6peN1JC+e0602LcrNh6gu9ebaXQ2
         JeatTeBzUATzp79AE5HlxpKkODqdTWABRJnBgKaTw1JEK6M35cNoSvDmynZZU17JNPCd
         qDj173WmJzHySDfVECR+KGtPR7MNNMY4YEGUCLvWzdtUO4Di7z/F4K+gMHaacHSdb/7i
         6fRIEyaptXGL9Dai6I1u/EbsyMk/NV+sQpP6f8ifB7QfaCeZDWs8z9Ki0VaWK9WOv0l9
         Y7hn756uAd0RcZkpy+MFgf71qbBeZGVeI33T25YFXcnpiZe9iwydIXXFJ/R7aDm0wOdh
         XohA==
In-Reply-To: <1595681998-19193-20-git-send-email-alex.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, kbuild test robot <lkp@intel.com>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Wei Yang <richard.weiyang@gmail.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Rong Chen <rong.a.chen@intel.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jann Horn <jannh@google.com>

On Sat, Jul 25, 2020 at 6:00 AM Alex Shi <alex.shi@linux.alibaba.com> wrote:
>
> From: Hugh Dickins <hughd@google.com>
>
> Use the relock function to replace relocking action. And try to save few
> lock times.
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

I am assuming this is only separate from patch 18 because of the fact
that it is from Hugh and not yourself. Otherwise I would recommend
folding this into patch 18.

Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
