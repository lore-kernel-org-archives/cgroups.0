From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Wed, 11 Mar 2015 11:13:48 -0400
Message-ID: <55005BAC.9060405@gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>	<1425606357-6337-1-git-send-email-cyphar@cyphar.com>	<1425606357-6337-3-git-send-email-cyphar@cyphar.com>	<20150309033405.GE13283@htj.duckdns.org>	<54FDED43.4050908@gmail.com>	<CAOviyah2KCu9K7D_H2zAf3LYbnj65P39YPmNamfA=-SSNq4hOg@mail.gmail.com>	<54FED651.6040100@gmail.com> <CAOviyagpCNcAN4hdhsxffdpE+yDmw+NXx+FikTe64GJ1hQeXhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=RxxBzz8UmsRc9cqswVSiPk/HmVY9Kzjo+sgRQcT+fZE=;
        b=jUOSg66V4QeBIHhgHd1arl/jFoxHYCuFpQ3j5kwKd5e5Oz3vuOGwpkkDSs4C20Wv0L
         79xxU13fDrF28IX/gbSwvAV1tPE0ikhsrhOzT2H8m3l+6t1fokRx9aYUs+7B46ASFwSP
         FalmasdxuSFpVPzuu9nWIhNlU1FG+2frYUmObtBTWKbXEHBlk9k0eNqvosi7vQ+T2yfZ
         IC/oNucde1qheBK6SMwlZ9QUqr4NLVdTB5K0XvlNK4/+ubyVP1b3RLWGMIwtJmPJ+FeA
         FLtSh/ra2OwEBV/zVk0on0NOyYKI/BdWZa4GkBtnDP9IFlN6iBXx9fHvgnW306/KN7Mo
         UGwQ==
In-Reply-To: <CAOviyagpCNcAN4hdhsxffdpE+yDmw+NXx+FikTe64GJ1hQeXhQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVj?= =?UTF-8?B?a2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-03-10 08:31, Aleksa Sarai wrote:
> Hi Austin,
>
>>>>> Does pids limit make sense in the root cgroup?
>>>>
>>>> I would say it kind of does, although I would just expect it to track
>>>> /proc/sys/kernel/pid_max (either as a read-only value, or as an
>>>> alternative way to set it).
>>>
>>> Personally, that seems unintuitive. /proc/sys/kernel/pid_max and the pids
>>> cgroup controller are orthogonal features, why should they be able to
>>> affect each other (or even be aware of each other)?
>>
>> I wouldn't consider them entirely orthogonal, the sysctl value is the
>> limiting factor for the maximal value that can be set in a given pids
>> cgroup.  Setting an unlimited value in the cgroup is functionally identical
>> to setting it to be equal to /proc/sys/kernel/pid_max, and the root cgroup
>> is functionally equivalent to /proc/sys/kernel/pid_max, because all tasks
>> that aren't in another cgroup get put in the root.
>
> While it is true that /proc/sys/kernel/pid_max would be functionally equivalent
> to setting pids.max to the value of /proc/sys/kernel/pid_max (and thus the pids
> root cgroup is functionally equivalent to the parent), it is untrue that the
> sysctl value is the limiting factor on what "max" is defined as. "max" is
> defined as the maximum possible pid_t value (it's really the only sane maximum
> value, because trying to use /proc/sys/kernel/pid_max would be problematic due
> to the fact that the maximum limit would keep changing and the line between
> "max" and some arbitrary value would be blurred). In addition, the sysctl value
> limits the number of pids in the system in a separate part of the kernel -- it
> has nothing to do with cgroups and cgroups have nothing to do with it.
>
I did not necessarily word this very clearly.  What I meant is that 
/proc/sys/kernel/pid_max is essentially an external limiting factor that 
caps the total number of pids that can be under the root cgroup and it's 
children, not that the cgroup in any way payed attention to it.  It 
might be useful to be able to just disable the sysctl option and set the 
value through the root cgroup, solely or consistency, although such 
usage isn't something I would consider essential in any way.
