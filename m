From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/11] cpuset: allow writing offlined masks to
 cpuset.cpus/mems
Date: Wed, 21 Aug 2013 10:18:51 -0400
Message-ID: <20130821141851.GJ19286@mtj.dyndns.org>
References: <52148F52.0@huawei.com>
 <52148FF1.5060503@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=94weXERMqrfymLeL9Q12jfReZZM5Y4IamaDBxzc1BoM=;
        b=tmNSj2sgQoIYj/DVSBI29x2MHySROXUoANgfFBASaI6UFNcxOFwpcBMsn4mfNeW6r8
         OWnFaJFikiuWOYLSFtt/i1F/nIwIqISlsCF4Xo6JlM5UlNIEaOPLXJ7AwdM3vzr0IE/O
         REhmS6KfLmTvGlaO0UH7XdDqV4Dch0cN1uumokjdcmMt43DnNeN0/qjVzlGQGRjhQ9GP
         3V5vFBr8y+RHFX6jZaCGTMGHanAePEejLZaFrVzJWLST8xhYwMr10C2Gu+/HRNWCHCva
         2eSWq+P/y1Irrr3BfO5+qV2ongirM2CJh1suWMUJjsEVuApqbH+RDkHy8nME7dxCEmmu
         8RRw==
Content-Disposition: inline
In-Reply-To: <52148FF1.5060503-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

Hello,

On Wed, Aug 21, 2013 at 06:01:21PM +0800, Li Zefan wrote:
> -		if (!cpumask_subset(trialcs->cpus_allowed, cpu_active_mask))
> +		if (!cpumask_subset(trialcs->cpus_allowed,
> +				    top_cpuset.cpus_allowed))

Hmmm... top_cpuset.cpus_allowed is filled using cpumask_setall(),
which may include more bits than cpu_possible_mask, which is kinda
weird.  We probably wanna initialize it with cpu_possible_mask and
also maybe using cpu_possible_mask in the above would be clearer?

Also, shouldn't this be dependent upon sane_behavior?

Thanks.

-- 
tejun
