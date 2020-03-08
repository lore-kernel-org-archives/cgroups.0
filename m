From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] mm: Use fallthrough;
Date: Sat, 07 Mar 2020 19:54:36 -0800
Message-ID: <5f297e8995b22c9ccf06d4d0a04f7d9a37d3cd77.camel@perches.com>
References: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
         <20200308031825.GB1125@jagdpanzerIV.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200308031825.GB1125-NsMb8Yw0+OOoSBNdbAt9fHzaFgp7qdfK@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 2020-03-08 at 12:18 +0900, Sergey Senozhatsky wrote:
> On (20/03/06 23:58), Joe Perches wrote:
> [..]
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -907,7 +907,6 @@ static void get_policy_nodemask(struct mempolicy *p, nodemask_t *nodes)
> >  
> >  	switch (p->mode) {
> >  	case MPOL_BIND:
> > -		/* Fall through */
> >  	case MPOL_INTERLEAVE:

Consecutive case labels do not need an interleaving fallthrough;

ie: ditto

cheers, Joe

