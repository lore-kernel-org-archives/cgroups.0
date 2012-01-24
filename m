From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Tue, 24 Jan 2012 14:22:49 +0400
Message-ID: <4F1E8679.5060606@parallels.com>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com> <20120123211218.GF23916@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120123211218.GF23916-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 01/24/2012 01:12 AM, Al Viro wrote:
> On Mon, Jan 23, 2012 at 08:56:08PM +0400, Glauber Costa wrote:
>> This patch creates a list of allowed filesystems per-namespace.
>> The goal is to prevent users inside a container, even root,
>> to mount filesystems that are not allowed by the main box admin.
>>
>> My main two motivators to pursue this are:
>>   1) We want to prevent a certain tailored view of some virtual
>>      filesystems, for example, by bind-mounting files with userspace
>>      generated data into /proc. The ability of mounting /proc inside
>>      the container works against this effort, while disallowing it
>>      via capabilities would have the effect of disallowing other
>>      mounts as well.
>
> Translation, please.
>
>> 2) Some filesystems are known not to behave well under a container
>>     environment. They require changes to work in a safe-way. We can
>>     whitelist only the filesystems we want.
>
> So fix them.
>
>> This works as a whitelist. Only filesystems in the list are allowed
>> to be mounted. Doing a blacklist would create problems when, say,
>> a module is loaded. The whitelist is only checked if it is enabled first.
>> So any setup that was already working, will keep working. And whoever
>> is not interested in limiting filesystem mount, does not need
>> to bother about it.
>>
>> Please let me know what you guys think about it.
>
> NAKed-by: Al Viro<viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> NAKed-because: too fucking ugly
>
> This is bloody ridiculous; if you want to prevent a luser adming playing with
> the set of mounts you've given it, the right way to go is not to mess with the
> "which fs types are allowed" but to add a per-namespace "immutable" flag.
> And add a new clone(2)/unshare(2) flag, used only along with the CLONE_NEWNS
> and setting the "immutable" on the copied namespace.

Okay, not that I laid down the problem, I am happy to pursue any 
solutions we think is better. But let me develop it a bit more, first.

An immutable flag does not work, because I don't want to prevent a luser 
(loved that) to mess up with the mounts they are given. In general, it 
is perfectly fine for them to mount things inside the cointainer as the 
time goes.

But some others, I don't consider so. The example of /proc I've given, 
let me elaborate: Much of the information living on /proc, is really 
global, rather than per-container. The ones pertaining to pid namespace, 
and other namespaces are already per-namespace so they are fine. But 
there is more: some of the things /proc track, like cpu usage, memory, 
and the like, are resource-constrained by other entities, for instance, 
cgroups. In some cases, like /proc/stat, information exists in cgroup, 
but come from more than once cgroup. All of them are independent in 
nature, making it hard to come out with a
coherent vision.

Furthermore, there is no connection between namespaces and cgroups, so 
it is not obvious at all (there were discussions before), which 
information should the process see - unlike namespaces, the mere fact 
that a process lives in a cgroup, does not really mean it is isolated 
from the system in this sense.

One of the solutions, is to do it all in userspace, from outside the 
container, and bind mount the files inside the container's /proc. But it 
only works if we can prevent the user from remounting the real /proc 
somewhere. Not because it would screw up his system, which I don't care 
about, but because it will give him information about the global state 
of the system.

An immutable flag fixes this, but then it prevents all further 
legitimate mounts
