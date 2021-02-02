From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 3/7] mm: memcontrol: privatize memcg_page_state query functions
Date: Tue, 2 Feb 2021 14:26:21 -0800
Message-ID: <CALvZod6kqzoydroO3E59=hrF+DBV6LwRZ282h2p+xeNKezFAgg@mail.gmail.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org> <20210202184746.119084-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wDotIy3tcEIJJUi6Xky2qhleZoFwxU7Fh1JVqEU4/ic=;
        b=DWhal97NxQ2UcRObukqIeV8C95ewjDs0qpbMhw0PAmBEJ3xVz68xcmNomNWXA+OJic
         +rIygIVjzV43HN7ioMBwfKyJVQhO9NMVYn1W/9WGwMDdEQx0n+umzXULPrkTJaVyvxyW
         pwgtfY25dcBvIRG2+SgntOFiAi/e+7cOpdNOaU41qnmXgqQTnVFZM1SPbiIQXiOwK+3h
         sTboxTmYqLIVMaT3mXKitQs1ablFfYVbDPpDCLlNnsids3HT3uQifHjR6H/wm2//y/5d
         dY492h/vGDfeQCipU0CkZmnzGYrEoEs0Hia3IDejLkYw16Cn+ZNg9J2G3D0EUmWgllJg
         p5/g==
In-Reply-To: <20210202184746.119084-4-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Tue, Feb 2, 2021 at 12:45 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> There are no users outside of the memory controller itself. The rest
> of the kernel cares either about node or lruvec stats.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
