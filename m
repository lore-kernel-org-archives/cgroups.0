From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: Cannot set memory.memsw.limit_in_bytes for a particular cgroup
Date: Wed, 25 Apr 2012 10:27:09 +0900
Message-ID: <4F9752ED.9050800@jp.fujitsu.com>
References: <CAE+0DR6yyRHGKYiR-svQAdaV2ZqgaTgPvDMwFFmVs6rJG6w0JA@mail.gmail.com> <4F974836.1090000@jp.fujitsu.com> <D5FAE552-76FE-43DB-B803-FD6F595C1518@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D5FAE552-76FE-43DB-B803-FD6F595C1518-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Martin <andrew.s.martin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

(2012/04/25 10:00), Andrew Martin wrote:


>> Then, Does "echo > ...apache/memory.memsw.limit_in_bytes" works fine ?
>> If so, kernel works fine.
>>
> It appears to work, in that if I cat it after doing so the new value is retained. However, I have not pushed apache hard enough after doing it to see if the limit is really enforced, though I agree it looks like it is being set correctly using this method.
> 
>> I'm sorry I'm not libcgroup specialist..but..What happens when you write
>>>        memory {
>>>                memory.limit_in_bytes = 6000M;
>>>                memory.memsw.limit_in_bytes = 6000M;
>>>                memory.swappiness = 5;
>>>        }
>>
> I also tried that as well as specifying the bytes directly, with no improvement. I also tried different values for memory.memsw.limit_in_bytes from 6000 to 6256 in both powers of 2 and 10.
> 
> Any other ideas?
> 

ok, I doubt memory.memsw.limit_in_bytes is set before memory.limit_in_bytes...
i.e. maybe libcgroup sets values in reverse order.

How about this ?

memory {
	memory.memsw.limit_in_bytes = 6G;
	memory.limit_in_bytes = 6G;
	memory.swappiness = 5;
}


memory.limit_in_bytes should be less than memory.memsw.limit_in_bytes.

Thanks,
-Kame

