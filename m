From: "Huang, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v1 3/4] mm: Fix demotion-only scanning anon pages
Date: Thu, 24 Nov 2022 13:27:51 +0800
Message-ID: <87wn7korag.fsf@yhuang6-desk2.ccr.corp.intel.com>
References: <20221122203850.2765015-1-almasrymina@google.com>
        <20221122203850.2765015-3-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669267736; x=1700803736;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=yzllx2aXHanc4RlM697MHQ9doyide2+HpLsBlPh6fPY=;
  b=a7dd0UFqA3/b8+LxYo0ChDAgo7WfRQGqC1iCpvwDfDhxowOyxepWaw59
   apO8di9w/hQ9DO5tyKbiukx/RD58d+9ULQ2jxwo8wCBoeL/o76M4lqglR
   kBjEX7DKXNZdWdOiB5k07/fu6jm6VMbne4/S5R6Hf9voHISOupa1ZgfDR
   M2IInhX9pJAR2UDZ+HL/29V9P4HE8VjSq3PtrnHKoTW7BZEsRtq1hes5l
   u8QABUokbJdktH0woThF8vlEusrI1zMxyCJxP1gplu4bJIL7Z63Yf/BFe
   vsKz75MvKFdxLlqkiIX3FVlZRGQg0cPTptorCBnyo18l/j8+YbRVbTvxS
   Q==;
In-Reply-To: <20221122203850.2765015-3-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Mina Almasry's
        message of "Tue, 22 Nov 2022 12:38:47 -0800")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, weixugc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fvdl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

> This is likely a missed change from commit a2a36488a61c ("mm/vmscan: Consider
> anonymous pages without swap"). Current logic is if !may_swap _or_
> !can_reclaim_anon_pages() then we don't scan anon memory.
>
> This should be an 'and'. We would like to scan anon memory if we may swap
> or if we can_reclaim_anon_pages().
>
> Fixes: commit a2a36488a61c ("mm/vmscan: Consider anonymous pages without swap")
>
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8c1f5416d789..d7e509b3f07f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2931,7 +2931,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>  	enum lru_list lru;
>
>  	/* If we have no swap space, do not bother scanning anon folios. */
> -	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
> +	if (!sc->may_swap && !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {

If there is only DRAM but swap device is enabled, sc->may_swap will not
work as expected.  So we should check can_demote() instead if
sc->may_swap.

Best Regards,
Huang, Ying

>  		scan_balance = SCAN_FILE;
>  		goto out;
>  	}
> --
> 2.38.1.584.g0f3c55d4c2-goog
