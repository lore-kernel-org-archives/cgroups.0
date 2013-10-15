From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/12] cpuset: use effective cpumask to build sched
 domains
Date: Tue, 15 Oct 2013 11:25:38 -0400
Message-ID: <20131015152538.GL3141@htj.dyndns.org>
References: <5257C9A1.1030404@huawei.com>
 <5257C9EE.9080902@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Cg1Z/adeQXQmTwvESpYH8qlYqWyV3uphJQZVtbXDCfU=;
        b=XgeEmwqhPc+t5BNKUrVw6suvCZ5H5Rp2eMUPThMzTDATkZR/qWDH5vE0/QF3h7Zp71
         fBiLJmxcazc22zqp3zFADA2ec9dHA9hL2Hd9ludOO7twuEepbOFFP5d/wk4qo53KPErb
         U3cHzidyw4Jnu3xQRUWmqMOUmHr1fSqessrV73vbem3LYro76oxwcf6MoJYdbwMLmK52
         wwVAl/eciKnQyNQ/ZMewa3W3AiyXNa1y50haOluQfH1UKTotC0Otncrv4jnT0Tfwfbx4
         zJ71xQvoWz4hYxYN23dMOlxTpmg5+671WD3k2jJmREVbbmDCC24pX8zatUIdz8ZEtAqX
         UGng==
Content-Disposition: inline
In-Reply-To: <5257C9EE.9080902-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Oct 11, 2013 at 05:50:38PM +0800, Li Zefan wrote:
> @@ -930,10 +931,21 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpuset *trialcs,
>  
>  		update_tasks_cpumask(cp, heap);
>  
> +		/*
> +		 * If the effective cpumask of any non-empty cpuset is
> +		 * changed, we need to rebuild sched domains.
> +		 */
> +		if (!cpumask_empty(cp->cpus_allowed) &&
> +		    is_sched_load_balance(cp))
> +			need_rebuild_sched_domains = true;
> +

Can you please explain *why* this change is being made in the patch
description?  The patch description doesn't give me anything and the
comment explain "what" but not why it's moved from update_cpumask()
into this function with an extra condition.

Thanks.

-- 
tejun
