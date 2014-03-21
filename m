From: Jean-Tiare LE BIGOT <jean-tiare.le-bigot-SavXxUIaH7I@public.gmane.org>
Subject: Re: using cgroups' classif with iptables
Date: Fri, 21 Mar 2014 10:27:14 +0100
Message-ID: <532C05F2.2070308@ovh.net>
References: <532B252F.80302@ovh.net> <CAKoUArkS2mBZkFULqvvHEUEt6btcAAmV-+oWBk2KbNxrnt-s8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKoUArkS2mBZkFULqvvHEUEt6btcAAmV-+oWBk2KbNxrnt-s8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Rami Rosen <roszenrami-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Rami,

Thanks for your hint. Looking in this direction I found 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/netfilter/xt_cgroup.c?id=82a37132f300ea53bdcd812917af5a6329ec80c3 
which includes netfilter side of cgroup filtering in... 3.14. I'll 
backport it.

Regards,

On 03/21/2014 10:10 AM, Rami Rosen wrote:
>
> Hi, Jean,
>
> You should look at t the Control Group Classifier module:
> http://lxr.free-electrons.com/source/net/sched/cls_cgroup.c
>
> Best regards,
> Rami Rosen
> http://ramirose.wix.com/ramirosen
>
>
> On Thu, Mar 20, 2014 at 7:28 PM, Jean-Tiare LE BIGOT
> <jean-tiare.le-bigot-SavXxUIaH7I@public.gmane.org> wrote:
>> Hi,
>>
>> In https://www.kernel.org/doc/Documentation/cgroups/net_cls.txt there is a
>> example to match the classid, set with a cgroup, with iptables:
>>          iptables -A OUTPUT -m cgroup ! --cgroup 0x100001 -j DROP
>>
>> However, I've not been able to find the corresponding kernel module neither
>> the iptables side module...
>>
>> Do you have any hint where I could find it ?
>>
>> Thanks,
>>
>> --
>> Jean-Tiare, shared-hosting team
>> --
>> To unsubscribe from this list: send the line "unsubscribe cgroups" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Jean-Tiare, shared-hosting team
