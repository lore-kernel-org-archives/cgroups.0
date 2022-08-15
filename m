From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 15 Aug 2022 02:18:20 -0700
Message-ID: <CAJD7tkY5SfdhC7-4B7QuJGUVj_Ts+xwCP5FUZ-Lvg=fd1p_xAQ@mail.gmail.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-2-yosryahmed@google.com> <YsdJPeVOqlj4cf2a@google.com>
 <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
 <Ys3+UTTC4Qgbm7pQ@google.com>
 <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
 <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=OOL4Y5kIDK4GpzcnTvXTZTdG7FAR6zzCfj7Cij1BefI=;
 b=CT2aSa6BZY94dkNNot3yaqnr3j9O7orSKuwxILRsqvRnd8WvEpXenBNae1eQ3He/Vr
 3AhSFAuhYY2hqrnn0IDDF0KHetLNrj4QcIGdxSVAjSYmODvxB/brvk0Zl7qi20uhok1U
 L8Vaasnomd+kIjC2rkJJhN7AU6emb3HjWMmp7U1Vlx8usn0ap0gN9exTvoztmuHkK+uZ
 bbG7qHXipz8305jwg9NNwjHODD3YuBTXoLQlVrnf796/Ss23Cy7QGESwKPeZDSbvamLV
 pmcUj/wRO29vXhL6WEKTuroMzefWNmVuDRvkPNn4jz3RLjyIYBjxzVAIO2YyineAt7Js
 iEhA==
In-Reply-To: <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
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
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Shaoqin <shaoqin.huang@intel.com>, Linux-MM <linux-mm@kvack.org>, Zefan Li <lizefan.x@bytedance.com>, kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>, linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>

On Mon, Aug 8, 2022 at 1:06 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> On Mon, Jul 18, 2022 at 11:26 AM Yosry Ahmed <yosryahmed@google.com> wrote:
> >
> > On Tue, Jul 12, 2022 at 4:06 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Jul 12, 2022, Yosry Ahmed wrote:
> > > > Thanks for taking another look at this!
> > > >
> > > > On Thu, Jul 7, 2022 at 1:59 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> > > > > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > > > > index aab70355d64f3..13190d298c986 100644
> > > > > > --- a/include/linux/mmzone.h
> > > > > > +++ b/include/linux/mmzone.h
> > > > > > @@ -216,6 +216,7 @@ enum node_stat_item {
> > > > > >       NR_KERNEL_SCS_KB,       /* measured in KiB */
> > > > > >  #endif
> > > > > >       NR_PAGETABLE,           /* used for pagetables */
> > > > > > +     NR_SECONDARY_PAGETABLE, /* secondary pagetables, e.g. kvm shadow pagetables */
> > > > >
> > > > > Nit, s/kvm/KVM, and drop the "shadow", which might be misinterpreted as saying KVM
> > > > > pagetables are only accounted when KVM is using shadow paging.  KVM's usage of "shadow"
> > > > > is messy, so I totally understand why you included it, but in this case it's unnecessary
> > > > > and potentially confusing.
> > > > >
> > > > > And finally, something that's not a nit.  Should this be wrapped with CONFIG_KVM
> > > > > (using IS_ENABLED() because KVM can be built as a module)?  That could be removed
> > > > > if another non-KVM secondary MMU user comes along, but until then, #ifdeffery for
> > > > > stats the depend on a single feature seems to be the status quo for this code.
> > > > >
> > > >
> > > > I will #ifdef the stat, but I will emphasize in the docs that is
> > > > currently *only* used for KVM so that it makes sense if users without
> > > > KVM don't see the stat at all. I will also remove the stat from
> > > > show_free_areas() in mm/page_alloc.c as it seems like none of the
> > > > #ifdefed stats show up there.
> > >
> > > It's might be worth getting someone from mm/ to weigh in before going through the
> > > trouble, my suggestion/question is based purely on the existing code.
> >
> > Any mm folks with an opinion about this?
> >
> > Any preference on whether we should wrap NR_SECONDARY_PAGETABLE stats
> > with #ifdef CONFIG_KVM for now as it is currently the only source for
> > this stat?
>
> Any input here?
>
> Johannes, you have been involved in discussions in earlier versions of
> this series, any thoughts here?

Andrew, do you have an opinion on this? If not, I will send a v7 with
the nits discussed with Sean. I think otherwise this series has
sufficient ACKs.

Would this be merged through the mm tree or kvm tree? This was based
on the kvm/queue branch but I think I can rebase it on top of
mm-unstable, I think all dependencies that this would have added in
kvm/queue would have been fanned to mm by now.
