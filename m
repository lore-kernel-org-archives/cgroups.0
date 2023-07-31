From: "Haitao Huang" <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 04/28] x86/sgx: Use sgx_epc_lru_lists for existing
 active page list
Date: Mon, 31 Jul 2023 15:43:54 -0500
Message-ID: <op.18yrvgbvwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-5-haitao.huang@linux.intel.com>
 <CU4GIFHMTA8N.2GV3WIA7HAVOE@seitikki>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690836265; x=1722372265;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=hu8JTDbJqIGr3TfklVY/QtEKkWMtllj5IhBurxsIJkA=;
  b=Ct9injIDoK03Q/rBDHWho/HkWMn9PamCrsNn8oYxp2dOiyTR5MoTeAXM
   1N94JNUF2oYCz0O08eahMoSUV7nnYgg3c9rFMxIsEAMvWgwpilS/gQRcx
   EXgELVBV/7UNX9AeTCQawZ05ftOl7fqnmEWyx+Xck1hbGvYHYFAHNtupi
   /YXqZLuIwGuMNPkD3zfYbQI7uRwzsEIV4KyF/E6rt1efIqXNyHSSIYS/Q
   3lCS0wwKqLqYZGCVfwJyFJP+FLlWTkPFR54MTwU/V9gNpEpNwkcsevnkP
   /P95Kg4Rf0EwsuthLPoGGR6jjTphTpB+HYU1fMXmzpAxJDQMWT9jD5V0/
   A==;
In-Reply-To: <CU4GIFHMTA8N.2GV3WIA7HAVOE@seitikki>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon, 17 Jul 2023 07:47:01 -0500, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>  
wrote:

> On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
>> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
>>
>> Replace the existing sgx_active_page_list and its spinlock with
>> a global sgx_epc_lru_lists struct.
>
> Similarly as the previous patch, I would extend this story a tiny
> bit forward to see the connection with the follow-up patches.
>
Sure

I also feel it may flow better by moving all changes related to  
'unreclaimable' such as owner field for VA, flags for types of owners,  
storing unreclaimables to LRU, etc. to later after all changes dealing  
with reclaimables are introduced. The unreclaimables are only of concern  
when OOM is involved so it'd be better to do them right before OOM.

Thanks
Haitao
