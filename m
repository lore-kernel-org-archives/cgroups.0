From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH 34/40] lib: code tagging context capture support
Date: Wed, 3 May 2023 08:26:40 -0700
Message-ID: <b8ab89e6-0456-969d-ed31-fa64be0a0fd0@intel.com>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-35-surenb@google.com> <ZFIO3tXCbmTn53uv@dhcp22.suse.cz>
 <CAJuCfpHrZ4kWYFPvA3W9J+CmNMuOtGa_ZMXE9fOmKsPQeNt2tg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683127605; x=1714663605;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JW32feYIw7XcNCp0X+HS3CFsBn68Px3L2hSYcXUbWmk=;
  b=PT6Tf3+ASWtq19/6hMEa+jPQ0ZVD0jARTYMjwUKenjA7A/kU7l6vFLZE
   9t53840o7oJXHlK4Ut64rUdq/LFDOaR1NG4yvaXryaV7MfnoUb7CkUbKp
   NCn6LNbt6HG3fR+Nt9YzZiNe4rwxx0KffSFgAwzgc4wshHmr0EDuuMNvI
   XM8jPeWbslJBLoHwPxmiV8sqV0CumCWvZCKV43eBEmaOy4f9vaVYSLGx1
   XuPtZf8AXWtK2Nb1+EqLqSbVcQfHtdh6rrGRHPHIg2lbvZlrgf1tWAW/O
   Mf/23L+lao3oyVGzsIwRiUOtCJpkpio9tUIp99X6lo8fJKwFhyX7dWPRb
   g==;
Content-Language: en-US
In-Reply-To: <CAJuCfpHrZ4kWYFPvA3W9J+CmNMuOtGa_ZMXE9fOmKsPQeNt2tg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On 5/3/23 08:18, Suren Baghdasaryan wrote:
>>> +static inline void rem_ctx(struct codetag_ctx *ctx,
>>> +                        void (*free_ctx)(struct kref *refcount))
>>> +{
>>> +     struct codetag_with_ctx *ctc = ctx->ctc;
>>> +
>>> +     spin_lock(&ctc->ctx_lock);
>> This could deadlock when allocator is called from the IRQ context.
> I see. spin_lock_irqsave() then?

Yes.  But, even better, please turn on lockdep when you are testing.  It
will find these for you.  If you're on x86, we have a set of handy-dandy
debug options that you can add to an existing config with:

	make x86_debug.config

That said, I'm as concerned as everyone else that this is all "new" code
and doesn't lean on existing tracing or things like PAGE_OWNER enough.
