From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 08:06:10 -1000
Message-ID: <ZFKikp0Poqen1kNv@slm.duckdns.org>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <CAJuCfpEFV7ZB4pvnf6n0bVpTCDWCVQup9PtrHuAayrf3GrQskg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683137173; x=1685729173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4cv7r3p/uGjVZzfVGJD3+oUJmj97nEyjDPWByIKN3z4=;
        b=kBIOUh53OZR1fn3Tl9vhMiJMS2FInFLP+lUhlPMor7jTDMLunrtCSmTdzMWMH2FwCJ
         YVGqfGBLCcFxyEZqWGvgdtkqh7q9mW9TITc2zQ1MEl9Z4dyRAIRBQgQ/GqXqe64yJJJD
         jtv1N2E+Q8wb/Xz4JW2RS+0z2DdUghhXRvmD4NcDBMi7YahwOEPgg0vNKS60VKG0vC0s
         rVXB8P21/jbXTCpjmQQRTHqlVfjdnNcak2Qa/aW6mlFKobaN4n+shXYE6Y3F+F5hgEAG
         f9bKyMjVy+ACvR4cf5kNhW2+TZwy4NkBNj9YXF9ja+6/87G38J+6YdFn2/3Ki55ZW1Z2
         6s2A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJuCfpEFV7ZB4pvnf6n0bVpTCDWCVQup9PtrHuAayrf3GrQskg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com

Hello, Suren.

On Wed, May 03, 2023 at 10:42:11AM -0700, Suren Baghdasaryan wrote:
> > * The framework doesn't really have any runtime overhead, so we can have it
> >   deployed in the entire fleet and debug wherever problem is.
> 
> Do you mean it has no runtime overhead when disabled?

Yes, that's what I meant.

> If so, do you know what's the overhead when enabled? I want to
> understand if that's truly a viable solution to track all allocations
> (including slab) all the time.

(cc'ing Alexei and Andrii who know a lot better than me)

I don't have enough concrete benchmark data on the hand to answer
definitively but hopefully what my general impresison would help. We attach
BPF programs to both per-packet and per-IO paths. They obviously aren't free
but their overhead isn't signficantly higher than building in the same thing
in C code. Once loaded, BPF progs are jit compiled into native code. The
generated code will be a bit worse than regularly compiled C code but those
are really micro differences. There's some bridging code to jump into BPF
but again negligible / acceptable even in the hottest paths.

In terms of execution overhead, I don't think there is a signficant
disadvantage to doing these things in BPF. Bigger differences would likely
be in tracking data structures and locking around them. One can definitely
better integrate tracking into alloc / free paths piggybacking on existing
locking and whatnot. That said, BPF hashtable is pretty fast and BPF is
constantly improving in terms of data structure support.

It really depends on the workload and how much overhead one considers
acceptable and I'm sure persistent global tracking can be done more
efficiently with built-in C code. That said, done right, the overhead
difference most likely isn't gonna be orders of magnitude but more like in
the realm of tens of percents, if that.

So, it doesn't nullify the benefits a dedicated mechansim can bring but does
change the conversation quite a bit. Is the extra code justifiable given
that most of what it enables is already possible using a more generic
mechanism, albeit at a bit higher cost? That may well be the case but it
does raise the bar.

Thanks.

-- 
tejun
