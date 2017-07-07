From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 14/15] kernel: convert futex_pi_state.refcount from
 atomic_t to refcount_t
Date: Fri, 7 Jul 2017 12:35:16 +0200
Message-ID: <20170707103516.d2xvqvijaomj342j@gmail.com>
References: <1499418269-3686-1-git-send-email-elena.reshetova@intel.com>
 <1499418269-3686-15-git-send-email-elena.reshetova@intel.com>
 <20170707092603.rmt4ne4c75k5qg56@hirez.programming.kicks-ass.net>
 <alpine.DEB.2.20.1707071149500.1871@nanos>
 <2236FBA76BA1254E88B949DDB74E612B6FF21DCD@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Inxtoo4OU9cGuMUEJgjw7R9K8bQxacT8gM0lAtgv0d0=;
        b=ugrCwZf7MYCPnHrVOMYVT6m8tnP/cCNe2alKDMo4kQrp02d7jLhgDpHd4RXr4y+JxK
         G4h5AZLy4oE/HT35T6+In4PVbJhyW3JegYFLZ3osFFroGJSuufyh4JrgmyJWtXcb4WVi
         kdofyTy3aVb3q1fgKKhtxYQrwX5ABc2iCemlC4tSOhEGofV+UIn/vBrSOUDjKDEvRBF4
         /hwdmyG22x2L7d7ZlbzefSfJvt8SeHS9tpnGXd2B1Xr4puPnpjVObvR9l1WBXOGynyWL
         r+51WmRAssMmOSHFQUWWLXi0e9S0S1g87s9IXsbWcwzd3BJy2x3RT5NGJeAYF95pYNWx
         xkDA==
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B6FF21DCD@IRSMSX102.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-audit@redhat.com" <linux-audit@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "tj@kernel.org" <tj@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "acme@kernel.org" <acme@kernel.org>, "alexander.shishkin@linux.intel.com" <alexander.shishkin@linux.intel.com>, "eparis@redhat.com" <eparis@redhat.com>, "akpm@linux-foundation.org" <akpm@l>


* Reshetova, Elena <elena.reshetova@intel.com> wrote:

> > On Fri, 7 Jul 2017, Peter Zijlstra wrote:
> > 
> > > On Fri, Jul 07, 2017 at 12:04:28PM +0300, Elena Reshetova wrote:
> > > > refcount_t type and corresponding API should be
> > > > used instead of atomic_t when the variable is used as
> > > > a reference counter. This allows to avoid accidental
> > > > refcounter overflows that might lead to use-after-free
> > > > situations.
> > > >
> > > > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > > > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > >
> > > I'll let tglx comment on the SoB chain, I know he likes those :-) You
> > > did Cc him right, seeing how he's the maintainer of this stuff..
> > 
> > Right, that SOB chain is crap. It suggests that the patch was written by
> > Elena and then carried on by Hans, handed over to Kees and from there to
> > David. And now it's resent by Elena. Circular dependencies or what?
> 
> I will fix SOB on all patches and resend. 

Please don't resend any of these until the merge window is over! This is probably 
the worst possible moment to seek review feedback and merging...

Thanks,

	Ingo
