From: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to draw values for /proc/stat
Date: Sun, 11 Dec 2011 14:11:43 -0500
Message-ID: <4EE5006F.6070604@gmail.com>
References: <4EDC8FB1.60407@parallels.com> <1323439411.17673.65.camel@twins> <4EE22179.5090106@parallels.com> <4EE4C350.90509@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=qUdbzylf44xOh9iKgYx+hQuYsPxVmXQWEUnLVhBU96E=;
        b=Bnt23X5wpto2FeoaJ5BPdXGg4YGpfhcRztWXJnOlMIKkmEpiikWMjvUAmw4Va1cPKR
         qUhJPC8Z3PGss+CLJd0kgREQfJm3WU6yNzTEzjq6R+BhiETVxTbj/hw53TpBtUYnnMGI
         hz/N+TT5zBFJpS7rTuijwb3zGBCDwhox21ICg=
In-Reply-To: <4EE4C350.90509-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


>>> IOW a /proc namespace coupled to cgroup scope would do what you want.
>>> Now my head hurts..
>>
>> Mine too. The idea is good, but too broad. Boils down to: How do you
>> couple them? And none of the methods I thought about seemed to make any
>> sense.
>>
>> If we really want to have the values in /proc being opted-in, I think
>> Kamezawa's idea of a mount option is the winner so far.

 > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
 > index 1b7f9d5..f0bc2e9 100644
 > --- a/include/linux/cgroup.h
 > +++ b/include/linux/cgroup.h
 > @@ -158,6 +158,7 @@ enum {
 > 	 * Clone cgroup values when creating a new child cgroup
 > 	 */
 > 	CGRP_CLONE_CHILDREN,
 > +	CGRP_PROC_OVERLAY,
 > };

I'm not cgroup expert, but I doubt it is mount option. I suspect it's
cgroup option. That's said, if we have following two directories,

/cgroup-for-virtualization
/cgroup-for-resource-management

are both directory affected the overlay flag? I don't think it is not
optimal. Why? we must care some system software (e.g. kvm, systemd) are
using cgroup internally and we expected this trend will grow more.

So, I doubt namespace issue can be solved by such tiny patch.

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
