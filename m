From: Marian Marinov <mm-NV7Lj0SOnH0@public.gmane.org>
Subject: Re: Protection against container fork bombs [WAS: Re: memcg with
 kmem limit doesn't recover after disk i/o causes limit to be hit]
Date: Wed, 23 Apr 2014 09:07:28 +0300
Message-ID: <535758A0.5000500@yuhu.biz>
References: <20140416154650.GA3034@alpha.arachsys.com> <20140418155939.GE4523@dhcp22.suse.cz> <5351679F.5040908@parallels.com> <20140420142830.GC22077@alpha.arachsys.com> <20140422143943.20609800@oracle.com> <20140422200531.GA19334@alpha.arachsys.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yuhu.biz; s=default;
	t=1398233250; bh=L6s5HtygfSWoyM0y4Y8T98uq0bhGMm5Gb36I5SpmxVM=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=TdWrWxCjIl0/fM85Gad/URjM8HAkNoInYfgmTUSF7bMpnP6RYMuluzHF5I9qUUQPB
	 FriNPUjhBhFSTEHWVFNolvN+XtkG+0VQ/pFytOtIfac5o9/pp4DitPCa7cdXDEW37L
	 SzbLKhsRrqkozu0EGDkN/NWFMBnPxdmtEYlBefZw=
In-Reply-To: <20140422200531.GA19334-2oeHp4OYwSjPZs67QiJbJtBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Richard Davies <richard-li8END47hbdWk0Htik3J/w@public.gmane.org>, Dwight Engen <dwight.engen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Max Kellermann <mk-xMchvyqCc6DQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, William Dauchy <wdauchy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Berrange <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 04/22/2014 11:05 PM, Richard Davies wrote:
> Dwight Engen wrote:
>> Richard Davies wrote:
>>> Vladimir Davydov wrote:
>>>> In short, kmem limiting for memory cgroups is currently broken. Do
>>>> not use it. We are working on making it usable though.
> ...
>>> What is the best mechanism available today, until kmem limits mature?
>>>
>>> RLIMIT_NPROC exists but is per-user, not per-container.
>>>
>>> Perhaps there is an up-to-date task counter patchset or similar?
>>
>> I updated Frederic's task counter patches and included Max Kellermann's
>> fork limiter here:
>>
>> http://thread.gmane.org/gmane.linux.kernel.containers/27212
>>
>> I can send you a more recent patchset (against 3.13.10) if you would
>> find it useful.
>
> Yes please, I would be interested in that. Ideally even against 3.14.1 if
> you have that too.

Dwight, do you have these patches in any public repo?

I would like to test them also.

Marian

>
> Thanks,
>
> Richard.
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
