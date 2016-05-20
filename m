From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 13:50:04 -0400
Message-ID: <1463766604.8091.53.camel@HansenPartnership.com>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
	 <573F23D0.2030500@suse.de> <20160520152244.GB5632@htj.duckdns.org>
	 <1463758258.8091.3.camel@HansenPartnership.com>
	 <20160520160352.GC5632@htj.duckdns.org>
	 <1463760550.8091.13.camel@HansenPartnership.com>
	 <20160520161759.GD5632@htj.duckdns.org>
	 <1463761509.8091.19.camel@HansenPartnership.com>
	 <CAGr1F2H_hFbkAdLks29P+Gg9w6+vbQ-Tzk_OT3908hOX93bj0w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
	s=20151216; t=1463766606;
	bh=tjP48kZBSMygUApQGgdCpJvokU2c6bdqt0+3QWciFDY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=AI2HONJ3aPZbihVsvgGFcroRSJSelPIqiGu0Ixz/pL4QPlFjDxeyUYfaNjhLIP5tg
	 nmU9SksmzcZTTLaCeKK+/yZU0w7kofuGiTF0bro8+RzxcYBMzw0yIgFOa0GoICZzpo
	 3ly/Dcv6HrkxUEFhfulZYOX5iVq5/hEhhqXlo8g0=
In-Reply-To: <CAGr1F2H_hFbkAdLks29P+Gg9w6+vbQ-Tzk_OT3908hOX93bj0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Aditya Kali <adityakali@google.com>
Cc: Tejun Heo <tj@kernel.org>, Aleksa Sarai <asarai@suse.de>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Aleksa Sarai <cyphar@cyphar.com>, cgroups mailinglist <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, dev@opencontainers.org

On Fri, 2016-05-20 at 10:33 -0700, Aditya Kali wrote:
> On Fri, May 20, 2016 at 9:25 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > On Fri, 2016-05-20 at 09:17 -0700, Tejun Heo wrote:
> > > Hello, James.
> > > 
> > > On Fri, May 20, 2016 at 12:09:10PM -0400, James Bottomley wrote:
> > > > I think it's just different definitions.  If you take on our
> > > > definition of being able to set up a container without any 
> > > > admin intervention, do you see our problem: we can't get the 
> > > > initial delegation of the hierarchy.
> > > 
> > > Yeah, I can see the difference but we can't solve that by special
> > > casing NS case.
> > 
> > Great, we agree on the problem definition ... as I said, I'm not 
> > saying this patch is the solution, but it gives us a starting point 
> > for exploring whether there is a solution.
> > 
> > >   This is stemming from the fact that an unpriv application can't
> > > create its sub-cgroups without explicit delegation from the root 
> > > and that has always been an explicit design choice.
> > > It's tied to who's responsible for cleanup afterwards and what
> > > happens when the process gets migrated to a different cgroup. 
> > >  The latter is an important issue on v1 hierarchies because 
> > > migrating tasks sometimes is used as a way to control resource
> > > distribution.
> > 
> > OK, so is the only problem cleanup?  If so, what if I proposed that 
> > a cgroup directory could only be created by the owner of the userns
> > (which would be any old unprivileged user) iff they create a cgroup 
> > ns and the cgroup ns would be responsible for removing it again, so
> > the cgroup subdirectory would be tied to the cgroup namespace as 
> > its holder and we'd use release of the cgroup to remove all the
> > directories?
> > 
> 
> cgroup namspace doesn't own the resources in the cgroupns-root, and 
> so I am not sure how it will be able to do the cleanup either. I.e, 
> even if all the processes in the cgroup ns die, it doesn't mean that 
> the cgroupns-root they belonged to is available for cleanup. For this
> reason, one of the implicit design choice in cgroupns was that the
> cgroup-ns root should already exist and the target process should
> already be moved to it (presumably by some admin process) before
> creating the cgroupns.
> 
> Moreover, the subsystem controllers (cpu, memory, etc.) are oblivious
> to cgroup namespaces. So, for example, creating new cgroup namespace
> doesn't affect the reclaim behavior.

That doesn't mean we can't give them an owning cgroup namespace. It's
more or less the way user ns works today for all the other namespaces. 
 However, lets try to arrive at a proposal that works before we start
thinking about the implementation.

>  But, allowing creation/modification of sub-cgroups affects it. So I 
> think allowing any unprivileged process to do that cannot be 
> considered safe for now. Explicit approval from some admin process 
> will still be needed (which can be given by chmod/chown today).

Well, that's the essence of the question.  Can this be done in a safe
way for cgroups like it is for namespaces today?

James

