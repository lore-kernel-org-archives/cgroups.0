From: Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Question] The system may be stuck if there is a cpu cgroup
 cpu.cfs_quato_us is very low
Date: Fri, 01 Jul 2022 13:08:21 -0700
Message-ID: <xm26czeoioju.fsf@google.com>
References: <5987be34-b527-4ff5-a17d-5f6f0dc94d6d@huawei.com>
        <YrlrBmF3oOfS3+fq@mtj.duckdns.org>
        <f0f55f89-14db-de29-c182-32539f8d4e4d@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=PSFngJKHrho0FhjB6XnRsy4TL/BbcPjIjM6hLwlPgJM=;
        b=KJN2es13TaWWapgFPPSZUr0HDQneLNPJI+FpW3g3pKbHwyoLr5ukOqQ6PfvGZyYsU6
         YVE0xVKLE5FZWNKxeqTTW+m7OM/XFUX1SlvFAOjo0BJ8/aHXDgD48rsY8qDd2KLt88Db
         ff7QI/rSlge0DvRdZBvMUsEeZ8SfK0/0omobRfhDo7MsVfXGQ4x5kDHFAE5hag/K4G/G
         PrQjSWop/84u7Wap/121fKfSYZCcbZ5NdvrlGhCvdqfjRSJmJzIu2frxoQU9qoIoWOYX
         H8eoFH4xEkWhBA7aOf5/hVkTmA+sZ86c5LnrhhRjqUta5cLGNt2r9DsFTDCsAKiyk02a
         u0/w==
In-Reply-To: <f0f55f89-14db-de29-c182-32539f8d4e4d-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> (Zhang Qiao's
        message of "Fri, 1 Jul 2022 15:34:41 +0800")
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, mgorman-l3A5Bk7waGM@public.gmane.org

Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> writes:

> Hi, tejun
>
> Thanks for your reply.
>
> =E5=9C=A8 2022/6/27 16:32, Tejun Heo =E5=86=99=E9=81=93:
>> Hello,
>>=20
>> On Mon, Jun 27, 2022 at 02:50:25PM +0800, Zhang Qiao wrote:
>>> Becuase the task cgroup's cpu.cfs_quota_us is very small and
>>> test_fork's load is very heavy, the test_fork may be throttled long
>>> time, therefore, the cgroup_threadgroup_rw_sem read lock is held for
>>> a long time, other processes will get stuck waiting for the lock:
>>=20
>> Yeah, this is a known problem and can happen with other locks too. The
>> solution prolly is only throttling while in or when about to return to
>> userspace. There is one really important and wide-spread assumption in
>> the kernel:
>>=20
>>   If things get blocked on some shared resource, whatever is holding
>>   the resource ends up using more of the system to exit the critical
>>   section faster and thus unblocks others ASAP. IOW, things running in
>>   kernel are work-conserving.
>>=20
>> The cpu bw controller gives the userspace a rather easy way to break
>> this assumption and thus is rather fundamentally broken. This is
>> basically the same problem we had with the old cgroup freezer
>> implementation which trapped threads in random locations in the
>> kernel.
>>=20
>
> so, if we want to completely slove this problem, is the best way to
> change the cfs bw controller throttle mechanism? for example, throttle
> tasks in a safe location.

Yes, fixing (kernel) priority inversion due to CFS_BANDWIDTH requires a
serious reworking of how it works, because it would need to dequeue
tasks individually rather than doing the entire cfs_rq at a time (and
would require some effort to avoid pinging every throttling task to get
it into the kernel).
