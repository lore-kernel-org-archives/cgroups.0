From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] mm: Use fallthrough;
Date: Sun, 08 Mar 2020 21:51:07 -0700
Message-ID: <84f3c9891d4e89909d5537f34ea9d75de339c415.camel@perches.com>
References: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
         <20200308031825.GB1125@jagdpanzerIV.localdomain>
         <5f297e8995b22c9ccf06d4d0a04f7d9a37d3cd77.camel@perches.com>
         <20200309041551.GA1765@jagdpanzerIV.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200309041551.GA1765@jagdpanzerIV.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, 2020-03-09 at 13:15 +0900, Sergey Senozhatsky wrote:
> On (20/03/07 19:54), Joe Perches wrote:
> > On Sun, 2020-03-08 at 12:18 +0900, Sergey Senozhatsky wrote:
> > > On (20/03/06 23:58), Joe Perches wrote:
> > > [..]
> > > > --- a/mm/mempolicy.c
> > > > +++ b/mm/mempolicy.c
> > > > @@ -907,7 +907,6 @@ static void get_policy_nodemask(struct mempolicy *p, nodemask_t *nodes)
> > > >  
> > > >  	switch (p->mode) {
> > > >  	case MPOL_BIND:
> > > > -		/* Fall through */
> > > >  	case MPOL_INTERLEAVE:
> > 
> > Consecutive case labels do not need an interleaving fallthrough;
> > 
> > ie: ditto
> 
> I see. Shall this be mentioned in the commit message, maybe?

<shrug, maybe>  I've no real opinion about that necessity.

fallthrough commments are relatively rarely used as a
separating element between case labels.

It's by far most common to just have consecutive case labels
without any other content.

It's somewhere between 500:1 to 1000:1 in the kernel.



