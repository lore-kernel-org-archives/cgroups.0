From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 03 May 2023 08:33:48 -0400
Message-ID: <25a1ea786712df5111d7d1db42490624ac63651e.camel@HansenPartnership.com>
References: <20230501165450.15352-1-surenb@google.com>
         <ZFIMaflxeHS3uR/A@dhcp22.suse.cz> <ZFIOfb6/jHwLqg6M@moria.home.lan>
         <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
         <20230503115051.30b8a97f@meshulam.tesarici.cz>
         <ZFIv+30UH7+ySCZr@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1683117236;
        bh=ouniWm3kSvheJ5FVfsQv5nBr8bj1HWMP2KRRhetgh0w=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=tBkpGMeHZlzQT7xcRfhegUu+wRFRMNYKk6KHQH9rVVXBpIbjN/8+o1xoQ19Hqpohg
         OkNzp5X7Gz8O9ULzqmlhb2B/3qykYYJsyqEUw/puHJIAqQho1Um/vUhig69kw9pE34
         3VJbCcqjcs3yhCW9eIwUZKzOzdLAc5JMGM1fjNZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1683117236;
        bh=ouniWm3kSvheJ5FVfsQv5nBr8bj1HWMP2KRRhetgh0w=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=tBkpGMeHZlzQT7xcRfhegUu+wRFRMNYKk6KHQH9rVVXBpIbjN/8+o1xoQ19Hqpohg
         OkNzp5X7Gz8O9ULzqmlhb2B/3qykYYJsyqEUw/puHJIAqQho1Um/vUhig69kw9pE34
         3VJbCcqjcs3yhCW9eIwUZKzOzdLAc5JMGM1fjNZI=
In-Reply-To: <ZFIv+30UH7+ySCZr@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet@linux.dev>, Petr =?UTF-8?Q?Tesa=C5=99=C3=ADk?= <petr@tesarici.cz>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

On Wed, 2023-05-03 at 05:57 -0400, Kent Overstreet wrote:
> On Wed, May 03, 2023 at 11:50:51AM +0200, Petr Tesařík wrote:
> > If anyone ever wants to use this code tagging framework for
> > something
> > else, they will also have to convert relevant functions to macros,
> > slowly changing the kernel to a minefield where local identifiers,
> > struct, union and enum tags, field names and labels must avoid name
> > conflict with a tagged function. For now, I have to remember that
> > alloc_pages is forbidden, but the list may grow.
> 
> Also, since you're not actually a kernel contributor yet...

You have an amazing talent for being wrong.  But even if you were
actually right about this, it would be an ad hominem personal attack on
a new contributor which crosses the line into unacceptable behaviour on
the list and runs counter to our code of conduct.

James

