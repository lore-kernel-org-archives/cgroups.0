From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 01/18] x86/sgx: Call cond_resched() at the end of
 sgx_reclaim_pages()
Date: Fri, 2 Dec 2022 14:37:09 -0800
Message-ID: <47799f29-8856-8c87-240b-0667f74a3be8@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-2-kristen@linux.intel.com>
 <37de083d-a63b-b2ff-d00a-e890a1ba5eea@intel.com>
 <da690a45a36038399c63ddac8f0efed9872ec13e.camel@linux.intel.com>
 <746adf31-e70c-e32d-a35d-72d352af613b@intel.com>
 <307b43aa5908c489913110287044e611f574db0a.camel@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670020631; x=1701556631;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fDwnio0U3LHuhov+sUpgA5OaZfMyZJrWLLg1iX6CVrY=;
  b=DCaujLzmEmaes1iDYCqZKoknKhAaNQHNF7DsUv8LTAdbvBfmdJ1KJFXU
   5pKwxoiGeHwWTECxG6RDh4PF9VlWL8MKriJpE2BdmSeExmQHekPrvlC06
   YyPxxVGMs/FK6XT4op1I8zjmfYCdYj+mmP4RM48K0z4wC2XQLhihR63/w
   M9VeQEWQqH5Z4ZoNKWunxZp5EOevANx7QaSdyqJ+BVgLY0ERlyoZXavBd
   vFF7F6P7iNUUx8w9A6Zs0w5ZiShiMyo0/ZJSHQQXXc7nW9LohEHUbmB5q
   Iva1VY+KHM9TmrCWUiN4m2ijvLZYYSROFVMzlYczcJIU46fljm9VDZIx6
   g==;
Content-Language: en-US
In-Reply-To: <307b43aa5908c489913110287044e611f574db0a.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/2/22 14:17, Kristen Carlson Accardi wrote:
> On Fri, 2022-12-02 at 13:45 -0800, Dave Hansen wrote:
>> On 12/2/22 13:37, Kristen Carlson Accardi wrote:
>>>>> +static void sgx_reclaim_pages(void)
>>>>> +{
>>>>> +       __sgx_reclaim_pages();
>>>>> +       cond_resched();
>>>>> +}
>>>> Why bother with the wrapper?  Can't we just put cond_resched() in
>>>> the
>>>> existing sgx_reclaim_pages()?
>>> Because sgx_reclaim_direct() needs to call sgx_reclaim_pages()
>>> but not do the cond_resched(). It was this or add a boolean or
>>> something to let caller's opt out of the resched.
>>
>> Is there a reason sgx_reclaim_direct() *can't* or shouldn't call
>> cond_resched()?
> 
> Yes, it is due to performance concerns. It is explained most succinctly
> by Reinette here:
> 
> https://lore.kernel.org/linux-sgx/a4eb5ab0-bf83-17a4-8bc0-a90aaf438a8e-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

I think I'd much rather have 3 cond_resched()s in the code that
effectively self-document than one __something() in there that's a bit
of a mystery.

Everyone knows what cond_resched() means.
