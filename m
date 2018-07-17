From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Tue, 17 Jul 2018 16:21:57 +0200
Message-ID: <20180717142157.GF2494@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OUNk26li7VwVFPkQIQ4fOTX19qt2GWgKPm5YuwyF2nY=; b=CVpUgEPrLebGmj2iK9Fn8Bu7C
        RKjuMWD9R/pc5NaMPCEaTaGTEK7TxlCWmF2lHZmbfUkB9k+OXS/1b0/O6Oxrt4M7CtIbnAroPHfr5
        Ej1plu6xu5F0HsI10Eglr8DxCNVWutsTYTJP6dTiJSBSdAh8AwnvY1ECBOa4sf+Oc22Y0S+2mkP9y
        +WbtODQ2pQ3QsKlAlCCGj7Qs3C9xblzBs0tPUndR37/iGAub5G69ys5EiwPcLfpIF3C994B0wegxt
        nXHdEaIzWK1fUGxwNY6U8ZJ9BlnsznecDEyXDUfnQy/M/hJlWTbEW+5ZU5VHC6M7a+2CXjYgoM0sx
    
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> diff --git a/include/linux/sched/stat.h b/include/linux/sched/stat.h
> index 04f1321d14c4..ac39435d1521 100644
> --- a/include/linux/sched/stat.h
> +++ b/include/linux/sched/stat.h
> @@ -28,10 +28,14 @@ static inline int sched_info_on(void)
>  	return 1;
>  #elif defined(CONFIG_TASK_DELAY_ACCT)
>  	extern int delayacct_on;
> +	if (delayacct_on)
> +		return 1;
> +#elif defined(CONFIG_PSI)
> +	extern int psi_disabled;
> +	if (!psi_disabled)
> +		return 1;
>  #endif
> +	return 0;
>  }

Doesn't that want to be something like:

static inline bool sched_info_on(void)
{
#ifdef CONFIG_SCHEDSTAT
	return true;
#else /* !SCHEDSTAT */
#ifdef CONFIG_TASK_DELAY_ACCT
	extern int delayacct_on;
	if (delayacct_on)
		return true;
#endif /* DELAYACCT */
#ifdef CONFIG_PSI
	extern int psi_disabled;
	if (!psi_disabled)
		return true;
#endif
	return false;
#endif /* !SCHEDSTATE */
}

Such that if you build a TASK_DELAY_ACCT && PSI kernel, and boot with
nodelayacct, you still get sched_info_on().
