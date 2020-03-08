From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] mm: Use fallthrough;
Date: Sat, 07 Mar 2020 19:19:04 -0800
Message-ID: <bfc9f9b69681c3ef285bf11b6506fa5b42b5917a.camel@perches.com>
References: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
         <20200308031634.GA1125@jagdpanzerIV.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200308031634.GA1125@jagdpanzerIV.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Sun, 2020-03-08 at 12:16 +0900, Sergey Senozhatsky wrote:
> On (20/03/06 23:58), Joe Perches wrote:
> [..]
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -424,7 +424,7 @@ static void *zs_zpool_map(void *pool, unsigned long handle,
> >  	case ZPOOL_MM_WO:
> >  		zs_mm = ZS_MM_WO;
> >  		break;
> > -	case ZPOOL_MM_RW: /* fall through */
> > +	case ZPOOL_MM_RW:
> >  	default:
> >  		zs_mm = ZS_MM_RW;
> >  		break;
> 
> Seems like missing fallthrough; for ZPOOL_MM_RW?

Consecutive case labels do not need an interleaving fallthrough


