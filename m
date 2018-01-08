From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): extending man-pages documentation for cgroups v2
Date: Tue, 9 Jan 2018 00:32:58 +0100
Message-ID: <bd719e73-a5e0-f327-8925-4e1e6356295d@gmail.com>
References: <7e5b2a80-9439-4229-0ad0-eecca026a282@gmail.com>
 <20180108122911.GM3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d4uxftCnyITZvYCEFEvc814Zc7dGCU85zR6WT2CpDJc=;
        b=DD3YiPbTF8nvnGikb9Hy+4niCZXH2Wedawt5KQoCTEcxG63g41GVb7bCM0MKVnGkTF
         ew8JY3Qni+i9A3igytiSeMQoAfqVStE3YEk5y08ARLNKk93xj+8Br+bf2mTSrn9ADXBQ
         5tReugUif8u4sjf2bOCliLIxRZl+TGUdOQM4QhgB7wOfUuhLMQw/TwEpwerZjWtyWv9T
         iaV/3xeKEJPHuTIgiN/s+q5ms5uL0jzDoew71mzesnhyIHCFyztBCRVn3RYx+g0k351M
         7coWTIp+ZQjf1RBZBu57BdHhL/pv4HjNyDY5zUdKsFDnwX790yJpxPGVEAtGJ24ycoVS
         vYsg==
In-Reply-To: <20180108122911.GM3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hello Tejun,

On 01/08/2018 01:29 PM, Tejun Heo wrote:
> Hello, Michael.
> 
> On Tue, Jan 02, 2018 at 07:21:27PM +0100, Michael Kerrisk (man-pages) wrote:
>> There are some older features, as well as new features in 
>> cgroups v2 that have not so far been documented in the cgroups(7)
>> manual page. I have been working on patches to add documentation
>> for these features, and the man-pages branch containing these
>> patches can be found at:
>> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates
>>
>> I will send the updates as a series of plain text messages,
>> and CC relevant people on the various patches. Would it be
>> possible for you to review these patches please.
> 
> Yes, will do.  Sorry about the delay.  Was traveling and then caught a
> cold.

Thanks for your comments so far. That did result also in some
other new text that I sent you for review, sorry :-}.

Also, it may be that you are still reviewing my other mail,
"cgroups(7): documenting cgroups v2 thread mode"
but I just remind you of it, in case you missed it.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
