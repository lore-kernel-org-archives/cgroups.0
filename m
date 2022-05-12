From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Thu, 12 May 2022 13:36:44 -0700
Message-ID: <CALvZod4w88YDCpageGPDZfCcFwi2C4YfSsavd-Svixovvx5n_A@mail.gmail.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com> <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com> <CAJD7tkbfT-FRs3LE2GPddqrQSWw_eC1R6k3z04x=z9Zvt5yLpg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8iEGBmtJoxRg/w5RBuhSp0K5Od/nybtVVk1rH49oGiM=;
        b=ixitpKQ3SEMJx6+vyRqfYZFPsTDVscIcPWYVwAot2TlYWB/whS7xd2WA0N3kFVhdWv
         xykgHSXbXR13UoiVi6kmSmkzX2tfIsv7vsZph7eFSvV1S0D9T3FHIUWA8LMD0Do236on
         FTisXIdk9sh4KeO0hAlhE0GBNUnBqeKLa0sWqmXuxnr73Xr9DqUdwX/qiP840xQT6KmX
         vUwaNHv4yq0UjkHIbCtTCBZttGQQrebwZJ05pQro3hanExvUMkgnoB8A3xPfeZTScIFd
         ifuuI96/H0MEDTv8C00E3fyfMSJ/KwBkl5YM9aUbb9nKKbBlKdnD3y7zJcQs9AzZnuVI
         uC7g==
In-Reply-To: <CAJD7tkbfT-FRs3LE2GPddqrQSWw_eC1R6k3z04x=z9Zvt5yLpg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWPdpHbCvnp+Ag@public.gmane.org

On Mon, May 9, 2022 at 9:38 AM Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
[...]
> > >
> > > What do you plan to do for IOMMU page tables? After all, they serve
> > > the exact same purpose, and I'd expect these to be handled the same
> > > way (i.e. why is this KVM specific?).
> >
> > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > account other types of secondary page tables to this stat. It is just
> > that we are currently interested in the KVM MMU usage.
> >
>
>
> Any thoughts on this? Do you think MEMCG_SECONDARY_PAGETABLE would be
> more appropriate here?

I think NR_SECONDARY_PAGTABLE is good. Later it can include pagetables
from other subsystems. The only nit (which you can ignore) I have is
the very long memcg stat and vmstat names. Other than that the patch
looks good to me.
