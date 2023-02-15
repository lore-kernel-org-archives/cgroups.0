From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 1/4] mm: change to return bool for folio_isolate_lru()
Date: Wed, 15 Feb 2023 15:35:17 +0000
Message-ID: <Y+z7tT6amGO4wNf4@casper.infradead.org>
References: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
 <8a4e3679ed4196168efadf7ea36c038f2f7d5aa9.1676424378.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Pp8J3FGpQVVxmK5MKJYP1/LwjqePRMBzRQKB1R9+njg=; b=UQs9d+wk5nXuAIIElOHTs4slay
        fOiSZ+YlSaPH2aFP+w5aqTClcGg0sOPkwOUqZCBh0KesaAr+45/AXkKaJ+X9QLerJ1hbbpLgbuXtj
        kdbepirVH+YcR6ZWERVQPhzOONE01jU5U3YT+MQALQPa35xP6ww9uuaTkshx3A1OdwmgCDpgmRq8M
        qL8AtVCQzZTzkUa29npfQ/r4AMz7q1jp+zE5yg2QHlLrQcJtxbQCZli1NHlxNhQ4VApfIeQCsoT28
        OUBrR1t1080Po2ONwgYSO0slfeswePnlGFNBux557gNcuhP/8GyQvUxlYDVrn4loM4aJkyyNAWKNR
        OONpnvLA==;
Content-Disposition: inline
In-Reply-To: <8a4e3679ed4196168efadf7ea36c038f2f7d5aa9.1676424378.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, naoya.horiguchi-YMj9X0ASwKA@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, osalvador-l3A5Bk7waGM@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, damon-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 15, 2023 at 06:39:34PM +0800, Baolin Wang wrote:
> Now the folio_isolate_lru() did not return a boolean value to indicate
> isolation success or not, however below code checking the return value
> can make people think that it was a boolean success/failure thing, which
> makes people easy to make mistakes (see the fix patch[1]).
> 
> if (folio_isolate_lru(folio))
> 	continue;
> 
> Thus it's better to check the negative error value expilictly returned by
> folio_isolate_lru(), which makes code more clear per Linus's suggestion[2].
> Moreover Matthew suggested we can convert the isolation functions to return
> a boolean[3], since most users did not care about the negative error value,
> and can also remove the confusing of checking return value.
> 
> So this patch converts the folio_isolate_lru() to return a boolean value,
> which means return 'true' to indicate the folio isolation is successful,
> and 'false' means a failure to isolation. Meanwhile changing all users'
> logic of checking the isolation state.
> 
> No functional changes intended.
> 
> [1] https://lore.kernel.org/all/20230131063206.28820-1-Kuan-Ying.Lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org/T/#u
> [2] https://lore.kernel.org/all/CAHk-=wiBrY+O-4=2mrbVyxR+hOqfdJ=Do6xoucfJ9_5az01L4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/
> [3] https://lore.kernel.org/all/Y+sTFqwMNAjDvxw3-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org/
> 
> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Reviewed-by: SeongJae Park <sj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
