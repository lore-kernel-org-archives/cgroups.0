From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 08:24:05 -1000
Message-ID: <ZFKmxVXlk9xkQoPB@slm.duckdns.org>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <ZFKfG7bVuOAk27yP@moria.home.lan>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683138248; x=1685730248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HAaHXuopg20H7kDrY4ngFywwBOIWWtTHOJdh9Kk4ti8=;
        b=aB33hUnZnfHPZlWWtIoWkOnjjHisPYabb6S2uWTBQ8h3onE+k8lH1fwWNrmP3+C2Ae
         V9xYfHUAfa1MQR5bGsnZZI/T3EfAtEbMB7LJgZA6S5DUFfa3NoHlKU045MUvM3dSPcwJ
         O9knvzOZHAicKc7Q1U9prQ5QYBA7iuXytpIxNnq+/0XAMdmK6s/cx66iKx/7bF6fFMVt
         9qvyKftWjNhL52s2yKIZb6lNZsILUvRPIJqsyqINqcoQfODMA3flr2J6lxf4LYnNwpJG
         HZgaEjG650bHbl05TVNvOqMZG18RkP9d2mBdzyVqPL8pMYePQurNMT2j8/2P3LbRKc10
         RP1Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ZFKfG7bVuOAk27yP@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com

Hello,

On Wed, May 03, 2023 at 01:51:23PM -0400, Kent Overstreet wrote:
> Do you have example output?

Not right now. It's from many months ago. It's just a script I could find
easily.

> TBH I'm skeptical that it's even possible to do full memory allocation
> profiling with tracing/bpf, due to recursive memory allocations and
> needing an index of outstanding allcations.

There are some issues e.g. w/ lossy updates which should be fixed from BPF
side but we do run BPF on every single packet and IO on most of our
machines, so basing this argument on whether tracking all memory allocations
from BPF is possible is probably not a winning strategy for this proposal.

Thanks.

-- 
tejun
