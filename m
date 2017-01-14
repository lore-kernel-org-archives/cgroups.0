From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/9] slab: introduce __kmemcg_cache_deactivate()
Date: Sat, 14 Jan 2017 10:39:34 -0500
Message-ID: <20170114153934.GD32693@mtj.duckdns.org>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-8-tj@kernel.org>
 <20170114134211.GF2668@esperanza>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=55FBscbkTaPasBFvCJhrVXb2cgYy9ttZtPORZJjxG4U=;
        b=SIkfEPMDwJ7UgOE0UfW1pi816L2dK9wfVbRyYZ0lvC5HDo45pasAmfj5MMb58Q6KIS
         3R443+8ull1cpvPPt4TfV8GS3BxGDwigOLpOGL2xTBHsCQZbZWQ3+0iJHCDUwBmTaSmV
         Yjcw7tf1sd7ZOMHn2Ar3twaU51Hi1KTGcDeWBUZ4VAAo69FHsnilAqq/+/M3PuYNVADV
         lOibEVn7pRWXicg5KDGD25nMa6bZU8OnnqwmDySqOnZ5Jvv6aMlE8epEuVQ73G63QKun
         lZGYp8G4OB9Gs53hrT6D7FII3Rvee63PlMD1roMhYNXXuKejrO7KUfO9qRYf1uoe1m8s
         BlWQ==
Content-Disposition: inline
In-Reply-To: <20170114134211.GF2668@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@tarantool.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Sat, Jan 14, 2017 at 04:42:11PM +0300, Vladimir Davydov wrote:
> > +#if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
> > +void __kmemcg_cache_deactivate(struct kmem_cache *s);
> > +#endif
> 
> nit: ifdef is not necessary

Will drop, thanks.

-- 
tejun
