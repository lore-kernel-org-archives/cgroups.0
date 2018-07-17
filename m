From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Tue, 17 Jul 2018 16:16:14 +0200
Message-ID: <20180717141614.GE2494@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZZ4KndFwA3KV+5BHpYSUDzvyMA6B/8tFlNACiFPkc7g=; b=Qf5bl8Fz6G4a0Y75MfuqgChYz
        gdlrC8C6MboDlATZLjH5AFTU9gZo9cGrVAmv6ZUubf8rvlF8MlnX7+vNtdKbV9CHjgs9HsfOwfYL3
        BltAZ6Yi8BOf5ZjDAOKXWhKLol7opLAo7orHOtGjrYa12uFdjoMAyFT5LJoryhNBK2F9QXxeblnUO
        XpbQeeBdv3drUPUC2sSWtkQqig+3siASQckpfU/gz673w5dcd6ckOtSIIOLoBEN+YJBVwEhd0X9H5
        wElNFOTB7rPo4le5KqWhsR3zcjcPhbfsGgF6+Ur80RoDbbwkLpkXqBP/+tk8fBE28omgiyhQISGIN
      
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> +/* Tracked task states */
> +enum psi_task_count {
> +	NR_RUNNING,
> +	NR_IOWAIT,
> +	NR_MEMSTALL,
> +	NR_PSI_TASK_COUNTS,
> +};

> +/* Resources that workloads could be stalled on */
> +enum psi_res {
> +	PSI_CPU,
> +	PSI_MEM,
> +	PSI_IO,
> +	NR_PSI_RESOURCES,
> +};

These two have mem and iowait in different order. It really doesn't
matter, but my brain stumbled.
