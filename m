From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 2/3] mm, memcg: inline mem_cgroup_{charge/uncharge} to
 improve disabled memcg config
Date: Sun, 18 Jul 2021 17:55:59 +0100
Message-ID: <YPRdH56+dOFs/Ypu@casper.infradead.org>
References: <20210710003626.3549282-1-surenb@google.com>
 <20210710003626.3549282-2-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ozqJ+/aQSjcd7Pmom3rhVpy9HyQmkQvEGQeoGv8EhNQ=; b=EBrcemI+F3ONTAb2qCb4CEiXIg
        OYQQFvoPudaW7rBK4ckow3sSEtO1iPo7moFRRx2My4GKi27935oIsbbE9ZXDpmXIDA4Gy2HeT8RkP
        PMo5gt0m311JLvrjuS9W8iZPz3mXKyyxf3QFAK2ltH78FIc5ELc2ENoTioPuPt1uxqCtCUGdevzks
        Bgg9PupQJhHpdlGAdDCggkjqj1HH1HsRNMzQEueEDkpp3wrW9tWOrp2JDtZPM1WpJPVjV7LFeRdOD
        E3N5TaOgKd0vAEJymLbibT2ApzY8njVJH1GWaPOdj48YuFFDrmyh1Qm72HEr/w7y/nipf4cDBgmqY
        DwE3ui3A==;
Content-Disposition: inline
In-Reply-To: <20210710003626.3549282-2-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Fri, Jul 09, 2021 at 05:36:25PM -0700, Suren Baghdasaryan wrote:
> @@ -6723,7 +6722,7 @@ static int __mem_cgroup_charge(struct page *page, struct mem_cgroup *memcg,
>  }
>  
>  /**
> - * mem_cgroup_charge - charge a newly allocated page to a cgroup
> + * __mem_cgroup_charge - charge a newly allocated page to a cgroup
>   * @page: page to charge
>   * @mm: mm context of the victim
>   * @gfp_mask: reclaim mode

This patch conflicts with the folio work, so I'm just rebasing the
folio patches on top of this, and I think this part of the patch is a
mistake.  We don't want to document the __mem_cgroup_charge() function.
That's an implementation detail.  This patch should instead have moved the
kernel-doc to memcontrol.h and continued to document mem_cgroup_charge().
