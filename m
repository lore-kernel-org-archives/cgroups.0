From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Fri, 1 Mar 2013 12:45:01 -0800
Message-ID: <CAOS58YPNAPhWUwNq9G39Airo+TvV2ecXBiNU5s9PFqkL3RbRFg@mail.gmail.com>
References: <512B01FA.5020506@huawei.com>
	<512B020D.9040504@huawei.com>
	<20130226022703.GA13837@htj.dyndns.org>
	<512C8D84.7090707@huawei.com>
	<CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
	<512DE4A8.5050303@huawei.com>
	<CAOS58YMhm6Uia0bx6oUHwheXUhu8i31LPhh8VVggvg0vg-UmUQ@mail.gmail.com>
	<512EFEDF.8080205@huawei.com>
	<CAOS58YMBcvhfBWdQmt=JersRgB9nVgsrLACtLovz===2ZXfR=w@mail.gmail.com>
	<51304C6D.8050207@huawei.com>
	<20130301203917.GT4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=SqqRV3jfBQCeyqLaKRfafOhhqwfdr0JZ8D0E21twBH0=;
        b=WbEKIru0POPPa6BaYihmmfIZIrRfj6u1SC/uTVrfnZxF0dUlAmXtFUTG9OVqM1Wznf
         s6R6j4EzhzTMmJDmbvANbWRsOnqUINS1jQfcVYtbkYhJSGThtaZjV3jG/bFvcEfKRyK+
         S8ZPrKSID8UZVPV+1+9MKlcH+CwDZ7v4dWWn6YK/PXTG3Z3mAd6XQ7wELi1YY7/beQSB
         JG0bFs86vBzrfx/0dtVjYaiH7JRbA6uR8fD+Dzbebpnj6KN80WDwyQzKMvhauQtejE2+
         FbmgCiIWkGNBoi5/XHmU/1aMlCJS1X3yWpHv2XjPZdazlLJb6xX2eOa7AqI3uD2iAfQ+
         1X2w==
In-Reply-To: <20130301203917.GT4503-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Al.

On Fri, Mar 1, 2013 at 12:39 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
>> > Flexible array members can be statically initialized. If you wanna be
>> > really anal about it, you can do it manually with a wrapping struct
>> > but I don't think that would be necessary.
>> >
>>
>> I didn't know this difference between flexible array and zero-size array.
>> Thanks.
>
> Mind you, initializing flex array member is explicitly invalid per C99;
> it's a GNU extension...

Yeah, that's what I meant by the "anal" part although it seems like
c99 doesn't even allow that. Do we care tho? It seems like a logical
feature which should show up in the standard eventually. Maybe it
could be a problem for clang?

Thanks.

-- 
tejun
