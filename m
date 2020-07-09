From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v14 07/20] mm/thp: narrow lru locking
Date: Thu, 9 Jul 2020 18:48:16 +0300
Message-ID: <20200709154816.wieg5thfejyv2h2l@box>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-8-git-send-email-alex.shi@linux.alibaba.com>
 <124eeef1-ff2b-609e-3bf6-a118100c3f2a@linux.alibaba.com>
 <20200706113513.GY25523@casper.infradead.org>
 <alpine.LSU.2.11.2007062059420.2793@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/O6H63+iy27zC2H7F0ueImelp7Ge5SFqvQCCzIgdoPI=;
        b=fJdsoF0IE+FLEEv9KDqsmMTunmNA1t7ytAqxnRwXZCyUBjvHa+7Feup8NmXZt2RCIu
         wsgnS324bHVYR7X24SjoapJxe8mrX3K9+2PcjnHWf6rNZtlb7ZolU+tws3K1hH1KVmcm
         bycKsH6D+8Qh9cjGdW5CUIhYqPa2fotIWVcNMVaZzViZEam/5tBRnUOj9UJO1x+fIc3m
         O8cVqipLSngqj+FzKufF+G68podLoQIbSZLK6hhNLOGNV82XT9hOnl60iqcAl0Y9sW56
         rQS8TUjYjEzWJepjjp1cqlqgBm1rgHT/O7QjaC3BjKm630xfivlUM+Jy9Sg0MDc3qNtn
         ucVQ==
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2007062059420.2793-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Mon, Jul 06, 2020 at 09:52:34PM -0700, Hugh Dickins wrote:
> On Mon, 6 Jul 2020, Matthew Wilcox wrote:
> > On Mon, Jul 06, 2020 at 05:15:09PM +0800, Alex Shi wrote:
> > > Hi Kirill & Johannes & Matthew,
> 
> Adding Kirill, who was in patch's Cc list but not mail's Cc list.
> 
> I asked Alex to direct this one particularly to Kirill and Johannes
> and Matthew because (and I regret that the commit message still does
> not make this at all clear) this patch changes the lock ordering:
> which for years has been lru_lock outside memcg move_lock outside
> i_pages lock, but here inverted to lru_lock inside i_pages lock.
> 
> I don't see a strong reason to have them one way round or the other,
> and think Alex is right that they can safely be reversed here: but
> he doesn't actually give any reason for doing so (if cleanup, then
> I think the cleanup should have been taken further), and no reason
> for doing so as part of this series.

I've looked around and changing order of lru_lock wrt. i_pages lock seems
safe. I don't have much experience with memcg move_lock.

Alex, if you are going ahead with the patch, please document the locking
order. We have some locking orders listed at the beginning of filemap.c
and rmap.c.

local_irq_disable() also deserves a comment.

-- 
 Kirill A. Shutemov
