From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Sat, 28 Feb 2015 20:26:34 +1100
Message-ID: <CAOviyajSOY6kTiwTA+APf9VGT=Ui=0QQH6KUqwaxHB3ahuJk2g@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<20150227114940.GB3964@htj.duckdns.org>
	<54F09E62.8000007@gmail.com>
	<20150227170640.GK3964@htj.duckdns.org>
	<54F0BC51.4050506@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F0BC51.4050506-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> I wouldn't think that preventing PID exhaustion would be all that much of a
> niche case, it's fully possible for it to happen without using excessive
> amounts of kernel memory (think about BIG server systems with terabytes of
> memory running (arguably poorly written) forking servers that handle tens of
> thousands of client requests per second, each lasting multiple tens of
> seconds), and not necessarily as trivial as you might think to handle sanely
> (especially if you want callbacks when the limits get hit).
> As far as being trivial to achieve, I'm assuming you are referring to rlimit
> and PAM's limits module, both of which have their own issues. Using
> pam_limits.so to limit processes isn't trivial because it requires calling
> through PAM to begin with, which almost no software that isn't login related
> does, and rlimits are tricky to set up properly with the granularity that
> having a cgroup would provide.

I just want to quickly echo my support for this statement. Process IDs
aren't limited by kernel memory, they're a hard-set limit. Thus they are
a resource like other global resources (open files, etc). Now, while you
can argue that it is possible to limit the amount of *effective*
processes you can use in a cgroup through kmemcg (by limiting the amount
of memory spent in storing task_struct data) -- that isn't limiting the
usage of the *actual* resource (the fact you're limiting the number of
PIDs is little more than a by-product).

Also, If it wasn't an actual resource then why is RLIMIT_NPROC a thing?
To me, that indicates that PID limiting not an esoteric usecase and it
should be possible to use the Linux kernel's home-grown accounting
system to limit the number of PIDs in a cgroup. Otherwise you're stuck
in a weird world where you *can* limit the number of processes in a
process tree but *not* the number of processes in a cgroup.

>> In general, I'm pretty strongly against adding controllers for things
>> which aren't fundamental resources in the system.  What's next?  Open
>> files?  Pipe buffer?  Number of flocks?  Number of session leaders or
>> program groups?
>>
> PID's are a fundamental resource, you run out and it's an only marginally
> better situation than OOM, namely, if you don't already have a shell open
> which has kill builtin (because you can't fork), or have some other reliable
> way to terminate processes without forking, you are stuck either waiting for
> the problem to resolve itself, or have to reset the system.

I couldn't agree more. PIDs are a fundamental resource because there is
a hard limit on the amount of PIDs you can have in any one system. Once
you've exhausted that limit, there's not much you can do apart from
doing the SYSRQ dance.

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
