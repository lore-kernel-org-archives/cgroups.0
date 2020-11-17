From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 RESEND] mm: memcg/slab: Rename *_lruvec_slab_state to
 *_lruvec_kmem_state
Date: Tue, 17 Nov 2020 09:40:04 -0500
Message-ID: <20201117144004.GA1013321@cmpxchg.org>
References: <20201117085249.24319-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7P9jVoxiN2XeeqlFhH6mghYTdw/Tp+4rlAyPEA3z/rg=;
        b=I6S+QcRX2mFpbyQr0vcRNYaflVo4PdeIx1m4jWIMQX7wvqS+/dJDJQ94cx7ztvtC1G
         fKg/FEdlvgdqlcmXo92gL8CneBlksCAkpzRkIyEglPqv3lUMKvx74QAANDNXTTLMxLrQ
         ngmJ+EQStoy17JWl7wfqSIxqjTG0K2IW6bJYceBqPjTpD+bnatsEa9et+oA3GLte2zu0
         V1l1H7HTarRJ4to+xPoHd4A3fgEkBuweP8y19mKgs7CsGfu9mZEdjmiZ/ox53xJDW3Jp
         uXaru4vahuZqdoYUCLSwb3F+kiJAEloUAvvjtkwM81W9izeEf0DIticCoE+CL+HtKMHE
         kFiw==
Content-Disposition: inline
In-Reply-To: <20201117085249.24319-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, laoar.shao@gmail.com, chris@chrisdown.name, christian.brauner@ubuntu.com, mingo@kernel.org, peterz@infradead.org, ebiederm@xmission.com, esyr@redhat.com, tglx@linutronix.de, surenb@google.com, areber@redhat.com, elver@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, Nov 17, 2020 at 04:52:49PM +0800, Muchun Song wrote:
> The *_lruvec_slab_state is also suitable for pages allocated from buddy,
> not just for the slab objects. But the function name seems to tell us that
> only slab object is applicable. So we can rename the keyword of slab to
> kmem.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <guro@fb.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
