From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 05/18] x86/sgx: Track epc pages on reclaimable or
 unreclaimable lists
Date: Fri, 2 Dec 2022 22:28:50 +0000
Message-ID: <Y4p8IuxyVLw2YPNy@google.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-6-kristen@linux.intel.com>
 <1dccd2ec-cad8-b9d2-d66b-aebad21cdb44@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mA7EbMY6jYQnBQ5a2EEJbPnWMt0mwJ2NvlH1bqAlVdY=;
        b=V060CW+9WaoNQd3JTJUfI6o9UkdRjdDPq8YkiSwizBRy26ilkRnNGJAXE7Vg9+lNlI
         2yoV5EBEzLEz03OO4J7or/HgCgJhox9GCPQSTfFmJl/8RH2WoDN4tpDIVB7c6tjjj1zw
         XpjdStemOWcnPqOer1QKZhSsCMKZ9rlqrOhavARkgcl9n0wfWmf1fpSwL9hSldz9SS2Q
         +S7s7eeJ4gTCgWzPJGljpfxS1WzJ/geX0nebjxdSA3dsEksaWk7t/oR7BC5dd7KrrXeT
         /mq07VibZtN+GbzY1ouUXHt/a9xxG1DhUAugzfWTojM3VFVZG3IlSe9RUyAoBjjhaMIa
         fEXA==
Content-Disposition: inline
In-Reply-To: <1dccd2ec-cad8-b9d2-d66b-aebad21cdb44-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Dec 02, 2022, Dave Hansen wrote:
> On 12/2/22 10:36, Kristen Carlson Accardi wrote:
> > Replace functions sgx_mark_page_reclaimable() and
> > sgx_unmark_page_reclaimable() with sgx_record_epc_page() and
> > sgx_drop_epc_page(). sgx_record_epc_page() wil add the epc_page
> > to the correct "reclaimable" or "unreclaimable" list in the
> > sgx_epc_lru_lists struct. sgx_drop_epc_page() will delete the page
> > from the LRU list. Tracking pages that are not tracked by
> > the reclaimer in the sgx_epc_lru_lists "unreclaimable" list allows
> > an OOM event to cause all the pages in use by an enclave to be freed,
> > regardless of whether they were reclaimable pages or not.
> 
> This might be more a comment about Sean's stuff

Anything with a single space after a period wasn't written by me, I'm a devout
believer of two spaces :-)
