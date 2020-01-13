From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v7 02/10] mm/memcg: fold lru_lock in lock_page_lru
Date: Mon, 13 Jan 2020 08:34:56 -0800
Message-ID: <20200113163456.GA332@bombadil.infradead.org>
References: <1577264666-246071-1-git-send-email-alex.shi@linux.alibaba.com>
 <1577264666-246071-3-git-send-email-alex.shi@linux.alibaba.com>
 <36d7e390-a3d1-908c-d181-4a9e9c8d3d98@yandex-team.ru>
 <952d02c2-8aa5-40bb-88bb-c43dee65c8bc@linux.alibaba.com>
 <2ba8a04e-d8e0-1d50-addc-dbe1b4d8e0f1@yandex-team.ru>
 <a095d80d-8e34-c84f-e4be-085a5aae1929@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OyWI+2CxCOjVFobV/HzUixcC6m6SP/UUicEvP6oEb8U=; b=XlRk9bRCU394R+rkkl6rrGt/r6
        Qqn9DBhqjxKtJUEgSFbDy5JQNJbJrSLegPLKMIFaGZJU18NogpLUuIVMtSW9KicfpHxIQHnBO/ocW
        i6b7r6Sypq7BF6c/ab4JiZ9/G5L1ZIk9k7+CCRNARPqSaAzbPWx9fppVhgFp9uixD9X1Ccq6Wkp3i
        qaaCOJ0wKe++RohEAsXFx/2Fd4hbRAGlSezRtNA9jQ80y1+7E21HirlBOjtVUEsSogU7s6DPjzYcu
        hkcFwwu2lw67HcSA5E7Nk/AqE+ag7qc1Laiq0dLRZsn/4YzeVcznnqauAkfvMcLgbfs3C3d5NsjI/
Content-Disposition: inline
In-Reply-To: <a095d80d-8e34-c84f-e4be-085a5aae1929-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Jan 13, 2020 at 08:47:25PM +0800, Alex Shi wrote:
> 在 2020/1/13 下午5:55, Konstantin Khlebnikov 写道:
> >>> That's wrong. Here PageLRU must be checked again under lru_lock.
> >> Hi, Konstantin,
> >>
> >> For logical remain, we can get the lock and then release for !PageLRU.
> >> but I still can figure out the problem scenario. Would like to give more hints?
> > 
> > That's trivial race: page could be isolated from lru between
> > 
> > if (PageLRU(page))
> > and
> > spin_lock_irq(&pgdat->lru_lock);
> 
> yes, it could be a problem. guess the following change could helpful:
> I will update it in new version.

> +       if (lrucare) {
> +               lruvec = lock_page_lruvec_irq(page);
> +               if (likely(PageLRU(page))) {
> +                       ClearPageLRU(page);
> +                       del_page_from_lru_list(page, lruvec, page_lru(page));
> +               } else {
> +                       unlock_page_lruvec_irq(lruvec);
> +                       lruvec = NULL;
> +               }

What about a harder race to hit like a page being on LRU list A when you
look up the lruvec, then it's removed and added to LRU list B by the
time you get the lock?  At that point, you are holding a lock on the
wrong LRU list.  I think you need to check not just that the page
is still PageLRU but also still on the same LRU list.
