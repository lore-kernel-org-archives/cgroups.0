From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
Date: Fri, 22 Feb 2013 16:34:47 +0000
Message-ID: <0000013d02c1c9be-1a06ac46-e42b-4174-8a41-bc5b22ad36ad-000000@email.amazonses.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1361550000-14173-1-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>

On Fri, 22 Feb 2013, Glauber Costa wrote:

> After we create a boot cache, we may allocate from it until it is bootstraped.
> This will move the page from the partial list to the cpu slab list. If this
> happens, the loop:

Acked-by: Christoph Lameter <cl@linux.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
