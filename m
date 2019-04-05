From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v7 1/7] sched/topology: Adding function
 partition_sched_domains_locked()
Date: Fri, 5 Apr 2019 14:04:34 +0200
Message-ID: <20190405120434.GS12232@hirez.programming.kicks-ass.net>
References: <20190403084650.4414-1-juri.lelli@redhat.com>
 <20190403084650.4414-2-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UTOYp7IjDImcxMFESq0cXAQX+6anvFw+H4/1OoPITYU=; b=1Dx5bgo/GSQcI7kkuXN88XpP4
        LJN6aRtV1RSVQUVtZXEcYhWnD55DEmHwezlcYYei7/2mtHqDX+Qvg/wJ3/WEGpmp8TDgn0MFNbPva
        vCRpsbFzeq8Q6HrgwxONEi0SBbSmQCVQ7LNdUpQvg68l3AcMQ9DJ/Ks3z087k3wtDaaJn2FrBLqKL
        Bsc/gA86kyV7lxxSDtF9mLycbGGa4niC5P0+OiDHY82rT9OAuF1713XBi4VAm01LAhM75YVmmf5iA
        DYTB/s4+9oQBAB5UriNvQTvaevLCdjCiFwz2vThrWkTeZthkITEB7QrmvGsEM14v5aV+Zk0MHVBHu
Content-Disposition: inline
In-Reply-To: <20190403084650.4414-2-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Wed, Apr 03, 2019 at 10:46:44AM +0200, Juri Lelli wrote:
> +/*
> + * Call with hotplug lock held

Is that spelled like:

	lockdep_assert_cpus_held();

?

> + */
> +void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
> +			     struct sched_domain_attr *dattr_new)
> +{
> +	mutex_lock(&sched_domains_mutex);
> +	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
>  	mutex_unlock(&sched_domains_mutex);
>  }
> -- 
> 2.17.2
> 
