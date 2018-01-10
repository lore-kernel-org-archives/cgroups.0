From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Wed, 10 Jan 2018 20:20:53 +0100
Message-ID: <655118da-6d58-8f02-7367-77c10a3c16ea@gmail.com>
References: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
 <20180108141450.GP3668920@devbig577.frc2.facebook.com>
 <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
 <20180109210722.GS3668920@devbig577.frc2.facebook.com>
 <672cd179-31be-e03a-f9ff-ce59b76e23e2@gmail.com>
 <20180110142640.GB3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TlBBblk1oZ2c7M0eYPiFR4JQIg0Dkin3gmjX/M/djm0=;
        b=EshkXAUr84Mymw2c1dek0s+0TCt8+q+CGmGoqUKxDFyk0F8rRRe71YNefdaUfNa/Xq
         LblUN42kzIa4wms28XeC/lRRB+K3mDhw0ZqW4U2OOk2CpSOkY/2WwlOZyfbP9zoDb4/U
         4FbxxxAyZdO/WqfmGOso4V7UYj3mlHDEWESWLcYTgXZssQNegVa4kjbp7GjAz+5vDDwE
         1TnBx/J1rfomErNe8YvCKcrDAv4F4NdUxJD9LII1u+b6+aEH06nfdmlQ3OcY+sW4vPio
         Ef8scHL4PN/y8jp6g0bBif3SN2yMItAcqjTss0Jkw6gXCpRK2jeRNkr1CRglT4quecJW
         ZWUA==
In-Reply-To: <20180110142640.GB3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Hello Tejun,

On 01/10/2018 03:26 PM, Tejun Heo wrote:
> Hello, Michael.
> 
> On Tue, Jan 09, 2018 at 11:48:11PM +0100, Michael Kerrisk (man-pages) wrote:
>>> That said, not necessarily an objection.  I'm just not sure about it.
>>
>> Okay. For the moment, I'll leave that text as is.
>>
>> I realized that there was also one more file that needs to be included
>> in the list of files that must be delegated:
>>
>>        /dlgt_grp/cgroup.threads
>>               Changing the ownership of  this  file  is  necessary  if  a
>>               threaded subtree is being delegated (see the description of
>>               "thread mode", below).
>>
>> Can you please confirm that it's only necessary to delegate this file
>> if we are delegating a threaded subtree?
> 
> Replied on the other thread.  The file isn't delegatable as far as I
> can tell.

So, following on from the discussion in the other thread, my
question above still stands.

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
