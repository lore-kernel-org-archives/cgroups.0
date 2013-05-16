From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [PATCH V2 0/3] memcg: simply lock of page stat accounting
Date: Thu, 16 May 2013 08:28:33 +0400
Message-ID: <51946071.4030101@openvz.org>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com> <519380FC.1040504@openvz.org> <20130515134110.GD5455@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=Q2rqre7Slg3vzv8hdolm5rb5g8vs88FbRFMXpylSrdY=;
        b=gwlGBebxVS5H5f9DUah2qmQNV4wDlp+YjnqZo3kOJ8gCxVap2sBHbed7teGzELYsbk
         IyOXbTVs10jYdXeEPLh1x3q5270yUtGggiMpz19yMgbuXVncvIq9KPbIAKiZfdbKiUKD
         UgSEZy0RsvSA48kexik2tQqky287cKQtO/3qhqXzK1c28vgRFJgXNG4/22QIBtys/I3G
         cyKQCEz56+H9yJyJz4ui7Ew2iSlvG4AGjUBwvjNkvip/+6zb3QweHaZSjnP9vJRP3GYL
         +qMqlUtgc1siuOf5XqtJ6Tsb/vnrZB+q6PZuVbT/LfC1VxJ5PTd/2LEtXijCzlygVLGZ
         lb6A==
In-Reply-To: <20130515134110.GD5455@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.cz>
Cc: Sha Zhengju <handai.szj@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, hughd@google.com, gthelen@google.com, Sha Zhengju <handai.szj@taobao.com>

Michal Hocko wrote:
> On Wed 15-05-13 16:35:08, Konstantin Khlebnikov wrote:
>> Sha Zhengju wrote:
>>> Hi,
>>>
>>> This is my second attempt to make memcg page stat lock simpler, the
>>> first version: http://www.spinics.net/lists/linux-mm/msg50037.html.
>>>
>>> In this version I investigate the potential race conditions among
>>> page stat, move_account, charge, uncharge and try to prove it race
>>> safe of my proposing lock scheme. The first patch is the basis of
>>> the patchset, so if I've made some stupid mistake please do not
>>> hesitate to point it out.
>>
>> I have a provocational question. Who needs these numbers? I mean
>> per-cgroup nr_mapped and so on.
>
> Well, I guess it makes some sense to know how much page cache and anon
> memory is charged to the group. I am using that to monitor the per-group
> memory usage. I can imagine a even better coverage - something
> /proc/meminfo like.
>

I think page counters from lru-vectors can give enough information for that.

If somebody needs more detailed information there are enough ways to get it.
Amount of mapped pages can be estimated via summing rss counters from mm-structs.
Exact numbers can be obtained via examining /proc/pid/pagemap.

I don't think that simulating 'Mapped' line in /proc/mapfile is a worth reason
for adding such weird stuff into the rmap code on map/unmap paths.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
