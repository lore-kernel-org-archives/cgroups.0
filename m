From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 5/5] psi: introduce psi monitor
Date: Tue, 29 Jan 2019 13:38:44 +0100
Message-ID: <20190129123843.GK28467@hirez.programming.kicks-ass.net>
References: <20190124211518.244221-1-surenb@google.com>
 <20190124211518.244221-6-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hcUmsWqOlUZoA0tGVtVxZVeGi9/WntceTQMLGURqW8U=; b=PBeiAFj84XF4ohPPYvNWj4Frx
        zy33xge/EQv0zpd59PDLm9VtSeIzpXE/lJEW4322H3P7tFLk4zvJP6dZ4NEifr60zfHbqnunPMmh7
        BNEYVN7SeJ/JCiD5JBo3xBvAF9RI/9ho2qVbgzxCcw6ZhcIBUooP2sen9hW8s1fkr46WXVF8hVJlj
        a5nWrftCspTUGFGV3K0hjkbch5lEitgg+JzHUbTusZps2AsgxgAaYnQ5ToQnDYoMaaPIXiscx/v+o
        t6qBu0lTsYS/Iq+N4raF0oQZ+VLiBr7q1ajxAP7N6NplyLoU7Zvns33ALWYK968MQoCR7KZslxNfw
Content-Disposition: inline
In-Reply-To: <20190124211518.244221-6-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Thu, Jan 24, 2019 at 01:15:18PM -0800, Suren Baghdasaryan wrote:
> +			atomic_set(&group->polling, polling);
> +			/*
> +			 * Memory barrier is needed to order group->polling
> +			 * write before times[] read in collect_percpu_times()
> +			 */
> +			smp_mb__after_atomic();

That's broken, smp_mb__{before,after}_atomic() can only be used on
atomic RmW operations, something atomic_set() is _not_.
