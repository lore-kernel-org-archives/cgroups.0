From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Thu, 23 Jun 2016 21:15:43 -0700
Message-ID: <CALCETrUBLxL116XrD6V9--H17q84KrMTYHm8UJF_kO3Reoh2pw@mail.gmail.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623164614.cc871a52402fca6179bef246@linux-foundation.org> <6a129f00-dbef-9916-ffaa-792b6b413362@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ZukJItG6m+5IW5TVbcouO5xWQ21XhePfG0jSU6avWnk=;
        b=rTb1Frzp+8QIfR3xArgXMlA7mW6a4fvc/haBIfuW6TV/9Tqz3zsTMHa2jeiuHme/iF
         dOgPlys+uM0HBUbZu1kXhle3bQcBRphzctYgSzIM7TY0whV+nkOPoziktP1X2RfyL2o+
         lHg7wGg+Iwi144/Brg1W8suyHhrhLToZrMj53WvdB+RQ71dWuPnD3o3Bq5CAleP+zK7Y
         IymrKL8DIcrzVBajB+76X7mG0IypLiQlC2YUgmh6YYWpbT1Eaz7iqLUpv0nPTDlEOqPT
         eNL5dZsT2IU5y2+lpZ1drkIIj66YKjmimUCrHNONzFueaf0mb+OSAv/bAm/ff2sDYgZM
         co1Q==
In-Reply-To: <6a129f00-dbef-9916-ffaa-792b6b413362-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 23, 2016 at 6:14 PM, Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 06/23/16 23:46, Andrew Morton wrote:
>> On Thu, 23 Jun 2016 18:07:10 +0300 Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> There are many basic ways to control processes, including capabilities,
>>> cgroups and resource limits. However, there are far fewer ways to find
>>> out useful values for the limits, except blind trial and error.
>>>
>>> Currently, there is no way to know which capabilities are actually used.
>>> Even the source code is only implicit, in-depth knowledge of each
>>> capability must be used when analyzing a program to judge which
>>> capabilities the program will exercise.
>>>
>>> Add a new cgroup controller for monitoring of capabilities
>>> in the cgroup.
>>
>> I'm having trouble understanding how valuable this feature is to our
>> users, and that's a rather important thing!
>>
>> Perhaps it would help if you were to explain your motivation:
>> particular use cases which benefited from this, for example.
>>
>
> It's easy to control with for example systemd or many other tools, which
> capabilities a service should have at the start. But how should a system
> administrator, application developer or distro maintaner ever determine
> a suitable value for this? Currently the only way seems to be to become
> an expert on capabilities, make an educated guess how the set of
> programs in question happen to work in this context and especially how
> they could exercise the capabilites in all possible use cases. Even
> then, the outcome is to just try something to see if that happens to
> work. Reading the source code (if available) does not help very much,
> because the use of capabilities is anything but explicit there.
>
> This is way too difficult, there must be some easier way. The
> information which capabilities actually were used in a trial run gives a
> much better starting point. The users can just use the list of used
> capabilities with configuring the service or when developing or
> maintaining the application. Of course, even that could still fail
> eventually, but then you simply copy the new value of used capabilities
> to the configuration, whereas currently you have to reconsider your
> understanding of the capabilities and the programs in light of the
> failure, which by itself might give no new useful information.
>
> One way to solve this for good would be to make the use of capabilities
> explicit in the ABI. For example, there could be a system call
> dac_override() which would be the only possible way ever to use the
> capability CAP_DAC_OVERRIDE and so forth. Then reading source code,
> tracing and many other approaches would be useful. But the OS with that
> kind of ABI (not Linux) would not be Unix-like at all for any
> (potentially) capability using programs, like find(1) or cat(1).

The problem is that most of the capabilities are so powerful on their
own that limiting services to just a few may be all but useless.

--Andy
