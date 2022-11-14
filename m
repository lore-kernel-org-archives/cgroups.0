From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 22/26] cgroup/misc: Add private per cgroup data to struct
 misc_cg
Date: Mon, 14 Nov 2022 12:34:06 -1000
Message-ID: <Y3LCXo9SLIleMmh2@slm.duckdns.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-23-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i5kwvrCfGArJDPvV4Au9rhARUgfYWksZx0biBAjHeX0=;
        b=CbVG/1M3midj8oTdfJZ785aSjwVPMxHG0nuAFAYsEyTDwi3uPSXQN1z8MAIqvwYEip
         XAP6exWKi2UjN5zQli8rg3kLgSKuxLYGGL6QozqLhHgX0GB7bwyRQoVL/Ky3I7Qp3Po6
         myDuKwSi5ITGfb2lbyiwf7PkrQgkU1/gaJdEo53vZ0RzmQdHL1TR90vGP586aWfdXoqB
         z4o8aP8aZXVtvU8+nYxLZDYrGGdDxRAc59CXwyJN4N4bGbIYG+mrgf9EgckBPG+FRk4/
         A/MAt7TfltQGZUzfwm/WBTHTLRzNoSu3jFwon2bMxfnNsNHA9OnwgtlMfkDo0D5FyA9b
         Zt8Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-23-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Nov 11, 2022 at 10:35:27AM -0800, Kristen Carlson Accardi wrote:
> +void *misc_cg_get_priv(enum misc_res_type type, struct misc_cg *cg)
> +{
> +	if (!(valid_type(type) && cg))
> +		return NULL;
> +
> +	return cg->res[type].priv;
> +}
> +EXPORT_SYMBOL_GPL(misc_cg_get_priv);

Yeah, just deref it. I'm not sure what all these accessors are contributing.

Thanks.

-- 
tejun
