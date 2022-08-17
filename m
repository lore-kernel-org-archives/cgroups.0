From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Wed, 17 Aug 2022 15:27:58 -0700
Message-ID: <CAJD7tkZQ07dZtcTSirj0qLawaE3Ndyn-385m_kL09=gsfO9QwA@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com>
 <20220817102408.7b048f198a736f053ced2862@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=o1hj40RfZIutgTtHY6Ei4iwhGh1778mLr0oxD454ZKw=;
 b=dxQEBsrSOL6uneP8vspbdKN8cBHPLmh476RXn4nJLef2SC2AaP3hEaVfFfI+RNXVBC
 vgzrUEQdxYMNrJ+jezUDoyob0kbiLE7ORKCdTBLFa2i3RQKy1foqJ61Gs3yaQS61PK99
 hKCF/kgqBaIHTekyfAfoVByipKAm6EgVGHNqnfh0M6ZBcTluXibNNSDJkKCQJH9N0cWp
 MaZ/MngfqLuXRrfljnJ/CdzaaBF5y3lB2jjOH9eC3r36yDFw56U7vu6Y6F/AWxpmWg4k
 +gFmn3dYTFKgVYuqjbtEl0Io2egt9yfZOdljmrlRETUhbMaQg7UXCc4GMk8ygxXXKw4u
 zrMw==
In-Reply-To: <20220817102408.7b048f198a736f053ced2862@linux-foundation.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>, Huang@google.com, linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>

On Wed, Aug 17, 2022 at 10:24 AM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 28 Jun 2022 22:09:35 +0000 Yosry Ahmed <yosryahmed@google.com> wrote:
>
> > We keep track of several kernel memory stats (total kernel memory, page
> > tables, stack, vmalloc, etc) on multiple levels (global, per-node,
> > per-memcg, etc). These stats give insights to users to how much memory
> > is used by the kernel and for what purposes.
> >
> > Currently, memory used by kvm mmu is not accounted in any of those
> > kernel memory stats. This patch series accounts the memory pages
> > used by KVM for page tables in those stats in a new
> > NR_SECONDARY_PAGETABLE stat. This stat can be later extended to account
> > for other types of secondary pages tables (e.g. iommu page tables).
> >
> > KVM has a decent number of large allocations that aren't for page
> > tables, but for most of them, the number/size of those allocations
> > scales linearly with either the number of vCPUs or the amount of memory
> > assigned to the VM. KVM's secondary page table allocations do not scale
> > linearly, especially when nested virtualization is in use.
> >
> > >From a KVM perspective, NR_SECONDARY_PAGETABLE will scale with KVM's
> > per-VM pages_{4k,2m,1g} stats unless the guest is doing something
> > bizarre (e.g. accessing only 4kb chunks of 2mb pages so that KVM is
> > forced to allocate a large number of page tables even though the guest
> > isn't accessing that much memory). However, someone would need to either
> > understand how KVM works to make that connection, or know (or be told) to
> > go look at KVM's stats if they're running VMs to better decipher the stats.
> >
> > Furthermore, having NR_PAGETABLE side-by-side with NR_SECONDARY_PAGETABLE
> > is informative. For example, when backing a VM with THP vs. HugeTLB,
> > NR_SECONDARY_PAGETABLE is roughly the same, but NR_PAGETABLE is an order
> > of magnitude higher with THP. So having this stat will at the very least
> > prove to be useful for understanding tradeoffs between VM backing types,
> > and likely even steer folks towards potential optimizations.
> >
> > The original discussion with more details about the rationale:
> > https://lore.kernel.org/all/87ilqoi77b.wl-maz@kernel.org
> >
> > This stat will be used by subsequent patches to count KVM mmu
> > memory usage.
>
> Nits and triviata:
>
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -977,6 +977,7 @@ Example output. You may not have all of these fields.
> >      SUnreclaim:       142336 kB
> >      KernelStack:       11168 kB
> >      PageTables:        20540 kB
> > +    SecPageTables:         0 kB
> >      NFS_Unstable:          0 kB
> >      Bounce:                0 kB
> >      WritebackTmp:          0 kB
> > @@ -1085,6 +1086,9 @@ KernelStack
> >                Memory consumed by the kernel stacks of all tasks
> >  PageTables
> >                Memory consumed by userspace page tables
> > +SecPageTables
> > +              Memory consumed by secondary page tables, this currently
> > +           currently includes KVM mmu allocations on x86 and arm64.
>
> Something happened to the whitespace there.

Yeah I have the fix for this queued for v7. Thanks!

>
> > +                          "Node %d SecPageTables:  %8lu kB\n"
> > ...
> > +                          nid, K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
>
> The use of "sec" in the user-facing changes and "secondary" in the
> programmer-facing changes is irksome.  Can we be consistent?  I'd
> prefer "secondary" throughout.
>

SecondaryPageTables is too long (unfortunately), it messes up the
formatting in node_read_meminfo() and meminfo_proc_show(). I would
prefer "secondary" as well, but I don't know if breaking the format in
this way is okay.

This is what I mean by breaking the format btw (the numbers become misaligned):

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5ad56a0cd593..4f85750a0f8e 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -433,7 +433,7 @@ static ssize_t node_read_meminfo(struct device *dev,
                             "Node %d ShadowCallStack:%8lu kB\n"
 #endif
                             "Node %d PageTables:     %8lu kB\n"
-                            "Node %d SecPageTables:  %8lu kB\n"
+                            "Node %d SecondaryPageTables:  %8lu kB\n"
                             "Node %d NFS_Unstable:   %8lu kB\n"
                             "Node %d Bounce:         %8lu kB\n"
                             "Node %d WritebackTmp:   %8lu kB\n"
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 208efd4fa52c..b7166d09a38f 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -115,7 +115,7 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #endif
        show_val_kb(m, "PageTables:     ",
                    global_node_page_state(NR_PAGETABLE));
-       show_val_kb(m, "SecPageTables:  ",
+       show_val_kb(m, "SecondaryPageTables:    ",
                    global_node_page_state(NR_SECONDARY_PAGETABLE));

        show_val_kb(m, "NFS_Unstable:   ", 0);
