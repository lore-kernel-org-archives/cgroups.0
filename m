From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Wed, 3 May 2023 08:50:16 +1000
Message-ID: <20230502225016.GJ2155823@dread.disaster.area>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan>
 <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
 <ZFCA2FF+9MI8LI5i@moria.home.lan>
 <2f5ebe8a9ce8471906a85ef092c1e50cfd7ddecd.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1683067820; x=1685659820;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g8QAkHheKqFpH2L93tPDJOTqznflZZjkS+pV5SBVWTE=;
        b=xLl94DvDD7xAPKjQEHhSkMSzWZfqUaCPIgpsfNNGTJy75L+Dhb0EQkIvsrYT7WWRQx
         wyTlZKx3XfmZ3vSL1O7jem1NnxxZL4//8rtlORY9ztDJ6rOc3Z71E8fNTCdWUkEYu1Vz
         d8ghK4g6nSEpHgoPg3Hqj7HIwKVMcR16Ne5q2xGcmR02ed7wf1kzCrDUXPzOn5N1iaZ/
         zK5AHzXU+6wmWAko7cr8CSaJE81yLtI0Y+Q4gJwMGo5tD1JbUWQilBVdBoOxiucCIdkt
         dMDo0uK0FWEfewBswmsl8vjQdzoc/L8KUeQKJhg/zra8yWKJKKPAHYHINPI83hQKTVFU
         f5XQ==
Content-Disposition: inline
In-Reply-To: <2f5ebe8a9ce8471906a85ef092c1e50cfd7ddecd.camel@HansenPartnership.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.c

On Tue, May 02, 2023 at 07:42:59AM -0400, James Bottomley wrote:
> On Mon, 2023-05-01 at 23:17 -0400, Kent Overstreet wrote:
> > On Mon, May 01, 2023 at 10:22:18PM -0400, James Bottomley wrote:
> > > It is not used just for debug.=A0 It's used all over the kernel for
> > > printing out device sizes.=A0 The output mostly goes to the kernel
> > > print buffer, so it's anyone's guess as to what, if any, tools are
> > > parsing it, but the concern about breaking log parsers seems to be
> > > a valid one.
> >=20
> > Ok, there is sd_print_capacity() - but who in their right mind would
> > be trying to scrape device sizes, in human readable units,
>=20
> If you bother to google "kernel log parser", you'll discover it's quite
> an active area which supports a load of company business models.

That doesn't mean log messages are unchangable ABI. Indeed, we had
the whole "printk_index_emit()" addition recently to create
an external index of printk message formats for such applications to
use. [*]

> >  from log messages when it's available in sysfs/procfs (actually, is
> > it in sysfs? if not, that's an oversight) in more reasonable units?
>=20
> It's not in sysfs, no.  As aren't a lot of things, which is why log
> parsing for system monitoring is big business.

And that big business is why printk_index_emit() exists to allow
them to easily determine how log messages change format and come and
go across different kernel versions.

> > Correct me if I'm wrong, but I've yet to hear about kernel log
> > messages being consider a stable interface, and this seems a bit out
> > there.
>=20
> It might not be listed as stable, but when it's known there's a large
> ecosystem out there consuming it we shouldn't break it just because you
> feel like it.

But we've solved this problem already, yes?

If the userspace applications are not using the kernel printk format
index to detect such changes between kernel version, then they
should be. This makes trivial issues like whether we have a space or
not between units is completely irrelevant because the entry in the
printk format index for the log output we emit will match whatever
is output by the kernel....

Cheers,

Dave.

