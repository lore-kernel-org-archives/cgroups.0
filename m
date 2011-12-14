From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 2/3] make clone_children a flag
Date: Wed, 14 Dec 2011 10:29:33 +0800
Message-ID: <4EE80A0D.7090808@cn.fujitsu.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-4-git-send-email-glommer@parallels.com> <20111213153921.GE25802@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111213153921.GE25802-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

Tejun Heo wrote:
> On Sun, Dec 11, 2011 at 03:45:37PM +0100, Glauber Costa wrote:
>> There is no reason to have a flags field, and then a separate
>> bool field just to indicate if the clone_children flag is set.
>> Make it a flag
>>
>> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 
> Doesn't this change how remount conditions are checked?
> 

Right. Currently we can do this:

	# mount -t cgroup xxx /mnt
	# mount -o remount,clone_children /mnt

with this patch, the above remount will fail.

But..the current bevaiour of remount is a bit confusing in that remount
with/without "clone_children" has no effect on anything:

	# mount -t cgroup -o clone_children xxx /mnt
	# cat /mnt/cgroup.clone_children
	1
	# mount -o remount xxx /mnt
	# mount | grep cgroup
	xxx on /mnt type cgroup (rw,clone_children)
	# cat /mnt/cgroup.clone_children
	1
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
