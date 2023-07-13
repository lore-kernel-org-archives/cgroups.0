From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 21/28] x86/sgx: Limit process EPC usage with misc
 cgroup controller
Date: Wed, 12 Jul 2023 17:03:25 -0700
Message-ID: <70cd3d3d-48b0-7570-850a-906a1d960bbd@infradead.org>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-22-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=cNlYMcVTEfy/fmVD8wCyTrFiHwmY85jTLhb7uGYkAe0=; b=CWrOGiVyZ6xotScp1dFunEvArA
        HpkAOJoRwLPjpPDqE98L4eeGySw9uYJLSkp2yyvIGRVbVFO+SdxdkuoAgbI5lKPdIZO1RAp7gcYHy
        HcA/3JvKWFixTOfSR03gYcpJgcs3NSkXZTcpHvVImevtBIy8X6Cf8PgDYSFVjisSt4V88xk5T0J7J
        y4i7EZ2QYnPa+FgZj2UljbmxCZtyTCVYZTeG51pkgXk1vn2ZQg4vq140MFL00BDzMjJ/M73BTG1/m
        vwZbTOmPpxJ5GcFRIloDi8Nc6Z2CQcylwntNM4hkzVEUD6zmJGIpPY4Px3B2fl/ogxHD4ol13MBU0
        MHVYlvOA==;
Content-Language: en-US
In-Reply-To: <20230712230202.47929-22-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org



On 7/12/23 16:01, Haitao Huang wrote:
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 53bab123a8ee..8a7378159e9e 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1952,6 +1952,19 @@ config X86_SGX
>  
>  	  If unsure, say N.
>  
> +config CGROUP_SGX_EPC
> +	bool "Miscellaneous Cgroup Controller for Enclave Page Cache (EPC) for Intel SGX"
> +	depends on X86_SGX && CGROUP_MISC
> +	help
> +	  Provides control over the EPC footprint of tasks in a cgroup via
> +	  the Miscellaneous cgroup controller.
> +
> +	  EPC is a subset of regular memory that is usable only by SGX
> +	  enclaves and is very limited in quantity, e.g. less than 1%
> +	  of total DRAM.
> +
> +          Say N if unsure.

Use tab + 2 spaces above for indentation, please.

-- 
~Randy
