From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 14:12:52 -0400
Message-ID: <ZFKkJJ8+/uD0tPMM@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
 <20230503122839.0d9934c5@gandalf.local.home>
 <CAJuCfpFYq7CZS4y2ZiF+AJHRKwnyhmZCk_uuTwFse26DxGh-qQ@mail.gmail.com>
 <20230503140337.0f7127b2@gandalf.local.home>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683137583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bFNCoxPB6ZGjmPXwS7aActt9s9ZGw8uNq57D7UKDjKM=;
        b=siD6JyeicdLYm9Q2yXmRLr5ySGXSB2lV1k50m3UiM0GKRXv1RttykEM7dYP8xs5X197IgJ
        jBtAc6ZM4L3Wd+zT4HheIwdrdCZIcmEPDStAu9bPcBItsW2S45BekRwud2QX4sDZVSICcP
        fDDddqmELDDTv0N0zR7Bb5BfCgDoj40=
Content-Disposition: inline
In-Reply-To: <20230503140337.0f7127b2@gandalf.local.home>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@g

On Wed, May 03, 2023 at 02:03:37PM -0400, Steven Rostedt wrote:
> On Wed, 3 May 2023 10:40:42 -0700
> Suren Baghdasaryan <surenb@google.com> wrote:
> 
> > > This approach is actually quite common, especially since tagging every
> > > instance is usually overkill, as if you trace function calls in a running
> > > kernel, you will find that only a small percentage of the kernel ever
> > > executes. It's possible that you will be allocating a lot of tags that will
> > > never be used. If run time allocation is possible, that is usually the
> > > better approach.  
> > 
> > True but the memory overhead should not be prohibitive here. As a
> > ballpark number, on my machine I see there are 4838 individual
> > allocation locations and each codetag structure is 32 bytes, so that's
> > 152KB.
> 
> If it's not that big, then allocating at runtime should not be an issue
> either. If runtime allocation can make it less intrusive to the code, that
> would be more rationale to do so.

We're more optimizing for runtime overhead - a major goal of this
patchset was to be cheap enough to be always on, we've got too many
debugging features that are really useful, but too expensive to have on
all the time.

Doing more runtime allocation would add another pointer fetch to the
fast paths - and I don't see how it would even be possible to runtime
allocate the codetag struct itself.

We already do runtime allocation of percpu counters; see the lazy percpu
counter patch.
