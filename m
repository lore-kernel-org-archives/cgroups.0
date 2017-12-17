From: Bronek Kozicki <brok-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>
Subject: Re: PROBLEM: NULL pointer dereference in kernel 4.14.6
Date: Sun, 17 Dec 2017 18:30:28 +0000
Message-ID: <04a4e27d-e291-66c3-ab88-e1343c6955f2@incorrekt.com>
References: <1513512885.3653140.1207725096.395A9CCC@webmail.messagingengine.com>
 <eccdc57d-d5ea-ddc5-9f07-269e4a6786ae@incorrekt.com>
 <08995310-d853-ee77-ed1f-26cc336a4a30@incorrekt.com>
 <54a16e07-70e6-adda-ebdb-06349b4f8e86@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=incorrekt.com;
         h=cc:content-transfer-encoding:content-type:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JgXFvbTsqEdYT3EEY
        BvIW1rad2Lk64zbyC6h0GvEWyw=; b=aeJMa5ks5wx532lfUcR1gNyCSP1YSBsuf
        rr8IOTOgHtnLK4W9RLUrUkyQYRqUNqlBIfRr296g/06f/XIJn3fY/lSzU8Tos49p
        ynj3wozJ8FbxT2lglW6vE910c5zR2Mg/E6lA6w/M2fZEEcK4BuYuyccHsOpSZPFJ
        WiNAVw1drSgnfMS7+QxDqeyD/wSqtTmDQlm7sYYmqPeQHOOzhtaFmDqyK3iOBj+v
        k4bnLATETOCDwniPSEuf2mj8yzvKOBPzDFW70tKaw18+ccPYkKkJY3y6JSR5NOEC
        89OcF6K2nIvJE6YUKIXtgYKMrr8JoDGowTWkNIhMVYk274lrimWFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JgXFvb
        TsqEdYT3EEYBvIW1rad2Lk64zbyC6h0GvEWyw=; b=lAEvg1j+eUoGMxylTgBUtX
        T+M516IRwI3npxPMqeRmlFAlQ1aFM6Mnl0auU8jpE7qLGwkf/k++4eODB09kEecU
        7anQyXxHhexpD1TY/16KMMRjDG7UHFtYzyK7vX0mYU5cLuTfh7hwsqq9K3AlBXvr
        mokIT2FbMEq4RuCRqyq98uyEA6RltCNp6mxHs3tjm+TukNO6KVPKKIrpFJCw/rEM
        8MinUzV8M+H8b5B2SYNrzMCb6iYJCWQfN/te40SGgjFtAgH0waOj498xrzQ5qyzo
        YKPxTK1TGbGlCYk0qtkN/GjgN/MA95Ms0X5OBk8DwmztbWTUrfn7KZp2rJ7sRShw
        ==
In-Reply-To: <54a16e07-70e6-adda-ebdb-06349b4f8e86-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-GB
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 17/12/2017 18:25, Randy Dunlap wrote:
> On 12/17/2017 09:49 AM, Bronek Kozicki wrote:
>> I just upgraded to 4.14.7 and tried to reproduce this error, this time under strace. As you can see this happens when systemctl tries to read a specific entry under /sys/fs . In case this matters, the entry is for a small virtual machine running under qemu/kvm and managed by libvirt.
>>
>> open("/sys/fs/cgroup/unified/machine.slice", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 5
>> fstat(5, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
>> getdents(5, /* 12 entries */, 32768)    = 464
>> openat(AT_FDCWD, "/sys/fs/cgroup/unified/machine.slice/machine-qemu\\x2d1\\x2dkartuzy\\x2dspice.scope/cgroup.procs", O_RDONLY|O_CLOEXEC) = 8
>> fstat(8, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>> read(8,  <unfinished ...>)              = ?
>> +++ killed by SIGKILL +++
>> [1]    12078 killed     strace -- systemctl status
>>
>>
>> B.
>>
> 
> Hi,
> 
> Can you reproduce this without using (loading) the XFS modules?
> They cause the kernel to be tainted.

I think you mean ZFS - I cannot do that. It is my root filesystem.


B.
