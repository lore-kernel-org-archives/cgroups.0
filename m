From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 02/18] x86/sgx: Store struct sgx_encl when allocating
 new VA pages
Date: Fri, 2 Dec 2022 22:49:46 +0000
Message-ID: <Y4qBCjTcMdBLUNEB@google.com>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-3-kristen@linux.intel.com>
 <3a789b1c-4c70-158b-d764-daec141a5816@intel.com>
 <abfc00a2ab1d97f8081c696f78e2d0ced23902b4.camel@linux.intel.com>
 <2015ae96-5459-1f82-596b-f46af08ef766@intel.com>
 <Y4p9nKV+jpLnOVwD@google.com>
 <8b7f6993-2135-a9f9-63c5-c9c6112ef676@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zf9FQYPb7IhTgwhWHe3ZzCAFF6zYBHHq7kdqxOUK6iE=;
        b=oNLuBgJV9pADQi48wDLKc0aHYvcSFy+n64QtfRVE9Qvx5jIC11Gt51rOMETOQtkv03
         Z0DdLrYHUrjE6AdeCCYWYFCYeMIsQ72e9HoEC8r38Zbxx0WaQrTx24PhhcISBUgIm7zN
         xy/lbDoWZw2Rid+3mwGaiU9YQSqJYu0o0Sda8PTfuMr1O5MOm0ZY/LZIaU83W223zhlz
         H7bzOPrBMii4m5EvjoJLYdUryrPyA3YUDEVofre1+SCmjewkhBlw2C2QOruYvYJnO4u2
         Q46PLNHcHnErGYNtJXbMc11k8/1mcmB9/epIn99dnC8IssY4IA6QGx+WDnN/X6U0phEw
         9WBQ==
Content-Disposition: inline
In-Reply-To: <8b7f6993-2135-a9f9-63c5-c9c6112ef676-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Fri, Dec 02, 2022, Dave Hansen wrote:
> On 12/2/22 14:35, Sean Christopherson wrote:
> >> That seems like it's going the other direction from what an OOM-kill
> >> would need to do.
> > Providing a backpointer from a VA page to its enclave allows OOM-killing the enclave
> > if its cgroup is over the limit but there are no reclaimable pages for said cgroup
> > (for SGX's definition of "reclaimable").  I.e. if all of an enclave's "regular"
> > pages have been swapped out, the only thing left resident in the EPC will be the
> > enclave's VA pages, which are not reclaimable in the kernel's current SGX
> > implementation.
> 
> Ooooooooooooooooooooh.  I'm a dummy.
> 
> 
> So, we've got a cgroup.  It's in OOM-kill mode and we're looking at the
> *cgroup* LRU lists.  We've done everything we can to the enclave and
> swapped everything out that we can.  All we're left with are these
> crummy VA pages on the LRU (or equally crummy pages).  We want to
> reclaim them but can't swap VA pages.  Our only recourse is to go to the
> enclave and kill *it*.
> 
> Right now, we can easily find an enclave's VA pages and free them.  We
> do that all the time when freeing whole enclaves.  But, what we can't
> easily do is find an enclave given a VA page.
> 
> A reverse pointer from VA page back to enclave allows the VA page's
> enclave to be located and efficiently killed.
> 
> Right?

Yep, exactly.
