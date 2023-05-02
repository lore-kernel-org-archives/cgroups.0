From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Tue, 02 May 2023 07:42:59 -0400
Message-ID: <2f5ebe8a9ce8471906a85ef092c1e50cfd7ddecd.camel@HansenPartnership.com>
References: <20230501165450.15352-1-surenb@google.com>
         <20230501165450.15352-2-surenb@google.com>
         <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
         <ZFAUj+Q+hP7cWs4w@moria.home.lan>
         <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
         <ZFCA2FF+9MI8LI5i@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1683027787;
        bh=VIXlwaAodrWp8Vhxz+WDa3KoUpXUVVhKJac+yTw3JPY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Jhl+sztrOwEDjtwmne5HQU6aXLKSFxkGsV+GqvMXCULQnVptmMOy46lcJn8TJD2nV
         Cz4FiICRD0fpyV2EVDrJ/+oCA0F64UjfFbcIL0QFb5f/iutLKwDLAAC08nsVf2C0sW
         PW2yXp5dIH6OPPlm4jB3q1u314n26v1FRt3YM0EM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1683027787;
        bh=VIXlwaAodrWp8Vhxz+WDa3KoUpXUVVhKJac+yTw3JPY=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Jhl+sztrOwEDjtwmne5HQU6aXLKSFxkGsV+GqvMXCULQnVptmMOy46lcJn8TJD2nV
         Cz4FiICRD0fpyV2EVDrJ/+oCA0F64UjfFbcIL0QFb5f/iutLKwDLAAC08nsVf2C0sW
         PW2yXp5dIH6OPPlm4jB3q1u314n26v1FRt3YM0EM=
In-Reply-To: <ZFCA2FF+9MI8LI5i@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, k

On Mon, 2023-05-01 at 23:17 -0400, Kent Overstreet wrote:
> On Mon, May 01, 2023 at 10:22:18PM -0400, James Bottomley wrote:
> > It is not used just for debug.  It's used all over the kernel for
> > printing out device sizes.  The output mostly goes to the kernel
> > print buffer, so it's anyone's guess as to what, if any, tools are
> > parsing it, but the concern about breaking log parsers seems to be
> > a valid one.
> 
> Ok, there is sd_print_capacity() - but who in their right mind would
> be trying to scrape device sizes, in human readable units,

If you bother to google "kernel log parser", you'll discover it's quite
an active area which supports a load of company business models.

>  from log messages when it's available in sysfs/procfs (actually, is
> it in sysfs? if not, that's an oversight) in more reasonable units?

It's not in sysfs, no.  As aren't a lot of things, which is why log
parsing for system monitoring is big business.

> Correct me if I'm wrong, but I've yet to hear about kernel log
> messages being consider a stable interface, and this seems a bit out
> there.

It might not be listed as stable, but when it's known there's a large
ecosystem out there consuming it we shouldn't break it just because you
feel like it.  You should have a good reason and the break should be
unavoidable.  I wanted my output in a particular form so I thought I'd
change everyone else's output as well isn't a good reason and it only
costs a couple of lines to avoid.

> But, you did write the code :)
> 
> > > If someone raises a specific objection we'll do something
> > > different, otherwise I think standardizing on what userspace
> > > tooling already parses is a good idea.
> > 
> > If you want to omit the space, why not simply add your own
> > variant?  A string_get_size_nospace() which would use most of the
> > body of this one as a helper function but give its own snprintf
> > format string at the end.  It's only a couple of lines longer as a
> > patch and has the bonus that it definitely wouldn't break anything
> > by altering an existing output.
> 
> I'm happy to do that - I just wanted to post this version first to
> see if we can avoid the fragmentation and do a bit of standardizing
> with how everything else seems to do that.

What fragmentation?  To do this properly you move the whole of the
current function to a helper which takes a format sting, say with a
double underscore prefix, then the existing function and what you want
become one line additions calling the helper with their specific format
string.  There's no fragmentation of the base function at all.

James


