From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 12:31:49 +0200
Message-ID: <20150514103148.GA5066@rei.suse.de>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514092145.GA6799-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hi!
> > The failing test cases 14, 22, 23, 24 and 30 test respectively:
> > 
> > 14: Hogging memory like so: mmap(NULL, memsize, PROT_WRITE | PROT_READ,
> > MAP_PRIVATE | MAP_ANONYMOUS | MAP_LOCKED, 0, 0);
> 
> MAP_LOCKED will not trigger the OOM killer as explained
> http://marc.info/?l=linux-mm&m=142122902313315&w=2. So this is expected
> and Cyril is working on fixing the test case.

It's on my TODO, I should get to this i a few weeks. Till then just
ignore the failure.

> > # Case 22 - 24: Test limit_in_bytes will be aligned to PAGESIZE - The
> > output clearly indicates that the limits in bytes is not being page
> > aligned?
> 
> I can see
> > memcg_function_test   22  TFAIL  :  ltpapicmd.c:190: input=4095,
> > limit_in_bytes=0
> > memcg_function_test   23  TFAIL  :  ltpapicmd.c:190: input=4097,
> > limit_in_bytes=4096
> > memcg_function_test   24  TFAIL  :  ltpapicmd.c:190: input=1,
> > limit_in_bytes=0
> 
> So limit_in_bytes _is_ page aligned but we round down rather than up.
> 
> > Is this desired behavior, in which case ltp is broken or is it
> > a genuine bug?
> 
> This behavior has changed by 3e32cb2e0a12 ("mm: memcontrol: lockless
> page counters") introduced in 3.19. The change in rounding has been
> pointed out during the review
> http://marc.info/?l=linux-mm&m=141207518827336&w=2 but the conclusion
> was that the original round up wasn't really much better
> http://marc.info/?l=linux-mm&m=141226210316376&w=2 resp.
> http://marc.info/?l=linux-mm&m=141234785111200&w=2
> 
> I will post fix for ltp in the reply
> 
> > 30: Again, it locks memory with mmap and then tries to see if
> > force_empty would succeed. Expecting it to fail, but in this particular
> > case it succeeds?
> 
> I am not sure I understand this testcase. It does:
> 	TEST_PATH/memcg_process --mmap-anon -s $PAGESIZE
> 	[...]

Looking at the code, it does two more things here:

echo $pid > tasks
kill -s USR1 $pid 2> /dev/null

Sending SIGUSR1 to the memcg_process causes it to repeat the allocation
that has been passed to it by the command line parameters.

So my guess is that it expect the force_empty to fail if the process has
allocated some memory after it has been moved to the current cgroup.

The previous testcases does exactly this but moves the process to the
parent with:

echo $pid > ../tasks

Before it tries the force_empty and expects it to succeed.

Was this some old implementation limitation that has been lifted
meanwhile?

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
