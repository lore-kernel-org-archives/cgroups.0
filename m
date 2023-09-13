From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: add THP swap out info for anonymous reclaim
Date: Wed, 13 Sep 2023 17:33:43 -0400
Message-ID: <20230913213343.GB48476@cmpxchg.org>
References: <20230913164938.16918-1-vernhao@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1694640824; x=1695245624; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S915mKK5+DIHTjSPmbc01fyab6FvzQ8To3PxTMKLA8Y=;
        b=nNEi+6uoJJf7OhHJUwN5KAPquj7RSqdV2vhiktOT03QDmjIqaF2Rb+GJLlsismu67U
         nIFDPARnQSg7VpcfzbkAZukhzvVI//9ObTvszQdup9DvzJLZFlpd8yqW9aPPjnfrR0MV
         zJiniceuKYgxnFJFTQs6JxvULYgbsj/lmx8KSOoJCoG2P6MnLazOWc8LyHjVqS35IP0i
         nkoarEZLfKhFpjyHH+P0/CJdc1pSHCHaqsELC8qJqYD3RuFs16Ko+TH1fodvSA7D6Li7
         luwj4P1NY0W7M1CdT2LFmzQQMfp2wbJD6+ni22oJnP89JsE7sBIMdum/+eY4P0za/9it
         cIDg==
Content-Disposition: inline
In-Reply-To: <20230913164938.16918-1-vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vern Hao <haoxing990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Thu, Sep 14, 2023 at 12:49:37AM +0800, Vern Hao wrote:
> @@ -296,6 +295,7 @@ static void swap_writepage_fs(struct page *page, struct writeback_control *wbc)
>  	struct file *swap_file = sis->swap_file;
>  	loff_t pos = page_file_offset(page);
>  
> +	count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));

Argh, this should be

	count_swpout_vm_event(page_folio(page));
