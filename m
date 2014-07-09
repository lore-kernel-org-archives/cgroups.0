From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 01/12] cpuset: add cs->effective_cpus and
 cs->effective_mems
Date: Wed, 9 Jul 2014 12:47:40 -0400
Message-ID: <20140709164740.GE11193@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD0187.9060309@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=SiiL5mpT49h9Kcrx85+G47zAQXryq5H0LkAoGJduOO4=;
        b=n3Go0lcJHNdM9TM4jVjUR6hBnKfitDHzv8jYUXnfCCr6OQSOH7qX3KZXaB4Ry4SA4B
         AboL5Dzt+7vUnNwhFzfKtzwxALPS4Cplz9go7KgKsCjZFm7tpF1r3CxxDKuiFqP/PTtk
         lI0iJ70jbg6XCwZQHIt+9W5kJAyxiKlfSFliOBLf1/PD3XT2Fajt640l6zifgUpMzbbJ
         5EccA9ChTESlMnzI4ucTQwkeupv+xT1/jTVG3cYgGqUb8uJzSmPAoQOfnuBxQb4QWVHZ
         rWkOPs2V8F3SD5Spjd2bcdmZN4J/E1RkYfKXBTKFYb2d0+MMrsiLRcyKJ/H1LWROFlST
         3Ciw==
Content-Disposition: inline
In-Reply-To: <53BD0187.9060309-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 09, 2014 at 04:47:03PM +0800, Li Zefan wrote:
> +	/* user-configured CPUs and Memory Nodes allow to tasks */
                                                allowed
> +	cpumask_var_t cpus_allowed;
> +	nodemask_t mems_allowed;
> +
> +	/* effective CPUs and Memory Nodes allow to tasks */

ditto.

Thanks.

-- 
tejun
