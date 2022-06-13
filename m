From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 13 Jun 2022 10:11:23 -0700
Message-ID: <CAJD7tkbUXb7qBm1GAMDr29DcsC90_bPzwffkdtAu_Na+inVzVg@mail.gmail.com>
References: <20220606222058.86688-1-yosryahmed@google.com> <20220606222058.86688-2-yosryahmed@google.com>
 <bdfea446-623c-d423-673f-496b3725ec2c@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:Cc:To:Subject:Message-ID:Date:From:
	In-Reply-To:References:MIME-Version:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Owner; bh=FBplYfD1tJHmO0GTZwaHQOjKNM/HUsIADEfJ8xACUtQ=; b=Q22reuq7/s1TaU
	QCHy2PBrZDcZEMAgqlQ4zI+JWhTt9V9j1GpuD3kUoFCh1EKweYT4VTf9TBVgLasjnUbXNLu97j4Tc
	iBtU1e32domsNEAXfETQ1pCBxafIjPLYr/hJ/PDy9LyEYmNSOfxpMaj9RrMwVa5NssdjxKzWIhq1d
	qc6Q0q//D5cGUAwTgEckRX5j0C8FxVllkyd3KpgIUkIx8L6yIlioyTwlnb1QXZKhDhvMBW1Z2e3nK
	lYjhh2LI4KGoQwpl74ovQorDFL2qdNOUwjKXsISR4w95bf1njMC4NQt+WxusDeaurutHknqsKwN4N
	vEsxbrEsnR1QeKFUmW6w==;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BwfpdGVZuLzhMRO0qDkUrzUSE4uGJ0s4izOa+gswkLc=;
        b=iyoFryyCEMOgC7rXLKu4nOmoJ4Ev3bSJmT6ed09FE5xCAAc5dBkkwtXxpcvvGQ+P+z
         ETT+TDFbc4w3QEtd0CSTtGopVeE/ROGO0WHkEbyE/LYwiv3H3TW3pyxouKMCLv+KqkYZ
         yNXDxA5s4wHBPNNleteRDWB0OVGKRy46fxusIatVg7fbsU3f8NuQHDDwXuooOAhihX5c
         apRzdEm4Qcxw1Vp4x8eHSJ0zk6RBYV1Jvu3JCqD8yM8Yczm4FlFHmh8FmzU3HH+SvYZl
         N0nY66gFj0te0BB1xSoY4rr990nbGbzyauUa8tb8y8DjQzQQuFKjHb8vPu4IK/5VClaZ
         mw/g==
In-Reply-To: <bdfea446-623c-d423-673f-496b3725ec2c@intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org
To: "Huang, Shaoqin" <shaoqin.huang@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Linux-MM <linux-mm@kvack>

On Sun, Jun 12, 2022 at 8:18 PM Huang, Shaoqin <shaoqin.huang@intel.com> wrote:
>
>
>
> On 6/7/2022 6:20 AM, Yosry Ahmed wrote:
> > Add NR_SECONDARY_PAGETABLE stat to count secondary page table uses, e.g.
> > KVM mmu. This provides more insights on the kernel memory used
> > by a workload.
> >
> > This stat will be used by subsequent patches to count KVM mmu
> > memory usage.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >   Documentation/admin-guide/cgroup-v2.rst | 5 +++++
> >   Documentation/filesystems/proc.rst      | 4 ++++
> >   drivers/base/node.c                     | 2 ++
> >   fs/proc/meminfo.c                       | 2 ++
> >   include/linux/mmzone.h                  | 1 +
> >   mm/memcontrol.c                         | 1 +
> >   mm/page_alloc.c                         | 6 +++++-
> >   mm/vmstat.c                             | 1 +
> >   8 files changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 69d7a6983f781..307a284b99189 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1312,6 +1312,11 @@ PAGE_SIZE multiple when read back.
> >         pagetables
> >                   Amount of memory allocated for page tables.
> >
> > +       sec_pagetables
> > +             Amount of memory allocated for secondary page tables,
> > +             this currently includes KVM mmu allocations on x86
> > +             and arm64.
> > +
> >         percpu (npn)
> >               Amount of memory used for storing per-cpu kernel
> >               data structures.
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index 061744c436d99..894d6317f3bdc 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -973,6 +973,7 @@ You may not have all of these fields.
> >       SReclaimable:   159856 kB
> >       SUnreclaim:     124508 kB
> >       PageTables:      24448 kB
> > +    SecPageTables:    0 kB
> >       NFS_Unstable:        0 kB
> >       Bounce:              0 kB
> >       WritebackTmp:        0 kB
> > @@ -1067,6 +1068,9 @@ SUnreclaim
> >   PageTables
> >                 amount of memory dedicated to the lowest level of page
> >                 tables.
> > +SecPageTables
> > +           amount of memory dedicated to secondary page tables, this
> > +           currently includes KVM mmu allocations on x86 and arm64.
>
> Just a notice. This patch in the latest 5.19.0-rc2+ have a conflict in
> Documentation/filesystems/proc.rst file. But that's not a problem.

Thanks for pointing this out. Let me know if a rebase and resend is necessary.

<snip>
