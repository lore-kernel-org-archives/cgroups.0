From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Sun, 7 May 2023 18:09:11 -0400
Message-ID: <20230507180911.09d328c8@rorschach.local.home>
References: <20230501165450.15352-1-surenb@google.com>
        <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
        <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
        <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
        <ZFfd99w9vFTftB8D@moria.home.lan>
        <20230507165538.3c8331be@rorschach.local.home>
        <ZFgdxR9PlUJYegDp@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <ZFgdxR9PlUJYegDp@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

On Sun, 7 May 2023 17:53:09 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> The underscore is a legitimate complaint - I brought this up in
> development, not sure why it got lost. We'll do something better with a
> consistent suffix, perhaps kmem_cache_alloc_noacct().

Would "_noprofile()" be a better name. I'm not sure what "acct" means.

-- Steve
