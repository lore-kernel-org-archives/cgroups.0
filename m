From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: PROBLEM: NULL pointer dereference in kernel 4.14.6
Date: Sun, 17 Dec 2017 10:31:39 -0800
Message-ID: <ec8d36ae-4fd6-a71c-0eb6-2d36e3d331ae@infradead.org>
References: <1513512885.3653140.1207725096.395A9CCC@webmail.messagingengine.com>
 <eccdc57d-d5ea-ddc5-9f07-269e4a6786ae@incorrekt.com>
 <08995310-d853-ee77-ed1f-26cc336a4a30@incorrekt.com>
 <54a16e07-70e6-adda-ebdb-06349b4f8e86@infradead.org>
 <04a4e27d-e291-66c3-ab88-e1343c6955f2@incorrekt.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=emiAojK1n3zVB1/AYpEfx7PypQ9U1Vj3ilpcz7pVYdM=; b=f8OmFo8qhJK48e/1ag4qwwapAs
        SAfCuMkyZzfYBZxontUlGTQAgc5CXMVF9iwmGElAmgWVBTEd2ycN3dLLDMFaD6O7dCfVlUWVVQokT
        PeHlq2kCsG29ptaznvO3b9KsI2xciFmeja/kdU0cai6KOh/EWyR994AcU/YUfUcMEzW/LfWOyIJsO
        uAjJhRkw6tZm6AvF+MXyRp1mVNNl+lx1AgZGHI+LXREk68AJFHAFfsmQFlgWOU/l2oj0yqdl2ICHD
        K/hZD5pQZ93AM7t7nEjFj+R/XquevBJ2a4YpgjxikL0VHb7jG3mT+F7psFkOngimvjP4oq46RU3O0
      
In-Reply-To: <04a4e27d-e291-66c3-ab88-e1343c6955f2-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Bronek Kozicki <brok-CgwIDsGnGWjby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/17/2017 10:30 AM, Bronek Kozicki wrote:
> On 17/12/2017 18:25, Randy Dunlap wrote:
>> On 12/17/2017 09:49 AM, Bronek Kozicki wrote:
>>> I just upgraded to 4.14.7 and tried to reproduce this error, this time under strace. As you can see this happens when systemctl tries to read a specific entry under /sys/fs . In case this matters, the entry is for a small virtual machine running under qemu/kvm and managed by libvirt.
>>>
>>> open("/sys/fs/cgroup/unified/machine.slice", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 5
>>> fstat(5, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
>>> getdents(5, /* 12 entries */, 32768)    = 464
>>> openat(AT_FDCWD, "/sys/fs/cgroup/unified/machine.slice/machine-qemu\\x2d1\\x2dkartuzy\\x2dspice.scope/cgroup.procs", O_RDONLY|O_CLOEXEC) = 8
>>> fstat(8, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
>>> read(8,  <unfinished ...>)              = ?
>>> +++ killed by SIGKILL +++
>>> [1]    12078 killed     strace -- systemctl status
>>>
>>>
>>> B.
>>>
>>
>> Hi,
>>
>> Can you reproduce this without using (loading) the XFS modules?
>> They cause the kernel to be tainted.
> 
> I think you mean ZFS - I cannot do that. It is my root filesystem.

Sorry, yes, I did mean ZFS.

thanks,
-- 
~Randy
