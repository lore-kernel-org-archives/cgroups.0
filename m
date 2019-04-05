From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 4/7] sched/core: Prevent race condition between cpuset
 and __sched_setscheduler()
Date: Fri, 5 Apr 2019 14:36:45 +0200
Message-ID: <20190405123645.GT12232@hirez.programming.kicks-ass.net>
References: <20190403084650.4414-1-juri.lelli@redhat.com>
 <20190403084650.4414-5-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cqaSZ+K93rrnDdKM+dpoAtz2NJApotYf4sBHoFtFOEs=; b=If2bqmPeef2+ZfqZ/OBWdNmNX
        5LsA+suau83D/ZuXavzMK+mtpt8cnUFbn2nWPdNBQOipjVijtMH2QRXZ6cAL/OlcNzD+JB2WK5cQ4
        f5Ga3ImjSTnFJy092oTPV38iIfSAoKU6ySsfaFXFYTBf8Zdn36Bag2/s26NCXIijvMUPwelTTb9pf
        zkjAPVYlRTzoWfzqb2I1EaQFKstTt1+EtKV+aWmzP0nhPHD8/4IyNe0e39wLtp8qzdODH7HdJW0Kf
        LgjuPvIrla1dECa+JnPdJJ5XySqeZbolgyljSs4xhcwUJBx57juwcDHpojhxnSdOmEXDNI3KRdm9N
Content-Disposition: inline
In-Reply-To: <20190403084650.4414-5-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Wed, Apr 03, 2019 at 10:46:47AM +0200, Juri Lelli wrote:
> +static inline void cpuset_read_only_lock(unsigned long *flags)
> +{
> +	local_irq_save(*flags);
> +	preempt_disable();
> +}
> +
> +static inline void cpuset_read_only_unlock(unsigned long *flags)
> +{
> +	local_irq_restore(*flags);
> +	preempt_enable();
> +}

You can ditch the preempt stuff. IRQs disabled already very much implies
!preemptible.
