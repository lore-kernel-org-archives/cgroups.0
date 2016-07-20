From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Thu, 21 Jul 2016 08:58:32 +1000
Message-ID: <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160720155147.GG4574-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

>> If we're moving from a parent to a direct descendant, the only end
>> result (on cgroupv2 hierarchies) is that the process experiences more
>> restrictive resource limits. Thus, there's no reason to restrict
>> processes from moving to direct descendants based on whether or not they
>> have cgroup.procs write access to their current cgroup.
>>
>> This is important for unprivileged subtree management, as it allows
>> unprivileged processes to move to their newly create subtrees.
>
> I don't think we can do this as this allows a sub-cgroup to steal an
> ancestor's process whether the ancestor likes it or not.  A process
> being put in a context where it's more restricted without whatever is
> managing that part of cgroup hierarchy is not ok, at all.  Please also
> note that nobody expects its processes to be stolen underneath it.
> This would be a management nightmare.

I'm not sure what you mean by "steal". The user doing the migration owns 
the process, so I would argue that they aren't "stealing" anything. 
While a higher level process might not know where precisely in the 
hierarchy the process is, they'll know it that it must be a sub-cgroup 
of the one they were put in (meaning the parent can still impose 
restrictions without any issue).

If you want, we can make it so that an unprivileged user migrating 
processes to a child cgroup only works if you're in the same cgroup 
namespace (and have CAP_SYS_ADMIN in the pinned user namespace, etc). 
The current setup would obviously still work, but you'd add a permission 
for users that just want to be able to limit their own processes. IIRC 
we need to update cgroup_procs_write_permission() anyway. By having the 
cgroup namespace requirement, you'd definitely have to "own" the process 
in every sense of the word I can imagine.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
