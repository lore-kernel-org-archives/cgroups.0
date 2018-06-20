From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v10 9/9] cpuset: Allow reporting of sched domain
 generation info
Date: Wed, 20 Jun 2018 16:20:23 +0200
Message-ID: <20180620142023.GL2494@hirez.programming.kicks-ass.net>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
 <1529295249-5207-11-git-send-email-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZKxqSmRvuBEzji6QJ6OPJdofTke9TPC+3mQgLDLbuK0=; b=FfcfwekdHiUptkRfLd3jezK1E
        O5CAxLDZM7ArLBCKh3gOdaCAtBixCWG8TmRABFDt0xvvu5W6x/+i+RxvgasONV1nshJM9cUkz+XNr
        1cdiRLAkMSSS3jWMIRHP7ZUBu+Y0F7nGSyWpSSNHTy/IznJLuHziV+ENXRjWJ/1J22ZTeTS7y7HUz
        rmvWXeszgvNPsbcfTzcI2r5qYcsfFNoDnHNHq7JZNHBGnWOKEELqz4PiBxnHEvqKTIkqh8cuIXygw
        b+rPDjTzMmIf9/xAUaIbu45vihPZSWKhvcQC9+CLqWM0ewYH2XmEULNjgaokq0VHdsrd2W1ATL3R9
    
Content-Disposition: inline
In-Reply-To: <1529295249-5207-11-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Mon, Jun 18, 2018 at 12:14:09PM +0800, Waiman Long wrote:
> +#ifdef CONFIG_DEBUG_KERNEL
> +static inline void debug_print_domains(cpumask_var_t *doms, int ndoms)
> +{
> +	int i;
> +	char buf[200];
> +	char *ptr, *end = buf + sizeof(buf) - 1;
> +
> +	for (i = 0, ptr = buf, *end = '\0'; i < ndoms; i++)
> +		ptr += snprintf(ptr, end - ptr, "dom%d=%*pbl ", i,
> +				cpumask_pr_args(doms[i]));
> +
> +	pr_debug("Generated %d domains: %s\n", ndoms, buf);
> +}

Why not use pr_cont() and do away with that static buffer?
