From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [patch 1/7] arch: mm: remove obsolete init OOM protection
Date: Tue, 6 Aug 2013 12:04:48 +0530
Message-ID: <52009908.3070609@synopsys.com>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org> <1375549200-19110-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1375549200-19110-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, azurIt <azurit@pobox.sk>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Johannes,

Thk for the cleanup.

On 08/03/2013 10:29 PM, Johannes Weiner wrote:
> Back before smart OOM killing, when faulting tasks where killed
> directly on allocation failures, the arch-specific fault handlers
> needed special protection for the init process.
> 
> Now that all fault handlers call into the generic OOM killer (609838c
> "mm: invoke oom-killer from remaining unconverted page fault
> handlers"), which already provides init protection, the arch-specific
> leftovers can be removed.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  arch/arc/mm/fault.c   | 5 -----
>  arch/score/mm/fault.c | 6 ------
>  arch/tile/mm/fault.c  | 6 ------
>  3 files changed, 17 deletions(-)

Acked-by: Vineet Gupta <vgupta@synopsys.com>  [arch/arc bits]

-Vineet

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
