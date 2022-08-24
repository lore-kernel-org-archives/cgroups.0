From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Wed, 24 Aug 2022 10:25:43 -0700
Message-ID: <CAJD7tkbn7mFvf0oiUKPZtu92GtuMht-s5iPBRfEuUfTxXC_j8Q@mail.gmail.com>
References: <20220823004639.2387269-1-yosryahmed@google.com>
 <20220823004639.2387269-2-yosryahmed@google.com> <5ac13c91-0e42-533b-42d0-c78573c7aef3@arm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=PyL5R0h/l4gJt239ptqG1oF6MWjvvRhnBKs2TUqoy18=;
        b=jQo8Hnb2GH3hf1ONG3xswu3V43RapwZZQv/uLqocxPR835oyqTUFMASIxiUoHL6XPp
         EbyicGfCO/sXpp4HRUcZkK6eb5S/FJk3LCRWifleT2kwRNWUQdb3Pycb7gz+LLxmY/R5
         cAwAKSjcgIGBXG8vtmnslPBHLQtM2g3cCibWehD2SbdsVHqGT2G9+BKT5dnCmoA5yLS/
         NVGYZip8bdVm+/+hyVO7QlJ3mzWEUYz9x/mwMcK90WZe3i29zVqh6PZXN9gfUwGFhwoX
         BqhSoPB12QVEr5eJwWyR6ofuIoW/nLes2Q//tqKQFwWjS9S5Pc7b3jtbxpG9zRwoyvst
         uW2g==
In-Reply-To: <5ac13c91-0e42-533b-42d0-c78573c7aef3-5wv7dgnIgG8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Huang@g

On Wed, Aug 24, 2022 at 6:42 AM Ryan Roberts <ryan.roberts-5wv7dgnIgG8@public.gmane.org> wrote:
>
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index e7aafc82be99..898c99eae8e4 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -982,6 +982,7 @@ Example output. You may not have all of these fields.
> >       SUnreclaim:       142336 kB
> >       KernelStack:       11168 kB
> >       PageTables:        20540 kB
> > +    SecPageTables:         0 kB
> >       NFS_Unstable:          0 kB
> >       Bounce:                0 kB
> >       WritebackTmp:          0 kB
> > @@ -1090,6 +1091,9 @@ KernelStack
> >                 Memory consumed by the kernel stacks of all tasks
> >   PageTables
> >                 Memory consumed by userspace page tables
> > +SecPageTables
> > +              Memory consumed by secondary page tables, this currently
> > +              currently includes KVM mmu allocations on x86 and arm64.
>
> nit: I think you have a typo here: "currently currently".

Sorry I missed this, thanks for catching it. The below diff fixes it
(let me know if I need to send v8 for this, hopefully not).

diff --git a/Documentation/filesystems/proc.rst
b/Documentation/filesystems/proc.rst
index 898c99eae8e4..0b3778ec12e1 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1093,7 +1093,7 @@ PageTables
               Memory consumed by userspace page tables
 SecPageTables
               Memory consumed by secondary page tables, this currently
-              currently includes KVM mmu allocations on x86 and arm64.
+              includes KVM mmu allocations on x86 and arm64.
 NFS_Unstable
               Always zero. Previous counted pages which had been written to
               the server, but has not been committed to stable storage.

>
> Thanks,
> Ryan
