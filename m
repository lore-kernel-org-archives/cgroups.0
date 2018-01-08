From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cgroups v2 thread mode "domain invalid" state
Date: Mon, 8 Jan 2018 19:07:23 +0100
Message-ID: <21ae2a18-64af-8647-94b7-4f0942806aaa@gmail.com>
References: <CAKgNAkg2u=zt87tKk35vR+tQ7DnkJp9vbj+8n88=_MCcvmH9oQ@mail.gmail.com>
 <20171222001554.GH1084507@devbig577.frc2.facebook.com>
 <CAKgNAkhWhw8LNBdVZPzZ73VOmXDrxzSUD862AHduAhs3CF0bNw@mail.gmail.com>
 <20180108160846.GV3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1H8S5SZZOUCt9A9OcKZkaXaZasn3VKzXvUiAQeQDKIc=;
        b=uIrhDN5isJRe75+pbxvjTSQ7dVLQq6JQggG89vLG2qYeRTRfOSqGpZdmPe+3065f2p
         E//nCLSbjxJXp3zLFbOCYRnYc5JnXSG5V+nMFXd5EOSDcRGGGy22f3e3BGPstwI733Fj
         +yu4AZccYXOtd9t9Bzj7r1OuwXUwhjbH6pr/fqBR+vhELeVVCpp4bkTiTqDfchnVnQxB
         HpDEHig47Wbans8fWQvfPHVT1TsG0pPknKnRLfGQP0CS/8fopFHgo179a1bYB20Y98N1
         DAkirfTEbcvBA+kXnAelOKOId7QOySo7/4AiqfxVDesWEZiG3FzLHCBqgBZ4iCylGJJc
         2jdg==
In-Reply-To: <20180108160846.GV3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Tejun,

On 01/08/2018 05:08 PM, Tejun Heo wrote:
> Hello, Michael.
> 
> On Fri, Dec 22, 2017 at 10:11:00AM +0100, Michael Kerrisk (man-pages) wrote:
>> I don't get the above. I mean, if we have the following hierarchy,
>> where R is the cgoup v2 mount point:
> 
> You're right, I'm probably confused with an earlier variant.  I might
> still be forgetting something in this area.  I'll ping back if I can
> recall something.

Okay -- if you do think of something, I'd be very happy to add it to
the man page.

>>> * Possible extension to threadmode.  If we figure out how to do mixed
>>>   mode further down in the hierarchy (and if there are actual use
>>>   cases which require that), automatically switching would be really
>>>   confusing.
>>>
>>> The invalid state while not the most convenient is straight forward
>>> (only the operations which are explicitly asked are performed) and
>>> keeps the door open for future changes.
>>
>> The "allowing for future" extensions idea makes some sense to me.
>>
>> One other point that occurred to me after I wrote my email yesterday
>> was that if the threaded root reverts from being "domain threaded" to
>> "domain" (because it no longer has "threaded" children AND either it
>> has no member processes or it has no threaded controllers enabled),
>> then the "domain invalid" descendants revert to type "domain". I'm not
>> sure whether that detail also provides some rationale as to why all
>> descendants of the threaded root cgroup aren't automatically converted
>> to type "threaded". Any thoughts about that?
> 
> Currently, thread mode implementation doesn't allow reverting back to
> domain.  The problem there is that it's impossible to tell which
> portions of the domain consumptions that are accounted to the threaded
> domain (the parent of threaded subtree) belong to the cgroup which is
> trying to revert to domain.
> 
> But assuming we in the future allow reverting back to domain,
> scenarios similar to what you suggested can become problematic.  All
> operations always behaving recursively will probably be the only sane
> solution but that blocks some possibilities for future changes.

I think I needed to be more explicit in my description of "reversion". 
I mean this situation, where we have written "threaded" to 
t1/t1-a/cgroup.type:

    t1 [dt]
        t1-a [t]
        t1-b [inv]
            t1-c [inv]

t1 is in the "domain threaded" state, and t1/t1-b and t1/t1-b/t1-c
are "domain invalid". If we now remove the t1/t1-a cgroup,
then the various other cgroups revert to type "domain":

    t1 [d]
        t1-b [d]
            t1-c [d]

And my point was that I wondered whether that had any relevance
in this discussion of why the "domain invalid" state exists.
Maybe it is irrelevant, but it just occurred to me that maybe it
is relevant.

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
