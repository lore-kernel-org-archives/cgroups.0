From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
Date: Fri, 22 Feb 2013 15:39:13 +0000
Message-ID: <0000013d028eec8e-012456de-9b98-4bcb-9427-2fbee58ecc74-000000@email.amazonses.com>
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com> <51278A12.4000504@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51278A12.4000504@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On Fri, 22 Feb 2013, Glauber Costa wrote:

> As I've mentioned in the description, the real bug is from partial slabs
> being temporarily in the cpu_slab during a recent allocation and
> therefore unreachable through the partial list.

The bootstrap code does not use cpu slabs but goes directly to the slab
pages. See early_kmem_cache_node_alloc.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
