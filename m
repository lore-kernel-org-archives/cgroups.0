From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 14:03:37 -0400
Message-ID: <20230503140337.0f7127b2@gandalf.local.home>
References: <20230501165450.15352-1-surenb@google.com>
        <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
        <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
        <20230503122839.0d9934c5@gandalf.local.home>
        <CAJuCfpFYq7CZS4y2ZiF+AJHRKwnyhmZCk_uuTwFse26DxGh-qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAJuCfpFYq7CZS4y2ZiF+AJHRKwnyhmZCk_uuTwFse26DxGh-qQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, an

On Wed, 3 May 2023 10:40:42 -0700
Suren Baghdasaryan <surenb@google.com> wrote:

> > This approach is actually quite common, especially since tagging every
> > instance is usually overkill, as if you trace function calls in a running
> > kernel, you will find that only a small percentage of the kernel ever
> > executes. It's possible that you will be allocating a lot of tags that will
> > never be used. If run time allocation is possible, that is usually the
> > better approach.  
> 
> True but the memory overhead should not be prohibitive here. As a
> ballpark number, on my machine I see there are 4838 individual
> allocation locations and each codetag structure is 32 bytes, so that's
> 152KB.

If it's not that big, then allocating at runtime should not be an issue
either. If runtime allocation can make it less intrusive to the code, that
would be more rationale to do so.

-- Steve
