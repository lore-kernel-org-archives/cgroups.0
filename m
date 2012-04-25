From: Andrew Martin <andrew.s.martin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cannot set memory.memsw.limit_in_bytes for a particular cgroup
Date: Tue, 24 Apr 2012 20:46:44 -0500
Message-ID: <CAE+0DR7JrS1rPzoLMZQVTts6p8nq8w=B-zZ4R21XqDjRpK13aw@mail.gmail.com>
References: <CAE+0DR6yyRHGKYiR-svQAdaV2ZqgaTgPvDMwFFmVs6rJG6w0JA@mail.gmail.com>
 <4F974836.1090000@jp.fujitsu.com> <D5FAE552-76FE-43DB-B803-FD6F595C1518@gmail.com>
 <4F9752ED.9050800@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        bh=OtZhK7efAECITNtXpkTt216ZClKJFn6hboIJHyS/MCY=;
        b=DAIr7peZWQZGeZ5+bJt8NCb51OptyVrlGH+rGkyySflAWGr6mM3Ah+N5Rtu+h7HTY/
         zv+MOuDvJ8KQ4xek9jAJVlhWg+ne4L6S0ZRqsU3hPw/GkgEF9R+Uu4+W++dzdbxv7sOv
         2fKIalOrz3sIaDozCjU9M3vWcu9UbwaE1ucn+/xeilL/EKRNK1Mav3oYCGqxtEVfyppg
         RRhGsY1TLLkFe/fpDTyNDyU94OeJlaIaV07AUniJfDkP5VIC70VXKriF4eKpEhPZ4zBv
         rhda6fOJcSaPMrt6nF8FiKFucVSFgY3Y/Cfq1yparGEeKA5p2hqU5ki6IDENytQjIOSV
         Vc4A==
In-Reply-To: <4F9752ED.9050800-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Kame,


On Apr 24, 2012, at 8:27 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:

> (2012/04/25 10:00), Andrew Martin wrote:
>
>
>>> Then, Does "echo > ...apache/memory.memsw.limit_in_bytes" works fine ?
>>> If so, kernel works fine.
>>>
>> It appears to work, in that if I cat it after doing so the new value is retained. However, I have not pushed apache hard enough after doing it to see if the limit is really enforced, though I agree it looks like it is being set correctly using this method.
>>
>>> I'm sorry I'm not libcgroup specialist..but..What happens when you write
>>>>       memory {
>>>>               memory.limit_in_bytes = 6000M;
>>>>               memory.memsw.limit_in_bytes = 6000M;
>>>>               memory.swappiness = 5;
>>>>       }
>>>
>> I also tried that as well as specifying the bytes directly, with no improvement. I also tried different values for memory.memsw.limit_in_bytes from 6000 to 6256 in both powers of 2 and 10.
>>
>> Any other ideas?
>>
>
> ok, I doubt memory.memsw.limit_in_bytes is set before memory.limit_in_bytes...
> i.e. maybe libcgroup sets values in reverse order.
>
> How about this ?
>
> memory {
>    memory.memsw.limit_in_bytes = 6G;
>    memory.limit_in_bytes = 6G;
>    memory.swappiness = 5;
> }
>
>
> memory.limit_in_bytes should be less than memory.memsw.limit_in_bytes.
>
> Thanks,
> -Kame
>
>
That's a good idea, but this Red Hat documentation explains that
memory.limit_in_bytes must occur before memory.memsw.limit_in_bytes
because of how they are initialized:
http://docs.redhat.com/docs/en-US/Red_Hat_Enterprise_Linux/6/html/Resource_Management_Guide/sec-memory.html

I would prefer memory.memsw.limit_in_bytes to be maybe 5-10MB larger
than memory.limit_in_bytes.

Thanks,

Andrew
