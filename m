From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Wed, 10 Jan 2018 23:01:11 +0100
Message-ID: <fdfc4c27-f87c-fab8-894c-f9f21374bab2@gmail.com>
References: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
 <20180108141450.GP3668920@devbig577.frc2.facebook.com>
 <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
 <20180109210722.GS3668920@devbig577.frc2.facebook.com>
 <672cd179-31be-e03a-f9ff-ce59b76e23e2@gmail.com>
 <20180110142640.GB3668920@devbig577.frc2.facebook.com>
 <655118da-6d58-8f02-7367-77c10a3c16ea@gmail.com>
 <20180110193907.GC3460072@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hDicol3mfbESr2Juw4aRlY8F8U1IChI1cjXTUI69RpU=;
        b=sOkIUcSLz+j7O+Ju06JH7cXrAPpH1pdtRIuWTFih8+PEoUFWU31uMIylncS9p3JfwR
         hFXO9qqRyZjBMYDx0E9OEquQlsdHNXXcWFX2pUdIMAAU3cAobaElXfRRiHvtbNIJQpTa
         vjXP1KU830UxkeWjvVPPwt9/V1W3FofFlzugz3nlwyXN/Ss8guGhzqm6NOGSaJu2pMMv
         zY4T08BiipuExB7xl+SdyJYpYTIZowzgVCiaUkiWXQCcq/OgFN11Q+u1oPKhsl6TMy2g
         hkiwAIpUGPSLWj3LmKlkZ4DFNiX2GWcXW/cRV+1wtSSvZSQAQenf98JfXfdVrIAgYf7R
         yR3A==
In-Reply-To: <20180110193907.GC3460072@devbig577.frc2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: mtk.manpages@gmail.com, "Serge E. Hallyn" <serge@hallyn.com>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hello Tejun,

On 01/10/2018 08:39 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jan 10, 2018 at 08:20:53PM +0100, Michael Kerrisk (man-pages) wrote:
>> On 01/10/2018 03:26 PM, Tejun Heo wrote:
>>> Hello, Michael.
>>>
>>> On Tue, Jan 09, 2018 at 11:48:11PM +0100, Michael Kerrisk (man-pages) wrote:
>>>>> That said, not necessarily an objection.  I'm just not sure about it.
>>>>
>>>> Okay. For the moment, I'll leave that text as is.
>>>>
>>>> I realized that there was also one more file that needs to be included
>>>> in the list of files that must be delegated:
>>>>
>>>>        /dlgt_grp/cgroup.threads
>>>>               Changing the ownership of  this  file  is  necessary  if  a
>>>>               threaded subtree is being delegated (see the description of
>>>>               "thread mode", below).
>>>>
>>>> Can you please confirm that it's only necessary to delegate this file
>>>> if we are delegating a threaded subtree?
>>>
>>> Replied on the other thread.  The file isn't delegatable as far as I
>>> can tell.
>>
>> So, following on from the discussion in the other thread, my
>> question above still stands.
> 
> Oh, I frankly haven't thought about delegating a threaded subtree.

I'm still confused. cgroup-v2.txt documents the possibility. You
wrote that text. We just had a conversation in another thread about the
fact that cgroup.threads is delegatable. You must have thought at 
least a little about this?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
