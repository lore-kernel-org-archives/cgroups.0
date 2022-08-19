From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] memcg: use root_mem_cgroup when css is inherited
Date: Fri, 19 Aug 2022 07:10:26 -1000
Message-ID: <Yv/EArPDTcCrGqJh@slm.duckdns.org>
References: <1660908562-17409-1-git-send-email-zhaoyang.huang@unisoc.com>
 <Yv+6YjaGAv52yvq9@slm.duckdns.org>
 <CALvZod7QdLSMdBoD2WztL72qS8kJe7F79JuCH6t19rRcw6Pn1w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=7WjX18+SJwTo5iBm+RDyyQ38vzw7KWPpCCkeot28T3I=;
        b=S2LQx7r114T3Une2zfGFyLwMrHa53oIGdjnC12/4bfWAbMWUv2OE+868ZxwJnKnTK5
         gIVgFaQYliBJlbsl93dYwckLq4nOrsq10YPb+jlSAjq9Umnyphckr+qnSL2aQVpzGVto
         vewKy7me+Lzo+L3NyBQSpckbYXsXXPhMFBybX8rTpvLr/JylVeX0hnH49TJcdqZADlz/
         EAdt9R3Hp5ulkjlW1/sWG3jBtntFH3F7J/pb/QIn81PIGqEbXw1nDsCA6B2zLes55j0a
         lqyzknuwoXDpW3Yokmnj3pI8Unzw9HnSTknRp/Z9t7fKbEETpV2Eg4zTWPxQK3Pq9zlH
         pV1A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALvZod7QdLSMdBoD2WztL72qS8kJe7F79JuCH6t19rRcw6Pn1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Fri, Aug 19, 2022 at 10:08:59AM -0700, Shakeel Butt wrote:
> On Fri, Aug 19, 2022 at 9:29 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Fri, Aug 19, 2022 at 07:29:22PM +0800, zhaoyang.huang wrote:
> > > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > >
> > > It is observed in android system where per-app cgroup is demanded by freezer
> > > subsys and part of groups require memory control. The hierarchy could be simplized
> > > as bellowing where memory charged on group B abserved while we only want have
> > > group E's memory be controlled and B's descendants compete freely for memory.
> > > This should be the consequences of unified hierarchy.
> > > Under this scenario, less efficient memory reclaim is observed when comparing
> > > with no memory control. It is believed that multi LRU scanning introduces some
> > > of the overhead. Furthermore, page thrashing is also heavier than global LRU
> > > which could be the consequences of partial failure of WORKINGSET mechanism as
> > > LRU is too short to protect the active pages.
> > >
> > > A(subtree_control = memory) - B(subtree_control = NULL) - C()
> > >                                                       \ D()
> > >                           - E(subtree_control = memory) - F()
> > >                                                         \ G()
> > >
> > > Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> >
> > Just in case it wasn't clear.
> >
> > Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >
> > Thanks.
> >
> 
> Was there a previous discussion on this? The commit message is unreadable.

http://lkml.kernel.org/r/1660298966-11493-1-git-send-email-zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

Thanks.

-- 
tejun
