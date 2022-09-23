From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 03/20] x86/sgx: Track owning enclave in VA EPC pages
Date: Fri, 23 Sep 2022 15:52:08 +0300
Message-ID: <Yy2r+MN28I54R9an@kernel.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <20220922171057.1236139-4-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663937532;
        bh=dyFwuPI8nAiWa2PCvqNDg4TRnPGIRnPb/48dH0S+ycU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UHyAyizWcDm5F8vFKzB+NUJxPhn+P4LLK8HMa9sPb7dyF72IiA0jLonx49XBNIL19
         +u1awv2DDm8jiRbWj2FDv8yYZ/4HduenQtxyCtUPspfANTtEfOXKO0e1FZCoX5zjLR
         N1aStGHm+IMHCHmPpDE3EejhcsKwn0DN2t1j64OuOoQbjqTKYdkUlGbnU59T/YwCvo
         azxTnT0u/gpNI7x4zr8JjkXGEW0yTxklnOjWCVrJpFve9JDqa189PuCnxmUudz0+E7
         0d+GQOKLg6wU5Z+vP93ktmMvv2KWpGiRYYYtPRX9Kiy5oT/MZFCJseL/MDxMYhugI5
         TM7c/e+rWP9HQ==
Content-Disposition: inline
In-Reply-To: <20220922171057.1236139-4-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Sep 22, 2022 at 10:10:40AM -0700, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> In order to fully account for an enclave's EPC page usage, store
> the owning enclave of a VA EPC page.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Why this change fully accounts enclave's EPC page usage?

BR, Jarkko
