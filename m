From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v3 2/2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Tue, 3 May 2016 11:52:22 +1000
Message-ID: <57280456.1090106@suse.de>
References: <1462197681-6879-1-git-send-email-asarai@suse.de>
 <1462197681-6879-3-git-send-email-asarai@suse.de>
 <20160502160604.GR7822@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502160604.GR7822-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

>> Change the mode of the cgroup directory for each cgroup association,
>> allowing the process to create subtrees and modify the limits of the
>> subtrees *without* allowing the process to modify its own limits. Due to
>> the cgroup core restrictions and unix permission model, this allows for
>> processes to create new subtrees without breaking the cgroup limits for
>> the process.
>
> I don't get why this is necessary.  What's wrong with the parent
> setting up permission correctly for the namespace?

The parent setting this up requires either:

1. A privileged process giving the process write access to the cgroup 
directory it is currently in. Since no software does this by default, 
and in addition it might not always make sense (systemd doesn't like 
processes messing around in their respective cgroups), this has to be 
dealt with better.

2. The process itself is a privileged process, which is not the usecase 
I'm going for with rootless containers. If you have root, you can do 
whatever you want in this regard and this feature doesn't affect you.

The main reason for this patchset is because I would like to make sure 
that unprivileged processes can take advantage of cgroup features (such 
as the freezer cgroup, and to just do regular resource limiting). Since 
cgroups are a hierarchy, I can see no fundamental reason why this is not 
possible. And the cgroup namespace appears to be the perfect way of 
doing it. I firmly believe there is a simple and safe way of allowing 
unprivileged processes to create subtrees of their current cgroup.

However, I agree with James that this patchset isn't ideal (it was my 
first rough attempt). I think I'll get to work on properly virtualising 
/sys/fs/cgroup, which will allow for a new cgroup namespace to modify 
subtrees (but without allowing for cgroup escape) -- by pinning what pid 
namespace the cgroup was created under. We can use the same type of 
virtualization that /proc does (except instead of selectively showing 
the dentries, we selectively show different owners of the dentries).

Would that be acceptable?

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
