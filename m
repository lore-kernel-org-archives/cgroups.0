From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 07/10] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ
 pressure
Date: Thu, 25 Aug 2022 13:17:35 -0400
Message-ID: <Yweur4ugxvLbP2L2@cmpxchg.org>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
 <20220825164111.29534-8-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=jwOz4iT2BQeb7Z52GoBXCVE165vQ/PaiB7E4MX3VOzg=;
        b=2g15XhRTJVHl3pGrBt7KYB9tODJZNPuo0RKK7aO0xcfwNYoiDa5gNnl9QhBZgRTZH1
         wzpGaPDTqYX9h4jpDuvgylUNoOT5Lch3EvX7BL7CkVbuyhm4hktsWJUFfLe8tib4v0Gq
         7Mjh3VgV21lcVMlZx06acL/VUPi6ODi2kr4hsmTpzEfwuJdhGtRa+uoNv7nXEudFJyIa
         iA890Pl9xzrBCOFHHrzOlOLMm3xlPiAqK2MFwaQKkmjwrpdkyiGN38v19lF6PONeoSXg
         guMjW7r9YLJwuo6i6gLS8hBFDFsrS2G7IU8PFhcG5seKK+gz7LlbLeq6E7UcbagEEWsK
         LpUg==
Content-Disposition: inline
In-Reply-To: <20220825164111.29534-8-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Fri, Aug 26, 2022 at 12:41:08AM +0800, Chengming Zhou wrote:
> Now PSI already tracked workload pressure stall information for
> CPU, memory and IO. Apart from these, IRQ/SOFTIRQ could have
> obvious impact on some workload productivity, such as web service
> workload.
> 
> When CONFIG_IRQ_TIME_ACCOUNTING, we can get IRQ/SOFTIRQ delta time
> from update_rq_clock_task(), in which we can record that delta
> to CPU curr task's cgroups as PSI_IRQ_FULL status.
> 
> Note we don't use PSI_IRQ_SOME since IRQ/SOFTIRQ always happen in
> the current task on the CPU, make nothing productive could run
> even if it were runnable, so we only use PSI_IRQ_FULL.
> 
> Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
