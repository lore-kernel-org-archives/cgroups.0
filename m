From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 14/15] kernel: convert futex_pi_state.refcount from
 atomic_t to refcount_t
Date: Tue, 18 Jul 2017 09:39:27 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B6FF26A5A@IRSMSX102.ger.corp.intel.com>
References: <1500288206-12074-1-git-send-email-elena.reshetova@intel.com>
 <1500288206-12074-15-git-send-email-elena.reshetova@intel.com>
 <alpine.DEB.2.20.1707171607050.2185@nanos>
 <2236FBA76BA1254E88B949DDB74E612B6FF265B9@IRSMSX102.ger.corp.intel.com>
 <alpine.DEB.2.20.1707171938070.2185@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1707171938070.2185@nanos>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-audit@redhat.com" <linux-audit@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "tj@kernel.org" <tj@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "acme@kernel.org" <acme@kernel.org>, "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, "eparis@redhat.com" <eparis@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, arnd@ar

> On Mon, 17 Jul 2017, Reshetova, Elena wrote:
> > > On Mon, 17 Jul 2017, Elena Reshetova wrote:
> > > > refcount_t type and corresponding API should be
> > > > used instead of atomic_t when the variable is used as
> > > > a reference counter. This allows to avoid accidental
> > > > refcounter overflows that might lead to use-after-free
> > > > situations.
> > >
> > > Copying the same sentence over and over avoids thinking about a proper
> > > changelog, right? You fail to explain, how you come to the conclusion that
> > > futex_pi_state.refcount is a pure reference counter (aside of the name) and
> > > therefor can be safely converted to refcount_t.
> 
> > OK, this is not very useful for many cases. Yes, I am using automated log
> > on these patches, because I used to have 240 of them and writing manual
> > logs for them would be fun.
> 
> Been there, done that.
> 
> > Moreover, in many cases, writing manual logs don't bring any value since
> > I would have to repeat the same things all over again: xyz conversions
> > was found by using *.cocci pattern first, then looked at manually and it
> > looked like a standard reference counter that frees the things after
> > calling refcount_dec_and_test() (or its variation with lock which is
> > rare).  Other things also looked correct, like I didn't see increments
> > from zero, counter starts at 1 etc.  I would really have to repeat the
> > same thing in each changelog. Does it really bring value?
> 
> You don't have to go into that level of detail, but you can provide enough
> information with a template as well, e.g.:
> 
>    atomic_t variables are often used to implement pure reference counters:
>      - starting at 1
>      - freeing a resource after reaching zero
>      - only using basic atomic operations (init, inc, dec_and_test)
> 
>    These variables should be converted to refcount_t because the refcount_t
>    operations can catch and prevent accidental underflows and overflows.
> 
>    The variable FOO is used as a pure reference counter. Convert it to
>    refcount_t and fix up the operations.
> 
> That gives enough context for someone who looks at a patch because then the
> reviewer can look for:
> 
>    starts at 1, frees at 0, does not use any fancy operations
> 
> and has not to use Gurgle to figure out what your understanding of
> reference counters is.
> 
> Replacing FOO with the real variable name can be done with a script easy
> enough.

Ok, let me try updating the commits messages in the above way. As soon as I
don't have to write them manually, I am fine with anything :) 

Best Regards,
Elena.

> 
> Thanks,
> 
> 	tglx
