From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcontrol: replace the loop with a
 list_for_each_entry()
Date: Thu, 4 Feb 2021 12:43:56 -0500
Message-ID: <YBwyXPFoXrLcxsZR@cmpxchg.org>
References: <20210204163055.56080-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GCBGFufjjtkKM79QaCqD4gnNbGr/Jp0wwB8/7DPDEJI=;
        b=kNmXSlAAZOA5BA1Nd/FHNTmnZuUl+kBcrKvgz0V3T9PaqZLDkAdiv+vpuvjGJWzgIQ
         1JbP6ozldUU5i9up9n52QDgGGYGoDr2vLQPsW3ypPSvSxzf47qEyMaHhjlht+j+pN+Am
         0SC3HBoEE2tK35rFDjrbYwH6woQAqVY+EP9KnLUo6SV1bNagCuG4CyFcPPx5AvuoKcPK
         hlMTyTVcLovypO7oBoPsJ00SQg0EViX0k+ScJ67WU8/8sMm7MpxTfTpmb9HHxGuwY84a
         31WQ5Pt3MX0MummZwo7oyY4RA7sqHnFFYctmMseNA4rmTHJTHv75zulDM5FQKOCrxpog
         rfpg==
Content-Disposition: inline
In-Reply-To: <20210204163055.56080-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Feb 05, 2021 at 12:30:55AM +0800, Muchun Song wrote:
> The rule of list walk has gone since:
> 
>  commit a9d5adeeb4b2 ("mm/memcontrol: allow to uncharge page without using page->lru field")
> 
> So remove the strange comment and replace the loop with a
> list_for_each_entry().
> 
> There is only one caller of the uncharge_list(). So just fold it into
> mem_cgroup_uncharge_list() and remove it.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Thank you, Muchun!
