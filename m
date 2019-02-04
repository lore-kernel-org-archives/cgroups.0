From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 3/5] cgroup/cpuset: make callback_lock raw
Date: Mon, 4 Feb 2019 12:55:50 +0100
Message-ID: <20190204115550.GB17550@hirez.programming.kicks-ass.net>
References: <20190117084739.17078-1-juri.lelli@redhat.com>
 <20190117084739.17078-4-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wdWg3Gk782dVCrvocq6FDMvJKD4tJ23otHwOGefFoWo=; b=OQgrpQSwPVg3KOSPz4326KVAo
        anBqsBOnYk1VUlqXIrsadW9QryJ6UwTv/UUdAEhTrOsTXTDAjY7Vuc1b1Bl6i3aLcP0+rHjPB5OPF
        qIVe9rlW9+B4dbkI2y8IpSFsVpnw9QJkdXSi1wV26J3x5hh/hmDdXr7p+1Lt7U0LeGh91luUgsO8B
        ISZ9vdoRdx5sVadWRVcsrIUtghoUu3TtGbw476wdAw3Yc2OUF5YDdSGEJ2RfMtpa9AVHRDNGx2+KU
        7R51B1qW5dhOtBoHl8ciGJD2PgwH1S2uvmrIRe2lyu9LapHthKaAu79f6mSpdYDbKUydruUpjG6UH
Content-Disposition: inline
In-Reply-To: <20190117084739.17078-4-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Thu, Jan 17, 2019 at 09:47:37AM +0100, Juri Lelli wrote:
> @@ -2366,7 +2366,7 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
>  	cpuset_filetype_t type = seq_cft(sf)->private;
>  	int ret = 0;
>  
> -	spin_lock_irq(&callback_lock);
> +	raw_spin_lock_irq(&callback_lock);
>  
>  	switch (type) {
>  	case FILE_CPULIST:
> @@ -2388,7 +2388,7 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
>  		ret = -EINVAL;
>  	}
>  
> -	spin_unlock_irq(&callback_lock);
> +	raw_spin_unlock_irq(&callback_lock);
>  	return ret;
>  }
>  
could we not convert this to use cpuset_mutex ?
