From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 01/18] cgroup/misc: Add per resource callbacks for CSS
 events
Date: Fri, 15 Sep 2023 07:55:45 -1000
Message-ID: <ZQSaoXBg-X4cwFdX@mtj.duckdns.org>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-2-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694800547; x=1695405347; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WaFcn1QzXPssaV1y6SpztPUVojrCHgnKF1dhNtlMGp4=;
        b=gkZvq6P00k5PUTsA89cAMAWHBG2rxmwaEnZaA1Dui3FGpsn8CeB6QBfPyADwkiSNrX
         dqbWmJtalDGj5/icUCkXffvKVzMU2S6nva0A26HdrYFmBs2t7P5B/J2ATtwKiZ1j+MYG
         2kPEGTe/9HLgHjsjCZgEfKkLjbMvACBlDtNVbpg9vRXszJoJgwtrflTxaCtTTA93fR2r
         IfmnBFcvAahdRUryWm17p1BZAbKnWi4jn0bebTAKb1SAbW8UUDySzppGIlEGQbGfuHR3
         BOl30qLJyJiDa5ZRx7N64CdbR1t4IhQX4BiToTfkCEY3EE/iR2Dl5Dn4OH8BNxkjOinm
         RPRw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230913040635.28815-2-haitao.huang@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang@linux.intel.com>
Cc: jarkko@kernel.org, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, sohil.mehta@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com, zhanb@microsoft.com, anakrish@microsoft.com, mikko.ylinen@linux.intel.com, yangjie@microsoft.com

On Tue, Sep 12, 2023 at 09:06:18PM -0700, Haitao Huang wrote:
> @@ -37,6 +37,11 @@ struct misc_res {
>  	u64 max;
>  	atomic64_t usage;
>  	atomic64_t events;
> +
> +	/* per resource callback ops */
> +	int (*misc_cg_alloc)(struct misc_cg *cg);
> +	void (*misc_cg_free)(struct misc_cg *cg);
> +	void (*misc_cg_max_write)(struct misc_cg *cg);

A nit about naming. These are already in misc_res and cgroup_ and cgrp_
prefixes are a lot more common. So, maybe go for sth like cgrp_alloc?

Thanks.

-- 
tejun
