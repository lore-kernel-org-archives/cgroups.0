From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Mon, 4 Mar 2013 11:02:37 +0800
Message-ID: <51340ECD.1030905@huawei.com>
References: <512B01FA.5020506@huawei.com> <512B020D.9040504@huawei.com> <20130226022703.GA13837@htj.dyndns.org> <512C8D84.7090707@huawei.com> <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com> <512DE4A8.5050303@huawei.com> <CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com> <512EFEDF.8080205@huawei.com> <CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com> <51304C6D.8050207@huawei.com> <20130301203917.GT4503@ZenIV.linux.org.uk> <CAOS58YPNAPhWUwNq9G39Airo+TvV2ecXBiNU5s9PFqkL3RbRFg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YPNAPhWUwNq9G39Airo+TvV2ecXBiNU5s9PFqkL3RbRFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/3/2 4:45, Tejun Heo wrote:
> Hello, Al.
> 
> On Fri, Mar 1, 2013 at 12:39 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>>>> Flexible array members can be statically initialized. If you wanna be
>>>> really anal about it, you can do it manually with a wrapping struct
>>>> but I don't think that would be necessary.
>>>>
>>>
>>> I didn't know this difference between flexible array and zero-size array.
>>> Thanks.
>>
>> Mind you, initializing flex array member is explicitly invalid per C99;
>> it's a GNU extension...
> 
> Yeah, that's what I meant by the "anal" part although it seems like
> c99 doesn't even allow that. Do we care tho? It seems like a logical
> feature which should show up in the standard eventually. Maybe it
> could be a problem for clang?
> 

Do we have a decision now? Please pick v4 if this GNU extension can't be used
in kernel code, otherwise v5.
