From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Fri, 19 Aug 2022 10:08:59 -0700
Message-ID: <CALvZod7QdLSMdBoD2WztL72qS8kJe7F79JuCH6t19rRcw6Pn1w@mail.gmail.com>
References: <1660908562-17409-1-git-send-email-zhaoyang.huang@unisoc.com> <Yv+6YjaGAv52yvq9@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=9tclK/v9g50KwV+RLBZQMeHODjCGNk5Pk0kzAABIBN4=;
        b=SVUHc0QVIE7RwsM5tECaG+ih+zr0KA2/p4V2kDsO+fKZzFpSkLcK7ni5sebA18KMa7
         LF32TyIIkLMiWoAyP7mOKXdDveWyTioev61RmCh2dJ9tm/bIbyIy3BmAWHKIy+cRCANY
         jeFS66lDeohKToWNEqjUJc7FegMW5N/BeHtbz33h/7ARPr4W4QF2loU8kebWe1GgCdBv
         vFvSwvh3wpb20YoxbdoSuJx4F4DBmsVN6xQwKK1DBMYHMIPUr4SJRVCBDmtpSBJ5qn6x
         1qLMqYfqyHIZb8OoX4Gv6TpFYcHKr4D1oudJJV/17juQUTWSIE+cK9rLIdXTPf9pwQs7
         f7dQ==
In-Reply-To: <Yv+6YjaGAv52yvq9-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Fri, Aug 19, 2022 at 9:29 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri, Aug 19, 2022 at 07:29:22PM +0800, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> >
> > It is observed in android system where per-app cgroup is demanded by freezer
> > subsys and part of groups require memory control. The hierarchy could be simplized
> > as bellowing where memory charged on group B abserved while we only want have
> > group E's memory be controlled and B's descendants compete freely for memory.
> > This should be the consequences of unified hierarchy.
> > Under this scenario, less efficient memory reclaim is observed when comparing
> > with no memory control. It is believed that multi LRU scanning introduces some
> > of the overhead. Furthermore, page thrashing is also heavier than global LRU
> > which could be the consequences of partial failure of WORKINGSET mechanism as
> > LRU is too short to protect the active pages.
> >
> > A(subtree_control = memory) - B(subtree_control = NULL) - C()
> >                                                       \ D()
> >                           - E(subtree_control = memory) - F()
> >                                                         \ G()
> >
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
>
> Just in case it wasn't clear.
>
> Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.
>

Was there a previous discussion on this? The commit message is unreadable.
