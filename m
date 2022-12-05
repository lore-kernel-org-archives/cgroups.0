From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 07/18] x86/sgx: Use a list to track to-be-reclaimed
 pages during reclaim
Date: Mon, 5 Dec 2022 09:03:14 -0800
Message-ID: <6668e428-8e4a-0a44-d77c-a540c04d72ed@intel.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-8-kristen@linux.intel.com>
 <0646275c-0ab9-2fad-8db1-7098656d6e1d@intel.com>
 <931e48dc399eddf8ad9f9dec8783f57df776daa9.camel@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670259820; x=1701795820;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wzh0rMbXm1tFMjnwOYEXWNfHVTuu3YxI67jkP6aqejU=;
  b=mErQh0+Nr4urRtDNhHkmMI4B2Ism3tvGWs8RweSNig4/Q4mV3WCPvuWC
   agVqr7WehlM2VicV5gKbCi3daRahBaHp+FQ/WtC3KDty+axflE2YjTrCb
   KpgO+nLDYOupOuGQD0YJrfdcYA52DuAUHFFk2w08IURS9pAQdDJ8lrl0N
   73CTz3/Hp9S3OmS85W4G+/WDSDaUP5Wr9SSl78veo2Gk0RGj7y6FCW+OB
   R9clRnnYtQ4Ocm3OahsFfitv7dsGeOE98kB9up5k5gx0Ha7NV968HyaEm
   A12RECSIwyzPb+tuYw5voiBL6DgEsy7txb81BQaBMe8efnz5r2DPUsfyB
   A==;
Content-Language: en-US
In-Reply-To: <931e48dc399eddf8ad9f9dec8783f57df776daa9.camel-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 12/5/22 08:33, Kristen Carlson Accardi wrote:
> The helpers were added because Jarrko requested a queue abstraction for
> the sgx_epc_lru_lists data structure in the first round of reviews. the
> simple one line inlines are effectively just renaming to make the queue
> abstraction more obvious to the reader.

Jarkko,

Do you have any issues with zapping these helpers?  I really don't think
they add to readability.  The "reclaimable" versus "unreclaimable"
naming is patently obvious from the structure member names.  I'm not
sure what value it adds to have them in the function names too.


