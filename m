From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-iocost: fix seq_printf compile type mismatch error
Date: Fri, 21 Jul 2023 15:14:09 -1000
Message-ID: <ZLstYbAzqkqwIRzy@slm.duckdns.org>
References: <20230717141852.153965-1-carlos.bilbao@amd.com>
 <93557f79-c12c-3c3f-2c25-9ba50a618daa@amd.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689988451; x=1690593251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ge0BDodPbbi0t2/fQVg7nNuXVsJ2KKE3irKK+lnKz00=;
        b=Q/quBlo055unQKj9s1TErQXtrc0CsCScbBVDQvoDxQ3boCFwjCQle9lI5ltwM2t3AQ
         euLwJmBg9f7hX/2Fq6r9W1zuhtOCZ1T6VYG/A1DGFtI2aLdi0ljIEMnqnGql59s16QpQ
         +/yC+ZO+b1Ffy6CeVNYUOU9ETshZjRvrgAAfK5ZEE/5mRrAJNlju+D1wO8ZlvhuJdnHO
         K+SKwqBbD3/Yh1mXpb1XKP7/4uLzvH7IUydyHMN5F3kObCsKD4bcY7mzNWDSzwsqKcIX
         cRUr27q41tc7EkvoZkGCEqX4nYOGRlbeHp82Ca9apeJzF8KgnClpDa3obP+WYJVHI0ll
         7GhA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <93557f79-c12c-3c3f-2c25-9ba50a618daa-5C7GfCeVMHo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>

On Fri, Jul 21, 2023 at 05:32:04PM -0500, Carlos Bilbao wrote:
> On 7/17/23 9:18 AM, Carlos Bilbao wrote:
> > From: amd <amd-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
> > 
> > Fix two type mismatch errors encountered while compiling blk-iocost.c with
> > GCC version 13.1.1 that involved constant operator WEIGHT_ONE. Cast the
> > result of the division operation to (unsigned int) to match the expected
> > format specifier %u in two seq_printf invocations.
> > 
> > Reviewed-by: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>
> This should have been:
> 
> Signed-off-by: Carlos Bilbao <carlos.bilbao-5C7GfCeVMHo@public.gmane.org>

Carlos, can you please retest the current linus#master?

Thanks.

-- 
tejun
