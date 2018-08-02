From: peter enderborg <peter.enderborg@sony.com>
Subject: Re: [PATCH 2/9] mm: workingset: tell cache transitions from
 workingset thrashing
Date: Thu, 2 Aug 2018 08:57:31 +0200
Message-ID: <c0480401-fb38-0b46-6dee-a20093dff065@sony.com>
References: <20180801151308.32234-1-hannes@cmpxchg.org>
 <20180801151308.32234-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801151308.32234-3-hannes@cmpxchg.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On 08/01/2018 05:13 PM, Johannes Weiner wrote:
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index e34a27727b9a..7af1c3c15d8e 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -69,13 +69,14 @@
>   */
>  enum pageflags {
>  	PG_locked,		/* Page is locked. Don't touch. */
> -	PG_error,
>  	PG_referenced,
>  	PG_uptodate,
>  	PG_dirty,
>  	PG_lru,
>  	PG_active,
> +	PG_workingset,
>  	PG_waiters,		/* Page has waiters, check its waitqueue. Must be bit #7 and in the same byte as "PG_locked" */
> +	PG_error,
>  	PG_slab,
>  	PG_owner_priv_1,	/* Owner use. If pagecache, fs may use*/
>  	PG_arch_1,
> @@ -280,6 +281,8 @@ PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
Any reason why the PG_error was moved? And dont you need to do some handling of this flag in proc/fs/page.c ?
Some KFP_WORKINGSET ?


