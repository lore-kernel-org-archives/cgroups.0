From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 10:00:28 -1000
Message-ID: <ZFK9XMSzOBxIFOHm@slm.duckdns.org>
References: <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org>
 <ZFKubD/lq7oB4svV@moria.home.lan>
 <ZFKu6zWA00AzArMF@slm.duckdns.org>
 <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
 <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
 <ZFK6pwOelIlhV8Bm@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683144030; x=1685736030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0HV83qXSxt0rJsxUhYqPsLXk4a5FBTNhGHWC84tLfFA=;
        b=T5ytdzQZFR/i6X3PRt8GPpsG1Y8I62q5m+7bcocFY5Cvsi6WjKKciTo/qMildNoBZe
         u85rUJbf90oBHRO2tw11PhVl1/2+PBLQR5fvlp3hzuHC/CfV94InI4lPsLH/RfX1qbI8
         ausoXPd6AA+d24SrubrUATq5ZGbTkNJHhzAmb4/I8cKntvdRB5ITs5umOnT9xtLYVW6J
         XelWqPKoBht+a4RuNCfbFoX3W+hTDToV7mxgM9rNIWkoPMCAeRQG8Dr+8MzArcAuR1Md
         bQM+fnzNC44jQ5pJFy8Oos8cJXJygO15rVG3lH4kT1O7gkNi5v7N3Otc1cZyartcRwPg
         eT9A==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ZFK6pwOelIlhV8Bm@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, vbabka@suse.cz, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

Hello,

On Wed, May 03, 2023 at 09:48:55AM -1000, Tejun Heo wrote:
> > If so, that's the idea behind the context capture feature so that we
> > can enable it on specific allocations only after we determine there is
> > something interesting there. So, with low-cost persistent tracking we
> > can determine the suspects and then pay some more to investigate those
> > suspects in more detail.
> 
> Yeah, I was wondering whether it'd be useful to have that configurable so
> that it'd be possible for a user to say "I'm okay with the cost, please
> track more context per allocation". Given that tracking the immediate caller
> is already a huge improvement and narrowing it down from there using
> existing tools shouldn't be that difficult, I don't think this is a blocker
> in any way. It just bothers me a bit that the code is structured so that
> source line is the main abstraction.

Another related question. So, the reason for macro'ing stuff is needed is
because you want to print the line directly from kernel, right? Is that
really necessary? Values from __builtin_return_address() can easily be
printed out as function+offset from kernel which already gives most of the
necessary information for triaging and mapping that back to source line from
userspace isn't difficult. Wouldn't using __builtin_return_address() make
the whole thing a lot simpler?

Thanks.

-- 
tejun
