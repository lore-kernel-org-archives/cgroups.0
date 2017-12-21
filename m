From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Thu, 21 Dec 2017 05:37:26 -0800
Message-ID: <20171221133726.GD1084507@devbig577.frc2.facebook.com>
References: <20171219152444.GP3919388@devbig577.frc2.facebook.com>
 <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
 <20171219173354.GQ3919388@devbig577.frc2.facebook.com>
 <CALvZod7pbp0fFUPRnC68qdzkCEUg2YTavq6C6OLxqooCU5VeyQ@mail.gmail.com>
 <20171219214107.GR3919388@devbig577.frc2.facebook.com>
 <CALvZod5XRhXc3XrQw50Jw_OpRQB2iCCbgG-NMDCa8xRmGNdLrw@mail.gmail.com>
 <20171220193741.GD3413940@devbig577.frc2.facebook.com>
 <CALvZod7Z1Yh+ZhU8qxzSiN0Pph2R7O4Mki5E23FbJFAzhyCH8g@mail.gmail.com>
 <20171220233658.GB1084507@devbig577.frc2.facebook.com>
 <CALvZod7eQWrD6LgbUrOvuhf5A1KKxBaK5t-U61gdFqvMeWXuzQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cLtY9trmA6sARVkA1thpeBSjDcVj8V63sU0BjmFDwkQ=;
        b=lMEk6Cdx1AgVDunjAAS8gmYCkDNIFbs2ZQaOG2NhnW1e8z1kLTyGlqYqWiKj/uOUO1
         0kDhjsSNOAmDZImZvppEvIvJey22vpqrKsUmxkjvRydjfrtNg1XPM+s1ieE+6xUs4a9i
         EY6Zuq9ygXIZl+G+89HlOjB9A8qMU00kpogaTsf6asN4Xgk2QNMntttn6old8JPuPji1
         Www0SJbF4Ia0scdDpFbpbQc0CuZK2uha1pKiOGEghAXVldBMDaucruEB9jCaWyBEJDfE
         tIzzqe7EX0q1J0Phll7mp4y3hSYpFS5QifNYn+v9vvuW1se47qpGGK5KfEuimd3znvw/
         yq1A==
Content-Disposition: inline
In-Reply-To: <CALvZod7eQWrD6LgbUrOvuhf5A1KKxBaK5t-U61gdFqvMeWXuzQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Li Zefan <lizefan@huawei.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

Hello, Shakeel.

On Wed, Dec 20, 2017 at 05:15:41PM -0800, Shakeel Butt wrote:
> Let's say we have a job that allocates 100 MiB memory and suppose 80
> MiB is anon and 20 MiB is non-anon (file & kmem).
> 
> [With memsw] Scheduler sets the memsw limit of the job to 100 MiB and
> memory to max. Now suppose the job tries to allocates memory more than
> 100 MiB, it will hit the memsw limit and will try to reclaim non-anon
> memory. The memcg OOM behavior will only depend on the reclaim of
> non-anon memory and will be independent of the underlying swap device.

Sure, the direct reclaim on memsw limit won't reclaim anon pages, but
think about how the state at that point would have formed.  You're
claiming that memsw makes memory allocation and balancing behavior an
invariant against the performance of the swap device that the machine
has.  It's simply not possible.

On top of that, what's the point?

1. As I wrote earlier, given the current OOM killer implementation,
   whether OOM kicks in or not is not even that relevant in
   determining the health of the workload.  There are frequent failure
   modes where OOM killer fails to kick in while the workload isn't
   making any meaningful forward progress.

2. On hitting memsw limit, the OOM decision is dependent on the
   performance of the file backing devices.  Why is that necessarily
   better than being dependent on swap or both, which would increase
   the reclaim efficiency anyway?  You can't avoid being affected by
   the underlying hardware one way or the other.

3. The only thing memsw does is that memsw direct reclaim will only
   consider file backed pages, which I think is more of an accident
   (in an attemp to avoid lower swap setting meaning higher actual
   memory usage) than the intended outcome.  This is obviously
   suboptimal and an implementation detail.  I don't think it's
   something we want to expose to userland as a feature.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
