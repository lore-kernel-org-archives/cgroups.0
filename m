From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 11:30:40 -0400
Message-ID: <ZFJ+IIugLhEtMXXW@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <20230503115051.30b8a97f@meshulam.tesarici.cz>
 <ZFIv+30UH7+ySCZr@moria.home.lan>
 <20230503122627.594ac4d9@meshulam.tesarici.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683127852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MnOvQ3HLpCXeXA7UeX7M5XmW5B1KmwVPXucVRQ7GRgo=;
        b=Es8fVBNgrQW6sWDHnnMS2DV9FP81dkFs0kCqy4/hnYaFCPtLgojNolKQWB0W2LBZ+qahdA
        tcYehX3zg/vqC7NHUtLuGegcQIVUg7RnAg02PkIubMG0xFKvAJj+DfZMQzi4blTdYEuKUN
        fLVWeotuy1ZDS2PBrOcayo65tc9cJHY=
Content-Disposition: inline
In-Reply-To: <20230503122627.594ac4d9@meshulam.tesarici.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Petr =?utf-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

On Wed, May 03, 2023 at 12:26:27PM +0200, Petr Tesařík wrote:
> On Wed, 3 May 2023 05:57:15 -0400
> Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Wed, May 03, 2023 at 11:50:51AM +0200, Petr Tesařík wrote:
> > > If anyone ever wants to use this code tagging framework for something
> > > else, they will also have to convert relevant functions to macros,
> > > slowly changing the kernel to a minefield where local identifiers,
> > > struct, union and enum tags, field names and labels must avoid name
> > > conflict with a tagged function. For now, I have to remember that
> > > alloc_pages is forbidden, but the list may grow.  
> > 
> > Also, since you're not actually a kernel contributor yet...
> 
> I see, I've been around only since 2007...
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2a97468024fb5b6eccee2a67a7796485c829343a

My sincere apologies :) I'd searched for your name and email and found
nothing, whoops.
