From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 05/20] x86/sgx: Introduce unreclaimable EPC page lists
Date: Fri, 23 Sep 2022 16:29:06 +0300
Message-ID: <Yy20ov/Pcxo3tBSn@kernel.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <20220922171057.1236139-6-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663939750;
        bh=7GWKDuhtbW6r2KpVH7DUjRqYL50U4cTrwdK0ewzhHyI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PF8GTxss/DpOVvSfm+7chSANkuylKwulE1LNRSBPBiW14DpRbT7vPLrg6k4lMMr+L
         Z0Xs2Lb4q4kS9mHeFZkRDnHi2UBksryOXNpcR9i2WD7OXqy7NEdu7M/VNYGhOJdX5T
         UWDglCD4n5vVQ1P4bdGE9UmNlC4zNQRfB3L15FvFvf9RmZVEKWGIVkJb9GB36Ulc7X
         qS3dP/aEMri9L0r0IjxWGdda/rpQDSLoZktYMD2KAItuJbaXBeKTnbLSLAjmjXFZOx
         2wLWLESfVZ1NPzxHg/Nk6eWw2PMBA26nT7zbAmFnln/39oy9FfDDDgUFyaiXjENOww
         vK8FKTsBYcdSQ==
Content-Disposition: inline
In-Reply-To: <20220922171057.1236139-6-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Sep 22, 2022 at 10:10:42AM -0700, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Add code to keep track of pages that are not tracked by the reclaimer
> in the LRU's "unreclaimable" list. When there is an OOM event and an
> enclave must be OOM killed, the EPC pages which are not tracked by
> the reclaimer can still be freed.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This could have some description of what is actually happening in
this patch.

BR, Jarkko
