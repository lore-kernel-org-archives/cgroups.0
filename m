From: Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups and nice
Date: Mon, 28 Nov 2016 16:13:09 -0500
Message-ID: <CAPhKKr8FWR6sfJNp62Q6bDxR5dAYr5uLf1HqfcVNWpNGYTFoVQ@mail.gmail.com>
References: <8e909b7a-ad0f-431c-4981-3cafe2690da1@rqc.ru>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ClIA9gJnbs2Ute0N0QpmRFaX9V8EeJQgDEmrIie05Ck=;
        b=Z7d3jvYvZuOgbT7ADSe5bFqkTIFNK3clsLnkS2rhegoJyoNOsxdS9BJAmUHaqgLlGp
         ouxzlBhuqTJILDHMIq0sUTbaFyEr/RJ8VqL2cdFRF5F7U8LJHlkWHqdhqOJM8rtH+ZCM
         n2UTLkyxRJf/3eFxZ2/OhvdK+l7fyAn32f45Grg3xVQmBttUjFu7Clv2+CCeSpdEN/Dc
         l7fQJjUFFSTzWipbS4xP40IaEm+cndfgK8ODdU/XWwe66gbwhTgbmQyNY23DBQFejk3U
         Mau/yVQ+paPmHkt8jRnpwNqKeBfbOe6I3g7o7QshtkDuQIbMNzFnFy6uS3jbHQRWzpAk
         vqPg==
In-Reply-To: <8e909b7a-ad0f-431c-4981-3cafe2690da1-CePww0+mnY4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marat Khalili <mkh-CePww0+mnY4@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

[Resending because gmail doesn't understand when to go plaintext :-) ]
[Added a few other folks who might have something to say about it]

On Fri, Nov 25, 2016 at 9:34 AM, Marat Khalili <mkh-CePww0+mnY4@public.gmane.org> wrote:
> I have a question as a cgroup cpu limits user: how does it interact with
> nice? Documentation creates the impression that, as long as number of
> processes demanding the cpu time exceeds number of available cores, time
> allocated will be proportional to configured cpu.shares. However, in
> practice I observe that group with niced processes significantly under
> perform.
>
> For example, suppose on a 6-core box /cgroup/cpu/group1/cpu.shares is 400,
> and /cgroup/cpu/group2/cpu.shares is 200.
> 1) If I run `stress -c 6` in both groups, I should see approximately 400% of
> cpu time in group1 and 200% in group2 in top output, regardless of their
> relative nice value.
> 2) If I run `nice -n 19 stress -c 1` in cgroup1 and `stress -c 24` in
> group2, I should see at least 100% of cpu time in group1.
>
> What I see is significantly less cpu time in group1 if group1 processes
> happen to have greater nice value, and especially if group2 have greater
> number of processes involved: cpu load of group1 in example 2 can be as low
> as 20%. It may create tensions among users in my case; how can this be
> avoided except by renicing all processes to the same value?
>
>> $ uname -a
>> Linux redacted 2.6.32-642.11.1.el6.x86_64 #1 SMP Fri Nov 18 19:25:05 UTC
>> 2016 x86_64 x86_64 x86_64 GNU/Linux
>

This is an old version of the kernel. Do you see the same behavior on
a newer version of the kernel? (4.8 is the latest stable kernel)

>
>> $ lsb_release -a
>> LSB Version:
>> :base-4.0-amd64:base-4.0-noarch:core-4.0-amd64:core-4.0-noarch:graphics-4.0-amd64:graphics-4.0-noarch:printing-4.0-amd64:printing-4.0-noarch
>> Distributor ID: CentOS
>> Description:    CentOS release 6.8 (Final)
>> Release:        6.8
>> Codename:       Final
>
>
> (My apologies if I'm posting to incorrect list.)
>
> --
>
> With Best Regards,
> Marat Khalili
> --

Thanks,
Dhaval
