From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: question about memsw of memory cgroup-subsystem
Date: Tue, 17 Apr 2012 11:25:26 +0800
Message-ID: <4F8CE2A6.7070004@gmail.com>
References: <op.wco7ekvhn27o5l@gaoqiang-d1.corp.qihoo.net> <20120413144954.GA9227@tiehlicka.suse.cz> <op.wct9zibjn27o5l@gaoqiang-d1.corp.qihoo.net>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=pkeyzU1hIOAERx4bjJszx1CWzLNcnZi5SwKHky0txRQ=;
        b=tzjBqXwf/tfDn85DPvf7vwNdfVHyuznb3lcBTLDp24nCk+32vCSl0k7WsUdIgP8Qhp
         iPe9l+6UWwwxE4zVeavVPfOIKgz+c/lmnWyzek0uSsIdz1sv2e2z2J5KXFHRaKjnvz2T
         66G9gSpfWwYQ1HO1BlJfnV/RdwwRri+VBMUn7NTwX00ddlrjVChaKJfrTN1Qjp8FifLJ
         HTDpMM9F6ZndVKOSUDHeFopxKS/k6fUmbeNyuvIZZt7npp6XW6Y6WaYJsl8flCNkTBx0
         tz7CqQJh6iCLrwXrgwZwteyDfMevSwgj+9O8zZ3/A0vNwjwOwc1QYrD1KR6QEjcQU/Jk
         DKLA==
In-Reply-To: <op.wct9zibjn27o5l-4p38iKlbJMyYoDLmhA0N64eABQC+30qQrE5yTffgRl4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: gaoqiang <gaoqiangscut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 04/16/2012 11:43 AM, gaoqiang wrote:
> =D4=DA Fri, 13 Apr 2012 22:49:54 +0800=A3=ACMichal Hocko <mhocko@suse=
=2Ecz> =D0=B4=B5=C0:
>
>> [CC linux-mm]
>>
>> Hi,
>>
>> On Fri 13-04-12 18:00:10, gaoqiang wrote:
>>>
>>>
>>> I put a single process into a cgroup and set memory.limit_in_bytes
>>> to 100M,and memory.memsw.limit_in_bytes to 1G.
>>>
>>> howevery,the process was oom-killed before mem+swap hit 1G. I tried
>>> many times,and it was killed randomly when memory+swap
>>>
>>> exceed 100M but less than 1G. what is the matter ?
>>
>> could you be more specific about your kernel version, workload and c=
ould
>> you provide us with GROUP/memory.stat snapshots taken during your te=
st?
>>
>> One reason for oom might be that you are hitting the hard limit (you
>> cannot get over even if memsw limit says more) and you cannot swap o=
ut
>> any pages (e.g. they are mlocked or under writeback).
>>
>
> many thanks.
>
>
> The system is a vmware virtual machine,running centos6.2 with kernel=20
> 2.6.32-220.7.1.el6.x86_64.
>
> the attachments are memory.stat, the test program and the=20
> /var/log/message of the oom.
>
> the workload is nearly 0,with searal sshd and bash program running.
>
> I just did the following command when testing:
>
> ./t
> # this program will pause at the "getchar()" line and in another=20
> terminal,run :
>
> cgclear
> service cgconfig restart
> mkdir /cgroup/memory/test
> cd /cgroup/memory/test
> echo 100m > memory.limit_in_bytes
> echo 1G > memory.memsw.limit_in_bytes
> echo 'pid' > tasks
>
> # then continue the t command
>
>
Hi,

I run your test under RHEL6.1 with 2.6.32-220.7.1.el6.x86_64 (an=20
internal version but
no changes in mm/memcg) in a real server and the process is killed with=
=20
memsw reaching
1G. Does your vmware virtual machine have enough swap space?.. I've no=20
idea whether
the different behavior come from the physical/virtual environment.


Thanks,
Sha

