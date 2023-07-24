From: Sohil Mehta <sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 00/28] Add Cgroup support for SGX EPC memory
Date: Mon, 24 Jul 2023 12:09:21 -0700
Message-ID: <6bedc9fe-88b5-8382-aa65-ded66b58aa2c@intel.com>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690225768; x=1721761768;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=raqKCCoVJKlq3uyn2RAKtsEI5VbNdMaGUoxBW9/RV1s=;
  b=dQKrD33WeA+foSm0iMCGvT2urf5I/KjwSOrLBQQXwf/oBF7q1QIEJ6Jv
   D1xOnwBXTmMNbg/5BJac0WdFId/rBw5v/wKuSurIqxUfwGIqWZasTtfRE
   sY5t6ZxbGV9To0/BJeJwPhRRKI/aWGAlpNPaBSayughyfE181W04n93Bv
   HHolJADtfkax9taENyhHdDQTWYN0L6O5VuiLxnlNQ+hw41zDKGtY959J5
   2OU20v6tjVGxNRoLwNzUmOA+Fzw8M3kVLHJjl5Dnk5C3cv9657xeiBKec
   pWtd5PSJTb00fbdG6Mpu/ynBuhA3hYE6+IV7z8nwZLB33eu4T2Zh06ARH
   g==;
Content-Language: en-US
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, X86-kernel <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

Hi Haitao,

On 7/12/2023 4:01 PM, Haitao Huang wrote:

> I appreciate your comments and feedback.
> 

Nit: You missed emailing the cover letter to x86-DgEjT+Ai2yi4UlQgPVntAg@public.gmane.org I think a
few other people included in the individual patches are also missing in
the cover letter.

In general, it might be useful to keep the email list consistent across
the cover letter and the individual patches.

-Sohil
