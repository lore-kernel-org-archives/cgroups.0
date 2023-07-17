From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v3 17/28] x86/sgx: fix a NULL pointer
Date: Mon, 17 Jul 2023 13:49:45 -0500
Message-ID: <op.178o87ejwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-18-haitao.huang@linux.intel.com>
 <CU4GJG1NRTUD.275UVHM8W2VED@seitikki>
 <ffe26e8b-9f2a-4f06-aadf-9dfb1421be76@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689619790; x=1721155790;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=vHqFAb6Vl7dA36hMqfVx3NL//FFkWSCEjQFuIaxEHj0=;
  b=JGcumQHKAfej9OfBNuWTssmjNqroOz3pWOZqr8dHcchCtTy70hnElRcM
   5vU4/1390LyNb6biCvbYFZcVAeFsPLNG67+vIUaNUKsHxNFkfzh66a0lU
   nPnmdhaTqSLOEdtVbrwxHHNcPAjXfwIKrM0YErvxYpSThhzlYkUV/hyzI
   jEnetacAhziVngbtgET8ZcPjFdI73ta+PCbtXRwhO00jaxvl137OHTSk9
   t/nwPBMvK+dI3q3MDO9jBBsS6GQb+twNGFl8DMym0M6GQ3DGfSvb60ViH
   GafsECD20kS3O2diCc+jrOd+2QdW4lzTqOBiZaaUNtor/rpC9O/SgEQku
   A==;
In-Reply-To: <ffe26e8b-9f2a-4f06-aadf-9dfb1421be76@intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: Jarkko Sakkinen <jarkko@kernel.org>, dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>
Cc: kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com

On Mon, 17 Jul 2023 10:49:03 -0500, Dave Hansen <dave.hansen@intel.com>  
wrote:

> On 7/17/23 05:48, Jarkko Sakkinen wrote:
>> On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
>>> Under heavy load, the SGX EPC reclaimers (ksgxd or future EPC cgroup
>>> worker) may reclaim SECS EPC page for an enclave and set
>>> encl->secs.epc_page to NULL. But the SECS EPC page is required for EAUG
>>> in #PF handler and is used without checking for NULL and reloading.
>>>
>>> Fix this by checking if SECS is loaded before EAUG and load it if it  
>>> was
>>> reclaimed.
>>>
>>> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>> A bug fix should be 1/*.
>
> No, bug fixes should not even be _part_ of another series.  Send bug
> fixes separately, please.


I sent the two bug fixes separately now. Do you want me resend this series  
without those?
Thanks
Haitao
