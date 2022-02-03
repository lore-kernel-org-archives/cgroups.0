From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm: memcg: synchronize objcg lists with a
 dedicated spinlock
Date: Thu, 3 Feb 2022 15:19:12 -0800
Message-ID: <20220203151912.87d47b82c1bc3f0d56be0e3a@linux-foundation.org>
References: <Yfm1IHmoGdyUR81T@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643930353;
        bh=QAHuBZ+lX2RUpSHwgEocw6rmoaPtXDKxXRloyq8ZEec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CjspKTS1bIPfibcKITrREBKeKQlZmkOykOg6E5BXy0zEwtnZIRsD4PFTz6byuzX9r
         +lFOI56eEYmixY6vm3Qq137KAT2W9/9MD417k/Q5JaOKMvDs+3P27ZGynHSXbyEx35
         c/dnEzqXOQRUU29oM0utwLQvmRN+owV/pen03xtc=
In-Reply-To: <Yfm1IHmoGdyUR81T@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alexander Egorenkov <egorenar@linux.ibm.com>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Jeremy Linton <jeremy.linton@arm.com>, cgroups@vger.kernel.org

On Tue, 1 Feb 2022 14:33:04 -0800 Roman Gushchin <guro@fb.com> wrote:

> Alexander reported a circular lock dependency revealed by the mmap1
> ltp test:
>   LOCKDEP_CIRCULAR (suite: ltp, case: mtest06 (mmap1))
> 
> ...
>
> Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")

I'm thinking it needs cc:stable.  It sounds unlikely that we'll hit it
in real life, but lockdep splats are concerning and I expect downstream
kernel consumers will end up merging this anyway, for this reason.

