From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Don't filter offline CPUs in
 cpuset_cpus_allowed() for top cpuset tasks
Date: Tue, 7 Feb 2023 11:32:29 +0000
Message-ID: <20230207113228.GB12147@willie-the-truck>
References: <20230203164040.213437-1-longman@redhat.com>
 <Y94s8mzrE9VyUJLa@hirez.programming.kicks-ass.net>
 <f356b916-1c10-1565-73fb-34027c6c510a@redhat.com>
 <20230206110540.GA11024@willie-the-truck>
 <Y+FgQXvnzSF1OrmO@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675769554;
        bh=Rx3qesTFjYVQZeUfWaFK3pteCQOp67kpFcX7NQe4XWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ouCviE7soxWQaxNuMqAEp/UxyNwdNn8JwBvupPyex57tqzN8UnwSOAmK/n07K5s1V
         ZIfTMQj9JdA+Wli5BUDE1FdqJmcovbxES/o2fXTXMa1QbLe0SrE+N7cE291dLOt4xm
         rXXdQpWZ7pb2n5wnXoJFRWCAEUgEQ69n8XPo908PMo9vJq7uesEdPujJ0+W8NXUnOO
         mfPQPcToqZb14qF8B3VmuNl+FJDnXQ/UspowogT2uMKFjoQQvOtdQXDftYwJXh6FT4
         NoSh2Lqmf4eKMukkM0sd+H+qBsyAsN5ie2mrPtmp+sRl1LozhyJT+naka9fpJR0+hE
         CaoyFHnIeFhOA==
Content-Disposition: inline
In-Reply-To: <Y+FgQXvnzSF1OrmO-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Mon, Feb 06, 2023 at 10:17:05AM -1000, Tejun Heo wrote:
> On Mon, Feb 06, 2023 at 11:05:41AM +0000, Will Deacon wrote:
> > > If we want to get it into the next merge windows, there isn't much time left
> > > for linux-next testing. So a lower risk solution is better from that
> > > perspective too.
> > 
> > This needs to land for 6.2 to fix the regression. The next merge window is
> > too late. That's why I cooked the reverts [1] as an alternative.
> 
> Yeah, I think Waiman meant before the coming merge window. We have at least
> one more week so let's try the two patches and see how that goes. We can
> always revert if it doesn't work out.

I see this has landed in Linus' tree now, so thanks for that! I also tested
his branch just to make sure and it all seems fine in my asymmetric
environment.

Cheers,

Will
