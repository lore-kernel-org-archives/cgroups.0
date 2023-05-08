From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Mon, 8 May 2023 11:57:10 -0400
Message-ID: <ZFkb1p80vq19rieI@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
 <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
 <ZFfd99w9vFTftB8D@moria.home.lan>
 <20230508175206.7dc3f87c@meshulam.tesarici.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683561443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=647sHPv4B7hFuK57ZzB2dzj7RoLmpQ+nMy5wXGAldL0=;
        b=pAEukJarAZ9zfpJQyxkLYirHPfIniZoUfqNC9brusyZBZ09sv28sxhM4k4em4nlQvaS5Do
        IxU3+yZoRUn8u1GNjUqpuj/xVZafV+nob5RQGwT3otweRNMnXRavTo5ic8BMQRHWe2z5mG
        jLofy7PdFoubJwBsB9N6rzDM0Y35kcU=
Content-Disposition: inline
In-Reply-To: <20230508175206.7dc3f87c@meshulam.tesarici.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Petr =?utf-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

On Mon, May 08, 2023 at 05:52:06PM +0200, Petr Tesařík wrote:
> On Sun, 7 May 2023 13:20:55 -0400
> Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Thu, May 04, 2023 at 11:07:22AM +0200, Michal Hocko wrote:
> > > No. I am mostly concerned about the _maintenance_ overhead. For the
> > > bare tracking (without profiling and thus stack traces) only those
> > > allocations that are directly inlined into the consumer are really
> > > of any use. That increases the code impact of the tracing because any
> > > relevant allocation location has to go through the micro surgery. 
> > > 
> > > e.g. is it really interesting to know that there is a likely memory
> > > leak in seq_file proper doing and allocation? No as it is the specific
> > > implementation using seq_file that is leaking most likely. There are
> > > other examples like that See?  
> > 
> > So this is a rather strange usage of "maintenance overhead" :)
> > 
> > But it's something we thought of. If we had to plumb around a _RET_IP_
> > parameter, or a codetag pointer, it would be a hassle annotating the
> > correct callsite.
> > 
> > Instead, alloc_hooks() wraps a memory allocation function and stashes a
> > pointer to a codetag in task_struct for use by the core slub/buddy
> > allocator code.
> > 
> > That means that in your example, to move tracking to a given seq_file
> > function, we just:
> >  - hook the seq_file function with alloc_hooks
> 
> Thank you. That's exactly what I was trying to point out. So you hook
> seq_buf_alloc(), just to find out it's called from traverse(), which
> is not very helpful either. So, you hook traverse(), which sounds quite
> generic. Yes, you're lucky, because it is a static function, and the
> identifier is not actually used anywhere else (right now), but each
> time you want to hook something, you must make sure it does not
> conflict with any other identifier in the kernel...

Cscope makes quick and easy work of this kind of stuff.
