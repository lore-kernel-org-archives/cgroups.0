From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 09:09:37 -1000
Message-ID: <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
References: <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org>
 <ZFKubD/lq7oB4svV@moria.home.lan>
 <ZFKu6zWA00AzArMF@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683140980; x=1685732980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m2prCTdjzaiRiaqQtudLpWKutHCUVL/OSWsxsk3W0H0=;
        b=DgGf/RDPAqWGHut8/ffMPgzzhFJ9XYYSPgLBeni/aHHvM33hoTyZ2z1/iWZrJfEq83
         XC8cOYLwo2w4awuIxnl0cMADE/m0XmY+wPpkMbjZhRe/h0OTU4R7JHORw6cp3ebvPJPs
         fVMtj4scXOewOp4pOg6Y+bLDbTCONtNkC6uKe3XQm4/tjkELGZ7bx+BlGycvwgcMZTg3
         diw26d57mAXbzMIEL2R9owFYzXiYqv54fGxd86cbz1pWBKa8UI2AhEJ1f1/yiknBF/PK
         kJgW8kCwMV9OQVIdn/sPBvqc9vOmLsLdyI/c/vfOx43vpU0ufO13PA0zEYN9tJjBA8qt
         Rc3Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ZFKu6zWA00AzArMF@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.c

On Wed, May 03, 2023 at 08:58:51AM -1000, Tejun Heo wrote:
> On Wed, May 03, 2023 at 02:56:44PM -0400, Kent Overstreet wrote:
> > On Wed, May 03, 2023 at 08:40:07AM -1000, Tejun Heo wrote:
> > > > Yeah, easy / default visibility argument does make sense to me.
> > > 
> > > So, a bit of addition here. If this is the thrust, the debugfs part seems
> > > rather redundant, right? That's trivially obtainable with tracing / bpf and
> > > in a more flexible and performant manner. Also, are we happy with recording
> > > just single depth for persistent tracking?
> > 
> > Not sure what you're envisioning?
> > 
> > I'd consider the debugfs interface pretty integral; it's much more
> > discoverable for users, and it's hardly any code out of the whole
> > patchset.
> 
> You can do the same thing with a bpftrace one liner tho. That's rather
> difficult to beat.

Ah, shit, I'm an idiot. Sorry. I thought allocations was under /proc and
allocations.ctx under debugfs. I meant allocations.ctx is redundant.

Thanks.

-- 
tejun
