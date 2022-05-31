From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Mon, 30 May 2022 19:46:20 -0700
Message-ID: <YpWBfPviP0TTSF4d@carbon>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530141711.6cf70dcf200e28aa40407f6e@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653965188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CWLskQLKMPVKxlcT8cF2mhzS9rXCoBmCHqKI67gGiCw=;
        b=f5jx0zSo1IDRLLA2GZuXmPBxAvu6IPoXlGGFIPAW6XeA5oP8KzsIUya+c1dZtZ3UwqO1Y6
        alTzIKwUDxFq+Ya5GGK63RBl/slscys5MmU+WjXwPXiLMFoPRataIRfeAwFWACW+GEE26w
        rUWXxNveDigVU/2Y0MKCi5DvmbtlULU=
Content-Disposition: inline
In-Reply-To: <20220530141711.6cf70dcf200e28aa40407f6e-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 30, 2022 at 02:17:11PM -0700, Andrew Morton wrote:
> On Mon, 30 May 2022 15:49:08 +0800 Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> 
> > This version is rebased on v5.18.
> 
> Not a great choice of base, really.  mm-stable or mm-unstable or
> linux-next or even linus-of-the-day are all much more up to date.
> 
> Although the memcg reviewer tags are pretty thin, I was going to give
> it a run.  But after fixing a bunch of conflicts I got about halfway
> through then gave up on a big snarl in get_obj_cgroup_from_current().
> 
> > RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> 
> Surprising, that was over a year ago.  Why has is taken so long?

It's partially my fault: I was thinking (and to some extent still are)
that using objcg is not the best choice long-term and was pushing on the
idea to used per-memcg lru vectors as intermediate objects instead.
But it looks like I underestimated the complexity and a potential overhead
of this solution.

The objcg-based approach can solve the problem right now and it shouldn't
bring any long-term issues. So I asked Muchun to revive the patchset.

Thanks!