[*]
commit 337015573718b161891a3473d25f59273f2e626b
Author: Chris Down <chris@chrisdown.name>
Date:   Tue Jun 15 17:52:53 2021 +0100

    printk: Userspace format indexing support
   =20
    We have a number of systems industry-wide that have a subset of their
    functionality that works as follows:
   =20
    1. Receive a message from local kmsg, serial console, or netconsole;
    2. Apply a set of rules to classify the message;
    3. Do something based on this classification (like scheduling a
       remediation for the machine), rinse, and repeat.
   =20
    As a couple of examples of places we have this implemented just inside
    Facebook, although this isn't a Facebook-specific problem, we have this
    inside our netconsole processing (for alarm classification), and as part
    of our machine health checking. We use these messages to determine
    fairly important metrics around production health, and it's important
    that we get them right.
   =20
    While for some kinds of issues we have counters, tracepoints, or metrics
    with a stable interface which can reliably indicate the issue, in order
    to react to production issues quickly we need to work with the interface
    which most kernel developers naturally use when developing: printk.
   =20
    Most production issues come from unexpected phenomena, and as such
    usually the code in question doesn't have easily usable tracepoints or
    other counters available for the specific problem being mitigated. We
    have a number of lines of monitoring defence against problems in
    production (host metrics, process metrics, service metrics, etc), and
    where it's not feasible to reliably monitor at another level, this kind
    of pragmatic netconsole monitoring is essential.
   =20
    As one would expect, monitoring using printk is rather brittle for a
    number of reasons -- most notably that the message might disappear
    entirely in a new version of the kernel, or that the message may change
    in some way that the regex or other classification methods start to
    silently fail.
   =20
    One factor that makes this even harder is that, under normal operation,
    many of these messages are never expected to be hit. For example, there
    may be a rare hardware bug which one wants to detect if it was to ever
    happen again, but its recurrence is not likely or anticipated. This
    precludes using something like checking whether the printk in question
    was printed somewhere fleetwide recently to determine whether the
    message in question is still present or not, since we don't anticipate
    that it should be printed anywhere, but still need to monitor for its
    future presence in the long-term.
   =20
    This class of issue has happened on a number of occasions, causing
    unhealthy machines with hardware issues to remain in production for
    longer than ideal. As a recent example, some monitoring around
    blk_update_request fell out of date and caused semi-broken machines to
    remain in production for longer than would be desirable.
   =20
    Searching through the codebase to find the message is also extremely
    fragile, because many of the messages are further constructed beyond
    their callsite (eg. btrfs_printk and other module-specific wrappers,
    each with their own functionality). Even if they aren't, guessing the
    format and formulation of the underlying message based on the aesthetics
    of the message emitted is not a recipe for success at scale, and our
    previous issues with fleetwide machine health checking demonstrate as
    much.
   =20
    This provides a solution to the issue of silently changed or deleted
    printks: we record pointers to all printk format strings known at
    compile time into a new .printk_index section, both in vmlinux and
    modules. At runtime, this can then be iterated by looking at
    <debugfs>/printk/index/<module>, which emits the following format, both
    readable by humans and able to be parsed by machines:
   =20
        $ head -1 vmlinux; shuf -n 5 vmlinux
        # <level[,flags]> filename:line function "format"
        <5> block/blk-settings.c:661 disk_stack_limits "%s: Warning: Device=
 %s is misaligned\n"
        <4> kernel/trace/trace.c:8296 trace_create_file "Could not create t=
racefs '%s' entry\n"
        <6> arch/x86/kernel/hpet.c:144 _hpet_print_config "hpet: %s(%d):\n"
        <6> init/do_mounts.c:605 prepare_namespace "Waiting for root device=
 %s...\n"
        <6> drivers/acpi/osl.c:1410 acpi_no_auto_serialize_setup "ACPI: aut=
o-serialization disabled\n"
   =20
    This mitigates the majority of cases where we have a highly-specific
    printk which we want to match on, as we can now enumerate and check
    whether the format changed or the printk callsite disappeared entirely
    in userspace. This allows us to catch changes to printks we monitor
    earlier and decide what to do about it before it becomes problematic.
   =20
    There is no additional runtime cost for printk callers or printk itself,
    and the assembly generated is exactly the same.
   =20
    Signed-off-by: Chris Down <chris@chrisdown.name>
    Cc: Petr Mladek <pmladek@suse.com>
    Cc: Jessica Yu <jeyu@kernel.org>
    Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
    Cc: John Ogness <john.ogness@linutronix.de>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Cc: Johannes Weiner <hannes@cmpxchg.org>
    Cc: Kees Cook <keescook@chromium.org>
    Reviewed-by: Petr Mladek <pmladek@suse.com>
    Tested-by: Petr Mladek <pmladek@suse.com>
    Reported-by: kernel test robot <lkp@intel.com>
    Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>
    Acked-by: Jessica Yu <jeyu@kernel.org> # for module.{c,h}
    Signed-off-by: Petr Mladek <pmladek@suse.com>
    Link: https://lore.kernel.org/r/e42070983637ac5e384f17fbdbe86d19c7b212a=
5.1623775748.git.chris@chrisdown.name

--=20
Dave Chinner
david@fromorbit.com
