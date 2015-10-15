From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-4.4] cgroup: make zombies retain cgroup
 membership and fix pids controller
Date: Thu, 15 Oct 2015 16:41:14 -0400
Message-ID: <20151015204114.GA3788@htj.duckdns.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
 <20151015013809.GC20884@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RM9ISY1M7oiQA5hxUBpfmi7Q7AgRhrykFK94yjuhjEw=;
        b=QQI727ojYNuJUzljQ04tEcNP9sSmsAbPEHNJflLfx1rdK8uXXH0I7vd9KsuFbyw8E5
         g/9qoZULt7hYFwNVfk7IYD0oEQOSn4rKnqS2f+JtK6NfwgPVucpaAGNUYIQ+XZesv7ys
         VcdAzUfP6XXjtAgX+kPGtGotPyFdAJiUEMZ4VeRJ6KcCPMkg0zvOANatUUgQqcZJSq18
         l/pz0ePEjk4sD1r885Q+015E+8YHEsm4qFRld67v3DPkXRODpNvJ1ORlM7RIyIOw/SZw
         RHKI7acHP89o84UqBvYR8cLBYLQDocIgblZ8GWGYCv85B52rXG3FNyaU8y8Tw3nqVNWH
         Wtwg==
Content-Disposition: inline
In-Reply-To: <20151015013809.GC20884-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Oct 14, 2015 at 09:38:09PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Fri, Oct 09, 2015 at 11:29:27PM -0400, Tejun Heo wrote:
> > The patchset is pretty lightly tested and I need to verify that the
> > corner cases behave as expected.
> 
> Fixed several bugs while testing.  Updated patches posted.  Seems to
> work fine now.  git branch has been refreshed with the updated
> patches.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-zombies
> 
> Li, can you please go over the changes?

I want this series to be in -next at least for a couple weeks before
the merge window opens, so I'm applying it to cgroup/for-4.4 now.
Please let me know if you spot something wrong.  Let's fix it up
incrementally.

Thanks.

-- 
tejun
