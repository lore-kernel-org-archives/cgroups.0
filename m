From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 0/4] fix depvpts in user namespaces
Date: Fri, 15 Mar 2013 19:26:54 +0400
Message-ID: <51433DBE.9020109@parallels.com>
References: <1363338823-25292-1-git-send-email-glommer@parallels.com> <87boalt0vi.fsf@xmission.com> <20130315140040.GB3782@sergelap> <5143333E.1040100@parallels.com> <20130315152133.GB24305@sergelap>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130315152133.GB24305@sergelap>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, mtk.manpages@gmail.com, Serge Hallyn <serge.hallyn@canonical.com>, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org

On 03/15/2013 07:21 PM, Serge Hallyn wrote:
> Quoting Glauber Costa (glommer@parallels.com):
>> On 03/15/2013 06:00 PM, Serge Hallyn wrote:
>>> Quoting Eric W. Biederman (ebiederm@xmission.com):
>>>> Glauber Costa <glommer@parallels.com> writes:
>>>>
>>>>> Hi,
>>>>>
>>>>> devpts mounts in user namespaces is queued for 3.9. However, while playing
>>>>> with it I found it to be less than ideal. Although it could possibly work
>>>>> with custom software that can be made to point to /dev/pts/ptmx, a few things
>>>>> prevent it from working correctly for people that, like us, are booting full
>>>>> distributions.
>>>>
>>>> Full distributions that have not been modified to be minimally container
>>>> aware.
>>>
>>> Right, in fact in this case it doesn't need to be minimally container
>>> aware, you just create the bind mount yourself and init just needs to
>>> accept that it shouldn't touch it.
>>>
>>
>> Well, what if it doesn't?
>>
>> At least in the system I am using, centos6, udev mounts a tmpfs in a
>> temporary location, and then mount --move this to /dev. This is now
>> empty, and devpts will be mounted ontop of that.
> 
> This also messes up your /dev/ttyN setup right?  How are you handling
> that?
> 
very simple: udev will just mknod everything back, so let him!

>> Let me reverse the question: If you bind mount /dev/pts and then udev
>> never touches it, etc, does my solution affects that in anyway? The way
>> I see it, we just become more capable of running legacy system without
>> giving nothing in return aside from code. And it is not even an
>> extremely complex code.
> 
> Right - I don't object to your patch, I just wanted to see if you and
> Eric could agree on which one to use.  After that I'll do a closer
> review - but on first look it looked good to me.
> 

As I said, as far as the specific part of the puzzle concerning the
/dev/ptmx to /dev/pts/ptmx mapping, I am fine with whatever works.

>>>>> One of the problems that I am addressing in here is that we are disallowing
>>>>> mknod in usernamespaces. Although I understand the motivation for that, I
>>>>> believe that to be too restrictive, specially because we already control access
>>>>> to the files separately. There should be no harm in mknod'ing something per se,
>>>>> if manipulating it is forbidden.
>>>>
>>>> mknod in userspace needs to be a separate patchset.  There is no need to
>>>> solve mknod in userspace to solve devpts.
>>>>
>>>>
>>>>> Last, /dev/ptmx will still always be the global ptmx device. We need to somehow
>>>>> link it to our namespaces'. My proposal is to multiplex it and return the
>>>>> correct "root ptmx" depending on which userns is reading that device.
>>>>
>>>> Doable.  I still strongly prefer my version of having /dev/ptmx act like
>>>> a link to /dev/pts/ptmx.  Letting the mount namespace control it.
>>>
>>> Right, Glauber have you seen this patch?  Eric did already solve this.
>>> (And again that's a nice safeguard, but it shouldn't be necessary)
>>>
>> No. Where was that sent to?
>>
>> If you can point me to it, I am of course willing to test it. If it
>> solves my problem (the description suggests that there is high
>> probability), then I have no particular attachments to my specific solution.
> 
> Well shoot, I can't find it right now.  Not even in Eric's git tree.
> IIRC upon lookup of /dev/pts it tried to find $rootfs/dev/pts/ptmx
> and open that instead.
>
Which gives a very good explanation about why haven't I seen it =)
Eric ?

What it a /dev/ptmx already exist? will it use it? That would be bad,
since that /dev/ptmx could be a host-side one. I actually believe
linking to $rootfs/dev/pts/ptmx is more robust than my solution against
remounts. So provided it can guarantee that the ptmx is not ever the
root ptmx, I would ack that.

