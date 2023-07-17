From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Mon, 17 Jul 2023 08:49:02 -1000
Message-ID: <ZLWNHuTGk0fy8pjE@slm.duckdns.org>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689619744; x=1692211744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pup51R7CH2ewXgPiiOoeKchEJYQ5CnfcD4TroSAHdfw=;
        b=HbtHz8LpTaLbUyiGKVmkJ3yx78q/6EOH/BHoCgVNYefT47cfEiX4eFj5RLZ3FU01gz
         H2iPj3N8WFS+D742JGqnELJtE1A6i1+T4VMNihUqrzcMr2ytbFpCGsT1JT7pNgXqxLyd
         dP6AIjxWfAhib7dl9V2oGhir76M7Z7VT1uiu19AahY4+Ve1rP8un56rBniEvGk6GFf7L
         Q9LRqBfUKdzfxyz87WOdZKYZvgxpkMNkY/8l7wvtJCep/JEMcKQ3om+flvX9mIECNk4i
         sxdaOWT0boghIB/XRn7bu3J4Zsy5gnuLR2xnuTyVKhmpFUTpza143v9d6XD6x8UNprtZ
         RixQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230717141852.153965-1-carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>

On Mon, Jul 17, 2023 at 09:18:52AM -0500, Carlos Bilbao wrote:
> From: amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
> 
> Fix two type mismatch errors encountered while compiling blk-iocost.c with
> GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
> result of the division operation to (unsigned int) to match the expected
> format specifier %u in two seq_printf invocations.

Can you detail the warnings? Was that on 32bit compiles?

Thanks.

-- 
tejun
