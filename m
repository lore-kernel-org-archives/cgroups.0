From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 14/15] kernel: convert futex_pi_state.refcount from
 atomic_t to refcount_t
Date: Fri, 7 Jul 2017 10:24:20 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B6FF21DBE@IRSMSX102.ger.corp.intel.com>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
 <1499418269-3686-15-git-send-email-elena.reshetova@intel.com>
 <20170707092603.rmt4ne4c75k5qg56@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170707092603.rmt4ne4c75k5qg56@hirez.programming.kicks-ass.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-audit@redhat.com" <linux-audit@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "tj@kernel.org" <tj@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "acme@kernel.org" <acme@kernel.org>, "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, "eparis@redhat.com" <eparis@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "arnd@arndb.de" <arnd@arndb.de>, "luto@kernel.org" <lut>

> On Fri, Jul 07, 2017 at 12:04:28PM +0300, Elena Reshetova wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> >
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: David Windsor <dwindsor@gmail.com>
> 
> I'll let tglx comment on the SoB chain, I know he likes those :-) You
> did Cc him right, seeing how he's the maintainer of this stuff..
> 
> *sigh* you didn't :-( After so many patches send you _really_ should
> know to Cc the right people.

It is not so trivial as you might think. Unless right  person shows up as maintainer/supporter
when I run get_maintainer script, it is hard to figure out who is the right CC person. 
And the amount of sending patches doesn't help, because if a person reacts on
patches and asks to change/fix stuff, it doesn't mean he is the right person, 
he might be just reading mailing list and having time to do reviews :(

That's said, I will try to improve the CC list. 


> 
> > ---
> >  kernel/futex.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> > @@ -814,7 +815,7 @@ static struct futex_pi_state *alloc_pi_state(void)
> >
> >  static void get_pi_state(struct futex_pi_state *pi_state)
> >  {
> > -	WARN_ON_ONCE(!atomic_inc_not_zero(&pi_state->refcount));
> > +	WARN_ON_ONCE(!refcount_inc_not_zero(&pi_state->refcount));
> >  }
> 
> I think we have refcount_inc() for just that case, no?
> 

Yes, this slipped through. Will fix so it would look shorted.  Thank you for catching it!

Best Regards,
Elena.
