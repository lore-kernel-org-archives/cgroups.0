From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 35/40] lib: implement context capture support for tagged
 allocations
Date: Fri, 5 May 2023 10:40:19 +0200
Message-ID: <ZFTA8xVzxWc345Ug@dhcp22.suse.cz>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-36-surenb@google.com>
 <ZFIPmnrSIdJ5yusM@dhcp22.suse.cz>
 <CAJuCfpGsvWupMbasqvwcMYsOOPxTQqi1ed5+=vyu-yoPQwwybg@mail.gmail.com>
 <ZFNoVfb+1W4NAh74@dhcp22.suse.cz>
 <CAJuCfpGUtw6cbjLsksGJKATZfTV0FEYRXwXT0pZV83XqQydBgg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683276019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/0NvfINDngaX81zK/8XuAzfIOyZoSgVhu9auLhp95+8=;
        b=N7Hh14VsXyzhdip98WZKHL6vi++Ot45f7xe1XG1LXAkD8DEJNNJwpr4HSGIxEz/MZq1bfG
        KUwErWXXaSTBD69btoSMDYsSKukSj3gDTrJzJv4JPQtavr86N6hSjezAAulivmJwR+mrLN
        xGzDPAbAKNp+pIZ7BzXA3dFlbRMDVYo=
Content-Disposition: inline
In-Reply-To: <CAJuCfpGUtw6cbjLsksGJKATZfTV0FEYRXwXT0pZV83XqQydBgg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On Thu 04-05-23 09:22:07, Suren Baghdasaryan wrote:
[...]
> > But even then I really detest an additional allocation from this context
> > for every single allocation request. There GFP_NOWAIT allocation for
> > steckdepot but that is at least cached and generally not allocating.
> > This will allocate for every single allocation.
> 
> A small correction here. alloc_tag_create_ctx() is used only for
> allocations which we requested to capture the context. So, this last
> sentence is true for allocations we specifically marked to capture the
> context, not in general.

Ohh, right. I have misunderstood that part. Slightly better, still
potentially a scalability issue because hard to debug memory leaks
usually use a generic caches (for kmalloc). So this might be still a lot
of objects to track.

> > There must be a better way.
> 
> Yeah, agree, it would be good to avoid allocations in this path. Any
> specific ideas on how to improve this? Pooling/caching perhaps? I
> think kmem_cache does some of that already but maybe something else?

The best I can come up with is a preallocated hash table to store
references to stack depots with some additional data associated. The
memory overhead could be still quite big but the hash tables could be
resized lazily.
-- 
Michal Hocko
SUSE Labs
