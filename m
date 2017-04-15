From: "Huang\, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm -v8 1/3] mm, THP, swap: Delay splitting THP during swap out
Date: Sat, 15 Apr 2017 09:17:04 +0800
Message-ID: <87k26mzcz3.fsf@yhuang-dev.intel.com>
References: <20170406053515.4842-1-ying.huang@intel.com>
	<20170406053515.4842-2-ying.huang@intel.com>
	<20170414145856.GA9812@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170414145856.GA9812@cmpxchg.org> (Johannes Weiner's message of
	"Fri, 14 Apr 2017 10:58:56 -0400")
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ebru Akagunduz <ebru.akagunduz@gmail.com>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Shaohua Li <shli@kernel.org>, Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>, cgroups@vger.kernel.org

Hi, Johannes,

Johannes Weiner <hannes@cmpxchg.org> writes:

> Hi Huang,
>
> I reviewed this patch based on the feedback I already provided, but
> eventually gave up and rewrote it. Please take review feedback more
> seriously in the future.

Thanks a lot for your help!  I do respect all your review and effort.
The -v8 patch doesn't take all your comments, just because I thought we
have not reach consensus for some points and I want to use -v8 patch to
discuss them.

One concern I have before is whether to split THP firstly when swap
space or memcg swap is used up.  Now I think your solution is
acceptable. And if we receive any regression report for that in the
future, it's not very hard to deal with.

> Attached below is the reworked patch. Most changes are to the layering
> (page functions, cluster functions, range functions) so that we don't
> make the lowest swap range code require a notion of huge pages, or
> make the memcg page functions take size information that can be
> gathered from the page itself. I turned the config symbol into a
> generic THP_SWAP that can later be extended when we add 2MB IO. The
> rest is function naming, #ifdef removal etc.

For some #ifdef in swapfile.c, it is to avoid unnecessary code size
increase for !CONFIG_TRANSPARENT_HUGEPAGE or platform with THP swap
optimization disabled.  Is it an issue?

> Please review whether this is an acceptable version for you.

Yes.  It is good for me.  I will give it more test on next Monday.

[...]

> diff --git a/mm/Kconfig b/mm/Kconfig
> index c89f472b658c..660fb765bf7d 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -447,6 +447,18 @@ choice
>  	  benefit.
>  endchoice
>  
> +config ARCH_WANTS_THP_SWAP
> +       def_bool n
> +
> +config THP_SWAP
> +	def_bool y
> +	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP
> +	help
> +	  Swap transparent huge pages in one piece, without splitting.
> +	  XXX: For now this only does clustered swap space allocation.

Is 'XXX' here intended.

> +
> +	  For selection by architectures with reasonable THP sizes.
> +
>  config	TRANSPARENT_HUGE_PAGECACHE
>  	def_bool y
>  	depends on TRANSPARENT_HUGEPAGE
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d14dd961f626..4a5c1ca21894 100644

[...]

Best Regards,
Huang, Ying

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
