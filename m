From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Tue, 9 Jan 2018 23:48:11 +0100
Message-ID: <672cd179-31be-e03a-f9ff-ce59b76e23e2@gmail.com>
References: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
 <20180108141450.GP3668920@devbig577.frc2.facebook.com>
 <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
 <20180109210722.GS3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uwCNlqmNr1rxucXGCF9rsvWYWt+JNs7ncQoAUOv+lJk=;
        b=EgUhvGCtl0B2Z72sdNUr5nyf8dT8Z3TfCJevdwKmOSi3uGK2F1kSMgqsu3dEtAkm/M
         /TRRoc3ykEZe20DRN4UFQRhy4ryPvmR02sOYrjfSLA76IYnrIKA6xpXxeiobi3YhSt9a
         MlDU3kbfyVwif0LSqyh3j444dgj30xJw789COMjyFRRvcQ7HmROGLxb0xhxN6E33gTsQ
         d7Ynn9++2iYwIvy380Gg14PtC0S6KhgmNhhf0JBa/uNuSFFqK5lbKckHkyL6iIxX8Wzi
         vxyUjADF76uyDnPKbSqHKKw3X8CNYrSFkEzmAg/MoO6Jdp2kWOe8h9S9etoGhl5ILz77
         /pig==
In-Reply-To: <20180109210722.GS3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Hello Tejun,

On 01/09/2018 10:07 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 09, 2018 at 12:27:58AM +0100, Michael Kerrisk (man-pages) wrote:
>>>>        /dlgt_grp/cgroup.subtree_control
>>>>               Making this file owned by  the  delegatee  is  optional.
>>>>               Doing  so  means that that the delegatee can enable con‐
>>>>               trollers  (that  are  present  in  /dlgt_grp/cgroup.con‐
>>>>               trollers)  in order to further redistribute resources at
>>>>               lower levels in  the  subtree.   As  an  alternative  to
>>>>               changing the ownership of this file, the delegater might
>>>>               instead add selected controllers to this file.
>>>
>>> I'm not sure how useful it is to describe this to be optional.  In the
>>> same sense, cgroup.procs would be optional too as the delegatee can
>>> take control from its first children.  Users of course can choose to
>>> do mix and match as they see fit but outside of the defined model,
>>> there can be surprises - e.g. nsdelegate or some future delegation
>>> aware feature can behave differently.  I think it'd be better to keep
>>> it simple - either a subtree is delegated or not.
>>
>> So, I changed that piece to:
>>
>>        /dlgt_grp/cgroup.subtree_control
>>               Changing the ownership of this file  means  that  that  the
>>               delegatee  can  enable  controllers  (that  are  present in
>>               /dlgt_grp/cgroup.controllers) in order  to  further  redis‐
>>               tribute  resources  at lower levels in the subtree.  (As an
>>               alternative to changing the ownership  of  this  file,  the
>>               delegater  might  instead  add selected controllers to this
>>               file.)
>>
>> Okay?
> 
> I haven't thought much about not giving out cgroup.subtree_control
> when delegating.  It's probably okay but there can be surprises -
> e.g. systemd or other agent failing to init resource control because
> it failed to write to subtree_control at root.
> 
> Also, given that the recommended way to delegate is now chown all
> files in the /sys/kernel/cgroup/delegate file it's a bit weird to
> single out subtree_control.

I guess the point here is that it really makes no sense not to
change ownership of cgroup.procs. On the other hand, if
ownership of cgroup.subtree_control is not handed to the
delegatee, then the delegater can choose which controllers the
delegatee will be allowed to exercise, by writing only those
controllers into cgroup.subtree_control. I'm not sure if
there's a use case though.

> That said, not necessarily an objection.  I'm just not sure about it.

Okay. For the moment, I'll leave that text as is.

I realized that there was also one more file that needs to be included
in the list of files that must be delegated:

       /dlgt_grp/cgroup.threads
              Changing the ownership of  this  file  is  necessary  if  a
              threaded subtree is being delegated (see the description of
              "thread mode", below).

Can you please confirm that it's only necessary to delegate this file
if we are delegating a threaded subtree?

>>> Roman recently added /sys/kernel/cgroup/delegate and
>>> /sys/kernel/cgroup/features.  The former contains newline separated
>>> list of cgroup files which should be chowned on delegation (in
>>> addition to the directory itself) and the latter contains optional
>>> features (currently only nsdelegate).  
>>
>> Oh -- and this reminds that I've been meaning to ask you for a while
>> now: could you please (please please please) CC all cgroup interface
>> changes to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (and prod others to do so
>> please). There have been many of these changes in recent times
>> (addition of new v2 controllers, thread mode, nsdelegate, the
>> changes that Roman made that you refer to above), and they really
>> all should have been CCed to linux-api@. It's often the only (easy)
>> way that I have to discover changes that should be documented in
>> the manual pages. And there are many other groups that are also
>> interested in tracking kernel-user-space interface changes; see 
>> https://www.kernel.org/doc/man-pages/linux-api-ml.html
> 
> Sorry about having not added them before.  Will try to.  Please feel
> free to scream at me if I forget.

Okay. (Except I may not not e when you forget ;-).)
 
>>> Also, if nsdelegate is enabled, both the source and destination
>>> cgroups must be visible (cgroup namespace-wise) to the writer.
>>
>> I added the following:
>>
>>        *  If  the  cgroup  v2  filesystem was mounted with the nsdelegate
>>           option, the writer must be able to see the source and  destina‐
>>           tion cgroup from its cgroup namespace.
>>
>> Okay?
> 
> Yeah, thanks.

Thanks for checking the text, Tejun!

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
