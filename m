From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v14 15/20] mm/swap: serialize memcg changes during
 pagevec_lru_move_fn
Date: Sat, 4 Jul 2020 12:39:44 +0100
Message-ID: <20200704113944.GN25523@casper.infradead.org>
References: <1593752873-4493-1-git-send-email-alex.shi@linux.alibaba.com>
 <1593752873-4493-16-git-send-email-alex.shi@linux.alibaba.com>
 <CALYGNiOkA_ZsycF_hqm3XLk55Ek1Mo9w1gO=6EeE35fUtA0i_w@mail.gmail.com>
 <56e395c6-81e7-7163-0d4f-42b91573289f@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MXpoH39hkfx8lgKVBovhjF5ANO4ljnFW8iWeu9q4FtE=; b=iP6/CNSCbNXBo+C/p41wEdgqOs
        Jr4msbp5S/4stoYRzupozCzahdW4W5qLA9rFE/jAJGafZzoTOWq/BtD0LPnMvRdZAJXEUXzA010OC
        wmYNupFLw0kEnngYZDcewEmwgTgPupAdv71XGlf8Mli9TxBAj3g1tIWPIqU6Ez+Mzr9aAiNExKS4u
        0qsXJLoqJ4SlS2+zhU2Orlh37xa8EOmq3xh8FAAwnSgBjB8F6fpRecx3YR4bpQWAo03LZDvzg7EzF
        uVwk2cwG0r3ZxLCtnYzOPq/50Uy2RS5XDCduvq5ZvNsXbvtvqqJLPEFMyhEKEOQ7cZk/omxY9Zx5R
        vwdW2zOQ==;
Content-Disposition: inline
In-Reply-To: <56e395c6-81e7-7163-0d4f-42b91573289f-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?0JrQvtC90YHRgtCw0L3RgtC40L0g0KXQu9C10LHQvdC40LrQvtCy?= <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Sat, Jul 04, 2020 at 07:34:59PM +0800, Alex Shi wrote:
> That's a great idea! Guess what the new struct we need would be like this?
> I like to try this. :)
> 
> 
> diff --git a/include/linux/pagevec.h b/include/linux/pagevec.h
> index 081d934eda64..d62778c8c184 100644
> --- a/include/linux/pagevec.h
> +++ b/include/linux/pagevec.h
> @@ -20,7 +20,7 @@
>  struct pagevec {
>         unsigned char nr;
>         bool percpu_pvec_drained;
> -       struct page *pages[PAGEVEC_SIZE];
> +       struct list_head veclist;
>  };

pagevecs are used not just for LRU.  If you want to use a list_head for
LRU then define a new structure.

