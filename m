From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: cgroup pid controller side effects
Date: Fri, 16 Oct 2015 10:39:43 -0700
Message-ID: <20151016173943.GA2162@cmpxchg.org>
References: <f2e-561fb480-9-1b99f780@25775614>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f2e-561fb480-9-1b99f780@25775614>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Robert Gierzinger <robert.gierzinger-RbZlAiThDcE@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Robert,

On Thu, Oct 15, 2015 at 04:13:02PM +0200, Robert Gierzinger wrote:
> I have finally had time to test 4.3-rc5 especially (my greatly anticipated) process limitiation with cgroup-pids.
> With bash forkbombs, it really works nice, however, I had some side effects with the forkbomb from
> https://github.com/linux-vserver/util-vserver/blob/master/tests/forkbomb.c
> 
> The good thing: my test systems did not die as in previous versions during the simulated attack. But executing the file with e.g. 
> ./forkbomb 100000 100 fork
> I get "unable to fork process: Resource temporarily unavailable" on the host

It looks like this forkbomb is not waiting for its children and is
creating a whole lot of zombies.

The pids controller is currently broken in that zombies can escape
accounting completely, and the proposed fix is too invasive to go in
before 4.4. Until then, we need forkbombs to nicely cooperate with us!

Could you retry your test against the following branch?

https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/log/?h=for-4.4

Thanks!
Johannes
