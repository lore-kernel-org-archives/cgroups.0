From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 17/28] x86/sgx: fix a NULL pointer
Date: Mon, 17 Jul 2023 08:49:03 -0700
Message-ID: <ffe26e8b-9f2a-4f06-aadf-9dfb1421be76@intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-18-haitao.huang@linux.intel.com>
 <CU4GJG1NRTUD.275UVHM8W2VED@seitikki>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689608945; x=1721144945;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=n7mERhm1vnG8xMeSAl/fiQX+qVVEGB1U/K7jVm6Ihyw=;
  b=QOynNXqX7fQtk/dHh3Eep4/zFJpsvridcXO1G7LPFwJqBnir8ERrswzM
   zlE6jQJcAnwYcEyTl1kR4cSyXMpmcEiasRHb05YbOO9h6rPG9UH+QvubM
   QCiNGR6lj5uhI8vD59Ehgk7A1yOwIOZwyEuolZXdmMDeDQtCPpJfup8p4
   I/RGD16UeR19dzDZt/++2RdnUXyRDBP7W/4PWH84UNamtb55YfBniI1qB
   OTe5Jsl3bOVEMtxpnWuuwNnTHZ2oE8quG5lNGrcUsxRjjinyn+wbc+r7U
   VlhWwuk77yZbk16WN6Y017LhAitJi7n8//pPg62ibNZDa40D2/P8E8nm7
   w==;
Content-Language: en-US
In-Reply-To: <CU4GJG1NRTUD.275UVHM8W2VED@seitikki>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On 7/17/23 05:48, Jarkko Sakkinen wrote:
> On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
>> Under heavy load, the SGX EPC reclaimers (ksgxd or future EPC cgroup
>> worker) may reclaim SECS EPC page for an enclave and set
>> encl->secs.epc_page to NULL. But the SECS EPC page is required for EAUG
>> in #PF handler and is used without checking for NULL and reloading.
>>
>> Fix this by checking if SECS is loaded before EAUG and load it if it was
>> reclaimed.
>>
>> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> A bug fix should be 1/*.

No, bug fixes should not even be _part_ of another series.  Send bug
fixes separately, please.
