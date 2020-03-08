From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] mm: Use fallthrough;
Date: Sun, 8 Mar 2020 12:16:34 +0900
Message-ID: <20200308031634.GA1125@jagdpanzerIV.localdomain>
References: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Nb+0eCJ+RmZWTIi/A28JTvkScuDbfRdl791J3v1ybU=;
        b=gyNFz1js4P3o2fO/Z1TjzVYoqZoqx1LLxetnlManqDFo7XnMcpxZihlmGqOGBDbrbo
         77+5HSZQ5rEo9o06ipb2DYJpyy97T/f8n8DI1fK/AxVr38p/w5nREwHd8W0C5mwYbo5N
         fKAq9qk1qOmVlHcc3vCwUU6TJki/1mKOkx5PkdMBkke4PCWhtz6MF5DjrQgBY4aOKiJK
         bydU0stJCgmMNFiH3vYn6FxdnIhqm8Z2DMGzuuUhNRQV8hLpq/8Y+fqCXmanPBsyFl+o
         Izra9FkQJisCTFoZ8wuvbg5xqiSD9QehRlKbVOeXqaQbCKuNqxaJvcH+e3kFUa//u061
         o3dg==
Content-Disposition: inline
In-Reply-To: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On (20/03/06 23:58), Joe Perches wrote:
[..]
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -424,7 +424,7 @@ static void *zs_zpool_map(void *pool, unsigned long handle,
>  	case ZPOOL_MM_WO:
>  		zs_mm = ZS_MM_WO;
>  		break;
> -	case ZPOOL_MM_RW: /* fall through */
> +	case ZPOOL_MM_RW:
>  	default:
>  		zs_mm = ZS_MM_RW;
>  		break;

Seems like missing fallthrough; for ZPOOL_MM_RW?

	-ss
