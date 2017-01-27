From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH v2 02/10] slub: separate out sysfs_slab_release() from
 sysfs_slab_remove()
Date: Fri, 27 Jan 2017 21:00:12 +0300
Message-ID: <20170127180012.GA4332@esperanza>
References: <20170117235411.9408-1-tj@kernel.org>
 <20170117235411.9408-3-tj@kernel.org>
 <20170123225449.GA29940@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=enjoeUK4hIR5fR0rkHPM3I7z2diat6hkZtcLphIRTUs=;
	b=bBm1BW/AjY5x2XqmbTWWTipMsasOHTGdSBiNOPRq9fw36k+tgTR2yYLHeWfKewKUINzzlNXVhY4M0tD9y1UnCjoNZ7w23RV/G6KUTzPHkKWHShazM7Kk9OKKRMZWqZ/Whq7n3zSHCg7k1mz1Eesxj5kQJt1kfDHw7wZ3h3KwOT4=;
Content-Disposition: inline
In-Reply-To: <20170123225449.GA29940@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Mon, Jan 23, 2017 at 05:54:49PM -0500, Tejun Heo wrote:
> From 3b0cdd93b2d9bdea62ea6681e612bdae7a40d883 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Mon, 23 Jan 2017 17:53:18 -0500
> 
> Separate out slub sysfs removal and release, and call the former
> earlier from __kmem_cache_shutdown().  There's no reason to defer
> sysfs removal through RCU and this will later allow us to remove sysfs
> files way earlier during memory cgroup offline instead of release.
> 
> v2: Add slab_state >= FULL test to sysfs_slab_release() so that
>     kobject_put() is skipped for caches which aren't fully initialized
>     as before.  This most likely leaks the kmem_cache on init failure
>     as we're skipping the only release path.  Let's fix that up later.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
