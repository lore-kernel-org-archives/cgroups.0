From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v6 6/7] refactor header includes to allow kthread.h
 inclusion in psi_types.h
Date: Wed, 20 Mar 2019 17:04:03 -0400
Message-ID: <20190320210403.GE19382@cmpxchg.org>
References: <20190319235619.260832-1-surenb@google.com>
 <20190319235619.260832-7-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c7mFoY9c1LOx2DLi8HmPtRRejYVacIC2KISLRsK7znE=;
        b=iNfJLn1VEvAICGg6+J8aTGo2WHwUAblrU8TC4P4d/YRBZXKDhFuHuWPyZ+0OcodA2R
         g7V3avx9WoHGDQcWiV6r3LM0LpMba9yJ3IUAj0x5QC+zKlzOmO4kgXtaoS+5XNfH35f6
         y3Q95eLIBZnLlHIgU2hmV3Z3aaaWgB2xG+sNBTD2NsA89KSRqyVkPML3RtWfJhtmFNdq
         uyW97pDsEiNY89ljQeenu9r/FX9qo6fKteLpOe4Ty8207DbRYrXxQ18O75u7haf4V8Sk
         XGHF1f5dd/S4jj+izKUS5beIisOqtB2HANTsNRLdkYtB97haZMPGFXeQ0p9W+YOT5XOm
         1Frw==
Content-Disposition: inline
In-Reply-To: <20190319235619.260832-7-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Tue, Mar 19, 2019 at 04:56:18PM -0700, Suren Baghdasaryan wrote:
> kthread.h can't be included in psi_types.h because it creates a circular
> inclusion with kthread.h eventually including psi_types.h and complaining
> on kthread structures not being defined because they are defined further
> in the kthread.h. Resolve this by removing psi_types.h inclusion from the
> headers included from kthread.h.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

> @@ -26,7 +26,6 @@
>  #include <linux/latencytop.h>
>  #include <linux/sched/prio.h>
>  #include <linux/signal_types.h>
> -#include <linux/psi_types.h>
>  #include <linux/mm_types_task.h>
>  #include <linux/task_io_accounting.h>
>  #include <linux/rseq.h>

Ah yes, earlier versions of the psi patches had a psi_task struct or
something embedded in task_struct. It's all just simple C types now.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
