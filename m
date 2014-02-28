From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: Ask about cgroups security
Date: Fri, 28 Feb 2014 03:39:47 -0800
Message-ID: <87eh2nwjng.fsf@xmission.com>
References: <CACBeRbYh58m+MuCefJP0SzT5AQADDJh==KyeDFG8UdRb=NQvQg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACBeRbYh58m+MuCefJP0SzT5AQADDJh==KyeDFG8UdRb=NQvQg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(nguyen thai's message of "Thu, 27 Feb 2014 10:59:31 +0700")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nguyen thai <thai.bkset-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Cgroups maillist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

nguyen thai <thai.bkset-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Hi everyone,
>
> I'm working with SELinux and cgroups to implement SELinux on cgroups
> file. This is expected to improve cgroups security. But i'm having na
> confusion identifying the possible vulnerabilities of current cgroups
> DAC check and what need to be improved.
> I know the cgroup interface is the filesystem. But how this can be the
> drawback of current implementation. I mean how hackers may use this to
> attack the system. Tejun Heo said that  the biggest issue with cgroup
> is the ability for non-root users to gain access to the raw kernel
> control knobs. anyone you explain more about this?

The problem is poor design of the basic mechanisms. The result is that
in some that in several instances a poor/unmaintainable choice of
abstractions were exposed.  That is there are values exposed for
tweaking that if a non-root user is allowed to change them can lead to
subversion of the policy framework that it is the intetion of cgroups to
implement.

The only sane fix is to go through the exported control knobs and
catalogue them as safe or not safe.  And then work towards removing the
unsafe knobs.

Eric
