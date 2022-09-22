From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 03/20] x86/sgx: Track owning enclave in VA EPC pages
Date: Thu, 22 Sep 2022 14:39:53 -0700
Message-ID: <f2236b51-400a-b300-e818-297e45cc7b49@intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <20220922171057.1236139-4-kristen@linux.intel.com>
 <1adb03c8-1274-3898-0677-03015a1f5a5d@intel.com>
 <f031ac1bd6b16509f1d714cd65e6b017f054940c.camel@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663882793; x=1695418793;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LziEyfJawc4QSz0lLnm/mVQqdAi9KJUUSw7+yO6FQ2U=;
  b=gPEQfjxow2GpepwrV6myffF8g/dR0a5Tiq0MfkOjd9MFkC4qXLOEyVlN
   /FjXq//T+lmEElCfuY/4Moz5RWmq/NNu3DSPuu0k2m8cp6t8MOZSoBkVK
   hMorp2rznH5d8/EuNuMl9NdTwh4H6ivlZtT2VNk1wd5lEWnrt7vOgxQG8
   EqQx8OEzBDAA7zx1MFf3zLCXIOiBNDN0Z+eIsPo/i/tESidgGT8OrQiMI
   WbeiNWNSCW1jPtRZ0l/Zqk9xZr6NCQH9q+StD6cDZEXE9IYK2dPKghHJd
   AGUkZmWeEzdKncr6V1ETBzvwPCJPuZWDdWxy33ypfIMV7CF+DSr5pRU66
   g==;
Content-Language: en-US
In-Reply-To: <f031ac1bd6b16509f1d714cd65e6b017f054940c.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 9/22/22 13:04, Kristen Carlson Accardi wrote:
>> BTW, is there a flag or any other way to tell to what kind of object
>> ->owner points?
> The owner will only be an sgx_encl type if it is a va page, so to tell
> what kind of object owner is, you look at the epc page flags - like
> this:
>         if (epc_page->flags & SGX_EPC_PAGE_ENCLAVE)
>                 encl = ((struct sgx_encl_page *)epc_page->owner)->encl;
>         else if (epc_page->flags & SGX_EPC_PAGE_VERSION_ARRAY)
>                 encl = epc_page->owner;
> ...

I don't know how much refactoring it would take, but it would be nice if
that was a bit more obvious.  Basically, can we get the code that checks
for or sets SGX_EPC_PAGE_VERSION_ARRAY close to the code that assigns or
reads ->owner?
