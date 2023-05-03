From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 16:37:36 +0100
Message-ID: <f57b77b0-74da-41a3-a3bc-969ded4e0410@lucifer.local>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <20230503115051.30b8a97f@meshulam.tesarici.cz>
 <ZFIv+30UH7+ySCZr@moria.home.lan>
 <25a1ea786712df5111d7d1db42490624ac63651e.camel@HansenPartnership.com>
 <ZFJ9hlQ3ZIU1XYCY@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683128258; x=1685720258;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5JJFuEPTE4BVU5/m4SDNq/0rwYCFngwHyNb8+sMGpbk=;
        b=f1ldkmb3XFaeE9giB5HgYpoxWExCQUXmfJ4wPY5lgSi5xTmbfBbONoep0z2W98W7Wt
         /V12EC2x93BkTv2q6xbvQ5zU+Qj35ndmiPtJoysgGPxWqIFgPDklGDxZY0MFJXHqzU2U
         V2xuyKyNq4q4r33oeksriXiB9EltdqXuI7t6CBkmVMxFAVk+5DZUTgEeuHOF8vdiYANJ
         CRBTNnFN6Q7laO5i1m5aBAuVRqvOb9ukpBUnG9MLtiPrq5D66aiqS1DbvznoNo4BfjZg
         U4AWHBJkmfkvfjVN3kAvMFidmy7t8a1i7JhTxDZ6WGETZCPlC/7CYZHOWGJC4EFs80nc
         3NfQ==
Content-Disposition: inline
In-Reply-To: <ZFJ9hlQ3ZIU1XYCY@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Petr =?utf-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>, Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, pa

On Wed, May 03, 2023 at 11:28:06AM -0400, Kent Overstreet wrote:
> On Wed, May 03, 2023 at 08:33:48AM -0400, James Bottomley wrote:
> > On Wed, 2023-05-03 at 05:57 -0400, Kent Overstreet wrote:
> > > On Wed, May 03, 2023 at 11:50:51AM +0200, Petr Tesařík wrote:
> > > > If anyone ever wants to use this code tagging framework for
> > > > something
> > > > else, they will also have to convert relevant functions to macros,
> > > > slowly changing the kernel to a minefield where local identifiers,
> > > > struct, union and enum tags, field names and labels must avoid name
> > > > conflict with a tagged function. For now, I have to remember that
> > > > alloc_pages is forbidden, but the list may grow.
> > >
> > > Also, since you're not actually a kernel contributor yet...
> >
> > You have an amazing talent for being wrong.  But even if you were
> > actually right about this, it would be an ad hominem personal attack on
> > a new contributor which crosses the line into unacceptable behaviour on
> > the list and runs counter to our code of conduct.
>
> ...Err, what? That was intended _in no way_ as a personal attack.
>

As an outside observer, I can assure you that absolutely came across as a
personal attack, and the precise kind that puts people off from
contributing. I should know as a hobbyist contributor myself.

> If I was mistaken I do apologize, but lately I've run across quite a lot
> of people offering review feedback to patches I post that turn out to
> have 0 or 10 patches in the kernel, and - to be blunt - a pattern of
> offering feedback in strong language with a presumption of experience
> that takes a lot to respond to adequately on a technical basis.
>

I, who may very well not merit being considered a contributor of
significant merit in your view, have had such 'drive-by' commentary on some
of my patches by precisely this type of person, and at no time felt the
need to question whether they were a true Scotsman or not. It's simply not
productive.

> I don't think a suggestion to spend a bit more time reading code instead
> of speculating is out of order! We could all, put more effort into how
> we offer review feedback.

It's the means by which you say it that counts for everything. If you feel
the technical comments might not be merited on a deeper level, perhaps ask
a broader question, or even don't respond at all? There are other means
available.

It's remarkable the impact comments like the one you made can have on
contributors, certainly those of us who are not maintainers and are
naturally plagued with imposter syndrome, so I would ask you on a human
level to try to be a little more considerate.

By all means address technical issues as robustly as you feel appropriate,
that is after all the purpose of code review, but just take a step back and
perhaps find the 'cuddlier' side of yourself when not addressing technical
things :)
