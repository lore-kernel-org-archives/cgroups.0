From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH -mm] slab: use cgroup ino for naming per memcg caches
Date: Wed, 8 Apr 2015 21:19:11 +0300
Message-ID: <20150408181911.GA18199@esperanza>
References: <1428414798-12932-1-git-send-email-vdavydov@parallels.com>
 <20150407133819.993be7a53a3aa16311aba1f5@linux-foundation.org>
 <20150408095404.GC10286@esperanza>
 <alpine.DEB.2.11.1504080845200.13120@gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1504080845200.13120@gentwo.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Apr 08, 2015 at 08:46:22AM -0500, Christoph Lameter wrote:
> On Wed, 8 Apr 2015, Vladimir Davydov wrote:
> 
> > has its own copy of kmem cache. What if we decide to share the same kmem
> > cache among all memory cgroups one day? Of course, this will hardly ever
> > happen, but it is an alternative approach to implementing the same
> 
> /sys/kernel/slab already supports the use of symlinks. And both SLAB and
> SLUB do slab merging which means effectively an aliasing of multiple slab
> caches to the same name.

Yeah, I think cache merging is a good argument for grouping memcg caches
under /sys/kernel/slab/<slab-name>/cgroup/. We cannot maintain symlinks
for merged memcg caches, because when a memcg cache is created we do not
have names of caches the new cache is merged with. If memcg caches were
listed under /sys/kernel/slab/ along with global ones, absence of the
symlinks would lead to confusion.

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
