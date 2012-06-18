From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroups: Account for CSS_DEACT_BIAS in __css_put
Date: Mon, 18 Jun 2012 15:39:23 -0700
Message-ID: <20120618223923.GG32733@google.com>
References: <20120614215530.12092.3543.stgit@dungbeetle.mtv.corp.google.com>
 <4FDAE23C.2020908@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uKGfT0el4tSVN2pRoyHch6HxEM0qXYNUyf85lbY2ImM=;
        b=xx6GvEXVbVYq5/zhACJs889gZXk9KX0n2pj6nIRtLlteZMprt0yM+QmZPu17KZWkfX
         PWxtII9k0y0Qjakqeu+EPf5ARnUQ3RUxyq2pp9J3PwoYlf9c8pvMILDviyHB0BNesqIM
         XK1G/sBWAE1QuOolzFTgCznce5kdwL7Q7Git2BJOREP4huUVqFj+Ni0RhjJTdGeIGWiC
         H0C54JFyrg7DBnXXJCT11xAp4reaJOQBT2AxpedsJ0N9XkErsoMzFh0cPzISzCWgJUb6
         vTl+ApDnX+xt+Ozz1wA8MN2OCwOuIKkadqZ1qumSxk9QCWBeyAc+QkYbrsYalvFM4IcC
         lw3A==
Content-Disposition: inline
In-Reply-To: <4FDAE23C.2020908-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 15, 2012 at 03:20:28PM +0800, Li Zefan wrote:
> On 2012/6/15 5:55, Salman Qazi wrote:
> 
> > When we fixed the race between atomic_dec and css_refcnt, we missed
> > the fact that css_refcnt internally subtracts CSS_DEACT_BIAS to get
> > the actual reference count.  This can potentially cause a refcount leak
> > if __css_put races with cgroup_clear_css_refs.
> > 
> > Signed-off-by: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> 
> Hope we've got everything right this time!
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to for-3.5-fixes.  Thanks.

-- 
tejun
