From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
Date: Fri, 22 Feb 2013 16:34:19 +0000
Message-ID: <0000013d02c15c85-1443abb7-e86b-429c-8452-3f2218a9b38f-000000@email.amazonses.com>
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com> <51278A12.4000504@parallels.com> <0000013d028eec8e-012456de-9b98-4bcb-9427-2fbee58ecc74-000000@email.amazonses.com>
 <5127928A.20000@parallels.com> <0000013d02ab8230-de441d64-395f-4c87-89e7-3f2cd2209680-000000@email.amazonses.com> <512798CC.2080501@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <512798CC.2080501@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Joonsoo Kim <js1304@gmail.com>

On Fri, 22 Feb 2013, Glauber Costa wrote:

> On 02/22/2013 08:10 PM, Christoph Lameter wrote:
> > kmem_cache_node creation runs before PARTIAL and kmem_cache runs
> > after. So there would be 2 kmem_cache_node structures allocated. Ok so
> > that would use cpu slabs and therefore remove pages from the partial list.
> > Pushing that back using the flushing should fix this. But I thought there
> > was already code that went through the cpu slabs to address this?
>
> not in bootstrap(), which is quite primitive. (and should remain so)

Joonsoo Kim had a patch for this. I acked it a while back AFAICR


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
