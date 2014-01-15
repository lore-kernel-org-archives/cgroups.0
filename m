From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Notifying on empty cgroup
Date: Wed, 15 Jan 2014 14:59:30 +0100
Message-ID: <20140115135930.GK8782@dhcp22.suse.cz>
References: <135711389759165@web22h.yandex.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <135711389759165-YiWutO3zKH1xpj1cXAZ9Bg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Victor Porton <porton-Q+l+L2ir60w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

[CCing cgroups mailing list]
On Wed 15-01-14 06:12:45, Victor Porton wrote:
> I want to write software which needs to receive a signal when the cgroup 
> created by it becomes empty. (After this the empty cgroup should be deleted 
> just not to clutter the memory.)
> 
> If the kernel does not support such notifications, it should be improved. 
> This functionality is crucial for some kinds of software.
> 
> There is /sys/fs/cgroup/systemd/release_agent but I don't understand how to 
> use it. I don't understand why we would need it at all.

"1.4 What does notify_on_release do ?" in
Documentation/cgroups/cgroups.txt the kernel source doesn't help?

> Starting a binary on emptying a cgroup with the purpose to notify an other 
> binary looks like a big overkill.

the binary can do rmdir which is what you want, no?

> Also my program should work in userspace without the need to use
> release_agent which can be accessed only by root.

The release_agent is global for all groups so the program doesn't have
to care.

> Note that my work is related with sandboxing software (running a program in 
> closed environment, so that it would be unable for example to remove user's 
> files).
> 
> See also
> http://portonsoft.wordpress.com/2014/01/11/toward-robust-linux-sandbox/
> 
> -- 
> Victor Porton - http://portonvictor.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
