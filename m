From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 05/12] cpuset: use effective cpumask to build sched
 domains
Date: Wed, 9 Jul 2014 15:18:36 -0400
Message-ID: <20140709191836.GA21090@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD01B6.403@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DBMxgCP3unpwtO4UB7deoNFToj3q9L9lWST6t2miWC0=;
        b=HIFki0L+SpQwJ7VwyfP5PS1RQyWDVibOihtbvsHR720MEJnNg5SNdq7oNaXkuNBHPZ
         lzCZYeoBBwiRFxkMxWg1fN1QuEz5LdCwTXuDdJY4V2d44jXLwk40fYPxHTsmFcTkbizj
         UY1bxsi6bBiwO1oLMcl5PRkOxKVk4gZeqXT1X4FrM0f7UjJMo1KHyxDJvC3HoENNohTk
         Oy6iW6ch03nm5by5vwpEXEyHLA9Rfe8oDYQugUN0yNVnvzOP6hqno8aw5p4thxFQj1CM
         nWFEAeXOrBxLz18x5BH2oml0TxR2dykjgr8KnvxO2FlWO0QURC7E5rjAtguZDQ64b2H2
         mYXg==
Content-Disposition: inline
In-Reply-To: <53BD01B6.403@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

On Wed, Jul 09, 2014 at 04:47:50PM +0800, Li Zefan wrote:
> +		/*
> +		 * If the effective cpumask of any non-empty cpuset is changed,
> +		 * we need to rebuild sched domains.
> +		 */
> +		if (!cpumask_empty(cp->cpus_allowed) &&
> +		    is_sched_load_balance(cp))
> +			need_rebuild_sched_domains = true;

Hmmm... is this because if cpus_allowed is empty, the effective always
equals the parent?  If so, let's update the comment so that it
explains why the code is like that.  The current comment just explains
what it does which isn't very helpful.

Thanks.

-- 
tejun
