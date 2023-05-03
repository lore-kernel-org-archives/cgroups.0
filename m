From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 03 May 2023 11:49:23 -0400
Message-ID: <d01388d01b93071ac9ad04452ff4ff29d85e90f1.camel@HansenPartnership.com>
References: <20230501165450.15352-1-surenb@google.com>
         <ZFIMaflxeHS3uR/A@dhcp22.suse.cz> <ZFIOfb6/jHwLqg6M@moria.home.lan>
         <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
         <20230503115051.30b8a97f@meshulam.tesarici.cz>
         <ZFIv+30UH7+ySCZr@moria.home.lan>
         <25a1ea786712df5111d7d1db42490624ac63651e.camel@HansenPartnership.com>
         <ZFJ9hlQ3ZIU1XYCY@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1683128971;
        bh=aZHv4qLewpPoN2a7Dp1hmQ518n6knm526HL7tro2+QQ=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=RuzgPwW7Excw6pez9bbQH1LgK0+PrOgDucE8mX352a/WgEFXdVcyXswKLkwHVN4FK
         NRRB6IArfDLzoJ2Y5xkv3PNA1E6ef4irPxZ/JjdOQrfSM2D4MyBH3rpgG/WnwCUFYL
         KRr071rSZhNhJKS7IDpjG6MPN5NNicYHXLH+D7mM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1683128970;
        bh=aZHv4qLewpPoN2a7Dp1hmQ518n6knm526HL7tro2+QQ=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=q0tL2VdkMVextXF7i8wLij4wc+Rv8eXjweyKXiHti73zJxCRaSCu25jteEhbnxI6v
         yK9rK8oceeU4P+nNqywZMzxEdAYo1SWnGfe4NiTdtA5ocsYJMypoTDNv+p+Qwjz8wz
         oLVM+AAJEgGOGX5BoVd44tXyBl3Vu996X/awzutg=
In-Reply-To: <ZFJ9hlQ3ZIU1XYCY@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Petr =?UTF-8?Q?Tesa=C5=99=C3=ADk?= <petr@tesarici.cz>, Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryah

On Wed, 2023-05-03 at 11:28 -0400, Kent Overstreet wrote:
> On Wed, May 03, 2023 at 08:33:48AM -0400, James Bottomley wrote:
> > On Wed, 2023-05-03 at 05:57 -0400, Kent Overstreet wrote:
> > > On Wed, May 03, 2023 at 11:50:51AM +0200, Petr Tesařík wrote:
> > > > If anyone ever wants to use this code tagging framework for
> > > > something else, they will also have to convert relevant
> > > > functions to macros, slowly changing the kernel to a minefield
> > > > where local identifiers, struct, union and enum tags, field
> > > > names and labels must avoid name conflict with a tagged
> > > > function. For now, I have to remember that alloc_pages is
> > > > forbidden, but the list may grow.
> > > 
> > > Also, since you're not actually a kernel contributor yet...
> > 
> > You have an amazing talent for being wrong.  But even if you were
> > actually right about this, it would be an ad hominem personal
> > attack on a new contributor which crosses the line into
> > unacceptable behaviour on the list and runs counter to our code of
> > conduct.
> 
> ...Err, what? That was intended _in no way_ as a personal attack.

Your reply went on to say "If you're going to comment, please do the
necessary work to make sure you're saying something that makes sense."
That is a personal attack belittling the person involved and holding
them up for general contempt on the mailing list.  This is exactly how
we should *not* treat newcomers.

> If I was mistaken I do apologize, but lately I've run across quite a
> lot of people offering review feedback to patches I post that turn
> out to have 0 or 10 patches in the kernel, and - to be blunt - a
> pattern of offering feedback in strong language with a presumption of
> experience that takes a lot to respond to adequately on a technical
> basis.

A synopsis of the feedback is that using macros to attach trace tags
pollutes the global function namespace of the kernel.  That's a valid
observation and merits a technical not a personal response.

James

