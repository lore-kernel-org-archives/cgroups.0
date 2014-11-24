From: SeongJae Park <sj38.park@gmail.com>
Subject: Re: [PATCH] cgroups: Documentation: fix wrong cgroupfs paths
Date: Tue, 25 Nov 2014 03:41:15 +0900
Message-ID: <CAEjAshqxpgAsO69zkNkb-CgbofHtXDriKP3CWwDeEcZJLF6jwA@mail.gmail.com>
References: <1416847159-3895-1-git-send-email-sj38.park@gmail.com> <20141124104530.78a0050e@lwn.net>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=+SOLdB3bXxk3t4y3KrDiRESF9OJeP3i/hVUB94/USwE=;
        b=cEVNsLqrVEVaCr1bp/f4SjFudpMgtNshbTa+AfTGskG3h153/B95tMmzFQwqevqlmM
         EZKMhNdrHmUyYTxbEHpbfKZokuk+HQRxfH93gV71e4v0q0L/UsOhWVNy5slHmGeG7VFH
         FDl+Q3Xh4DzaWNhhduEr4k13KaT6jUREXwNwkiNzYY9dzGbni66w5Pc5U9Y4+A+wd/ct
         7wzZAS+sX0E2DksHp+PHLL0wPxU0eM60/Dv8gANhoIl958kepnhGlZ0LiR950nHDHr8j
         POvH7OyPn4cR63Gx7fnFI2ql6nmeCD58M8Sb2FhmQCy9Oq79C6zkPRV71c0QyAbYhf4Q
         M3Mw==
In-Reply-To: <20141124104530.78a0050e@lwn.net>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Corbet <corbet@lwn.net>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-doc <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Nov 25, 2014 at 2:45 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 25 Nov 2014 01:39:19 +0900
> SeongJae Park <sj38.park@gmail.com> wrote:
>
>>   6) Attach that task to the new cgroup by writing its PID to the
>> -    /sys/fs/cgroup/cpuset/tasks file for that cgroup.
>> +    /sys/fs/cgroup/cpuset tasks file for that cgroup.
>
> That one looks like it was correct before the change...?  What am I
> missing here?

It should represents /sys/fs/cgroup/cpuset/<*new cgroup name*>/tasks,
not /sys/fs/cgroup/cpuset/tasks.

If there are better suggestions or anything I am missing, please let me
know.

Thanks,
SeongJae Park

>
> Thanks,
>
> jon
