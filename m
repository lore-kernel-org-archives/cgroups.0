From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v5 3/4] KVM: x86/mmu: count KVM mmu usage in secondary
 pagetable stats.
Date: Mon, 27 Jun 2022 09:29:12 -0700
Message-ID: <CAJD7tkbkgruPRrfyaHGQcOgmNFCWRASaZB-a8igBScpasfC64g@mail.gmail.com>
References: <20220606222058.86688-1-yosryahmed@google.com> <20220606222058.86688-4-yosryahmed@google.com>
 <YrnZVgq1E/u1nYm0@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kCgDBgQt6lsYAKDyUa0fPFsfL97zuKyIxwCybKNVm6o=;
        b=IuiG/blkJ7gXjOQhLgtlkFYoJRK5r8pgakqSWN1/zlxqf40s05Q2KxgVLRnXAzs+fg
         ulTgDq4Xa1IQ2RvaytKxJcvgFOnViaFiqQeqoT8bFMwQmOfmx5WYvBOMGbjbujaxBKq2
         ZxRw26go6NuTS6kLvJS34xZfj51gNbDxnvzESq7KPA+97DIORIk3qqV6wvZaFYlRyp37
         iYjN5F2Fx3qCzsMwgAJwoELntygw5WoMYjcgqI9vY49AS4kLGOtkbsV2NX3QusZYb24t
         UMBgY7EFeybOiOqeaEkIwXo3wZRzJbzLQJE66d9iQWRd6teu2XSLOdmiKZKg0XoS0prd
         qUlg==
In-Reply-To: <YrnZVgq1E/u1nYm0@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>, Cgroups <cgroups@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.o

On Mon, Jun 27, 2022 at 9:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> > Count the pages used by KVM mmu on x86 for in secondary pagetable stats.
>
> "for in" is funky.  And it's worth providing a brief explanation of what the
> secondary pagetable stats actually are.  "secondary" is confusingly close to
> "second level pagetables", e.g. might be misconstrued as KVM counters for the
> number of stage-2 / two-dimension paging page (TDP) tables.
>
> Code looks good, though it needs a rebased on kvm/queue.

Will rebase and modify the commit message accordingly, thanks!
