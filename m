From: Lucas Karpinski <lkarpins@redhat.com>
Subject: Re: [PATCH] selftests: cgroup: fix test_kmem_basic false positives
Date: Thu, 3 Aug 2023 12:13:26 -0400
Message-ID: <tqt5od6fuwid5qf2vjhkxef2swlccpki5oikx4pdoabyycrdpe@kzx2rpscvwgs>
References: <20230801135632.1768830-1-hannes@cmpxchg.org>
 <c40ca485-f52e-411a-9f33-3adabc53c0fc@paulmck-laptop>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691079218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NBGgPFoZzZurgnvdLr2MN4Fp3sMcoIPkqmKxp6vR8Tk=;
        b=OaEUAdm2ZBPfMQuFubVxwTt801x2nffLCOcg3J90JvTxz6+FC3JFKAdDhMPp3+IZJvOVNa
        JEty4vYM93xuRcuvCFdltXgIw2Oofgd/ulDripzSEcKrtiW24Nmv9PM4Xq5pFalTzlz/UV
        PwpTBO9n0Ruu/FkfArOy4/ukApRjLMg=
Content-Disposition: inline
In-Reply-To: <c40ca485-f52e-411a-9f33-3adabc53c0fc@paulmck-laptop>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@suse.com>, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 01, 2023 at 09:39:28AM -0700, Paul E. McKenney wrote:
> On Tue, Aug 01, 2023 at 09:56:32AM -0400, Johannes Weiner wrote:
> > This test fails routinely in our prod testing environment, and I can
> > reproduce it locally as well.
> > 
> > The test allocates dcache inside a cgroup, then drops the memory limit
> > and checks that usage drops correspondingly. The reason it fails is
> > because dentries are freed with an RCU delay - a debugging sleep shows
> > that usage drops as expected shortly after.
> > 
> > Insert a 1s sleep after dropping the limit. This should be good
> > enough, assuming that machines running those tests are otherwise not
> > very busy.
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> I am putting together something more formal, but this will certainly
> improve things, as Johannes says, assuming the system goes mostly
> idle during that one-second wait.  So:
> 
> Acked-by: Paul E. McKenney <paulmck@kernel.org>
> 
> Yes, there are corner cases, such as the system having millions of
> RCU callbacks queued and being unable to invoke them all during that
> one-second interval.  But that is a corner case, and that is exactly
> why I will be putting together something more formal.  ;-)
> 
> 							Thanx, Paul
> 
> > ---
> >  tools/testing/selftests/cgroup/test_kmem.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
> > index 258ddc565deb..1b2cec9d18a4 100644
> > --- a/tools/testing/selftests/cgroup/test_kmem.c
> > +++ b/tools/testing/selftests/cgroup/test_kmem.c
> > @@ -70,6 +70,10 @@ static int test_kmem_basic(const char *root)
> >  		goto cleanup;
> >  
> >  	cg_write(cg, "memory.high", "1M");
> > +
> > +	/* wait for RCU freeing */
> > +	sleep(1);
> > +
> >  	slab1 = cg_read_key_long(cg, "memory.stat", "slab ");
> >  	if (slab1 <= 0)
> >  		goto cleanup;
> > -- 
> > 2.41.0
> >

The same issue exists in the test case test_kmem_memcg_deletion. I
wouldn't mind posting the patch, but it seems you want to propose
something more formal. Let me know your opinion.

Thanks,
Lucas

