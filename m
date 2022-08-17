From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v6 1/4] mm: add NR_SECONDARY_PAGETABLE to count
 secondary page table uses.
Date: Wed, 17 Aug 2022 10:25:00 -0700
Message-ID: <20220817102500.440c6d0a3fce296fdf91bea6@linux-foundation.org>
References: <20220628220938.3657876-1-yosryahmed@google.com>
        <20220628220938.3657876-2-yosryahmed@google.com>
        <YsdJPeVOqlj4cf2a@google.com>
        <CAJD7tkYE+pZdk=-psEP_Rq_1CmDjY7Go+s1LXm-ctryWvUdgLA@mail.gmail.com>
        <Ys3+UTTC4Qgbm7pQ@google.com>
        <CAJD7tkY91oiDWTj5FY2Upc5vabsjLk+CBMNzAepXLUdF_GS11w@mail.gmail.com>
        <CAJD7tkbc+E7f+ENRazf0SO7C3gR2bHiN4B0F1oPn8Pa6juAVfg@mail.gmail.com>
        <Yvpir0nWuTsXz322@cmpxchg.org>
        <CAJD7tkYJcsSvCUCkNgcWvi2Xoa3GDZk81p5GUptZzkOkrhrTWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660757102;
        bh=ZTD0yTCE3YoAij/5K0t2/ZUlwJCWY5Buw6REabl/WR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SC2J5w+BXqr7lkuRfY2QM2puWBjyj5GOP6h+wLPgx64dkkM+tCRVdWsIQbGiRCiIP
         HS1DIM/JFDsLiNWXImyXnJAEql4l81hy1lSRe9YMugF7RDL9vmprjJPiL2ngIQK74F
         NEO2ZMkx/eaYaCUlkqbMXLYhbvkPgc997CnqKEYY=
In-Reply-To: <CAJD7tkYJcsSvCUCkNgcWvi2Xoa3GDZk81p5GUptZzkOkrhrTWQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Marc Zyngier <maz-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Alexandru Elisei <alexandru.elisei-5wv7dgnIgG8@public.gmane.org>, Suzuki K Poulose <suzuki.poulose-5wv7dgnIgG8@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wanpeng Li <wanpengli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>, Jim Mattson <jmattson-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oliver Upton <oupton-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huang-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Shaoqin <shaoqin.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel@v>

On Mon, 15 Aug 2022 08:39:23 -0700 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Thanks a lot, Johannes! I haven't ifdeffed it yet so I'll send a v7
> with a few nits and collect ACKs. Andrew, would you prefer me to
> rebase on top of mm-unstable? Or will this go in through the kvm tree?
> (currently it's based on an old-ish kvm/queue).

Through KVM is OK by me, assuming there'll be ongoing work which is
dependent on this.
