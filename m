From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH V2 0/3] memcg: simply lock of page stat accounting
Date: Fri, 17 May 2013 09:57:37 +0400
Message-ID: <5195C6D1.6040005@openvz.org>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com> <519380FC.1040504@openvz.org> <20130515134110.GD5455@dhcp22.suse.cz> <51946071.4030101@openvz.org> <20130516132846.GE13848@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=YNGbNgydTREXrPBYPFoWAz/p2r6Ed95enJJ40uST2Gg=;
        b=0idT8oOOVX0xauQmUE10dln1CRpnSBNTgv44FC3anByl8/BHMOCEgUyZiYYMTN2S1H
         f6pG8LnRjjknnRQ+gbn5qGmD1fz2yKUkXTbAirHT5qBzAhNDFIh00IujtJ7v5I0mBheX
         MAusJp86cKvIQDJz4mZhHiKmg8AvQIQ4uzVoaGYOxM9JubySj9XoI6KTqmcn0+fJpWhR
         Gt+BwBkh8cJveSQd+rApoP8w6scMgN8SIPEzKkKcUynzD4h/hnSt/KJgZh+2l5Idi9Go
         p0wR2nFngY6s1/AhIWHca25oazmMxS2E3RklIete+DvW8oS9bV8Ln74A/23fs8m9u95e
         K4+A==
In-Reply-To: <20130516132846.GE13848@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.cz>
Cc: Sha Zhengju <handai.szj@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, hughd@google.com, gthelen@google.com, Sha Zhengju <handai.szj@taobao.com>

Michal Hocko wrote:
> On Thu 16-05-13 08:28:33, Konstantin Khlebnikov wrote:
>> Michal Hocko wrote:
>>> On Wed 15-05-13 16:35:08, Konstantin Khlebnikov wrote:
>>>> Sha Zhengju wrote:
>>>>> Hi,
>>>>>
>>>>> This is my second attempt to make memcg page stat lock simpler, the
>>>>> first version: http://www.spinics.net/lists/linux-mm/msg50037.html.
>>>>>
>>>>> In this version I investigate the potential race conditions among
>>>>> page stat, move_account, charge, uncharge and try to prove it race
>>>>> safe of my proposing lock scheme. The first patch is the basis of
>>>>> the patchset, so if I've made some stupid mistake please do not
>>>>> hesitate to point it out.
>>>>
>>>> I have a provocational question. Who needs these numbers? I mean
>>>> per-cgroup nr_mapped and so on.
>>>
>>> Well, I guess it makes some sense to know how much page cache and anon
>>> memory is charged to the group. I am using that to monitor the per-group
>>> memory usage. I can imagine a even better coverage - something
>>> /proc/meminfo like.
>>>
>>
>> I think page counters from lru-vectors can give enough information for that.
>
> not for dirty and writeback data which is the next step.

I think tracking dirty and writeback pages in per-inode manner is much more useful.
If there is only one cgroup per inode who responds for all dirtied pages we can use this
hint during writeback process to account disk operations and throttle tasks in that cgroup.

This approach allows to easily implement effective IO bandwidth controller in the VFS layer.
Actually we did this in our commercial product, feature called 'iolimits' works exactly in this
way. Unlike to blkcg this disk bandwidth controller doesn't suffer from priority inversion
bugs related to fs journal, and it works for non-disk filesystems like NFS and FUSE.
This is something like 'balance-dirty-pages' on steroids which also can handle read
operations and can take IOPS counters into account.

>
>> If somebody needs more detailed information there are enough ways to get it.
>> Amount of mapped pages can be estimated via summing rss counters from mm-structs.
>> Exact numbers can be obtained via examining /proc/pid/pagemap.
>
> How do you find out whether given pages were charged to the group of
> interest - e.g. shared data or taks that has moved from a different
> group without move_at_immigrate?

For example we can export pages ownership and charging state via single file in proc,
something similar to /proc/kpageflags

BTW
In our kernel the memory controller tries to change page's ownership at first mmap and
at each page activation, probably it's worth to add this into mainline memcg too.

>
>> I don't think that simulating 'Mapped' line in /proc/mapfile is a worth reason
>> for adding such weird stuff into the rmap code on map/unmap paths.
>
> The accounting code is trying to be not intrusive as much as possible.
> This patchset makes it more complicated without a good reason and that
> is why it has been Nacked by me.

I think we can remove it or replace it with something different but much less intrusive,
if nobody strictly requires exactly this approach in managing 'mapped' pages counters.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
