From: richard -rw- weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
Date: Tue, 31 Jul 2012 12:21:58 +0200
Message-ID: <CAFLxGvxgq9HJJvRgz=z48D7V_j=dTv4jSCLqEZcE=oCBAXnSug@mail.gmail.com>
References: <500D09C9.7060903@parallels.com>
	<500D1116.7070301@parallels.com>
	<CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com>
	<50179CF0.7050200@parallels.com>
	<CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com>
	<5017A053.9000206@parallels.com>
	<CAFLxGvy396+BfYSaSnvAwJb0GO4WZCKbPXSbU7YfrOJTo6zk6A@mail.gmail.com>
	<5017AB41.60700@parallels.com>
	<CAFLxGvwu8-ii7hDbDfco3JrgKgOK+hsdTN_Q--AHbom0Ni8WYA@mail.gmail.com>
	<20120731101603.GD2007@moon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=g3MMOWfmNeezoFq9NVqxrWoAks911y/0WbPMo9Abpzo=;
        b=ZAhrIJJ83S0QNX89reFo+BUmBfxZyzMqzOoLCZZuUpvSIcnSN1m/mb/cmXyN/I8RCD
         rtJfXDZRlG4LpJn5361LWs51z6koMzGXqZq+Z8Stjq6C/XTYvThPBNQwtD9A5zUAL4jq
         0UdXhqWD8v4t310lllQMThGfp5NrNNqfZGPQltsQEBQo5QecTe+3x0sPH2Q0fJYX56jc
         8ZVKf45VP/ZsgOB2SOxUjc6asAzxHXlH9609ecLIy4RlzZkPdX7pSvuhWXP3W7RdTG/j
         zdEs9613VORjGRT533dLAGHGltS/JAKGx5m5eVJuh29FUxLRAOocYVFGcL1WFeAvoR6w
         FHqg==
In-Reply-To: <20120731101603.GD2007@moon>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lwn-T1hC0tSOHrs@public.gmane.org" <lwn-T1hC0tSOHrs@public.gmane.org>, "criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "users-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <users-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Jul 31, 2012 at 12:16 PM, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Jul 31, 2012 at 12:08:22PM +0200, richard -rw- weinberger wrote:
>> On Tue, Jul 31, 2012 at 11:54 AM, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>> >> Yeah, but I fear it's not that easy.
>> >> We'd have to change crtools to work without ptrace().
>> >
>> > Well, this is hard. Using ptrace saved us from having many special-purpose
>> > APIs for dumping various stuff (there will be an article about it). Thus I
>> > don't know which way is simpler -- stop using ptrace or teach ptrece to allow
>> > several tracers to attach to one task %)
>>
>> Allowing multiple tracers in a safe way is IMHO even more harder.
>>
>> BTW:  While reading prctl_set_mm() I noticed two things.
>> 1.  Why isn't the return value of find_vma() verified?
>
> prctl_set_mm
>         vma = find_vma(mm, addr);
>         ...
>         if (!vma) {
>                 error = -EFAULT;
>                 goto out;
>         }
>
> these values are used in procfs statistics only. So I don't get
> which verify you mean here.

If I do PR_SET_MM_START_BRK the if(!vma) will never be executed because
there a break in case PR_SET_MM_START_BRK.

-- 
Thanks,
//richard
