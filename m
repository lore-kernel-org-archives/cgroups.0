From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH 9/9] slab: remove slub sysfs interface files early for
 empty memcg caches
Date: Sat, 14 Jan 2017 17:00:43 +0300
Message-ID: <20170114140043.GH2668@esperanza>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-10-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=Var+SzJ+6HTuIsmH2nJMhrzgs88wxki17X73PJP2zsw=;
	b=CAOUjI8+GdMwC5hx5ysACmRIc7P12nF/19Nz9IpWmIKrEjDnFbvUvN/QIW7h790miH43ux4aIouxvC/OPg/CY0KujxeHjUjG3hNT0YAYyMn5JV1hq4VWfvvsCUXNOjzMqcS/TIej/GS71vh4SxM3I067v7VwDXelkmlXDb6lIqs=;
Content-Disposition: inline
In-Reply-To: <20170114055449.11044-10-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Sat, Jan 14, 2017 at 12:54:49AM -0500, Tejun Heo wrote:
> With kmem cgroup support enabled, kmem_caches can be created and
> destroyed frequently and a great number of near empty kmem_caches can
> accumulate if there are a lot of transient cgroups and the system is
> not under memory pressure.  When memory reclaim starts under such
> conditions, it can lead to consecutive deactivation and destruction of
> many kmem_caches, easily hundreds of thousands on moderately large
> systems, exposing scalability issues in the current slab management
> code.  This is one of the patches to address the issue.
> 
> Each cache has a number of sysfs interface files under
> /sys/kernel/slab.  On a system with a lot of memory and transient
> memcgs, the number of interface files which have to be removed once
> memory reclaim kicks in can reach millions.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Jay Vana <jsvana@fb.com>
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
