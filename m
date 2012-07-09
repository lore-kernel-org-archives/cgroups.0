From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch 10/11] mm: memcg: only check swap cache pages for repeated
 charging
Date: Mon, 09 Jul 2012 12:26:46 +0900
Message-ID: <4FFA4F76.7090901@jp.fujitsu.com>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org> <1341449103-1986-11-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1341449103-1986-11-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

(2012/07/05 9:45), Johannes Weiner wrote:
> Only anon and shmem pages in the swap cache are attempted to be
> charged multiple times, from every swap pte fault or from
> shmem_unuse().  No other pages require checking PageCgroupUsed().
> 
> Charging pages in the swap cache is also serialized by the page lock,
> and since both the try_charge and commit_charge are called under the
> same page lock section, the PageCgroupUsed() check might as well
> happen before the counter charging, let alone reclaim.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

You're right. This is SwapCache handling is done by commit d13d144309d...
I should notice this....

Thank you very much !

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
