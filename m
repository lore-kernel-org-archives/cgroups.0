From: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: Use fallthrough;
Date: Mon, 9 Mar 2020 13:15:51 +0900
Message-ID: <20200309041551.GA1765@jagdpanzerIV.localdomain>
References: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
 <20200308031825.GB1125@jagdpanzerIV.localdomain>
 <5f297e8995b22c9ccf06d4d0a04f7d9a37d3cd77.camel@perches.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jAoReLNBniwrpa0uZH66RQ2ZZJ/sNHlyqQJ+mmk89mc=;
        b=sBKY5ixcRQOrBOp/pyft+S4zvUPqjKpmc1HKbQidmstpOHLfoLeJUB1bAXwWgVi69/
         pj8YKammOpCOOeWyV1Xxbdv/T3MXi30h8eRzLa2mPwqNTAJb+gLZaopAGcW3uUeLI812
         dMdtMcbJQ8HRq2UZj1N1Zi+t69UXv6EIX8g1b7sTXNHHrmRvJ2kgfR5MqM/9Y1q8UNof
         uYQIYzxhqeBGzDigDR6Wn8ClhubyphvMXYhQIXuwUuo4ZO7FrS6xBMn+oQsK1fNrtVtE
         XddnpDf4RfwwEI/eLAd43eEaVqe2VOWsY1xL8HM6rHNTAq4TaJFBfX8Ext1Sr/dfMQDw
         xv1w==
Content-Disposition: inline
In-Reply-To: <5f297e8995b22c9ccf06d4d0a04f7d9a37d3cd77.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On (20/03/07 19:54), Joe Perches wrote:
> On Sun, 2020-03-08 at 12:18 +0900, Sergey Senozhatsky wrote:
> > On (20/03/06 23:58), Joe Perches wrote:
> > [..]
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -907,7 +907,6 @@ static void get_policy_nodemask(struct mempolicy *p, nodemask_t *nodes)
> > >  
> > >  	switch (p->mode) {
> > >  	case MPOL_BIND:
> > > -		/* Fall through */
> > >  	case MPOL_INTERLEAVE:
> 
> Consecutive case labels do not need an interleaving fallthrough;
> 
> ie: ditto

I see. Shall this be mentioned in the commit message, maybe?

	-ss
