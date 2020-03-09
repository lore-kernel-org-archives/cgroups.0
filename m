From: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: Use fallthrough;
Date: Mon, 9 Mar 2020 15:48:06 +0900
Message-ID: <20200309064806.GB46830@google.com>
References: <f62fea5d10eb0ccfc05d87c242a620c261219b66.camel@perches.com>
 <20200308031825.GB1125@jagdpanzerIV.localdomain>
 <5f297e8995b22c9ccf06d4d0a04f7d9a37d3cd77.camel@perches.com>
 <20200309041551.GA1765@jagdpanzerIV.localdomain>
 <84f3c9891d4e89909d5537f34ea9d75de339c415.camel@perches.com>
 <20200309062046.GA46830@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y4UxGHAQZzEPyQy0KsfAI6f3ElLxET+uiuIqagGiKHY=;
        b=B6pVr9UgIF/7hOkq20mC2Tt8jES/c+2rAZeqAcgLBjERCMe3+hq3EpMlarZK9XW4j2
         7Z4TjxwS3LhKwveWSWHGBN9wdcb2nxb4Epj0ixu30KrLq+maqRWnbOMn4UcEr8Dg9ipz
         yTnNGYdcXhxzg5vMpI9Oe2I+lC4Wq0sreAnJZMQqU7vBHps1ykJ26WyKrNCXxtN9hJ4N
         uybpbMx7yoss9Xln3TAb7zP+3CmV8CCEvfro2zQCJ8uMjQqQ/QSbBRJnWl02a1YUZo+E
         2PftO9hM/qgTcb5zBGVg/hAnXyOVtN46PMS7R8nTLJcl4/mIjWOK5T+VEKNLfzuCOW4c
         pRjg==
Content-Disposition: inline
In-Reply-To: <20200309062046.GA46830-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On (20/03/09 15:20), Sergey Senozhatsky wrote:
[..]
> > <shrug, maybe>  I've no real opinion about that necessity.
> > 
> > fallthrough commments are relatively rarely used as a
> > separating element between case labels.
> > 
> > It's by far most common to just have consecutive case labels
> > without any other content.
> > 
> > It's somewhere between 500:1 to 1000:1 in the kernel.
> 
> I thought that those labels were used by some static code analysis
> tools, so that the removal of some labels raised questions. But I
> don't think I have opinions otherwise.

... I guess GCC counts as a static code analysis tool :)

Looking at previous commits, people wanted to have proper 'fall through'


    Replace "fallthru" with a proper "fall through" annotation.
    This fix is part of the ongoing efforts to enabling
    -Wimplicit-fallthrough

---

-       case ZPOOL_MM_RW: /* fallthru */
+       case ZPOOL_MM_RW: /* fall through */

---


> Consecutive case labels do not need an interleaving fallthrough;

I suppose this means that GCC -Wimplicit-fallthrough handles it?

	-ss
