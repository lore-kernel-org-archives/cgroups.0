From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 01/20] x86/sgx: Call cond_resched() at the end of
 sgx_reclaim_pages()
Date: Fri, 23 Sep 2022 15:32:40 +0300
Message-ID: <Yy2naAZfiAyP5H/a@kernel.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <20220922171057.1236139-2-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663936364;
        bh=Fev/xAbFy6dCF9ucIYtx19kMsRsV2B9GzILLEMxl7KU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i8VrLusZ5uePvQXxY5Mcd7BGi1YUArVfDQPr1NkwhErQ0EigpIyVeNCaC68a2fuxI
         dcPh5rTB8eooSjAoj0sQvmq6Y10oempGoRFrFXZJDPcPCIQvbIggRJS+16m0upMLdD
         /J9yLiwnUENhZ8NoRmXgZ9Ann7bcrOjt4O6+Qi8U/gj4IgGqmzWqpMTbUOAz6Myx/P
         666EfrDI/guIroOhYeWlaxz1Vbvy0ZgvKxc1zvlJV7Fm+bGmx6H+e3t/eRPv0gdZ0z
         RwXkofn7VRGdJpGtwKU6sCGr2zyYf6m8P+SSnTyDnbZSf22aIQk8gGNKBcDGXpKQRC
         n1wa9E/VBs53w==
Content-Disposition: inline
In-Reply-To: <20220922171057.1236139-2-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Sep 22, 2022 at 10:10:38AM -0700, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Move the invocation of post-reclaim cond_resched() from the callers of
> sgx_reclaim_pages() into the reclaim path itself.   sgx_reclaim_pages()
> is always called in a loop and is always followed by a call to
> cond_resched().  This will hold true for the EPC cgroup as well, which
> adds even more calls to sgx_reclaim_pages() and thus cond_resched().

This would be in my opinion better:

"
In order to avoid repetion of cond_sched() in ksgxd() and
sgx_alloc_epc_page(), move the call inside sgx_reclaim_pages().

This will hold true for the EPC cgroup as well, which adds more
call sites sgx_reclaim_pages().
"

This way it is dead obvious and is better description because
it enumerates the consequences (i.e. call sites).

BR, Jarkko

