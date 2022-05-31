From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v5 00/11] Use obj_cgroup APIs to charge the LRU pages
Date: Tue, 31 May 2022 10:26:17 +0800
Message-ID: <YpV8yVKKNmGw91No@FVFYT0MHHV2J.googleapis.com>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530141711.6cf70dcf200e28aa40407f6e@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iv992blvs9Id0nKZNCQUi6AyK6qrkd7jCkuGgUWlqac=;
        b=QR9cp9SlXdxGFYBU5pilxQohbMBQAncS2IAUFL9MoT8gLdPyRrBdE+JmyHndh9OQDg
         rE6eeyc2jdsYk2vf0nYodiyQND1GTFmLwfIz41dLTveJWgyd3CRiZNPlWKe95h50CgOb
         RkmyOosMbRMZOCc6SduyD1vr+umt926AfGjmNX3fAdC1o966UMdF7EL3yB8dzVPhnWnK
         QOIitl7ariGYpeYBouTPLGraZr9dAfwtV87t5xQWTCYYgzELw1Dd6chT0Ep55jLLPQGb
         nSjNqhXIjVYKR0yBFSi8ZH/T6jT+m5mGD+zwpyWgCHzM5v5oT6nIuxtXCbS6PebIy8fn
         IO6w==
Content-Disposition: inline
In-Reply-To: <20220530141711.6cf70dcf200e28aa40407f6e-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 30, 2022 at 02:17:11PM -0700, Andrew Morton wrote:
> On Mon, 30 May 2022 15:49:08 +0800 Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> 
> > This version is rebased on v5.18.
> 
> Not a great choice of base, really.  mm-stable or mm-unstable or
> linux-next or even linus-of-the-day are all much more up to date.
>

I'll rebase it to linux-next in v6.
 
> Although the memcg reviewer tags are pretty thin, I was going to give
> it a run.  But after fixing a bunch of conflicts I got about halfway
> through then gave up on a big snarl in get_obj_cgroup_from_current().
>

Got it. Will fix.

> > RFC v1: https://lore.kernel.org/all/20210330101531.82752-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
> 
> Surprising, that was over a year ago.  Why has is taken so long?
>

Yeah, a little long. This issue has been going on for years.
I have proposed an approach based on objcg to solve this issue
last year, however, we are not sure if this is the best choice.
So this patchset stalled for months.  Recently, this issue
was proposed in LSFMM 2022 conference by Roman, consensus was
that the objcg-based reparenting is fine as well.  So this
patchset has recently resumed.

Thanks.
