From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Wed, 10 Jan 2018 23:34:46 +0100
Message-ID: <ff31f13b-f28b-2765-73dd-c2d67524ff9f@gmail.com>
References: <20180108141450.GP3668920@devbig577.frc2.facebook.com>
 <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
 <20180109210722.GS3668920@devbig577.frc2.facebook.com>
 <672cd179-31be-e03a-f9ff-ce59b76e23e2@gmail.com>
 <20180110142640.GB3668920@devbig577.frc2.facebook.com>
 <655118da-6d58-8f02-7367-77c10a3c16ea@gmail.com>
 <20180110193907.GC3460072@devbig577.frc2.facebook.com>
 <fdfc4c27-f87c-fab8-894c-f9f21374bab2@gmail.com>
 <20180110221418.GF3460072@devbig577.frc2.facebook.com>
 <5207cfc8-5525-b932-baee-6b0160886178@gmail.com>
 <20180110222726.GG3460072@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r0Xr/uaOOjxpzxyY4+v/dsMOtHWjQowVUYYix20O/OU=;
        b=ChalvRs4F3kZmqjn5/CLuiZ7Fl0fBxBCweSw8TwJjkYvXofpu+KDBoB1m4IfsumEwx
         lEyAuwl+KJwbcFeNq81CeMsi/AS/2nl2lvdfs/yF4Q3mA6eV0yPJoHTKNmqCHKZ5+lbq
         WToVuFYLE6uXoMi4YOyBN1Ac+cgFYc2Nods9tcGW5Ihj72VyotLWD0aboWahR+njQF7H
         scXEauShCihlLE7xYqpaU4umLve9IMLMIGQ1SY2vfVM08wU9jK/pnYnObHNBu5Q5lAi+
         mS1VJBNydy596iWVRKYufLJrQF7o8l324DF8GhdRFJarLK50iNwseLgm9/gOhOZHuta7
         g+Ig==
In-Reply-To: <20180110222726.GG3460072-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On 01/10/2018 11:27 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jan 10, 2018 at 11:24:05PM +0100, Michael Kerrisk (man-pages) wrote:
>>> Oh, I'm probably mixing up two things.
>>>
>>> 1. When delegating, cgroup.threads should be delegated.  Doing that
>>>    selectively doesn't achieve anything meaningful.
>>
>> Understood. But surely delegating cgroup.threads is effectively
>> meaningless when delegating a "domain" cgroup tree? (Obviously it's
>> not harmful to delegate the the cgroup.threads file in this case;
>> it's just not useful to do so.)
> 
> Yeap, unless we can somehow support non-root mixed domains.

Thanks for the clarification/confirmation, Tejun.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
