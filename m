From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 16:16:44 -1000
Message-ID: <ZFMVjAze4tu0DUXs@slm.duckdns.org>
References: <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org>
 <ZFKubD/lq7oB4svV@moria.home.lan>
 <ZFKu6zWA00AzArMF@slm.duckdns.org>
 <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
 <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
 <ZFK6pwOelIlhV8Bm@slm.duckdns.org>
 <CAJuCfpG4TmRpT5iU7bJmKcjW2Tghstdo1b=qEG=tDsmtJQYuWA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683166607; x=1685758607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xki9EImbF8EHplkOG7u13eoQc3pPoVT6i0i48IKNO48=;
        b=AVbZGT9K0r89MqzrSpIR7uMQXdw8u/F4834X6xnRREOGxmDQ4D/A6MjHGUxFG3npis
         aSiP7azLezP1XiGgrGudWR33IUl22a/61L8gQoe/STrWaRoCtDxodSejGGl7LbFwoSoW
         y8er0cowxZ+SiTuo8NZyP0h49wpyK2kMLhUVxrO1AuEfSIV5AQV6s/WtZ233X+EY2wzS
         HnH2l/EQfk2fmkfN3WEcKcwTa+M18CB0b6bZWDe3dFh5+ms0vEqPkw0zF+C7i7OAyOn6
         4mDKRPiK7AP3pPjuxFNw9ey2zSAa4AXCrWoax2bREtiC64a4zO5i43E6Ply2PNr5/uI6
         ybJw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJuCfpG4TmRpT5iU7bJmKcjW2Tghstdo1b=qEG=tDsmtJQYuWA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, vbabka@suse.cz, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

Hello,

On Wed, May 03, 2023 at 01:08:40PM -0700, Suren Baghdasaryan wrote:
> > Yeah, I was wondering whether it'd be useful to have that configurable so
> > that it'd be possible for a user to say "I'm okay with the cost, please
> > track more context per allocation".
> 
> I assume by "more context per allocation" you mean for a specific
> allocation, not for all allocations.
> So, in a sense you are asking if the context capture feature can be
> dropped from this series and implemented using some other means. Is
> that right?

Oh, no, what I meant was whether it'd make sense to allow enable richer
tracking (e.g. record deeper into callstack) for all allocations. For
targeted tracking, it seems that the kernel already has everything needed.
But this is more of an idle thought and the immediate caller tracking is
already a big improvement in terms of visibility, so no need to be hung up
on this part of discussion at all.

Thanks.

-- 
tejun
