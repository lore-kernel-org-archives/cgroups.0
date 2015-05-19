From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 5/8] cgroup: move enum cgroup_subsys_id definition
Date: Tue, 19 May 2015 11:25:41 +1000
Message-ID: <CAOviyag9Vu=MJcgc7zinXfabyuz2DsOReTUyd-XXd6X8+6CKng@mail.gmail.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
	<1431960667-26593-6-git-send-email-cyphar@cyphar.com>
	<20150518215944.GK24861@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150518215944.GK24861-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

>> This is in preparation for implementing the pids cgroup subsystem. It is
>> not a functional change and should not change any behavior.
>>
>> Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
>
> I did a big reorg of cgroup.h and split of cgroup-defs.h from it and
> this patch doesn't seem necessary anymore.

Is it in your tree?

--
Aleksa Sarai (cyphar)
www.cyphar.com
