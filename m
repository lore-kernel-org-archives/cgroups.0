From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 09:21:28 -0400
Message-ID: <20230503092128.1a120845@gandalf.local.home>
References: <20230501165450.15352-1-surenb@google.com>
        <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
        <ZFIOfb6/jHwLqg6M@moria.home.lan>
        <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
        <ZFIVtB8JyKk0ddA5@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <ZFIVtB8JyKk0ddA5@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

On Wed, 3 May 2023 04:05:08 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> > The burden is on you and Suren. You are proposing the implement an
> > alternative tracing infrastructure.  
> 
> No, we're still waiting on the tracing people to _demonstrate_, not
> claim, that this is at all possible in a comparable way with tracing. 

It's not my job to do your work for you!

I gave you hints on how you can do this with attaching to existing trace
events and your response was "If you don't think it's hard, go ahead and
show us." No! I'm too busy with my own work to do free work for you!

https://lore.kernel.org/all/20220905235007.sc4uk6illlog62fl@kmo-framework/

I know it's easier to create something from scratch that you fully know,
than to work with an existing infrastructure that you need to spend effort
and learn to make it do what you want. But by recreating the work, you now
pass the burden onto everyone else that needs to learn what you did. Not to
mention, we would likely have multiple ways to do the same thing.

Sorry, but that's not how an open source community is suppose to work.

-- Steve
