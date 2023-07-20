From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 0/8] memory recharging for offline memcgs
Date: Thu, 20 Jul 2023 12:31:02 -1000
Message-ID: <ZLm1ptOYH6F8fGHT@slm.duckdns.org>
References: <20230720070825.992023-1-yosryahmed@google.com>
 <20230720153515.GA1003248@cmpxchg.org>
 <ZLmRlTej8Tm82kXG@slm.duckdns.org>
 <CAJD7tkYhu3g9u7HkUTFBtT3Q4edVZ2g1TWV1FDcyM9srrYCBLg@mail.gmail.com>
 <ZLmxLUNdxMi5s2Kq@slm.duckdns.org>
 <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689892264; x=1690497064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZpl8s75HuZGEhNzUvLR3L4qywqf/Lpjo/SjREf5tA4=;
        b=ghf2BigSLopuzIAO9mo5bilaWUW4pw/MFFRLacsY7gWLDlVj9giiAM8MRIJR4yUUN1
         0eZXp+66XIpghEylgvGqAISiRJtWYiAeKFk7WqWG9YoONhzF7W8uockvwN6JHX9P2ZkX
         1WQhxBW7HjKnkQF7XhjgGOYKP2fXw2EG0F8J+r2UjwCm20cngLNEKgvq2w+1/xMghmP4
         0F1mD2djp/qp+HRvQPIcmx4EbINiffoW4s2adiKXZS/QnQC/F3zsDi5AZw11mkZQfaLw
         JFzkRMQNS3a5BSHUM/Gm5XZF6bkZeN/kuIDV0MNaB/JLMC1CDfRMDUaljWa1nfZfBNCU
         Dtbw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkZKo_oSZ-mQc-knMELP8kiY1N7taQhdV6tPsqN0tg=gog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Jul 20, 2023 at 03:23:59PM -0700, Yosry Ahmed wrote:
> > On its own, AFAICS, I'm not sure the scope of problems it can actually solve
> > is justifiably greater than what can be achieved with simple nesting.
> 
> In our use case nesting is not a viable option. As I said, in a large
> fleet where a lot of different workloads are dynamically being
> scheduled on different machines, and where there is no way of knowing
> what resources are being shared among what workloads, and even if we
> do, it wouldn't be constant, it's very difficult to construct the
> hierarchy with nesting to keep the resources confined.

Hmm... so, usually, the problems we see are resources that are persistent
across different instances of the same application as they may want to share
large chunks of memory like on-memory cache. I get that machines get
different dynamic jobs but unrelated jobs usually don't share huge amount of
memory at least in our case. The sharing across them comes down to things
like some common library pages which don't really account for much these
days.

> Keep in mind that the environment is dynamic, workloads are constantly
> coming and going. Even if find the perfect nesting to appropriately
> scope resources, some rescheduling may render the hierarchy obsolete
> and require us to start over.

Can you please go into more details on how much memory is shared for what
across unrelated dynamic workloads? That sounds different from other use
cases.

Thanks.

-- 
tejun
