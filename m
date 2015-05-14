From: Michal Hocko <mhocko@suse.cz>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 13:31:01 +0200
Message-ID: <20150514113101.GD6799@dhcp22.suse.cz>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
 <20150514092301.GB6799@dhcp22.suse.cz>
 <20150514103542.GB5066@rei.suse.de>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150514103542.GB5066@rei.suse.de>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cyril Hrubis <chrubis@suse.cz>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-mm@kvack.org, Nikolay Borisov <kernel@kyup.com>

On Thu 14-05-15 12:35:43, Cyril Hrubis wrote:
> Hi!
> > --- a/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
> > +++ b/testcases/kernel/controllers/memcg/functional/memcg_function_test.sh
> > @@ -158,17 +158,12 @@ testcase_21()
> >  # Case 22 - 24: Test limit_in_bytes will be aligned to PAGESIZE
> >  testcase_22()
> >  {
> > -	test_limit_in_bytes $((PAGESIZE-1)) $PAGESIZE 0
> > +	test_limit_in_bytes $((PAGESIZE-1)) 0 0
> >  }
> >  
> >  testcase_23()
> >  {
> > -	test_limit_in_bytes $((PAGESIZE+1)) $((PAGESIZE*2)) 0
> > -}
> > -
> > -testcase_24()
> > -{
> > -	test_limit_in_bytes 1 $PAGESIZE 0
> > +	test_limit_in_bytes $((PAGESIZE+1)) $((PAGESIZE)) 0
> >  }
> 
> That would fail on older kernels without the patch, woudln't it?

Yes it will. I thought those would be using some stable release (I do
not have much idea about the release process of ltp...). You are
definitely right that a backward compatible way is better. I will cook
up a patch later today.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
