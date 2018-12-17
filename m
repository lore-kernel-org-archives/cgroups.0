From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 6/6] psi: introduce psi monitor
Date: Mon, 17 Dec 2018 17:27:13 +0100
Message-ID: <20181217162713.GE2218@hirez.programming.kicks-ass.net>
References: <20181214171508.7791-1-surenb@google.com>
 <20181214171508.7791-7-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tvRn8uif1FnxMDVH2moPVASXN2XAW1fiY/rFaMZFEyI=; b=dQXzUi5NrkierFSHvM7QCXs/O
        ZWFNmaeehaYNLpnR9GzryAAPBBuVRKGb5l5VBNg47EzvcT89POWv2REMMhC0649KvhmagRsJd1tAe
        CWc/ezl7zDP9exWBlWQqVDFjwSShk2d317FMyVCXlrY+5VwqB0lgpwGiPAS2S7juxUN90QpPCo335
        w1nOWDyeWHwjeWfpfeglVR7q5ulW8OAr7kzgQwyk72FblOry58HlIPfwfLw+tOfINWShO3EXTyu9c
        801sQ9YVHkOnYX7T5Py6gD59cwK0XaIHPSww5RXI6TDjy8JZFY5geZl+5MLUlQDc6vioOAhAuiKu1
    
Content-Disposition: inline
In-Reply-To: <20181214171508.7791-7-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Fri, Dec 14, 2018 at 09:15:08AM -0800, Suren Baghdasaryan wrote:
> @@ -358,28 +526,23 @@ static void psi_update_work(struct work_struct *work)
>  {
>  	struct delayed_work *dwork;
>  	struct psi_group *group;
> +	u64 next_update;
>  
>  	dwork = to_delayed_work(work);
>  	group = container_of(dwork, struct psi_group, clock_work);
>  
>  	/*
> +	 * Periodically fold the per-cpu times and feed samples
> +	 * into the running averages.
>  	 */
>  
> +	psi_update(group);
>  
> +	/* Calculate closest update time */
> +	next_update = min(group->polling_next_update,
> +				group->avg_next_update);
> +	schedule_delayed_work(dwork, min(PSI_FREQ,
> +		nsecs_to_jiffies(next_update - sched_clock()) + 1));

See, so I don't at _all_ like how there is no idle option..

>  }


