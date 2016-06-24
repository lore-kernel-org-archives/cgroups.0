From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Fri, 24 Jun 2016 01:14:46 +0000
Message-ID: <6a129f00-dbef-9916-ffaa-792b6b413362@gmail.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623164614.cc871a52402fca6179bef246@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=vZrFus9BK3x+DdEaLvJbfEdTKu7rS42SqCGGvofDsNI=;
        b=aBmXjVyUYdQ9rdRGi0oJmRRJmguTXRLQylVzqMto107BXbjwmC03gZUGs9fi4vO7o2
         HNjREtYaJUIoDPOtbmxr1GPf0DGmcXlYXs14jvM6VapxVriNFLkBHSkrJzumrP8ioYn9
         0Ut5tMH4ll+RL8K7qVN3lwb1glQFhN5+rzydwb+IJz8VKYTHnGl13jWDLszlrHsR3a++
         ln1BFh6Jc+5WAvsMODKat/5jxS5bOmzhBNLnymibRPnairguFf2P9c7OAt3ZF4aK50aK
         49QVfw9+a8kGOf+mrTCUFrd5Bh3Do7dqeAvnxbjbpC+7S6KdX00Qz2TK5AECGV0lcxYD
         XjqQ==
In-Reply-To: <20160623164614.cc871a52402fca6179bef246-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Woodhouse <David.Woodhouse-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 06/23/16 23:46, Andrew Morton wrote:
> On Thu, 23 Jun 2016 18:07:10 +0300 Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> There are many basic ways to control processes, including capabilities,
>> cgroups and resource limits. However, there are far fewer ways to find
>> out useful values for the limits, except blind trial and error.
>>
>> Currently, there is no way to know which capabilities are actually used.
>> Even the source code is only implicit, in-depth knowledge of each
>> capability must be used when analyzing a program to judge which
>> capabilities the program will exercise.
>>
>> Add a new cgroup controller for monitoring of capabilities
>> in the cgroup.
> 
> I'm having trouble understanding how valuable this feature is to our
> users, and that's a rather important thing!
> 
> Perhaps it would help if you were to explain your motivation:
> particular use cases which benefited from this, for example.
> 

It's easy to control with for example systemd or many other tools, which
capabilities a service should have at the start. But how should a system
administrator, application developer or distro maintaner ever determine
a suitable value for this? Currently the only way seems to be to become
an expert on capabilities, make an educated guess how the set of
programs in question happen to work in this context and especially how
they could exercise the capabilites in all possible use cases. Even
then, the outcome is to just try something to see if that happens to
work. Reading the source code (if available) does not help very much,
because the use of capabilities is anything but explicit there.

This is way too difficult, there must be some easier way. The
information which capabilities actually were used in a trial run gives a
much better starting point. The users can just use the list of used
capabilities with configuring the service or when developing or
maintaining the application. Of course, even that could still fail
eventually, but then you simply copy the new value of used capabilities
to the configuration, whereas currently you have to reconsider your
understanding of the capabilities and the programs in light of the
failure, which by itself might give no new useful information.

One way to solve this for good would be to make the use of capabilities
explicit in the ABI. For example, there could be a system call
dac_override() which would be the only possible way ever to use the
capability CAP_DAC_OVERRIDE and so forth. Then reading source code,
tracing and many other approaches would be useful. But the OS with that
kind of ABI (not Linux) would not be Unix-like at all for any
(potentially) capability using programs, like find(1) or cat(1).

-Topi
