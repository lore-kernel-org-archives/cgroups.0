From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 25/26] x86/sgx: Add support for misc cgroup controller
Date: Mon, 14 Nov 2022 12:38:09 -1000
Message-ID: <Y3LDUaQ5fuLCuAhD@slm.duckdns.org>
References: <20221111183532.3676646-1-kristen@linux.intel.com>
 <20221111183532.3676646-26-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JaW/R8iCCS/1A9BRN+LwDCOTY1xF4tsj+qzK35G6lZo=;
        b=Du8ZgVPp1AWEAef+8v0/Eoa/chpMPJcieUAPGH8sq0fGNMyoeliA2PAtXVrauYlDze
         l7TMbcvmc0PivKE+xSYRMj9EgfCxVDwWln8ZmZjTZQ+5gQIMomP8cQnLLnpb95htQAqj
         FjfXo6JxllvkuUdDkm+lGbsWLqdWI85x5JU7eVDIt+A19yqGA0T0U/x9PhZmkX6ly6HS
         M89z53VsSzEN1gIiVQNvWb9nV56EEl+oyUu+3s4mPsM3twqjZHepWNcwKJC0mHH0ifax
         wrrUwqxlVTpfQhTpIulQnO1RDPDRCle7oJMCeYrXSibwot30ousvSP+0Jk1rgln0LUHD
         y0wA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221111183532.3676646-26-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Nov 11, 2022 at 10:35:30AM -0800, Kristen Carlson Accardi wrote:
> Implement support for cgroup control of SGX Enclave Page Cache (EPC)
> memory using the misc cgroup controller. EPC memory is independent
> from normal system memory, e.g. must be reserved at boot from RAM and
> cannot be converted between EPC and normal memory while the system is
> running. EPC is managed by the SGX subsystem and is not accounted by
> the memory controller.
> 
> Much like normal system memory, EPC memory can be overcommitted via
> virtual memory techniques and pages can be swapped out of the EPC to
> their backing store (normal system memory, e.g. shmem).  The SGX EPC
> subsystem is analogous to the memory subsytem and the SGX EPC controller
> is in turn analogous to the memory controller; it implements limit and
> protection models for EPC memory.
> 
> The misc controller provides a mechanism to set a hard limit of EPC
> usage via the "sgx_epc" resource in "misc.max". The total EPC memory
> available on the system is reported via the "sgx_epc" resource in
> "misc.capacity".
> 
> This patch was modified from its original version to use the misc cgroup
> controller instead of a custom controller.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This looks fine from cgroup POV.

Thanks.

-- 
tejun
