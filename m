From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Wed, 10 Jan 2018 23:24:05 +0100
Message-ID: <5207cfc8-5525-b932-baee-6b0160886178@gmail.com>
References: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
 <20180108141450.GP3668920@devbig577.frc2.facebook.com>
 <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
 <20180109210722.GS3668920@devbig577.frc2.facebook.com>
 <672cd179-31be-e03a-f9ff-ce59b76e23e2@gmail.com>
 <20180110142640.GB3668920@devbig577.frc2.facebook.com>
 <655118da-6d58-8f02-7367-77c10a3c16ea@gmail.com>
 <20180110193907.GC3460072@devbig577.frc2.facebook.com>
 <fdfc4c27-f87c-fab8-894c-f9f21374bab2@gmail.com>
 <20180110221418.GF3460072@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eLmgPt2e+pPpL+FVuzRynfMiJN644WrKV6Io51wBgi8=;
        b=Gz8jWQD5+HXWJcEsNe8A3k7Hg4rSHaebdNbevGPYEVHrGWA5nvZs1POmG/RojvZ81m
         iIl3xUeTIHo5KmGtnJu/hA/U2Jo0pvKGGUUp8B54jur00LlQ/HEZ4NUjlU8j265h28S3
         SnFWptzFm6A5nV/1Wyem/0S04oJGEkikz1MGAxtKcaBzDI6woHltXhWiWIBpKKyssP1g
         CpG+KCPQyzhA/CfCEuOh7NZQwE3ByO2bcPPpY89HQvCiCU7hVU26Ma/nOXwSnJ/7HSIA
         Cw7JUwByRPYzEpw7ba0C8leaq1rnxZy6rT91B/XszCQlYXug9egG6E0b8oZahuUUbDx2
         FoTg==
In-Reply-To: <20180110221418.GF3460072-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Hello Tejun,

On 01/10/2018 11:14 PM, Tejun Heo wrote:
> Hello, Michael.
> 
> On Wed, Jan 10, 2018 at 11:01:11PM +0100, Michael Kerrisk (man-pages) wrote:
>>>>>> Can you please confirm that it's only necessary to delegate this file
>>>>>> if we are delegating a threaded subtree?
>>>>>
>>>>> Replied on the other thread.  The file isn't delegatable as far as I
>>>>> can tell.
>>>>
>>>> So, following on from the discussion in the other thread, my
>>>> question above still stands.
>>>
>>> Oh, I frankly haven't thought about delegating a threaded subtree.
>>
>> I'm still confused. cgroup-v2.txt documents the possibility. You
>> wrote that text. We just had a conversation in another thread about the
>> fact that cgroup.threads is delegatable. You must have thought at 
>> least a little about this?
> 
> Oh, I'm probably mixing up two things.
> 
> 1. When delegating, cgroup.threads should be delegated.  Doing that
>    selectively doesn't achieve anything meaningful.

Understood. But surely delegating cgroup.threads is effectively
meaningless when delegating a "domain" cgroup tree? (Obviously it's
not harmful to delegate the the cgroup.threads file in this case;
it's just not useful to do so.)

> 2. I haven't thought much about delegating a sub-protion of a threaded
>    subtree.  Everything works the same way.  I just can't think of a
>    use case.

Ahhh -- now I see what you meant before.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
