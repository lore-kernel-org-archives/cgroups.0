From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 09:18:59 +1000
Message-ID: <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
 <20160720230228.GA19588@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160720230228.GA19588-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

>> process, so I would argue that they aren't "stealing" anything. While a
>> higher level process might not know where precisely in the hierarchy the
>> process is, they'll know it that it must be a sub-cgroup of the one they
>> were put in (meaning the parent can still impose restrictions without any
>> issue).
>
> Hmmm... it's not just about the ownership of the process itself.  If
> it had been, we wouldn't have bothered with permission model on cgroup
> hierarchy itself.  It's also about who is allowed to modify a given
> cgroup and what you're proposing violates that.

I feel like the permission model makes sense in certain cases (the 
common ancestor restriction, as well as the ability for a parent to 
apply limits to children by setting its own limits). Neither of those 
are violated (if you read the commit that introduced the common ancestor 
restriction).

Maybe if you give me a usecase of when it might be important that a 
process must not be able to move to a sub-cgroup of its current one, I 
might be able to understand your concerns? From my perspective, I think 
that's actually quite useful.

>> If you want, we can make it so that an unprivileged user migrating processes
>> to a child cgroup only works if you're in the same cgroup namespace (and
>> have CAP_SYS_ADMIN in the pinned user namespace, etc). The current setup
>> would obviously still work, but you'd add a permission for users that just
>> want to be able to limit their own processes. IIRC we need to update
>> cgroup_procs_write_permission() anyway. By having the cgroup namespace
>> requirement, you'd definitely have to "own" the process in every sense of
>> the word I can imagine.
>
> Maybe I'm misunderstanding but I can't see how that would change the
> situation in a significant way.

Well, it would avoid the issue of a process being moved against *its* 
will. The process would have to be complicit in joining (or unsharing) a 
cgroup namespace. I'm not sure I really agree with the argument that a 
higher level process should be able to stop a process from imposing more 
*stringent* limits on itself if the process is complicit in setting 
those limits (see above).

The reason I'm doing this is so that we might be able to _practically_ 
use cgroups as an unprivileged user (something that will almost 
certainly be useful to not just the container crowd, but people also 
planning on using cgroups as advanced forms of rlimits).

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
