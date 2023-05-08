From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Mon, 8 May 2023 17:52:06 +0200
Message-ID: <20230508175206.7dc3f87c@meshulam.tesarici.cz>
References: <20230501165450.15352-1-surenb@google.com>
        <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
        <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
        <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
        <ZFfd99w9vFTftB8D@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683561128; bh=BFn9Tracp9VxaZM60yLgxkOrsr3APEY/DMe++D00LuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jzw6i+az4cd3ysej2exGEA4kISOYgjbh0ENPJCJyWdn/0A10t6Pwyho5Uw7WFybg9
         SXVB1YptnELAS3czSaqsGA3S1Fc4c5saIHHPysqmr9y1rU2b9ljk6jfQ8rlOCkNwim
         cHj4eyMx/pCZRE9brw036NLsIsxchE7n/wjhjOGiw5wl7R2Zyki+tLjWQvstofwtVk
         6fHcDmm+z3+deHDYoIGmgjSNkg7ik8nuHfaQDWnO8HZ09aHNDa2h+YtEFDLlKmYrxk
         sHKw8YWpCbC9atcnvI460v9AD07H/ZnY9enHVTTj1R8M4WAtbTa7GZFPo1ADZKB47X
         GYGs0qHAIF2xw==
In-Reply-To: <ZFfd99w9vFTftB8D@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

On Sun, 7 May 2023 13:20:55 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> On Thu, May 04, 2023 at 11:07:22AM +0200, Michal Hocko wrote:
> > No. I am mostly concerned about the _maintenance_ overhead. For the
> > bare tracking (without profiling and thus stack traces) only those
> > allocations that are directly inlined into the consumer are really
> > of any use. That increases the code impact of the tracing because any
> > relevant allocation location has to go through the micro surgery. 
> > 
> > e.g. is it really interesting to know that there is a likely memory
> > leak in seq_file proper doing and allocation? No as it is the specific
> > implementation using seq_file that is leaking most likely. There are
> > other examples like that See?  
> 
> So this is a rather strange usage of "maintenance overhead" :)
> 
> But it's something we thought of. If we had to plumb around a _RET_IP_
> parameter, or a codetag pointer, it would be a hassle annotating the
> correct callsite.
> 
> Instead, alloc_hooks() wraps a memory allocation function and stashes a
> pointer to a codetag in task_struct for use by the core slub/buddy
> allocator code.
> 
> That means that in your example, to move tracking to a given seq_file
> function, we just:
>  - hook the seq_file function with alloc_hooks

Thank you. That's exactly what I was trying to point out. So you hook
seq_buf_alloc(), just to find out it's called from traverse(), which
is not very helpful either. So, you hook traverse(), which sounds quite
generic. Yes, you're lucky, because it is a static function, and the
identifier is not actually used anywhere else (right now), but each
time you want to hook something, you must make sure it does not
conflict with any other identifier in the kernel...

Petr T
