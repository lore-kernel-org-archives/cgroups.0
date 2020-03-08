From: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: Use fallthrough;
Date: Sun, 8 Mar 2020 12:18:25 +0900
Message-ID: <20200308031825.GB1125@jagdpanzerIV.localdomain>
References: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YlUcTsthp1jT+o6f6NANQqT+eCJYTM4ae8wXuy/WzUk=;
        b=ECVc7jtBxuJMkBzqO7pgWcK0ajgrKB9b5cqpx18D9ofoE0+Ficc+pZhn2tDmOBGhHm
         ZVhdh2zoNOCi88ZF9Mo22agCA8qknCa0WBHft1UVXwcWfauUh7NKOp6/I5N8oDqe+IbM
         T7U3/kZubkFdMqZAAwtAY5bGj+38XnBreO/uZR1DDtlVYO46n0vozBkYqPVjnpvuDFV7
         FLmKwafHM6gwYy3cQh4knRZVbDOWjPm2cuJUqwGUu1YiWDW+25SfuU+PnbXmL9ww3DQs
         vqmQJseyhqZ0wb56pQn33955HJBES20I2ZeOIVlmKIWrxHBLCqBE8k8kTO8hR10uL4lq
         Stdw==
Content-Disposition: inline
In-Reply-To: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On (20/03/06 23:58), Joe Perches wrote:
[..]
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -907,7 +907,6 @@ static void get_policy_nodemask(struct mempolicy *p, nodemask_t *nodes)
>  
>  	switch (p->mode) {
>  	case MPOL_BIND:
> -		/* Fall through */
>  	case MPOL_INTERLEAVE:
>  		*nodes = p->v.nodes;
>  		break;
> @@ -2092,7 +2091,6 @@ bool init_nodemask_of_mempolicy(nodemask_t *mask)
>  		break;
>  
>  	case MPOL_BIND:
> -		/* Fall through */
>  	case MPOL_INTERLEAVE:
>  		*mask =  mempolicy->v.nodes;
>  		break;
> @@ -2359,7 +2357,6 @@ bool __mpol_equal(struct mempolicy *a, struct mempolicy *b)
>  
>  	switch (a->mode) {
>  	case MPOL_BIND:
> -		/* Fall through */
>  	case MPOL_INTERLEAVE:
>  		return !!nodes_equal(a->v.nodes, b->v.nodes);
>  	case MPOL_PREFERRED:

Ditto. This doesn't convert /* Fall through */ to fallthrough;

	-ss
