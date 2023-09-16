From: "Haitao Huang" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v4 12/18] x86/sgx: Add EPC OOM path to forcefully reclaim
 EPC
Date: Fri, 15 Sep 2023 23:19:53 -0500
Message-ID: <op.2bcjnfkmwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230913040635.28815-1-haitao.huang@linux.intel.com>
 <20230913040635.28815-13-haitao.huang@linux.intel.com>
 <CVHWE8HC4SHA.FU2XVIXN6WB7@suppilovahvero>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694837997; x=1726373997;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=gIPyWiuFfzCzD4q9eXt3xfBm9DVJMh2r9IPir+knJEA=;
  b=FAzDEN9rRR2HqihsDZKXnLrKWzQYeYI4y+RCHEq7iDU0vBJ0kUtkrAC2
   nuqHsAIMjMb7jfJ+ngrOuWRYCj7BCv7COjGIs5K/BtYmsXRGYQdM9HxBl
   GlyLW2opqLI99XC1xek0V3w01fpRSMqQuZTpZ8WvkBU26+RXggxPkNCeK
   xSTbGr1GTZbgEmxdFbUIo4N5dMLPmFFB7lOBLjDnO5r7RYKFPmTtP4to6
   SObrY4GTnbZy9W/Wqm+/fHUMBmTOIlS36oF+FolRGohDIoUOAcEiJJ2al
   frxc36LGjLNw53ChmzHSsxidtt61BL1lOLOXEDrL/L5FUnMrAJkDa3OVd
   A==;
In-Reply-To: <CVHWE8HC4SHA.FU2XVIXN6WB7@suppilovahvero>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

On Wed, 13 Sep 2023 10:34:28 -0500, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  
wrote:

>> +++ b/arch/x86/kernel/cpu/sgx/encl.h
>> @@ -39,6 +39,7 @@ enum sgx_encl_flags {
>>  	SGX_ENCL_DEBUG		= BIT(1),
>>  	SGX_ENCL_CREATED	= BIT(2),
>>  	SGX_ENCL_INITIALIZED	= BIT(3),
>> +	SGX_ENCL_OOM		= BIT(4),
>
> Given how the constants are named before maybe SGX_ENCL_NO_MEMORY would
> be more obvious.

Will do.
Thanks
Haitao
