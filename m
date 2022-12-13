From: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in
 prints
Date: Tue, 13 Dec 2022 13:05:11 +0100
Message-ID: <c7539121-c8fc-b4b7-b722-ead833420b2b@kernel.org>
References: <20221031114520.10518-1-jirislaby@kernel.org>
 <Y1++fLJXkeZgtXR2@infradead.org> <Y2AMcSPAJpj6obSA@slm.duckdns.org>
 <d833ad15-f458-d43d-cab7-de62ff54a939@kernel.org>
 <Y2FNa4bGhJoevRKT@slm.duckdns.org>
 <2b975ee3117e45aaa7882203cf9a4db8@AcuMS.aculab.com>
 <Y2Kaghnu/sPvl0+g@slm.duckdns.org> <Y2KePvYRRMOrqzOe@slm.duckdns.org>
 <320c939e-a3f0-1b1e-77e4-f3ecca00465d@kernel.org>
 <Y5ehU524daymEKgf@slm.duckdns.org>
 <f5220f08bd7f45248d718f1919503261@AcuMS.aculab.com>
 <9d2ead31-efab-cf49-08d4-1e613382d89f@kernel.org>
 <542d413b9d044474a34b6e7a40d70541@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <542d413b9d044474a34b6e7a40d70541-1XygrNkDbNvwg4NCKwmqgw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>, 'Tejun Heo' <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 13. 12. 22, 12:50, David Laight wrote:
> From: Jiri Slaby
>> Sent: 13 December 2022 11:15
>>
>> On 13. 12. 22, 9:30, David Laight wrote:
>>> From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> On Behalf Of 'Tejun Heo'
>>>> Sent: 12 December 2022 21:47
>>>> To: Jiri Slaby <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>>> Cc: David Laight <David.Laight-ZS65k/vG3HxXrIkS9f7CXA@public.gmane.org>; Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; linux-
>>>> kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>; Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>; Jens
>> Axboe
>>>> <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>; cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> Subject: Re: [PATCH] block/blk-iocost (gcc13): cast enum members to int in prints
>>>>
>>>> On Mon, Dec 12, 2022 at 01:14:31PM +0100, Jiri Slaby wrote:
>>>>>> If so, my suggestion is just sticking with the old behavior until we switch
>>>>>> to --std=g2x and then make one time adjustment at that point.
>>>>>
>>>>> So is the enum split OK under these circumstances?
>>>>
>>>> Oh man, it's kinda crazy that the compiler is changing in a way that the
>>>> same piece of code can't be compiled the same way across two adjoining
>>>> versions of the same compiler. But, yeah, if that's what gcc is gonna do and
>>>> splitting enums is the only way to be okay across the compiler versions,
>>>> there isn't any other choice we can make.
>>>
>>> It is also a silent code-breaker.
>>> Compile this for 32bit x86:
>>>
>>> enum { a = 1, b = ~0ull};
>>
>> But having ull in an enum is undefined anyway. C99 allows only int
>> constants. gnuC supports ulong expressions (IIRC).
> 
> gcc supports 'long long' as well - 64bit on 32bit systems.

Can you elaborate what's source of this? Gcc manual says this about enum 
values:

The integer type compatible with each enumerated type (C90 6.5.2.2, C99 
and C11 6.7.2.2).

Normally, the type is unsigned int if there are no negative values in 
the enumeration, otherwise int. If ‘-fshort-enums’ is specified, ..., 
otherwise it is the first of unsigned char, unsigned short and unsigned 
int that can represent all the values.

I.e. the documentation says uint is the highest possible enum value.

C2x/g2x also supports ulong (that's what it is all about). But we don't 
do c2x quite yet.

thanks,
-- 
-- 
js
suse labs

