From: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v4 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Fri, 13 May 2022 16:12:40 +0000
Message-ID: <Yn6DeEGLyR4Q0cDp@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-2-yosryahmed@google.com>
 <87ilqoi77b.wl-maz@kernel.org>
 <CAJD7tkY7JF25XXUFq2mGroetMkfo-2zGOaQC94pjZE3D42+oaw@mail.gmail.com>
 <Yn2TGJ4vZ/fst+CY@cmpxchg.org> <Yn2YYl98Vhh/UL0w@google.com>
 <Yn5+OtZSSUZZgTQj@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=z141h5DooZE4FL3AcX+0cKxHlZQWL6e7O/2bq4FL5UY=;
 b=pMpyJUjUuK/7b/oFgsoqZPGJMcOKB+7c5car+thP1abZdX0Ernmov9vuFLaqKMGXn2
 rG8JUhF6WgH7lMygF4hmuRIwFoCrADaFG0pDWTQKNWoL6WLM69N4kM4KtTQkkoALHWrD
 mAeJQipbT6/IL+OPcmvLrWT3xFgMFLNWJ+O6dFPVj4sg1KmNHaULMm56Trm/hh8TOipy
 uhaRQ/7aUedXdd9J0nEfOtBBAWb0ZPzn5j4jRptmc960+ldd4gTqKw70bR33LbaLOe4i
 OR/28/FZmY9vcAYQkNkQbiAC8Sl0bxsa6t+sHaEyvc1goNVOfOnpsfXq5AH2VoYmLRhW
 N/PQ==
Content-Disposition: inline
In-Reply-To: <Yn5+OtZSSUZZgTQj@cmpxchg.org>
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
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>

On Fri, May 13, 2022, Johannes Weiner wrote:
> On Thu, May 12, 2022 at 11:29:38PM +0000, Sean Christopherson wrote:
> > On Thu, May 12, 2022, Johannes Weiner wrote:
> > > On Mon, May 02, 2022 at 11:46:26AM -0700, Yosry Ahmed wrote:
> > > > On Mon, May 2, 2022 at 3:01 AM Marc Zyngier <maz@kernel.org> wrote:
> > > > > What do you plan to do for IOMMU page tables? After all, they serve
> > > > > the exact same purpose, and I'd expect these to be handled the same
> > > > > way (i.e. why is this KVM specific?).
> > > > 
> > > > The reason this was named NR_SECONDARY_PAGTABLE instead of
> > > > NR_KVM_PAGETABLE is exactly that. To leave room to incrementally
> > > > account other types of secondary page tables to this stat. It is just
> > > > that we are currently interested in the KVM MMU usage.
> > > 
> > > Do you actually care at the supervisor level that this memory is used
> > > for guest page tables?
> > 
> > Hmm, yes?  KVM does have a decent number of large-ish allocations that aren't
> > for page tables, but except for page tables, the number/size of those allocations
> > scales linearly with either the number of vCPUs or the amount of memory assigned
> > to the VM (with no room for improvement barring KVM changes).
> > 
> > Off the top of my head, KVM's secondary page tables are the only allocations that
> > don't scale linearly, especially when nested virtualization is in use.
> 
> Thanks, that's useful information.
> 
> Are these other allocations accounted somewhere? If not, are they
> potential containment holes that will need fixing eventually?

All allocations that are tied to specific VM/vCPU are tagged GFP_KERNEL_ACCOUNT,
so we should be good on that front.
 
> > > It seems to me you primarily care that it is reported *somewhere*
> > > (hence the piggybacking off of NR_PAGETABLE at first). And whether
> > > it's page tables or iommu tables or whatever else allocated for the
> > > purpose of virtualization, it doesn't make much of a difference to the
> > > host/cgroup that is tracking it, right?
> > > 
> > > (The proximity to nr_pagetable could also be confusing. A high page
> > > table count can be a hint to userspace to enable THP. It seems
> > > actionable in a different way than a high number of kvm page tables or
> > > iommu page tables.)
> > 
> > I don't know about iommu page tables, but on the KVM side a high count can also
> > be a good signal that enabling THP would be beneficial.
> 
> Well, maybe.
> 
> It might help, but ultimately it's the process that's in control in
> all cases: it's unmovable kernel memory allocated to manage virtual
> address space inside the task.
> 
> So I'm still a bit at a loss whether these things should all be lumped
> in together or kept separately. meminfo and memory.stat are permanent
> ABI, so we should try to establish in advance whether the new itme is
> really a first-class consumer or part of something bigger.
> 
> The patch initially piggybacked on NR_PAGETABLE. I found an email of
> you asking why it couldn't be a separate item, but it didn't provide a
> reasoning for that decision. Could you share your thoughts on that?

It was mostly an honest question, I too am trying to understand what userspace
wants to do with this information.  I was/am also trying to understand the benefits
of doing the tracking through page_state and not a dedicated KVM stat.  E.g. KVM
already has specific stats for the number of leaf pages mapped into a VM, why not
do the same for non-leaf pages?
