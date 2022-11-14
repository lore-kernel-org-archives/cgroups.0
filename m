From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 18/26] cgroup/misc: Expose root_misc
Date: Mon, 14 Nov 2022 12:19:35 -1000
Message-ID: <Y3K+94YYVbTg2a8P@slm.duckdns.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-19-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8CFeFkvZOn3+ucUALvR/U14w4izEUCDR2kTDtlNxQCE=;
        b=cqIHEjSRzp/QzDWAkHso5UgqwlPuL25EWfel0ecGsIWWkc1m7HAJfPPBedKaoz0+je
         k6s7CRBqQXAET+Kvi+Z+gLXoE03ArA6qG2oHeC9KOc+ww4Oh4d0SyCyuJ0kh4rak9b7U
         TXXBZJ1ztH2WTht20jENgPSSms0m1Rd0Z8CKk63rsUHvzH18S9yzYWrXL5YiTk0Mhm4W
         wBblEuTPc6cKqmnCI/J9EdsgAYDgoHR4sFVxva8QarsDn8xTTjMV5638S9kSrfXw8sVu
         1y9Mziq9aJ0MDGurItuvWd1M6O4Na7VgQ4J6DZCoIjcm6xAF5ihIla/RHz098LTRchvq
         8QAg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-19-kristen@linux.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: jarkko@kernel.org, dave.hansen@linux.kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, zhiquan1.li@intel.com

On Fri, Nov 11, 2022 at 10:35:23AM -0800, Kristen Carlson Accardi wrote:
> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
> index 8f1b7b6cb81d..b79c78378f17 100644
> --- a/include/linux/misc_cgroup.h
> +++ b/include/linux/misc_cgroup.h
> @@ -59,6 +59,7 @@ struct misc_cg {
>  	struct misc_res res[MISC_CG_RES_TYPES];
>  };
>  
> +struct misc_cg *root_misc(void);

This is too generic a name to expose globally. Can we do sth like
cgrp_misc_root()?

Thanks.

-- 
tejun
