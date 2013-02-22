From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
Date: Fri, 22 Feb 2013 20:20:42 +0400
Message-ID: <51279ADA.4060602@parallels.com>
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <51275364.3010908@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51275364.3010908@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>

On 02/22/2013 03:15 PM, Kamezawa Hiroyuki wrote:
> Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu,com>
I took the liberty to keep this, even with changes in the patch
because I didn't change anything related to the root cause of the
problem.

Let me know if you object.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
