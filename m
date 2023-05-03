From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 14:56:44 -0400
Message-ID: <ZFKubD/lq7oB4svV@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683140217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kvDb7bxJfzE9KfjpQKTTQijQZOsAXNXH2iadfpJ44Yc=;
        b=h1g4T3QhYib2nBdpUAXTn+2qQD9ejDw6IFQM/FKbwPTcpONEOGJug9IN/JkcPzWXJb7WMP
        26usKy4n6B80sjCITIgILHgS1JbDUF0CHEgjPjZCLkcCdcNgTyG39f1X0AAT4O4tYbSzBt
        CqImMwnUyz+b+HgDx7XUNM9L7g1vdag=
Content-Disposition: inline
In-Reply-To: <ZFKqh5Dh93UULdse@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.c

On Wed, May 03, 2023 at 08:40:07AM -1000, Tejun Heo wrote:
> > Yeah, easy / default visibility argument does make sense to me.
> 
> So, a bit of addition here. If this is the thrust, the debugfs part seems
> rather redundant, right? That's trivially obtainable with tracing / bpf and
> in a more flexible and performant manner. Also, are we happy with recording
> just single depth for persistent tracking?

Not sure what you're envisioning?

I'd consider the debugfs interface pretty integral; it's much more
discoverable for users, and it's hardly any code out of the whole
patchset.

Single depth was discussed previously. It's what makes it cheap enough
to be always-on (saving stack traces is expensive!), and I find the
output much more usable than e.g. page owner.
