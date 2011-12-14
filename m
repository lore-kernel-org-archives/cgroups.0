From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 2/3] make clone_children a flag
Date: Wed, 14 Dec 2011 11:09:14 +0400
Message-ID: <4EE84B9A.90901@parallels.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-4-git-send-email-glommer@parallels.com> <20111213153921.GE25802@google.com> <4EE80A0D.7090808@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EE80A0D.7090808-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On 12/14/2011 06:29 AM, Li Zefan wrote:
> Tejun Heo wrote:
>> On Sun, Dec 11, 2011 at 03:45:37PM +0100, Glauber Costa wrote:
>>> There is no reason to have a flags field, and then a separate
>>> bool field just to indicate if the clone_children flag is set.
>>> Make it a flag
>>>
>>> Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>
>> Doesn't this change how remount conditions are checked?
>>

Well, I was thinking it wouldn't, because I patched all callers. But I 
forget life is not always that simple: After you mentioned, I checked 
and we do test for changes in the flag field explicitly on remount. So I 
missed that, indeed.

> Right. Currently we can do this:
>
> 	# mount -t cgroup xxx /mnt
> 	# mount -o remount,clone_children /mnt
>
> with this patch, the above remount will fail.
>
> But..the current bevaiour of remount is a bit confusing in that remount
> with/without "clone_children" has no effect on anything:
>
> 	# mount -t cgroup -o clone_children xxx /mnt
> 	# cat /mnt/cgroup.clone_children
> 	1
> 	# mount -o remount xxx /mnt
> 	# mount | grep cgroup
> 	xxx on /mnt type cgroup (rw,clone_children)
> 	# cat /mnt/cgroup.clone_children
> 	1

That's indeed confusing, and it comes from the fact that we always 
inherit clone_children from the parent - which is sane, IMHO. So this 
flag only has any value in establishing the initial behaviour of the top 
root cgroup. I wonder then if it wouldn't better to just be explicit and 
fail in this case ?

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
