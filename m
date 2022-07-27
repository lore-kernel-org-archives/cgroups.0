From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 9/9] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
Date: Wed, 27 Jul 2022 09:00:27 -0400
Message-ID: <YuE26+jMjnE4GZZ2@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-10-zhouchengming@bytedance.com>
 <Yt7gOhbqYzIKyhfv@cmpxchg.org>
 <5f91e194-439a-12c0-4987-5dea0e68a60a@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n6b1aqsIK88pylFiOISBY0ELZL9Xn38SDDWKXVWVdB4=;
        b=mxeEHVKroQaEoNkoAbosEAI+dwFaB8qB8NsFaQPj5VYhC75/7PYl6GD/R0zO3TyA1o
         nBoj0AqdsPWFpokMFX7xH1L99L/Wt5B3Vhap0k0fS0Wvpxa4tOtPicKtinbNQMNuutQ/
         YMVBISTb6VDgAqg17inYCaUofGhW7ywH/m9nNmo/oAm55BIbDT+vkFKe9oij5crJdKPZ
         yc3QzeBkdujnDYXXN2sg9rxjjeXVghNgNJffb03vGdBSiCc8kfoJzJNXPTdAQPi0o/oD
         LJgEWF4gM6XX9sS8R+p8R9tweLfFEPPDS3fyv1LmunM9vr+l6K6rj3qoJCRwHUS/nD0V
         wf7w==
Content-Disposition: inline
In-Reply-To: <5f91e194-439a-12c0-4987-5dea0e68a60a@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On Wed, Jul 27, 2022 at 07:28:37PM +0800, Chengming Zhou wrote:
> On 2022/7/26 02:26, Johannes Weiner wrote:
> > I think we can remove the NR_CPU task count, which frees up one
> > u32. Something like the below diff should work (untested!)
> 
> Hi, I tested ok, would you mind if I put this patch in this series?
> 
> Subject: [PATCH] sched/psi: remove NR_ONCPU task accounting
> 
> We put all fields updated by the scheduler in the first cacheline of
> struct psi_group_cpu for performance.
> 
> Since we want add another PSI_IRQ_FULL to track IRQ/SOFTIRQ pressure,
> we need to reclaim space first. This patch remove NR_ONCPU task accounting
> in struct psi_group_cpu, use TSK_ONCPU in state_mask to track instead.

Thanks for testing it, that sounds good.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Tested-by: Chengming Zhou <zhouchengming@bytedance.com>

Since you're handling the patch, you need to add your own
Signed-off-by: as well. And keep From: Johannes (git commit --author).

Thanks!
