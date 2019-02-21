From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: Re: [PATCH] doc: cgroup: correct the wrong information about measure
 of memory pressure
Date: Thu, 21 Feb 2019 11:54:46 -0800
Message-ID: <3edd7008-d568-f9b1-a991-bd0ee88f6c52@linux.alibaba.com>
References: <1550278564-81540-1-git-send-email-yang.shi@linux.alibaba.com>
 <20190218210504.GT50184@devbig004.ftw2.facebook.com>
 <CAHCio2g-S6snHsh84r0Wp1RQW1CR3t_eyUUjcdDaxnUHWTcdFw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHCio2g-S6snHsh84r0Wp1RQW1CR3t_eyUUjcdDaxnUHWTcdFw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?B?56a56Iif6ZSu?= <ufo19890607@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



On 2/19/19 2:45 AM, 禹舟键 wrote:
> Hi TeJun
> I've built the 5.0.0-rc6 kernel with psi option, but I cannot find any
> cgroup.controllers when I mounted cgroup2.
>
> [root@bogon /]# uname -r
> [root@bogon /]# 5.0.0-rc6+
> [root@bogon /]# mount -t cgroup2 none cgroup2/
> [root@bogon /]# cat cgroup2/cgroup.controllers
> [root@bogon /]
> [root@bogon /]# cat cgroup2/cgroup.subtree_control
> [root@bogon /]#
>
> What's wrong with this kernel? Or maybe I lost some mount option?

I'm not sure what you did before you mounted cgroup2, but if you have 
legacy controllers mounted, you have to unmount them, otherwise 
cgroup.controllers would show up as empty. Or you can pass 
"cgroup_no_v1=" in your kernel parameter.

Yang

>
> Thanks
> Yuzhoujian
>
> Tejun Heo <tj@kernel.org> 于2019年2月19日周二 上午10:32写道：
>> On Sat, Feb 16, 2019 at 08:56:04AM +0800, Yang Shi wrote:
>>> Since PSI has implemented some kind of measure of memory pressure, the
>>> statement about lack of such measure is not true anymore.
>>>
>>> Cc: Tejun Heo <tj@kernel.org>
>>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>>> Cc: Jonathan Corbet <corbet@lwn.net>
>>> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
>>> ---
>>>   Documentation/admin-guide/cgroup-v2.rst | 3 +--
>>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
>>> index 7bf3f12..9a92013 100644
>>> --- a/Documentation/admin-guide/cgroup-v2.rst
>>> +++ b/Documentation/admin-guide/cgroup-v2.rst
>>> @@ -1310,8 +1310,7 @@ network to a file can use all available memory but can also operate as
>>>   performant with a small amount of memory.  A measure of memory
>>>   pressure - how much the workload is being impacted due to lack of
>>>   memory - is necessary to determine whether a workload needs more
>>> -memory; unfortunately, memory pressure monitoring mechanism isn't
>>> -implemented yet.
>>> +memory.
>> Maybe refer to PSI?
>>
>> Thanks.
>>
>> --
>> tejun

