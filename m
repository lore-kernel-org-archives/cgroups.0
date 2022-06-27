From: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v5 1/4] mm: add NR_SECONDARY_PAGETABLE to count secondary
 page table uses.
Date: Mon, 27 Jun 2022 16:27:11 +0000
Message-ID: <YrnaX/GzivdLPel5@google.com>
References: <20220606222058.86688-1-yosryahmed@google.com>
 <20220606222058.86688-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mvInyOfSwUwozjAA99zs61ByhccL7VTO1x3ICoYmzBc=;
        b=ajnq7ke4Zz4McbdwS+PvHKW0VTT+5/HKbvbyUSU1xxNO95siL3s1Jpz428GFKykOXg
         d8VB6gCmL6MAhNlqxOFU83q7MUtfZqaThTeljwRubrjY3FXr/nSrG8ysRcwC3JY9oXHY
         E/nazIf3ro2KlZr4d5FeO++ZCODHw1FvBEgFN0RUD7vpMXappy8dWxMkU57GzU0Zjw2G
         vT0p9IwlEukEh7Kxuyd/5hL3Huv66bpmY8YLrafTKaNkvkRpdXflG8tpbnFvxHj6/fm2
         e1NOsQAKbZvXwYzS6mETspy+MSA2+b26DyQwX1r3nMVNhSoR9V6muHqeAQbGFgyO+Apl
         N6pA==
Content-Disposition: inline
In-Reply-To: <20220606222058.86688-2-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zefan Li <lizefan.x@bytedance.com>, Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Oliver Upton <oupton@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.ker

On Mon, Jun 06, 2022, Yosry Ahmed wrote:
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 061744c436d99..894d6317f3bdc 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -973,6 +973,7 @@ You may not have all of these fields.
>      SReclaimable:   159856 kB
>      SUnreclaim:     124508 kB
>      PageTables:      24448 kB
> +    SecPageTables:	 0 kB

If/when you rebase, this should probably use all spaces and no tabs to match the
other fields.  Given that it's documentation, I'm guessing the use of spaces is
deliberate.
