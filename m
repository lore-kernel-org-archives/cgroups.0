From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Sat, 28 Feb 2015 06:59:26 -0500
Message-ID: <20150228115926.GA1005@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <54F0BC51.4050506@gmail.com>
 <CAOviyajSOY6kTiwTA+APf9VGT=Ui=0QQH6KUqwaxHB3ahuJk2g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6wapECk9GGnwu0Cx919LE4xSKk+yhUP8VcbAmXxdWAI=;
        b=g4Fdqv5fY3xyUbWRe1upAxi8SRLMqjVbkxkpJAn1UzirS6lKQkDVo9ttE/+nhzz6i2
         78AHAnq9sXcczjfsC1vZkxLZgEbi34TiPqMXSP+ZTEctGOnOKtdh4UwqtBtB2a8n+D3R
         6ou8riT+HDPlqTDAGgzfGL3DhLfJ6rDXqyankLOO3Org9RA086Ib6GamfSBtegTxqoE7
         GfqLwm3zgA3nmUKMVZIDd2w4M0srP2U5Ptg49cBTHChSZbStwaCTSZmd2FF3CtynolAr
         wG6T/Bes60MxO1QB4lAOM662PxHo5/P4zXuZkjiJ8hoUsIBFpN/egYdmKnCMgcN28Hy3
         M40w==
Content-Disposition: inline
In-Reply-To: <CAOviyajSOY6kTiwTA+APf9VGT=Ui=0QQH6KUqwaxHB3ahuJk2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Aleksa.

On Sat, Feb 28, 2015 at 08:26:34PM +1100, Aleksa Sarai wrote:
> I just want to quickly echo my support for this statement. Process IDs
> aren't limited by kernel memory, they're a hard-set limit. Thus they are

Process IDs become a hard global resource because we didn't switch to
long during 64bit transition and put an artifical global limit on it,
which allows it to affect system-wide operation while its memory
consumption is staying within practical range.

> a resource like other global resources (open files, etc). Now, while you

Unlike open files.

> can argue that it is possible to limit the amount of *effective*
> processes you can use in a cgroup through kmemcg (by limiting the amount
> of memory spent in storing task_struct data) -- that isn't limiting the
> usage of the *actual* resource (the fact you're limiting the number of
> PIDs is little more than a by-product).

No, the problem is not that.  The problem is that pid_t is, as a
resource, is decoupled from its backing resource - memory - by the
extra artificial and difficult-to-overcome limit put on it.  You are
saying something which is completely different from what Austin was
arguing.

> Also, If it wasn't an actual resource then why is RLIMIT_NPROC a thing?

One strong reason would be because we didn't have a way to account for
and limit the fundamental resources.  If you can fully contain and
control the consumption via rationing the underlying resource, there
isn't much point in controlling the upper layer constructs.

> To me, that indicates that PID limiting not an esoteric usecase and it
> should be possible to use the Linux kernel's home-grown accounting
> system to limit the number of PIDs in a cgroup. Otherwise you're stuck

Again, I think it's a lot more indicative of the fact that we didn't
have any way to control kernel side memory consumption and pids and
open files were one of the things which are relatively easy to
implement policy-wise.

> in a weird world where you *can* limit the number of processes in a
> process tree but *not* the number of processes in a cgroup.

I'm not sold on the idea of replicating the features of ulimit in
cgroups.  ulimit is a mixed bag of relatively easily implementable
resource limits and their behaviors are a combination of resource
limits, per-user usage policies, and per-process behavior safetynets.
The only part translatable to cgroups is actual resource related part
and even among those we should identify what are actual resources
which can't be mapped to consumption of other fundamental resources.

> >> In general, I'm pretty strongly against adding controllers for things
> >> which aren't fundamental resources in the system.  What's next?  Open
> >> files?  Pipe buffer?  Number of flocks?  Number of session leaders or
> >> program groups?
> >>
> > PID's are a fundamental resource, you run out and it's an only marginally
> > better situation than OOM, namely, if you don't already have a shell open
> > which has kill builtin (because you can't fork), or have some other reliable
> > way to terminate processes without forking, you are stuck either waiting for
> > the problem to resolve itself, or have to reset the system.
> 
> I couldn't agree more. PIDs are a fundamental resource because there is
> a hard limit on the amount of PIDs you can have in any one system. Once
> you've exhausted that limit, there's not much you can do apart from
> doing the SYSRQ dance.

The reason why this holds is because we can hit the global limit way
earlier than a practically sized kmem consumption limits can kick in.

Thanks.

-- 
tejun
