From: Peter Dolding <oiaohm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Single process controlling all cgroups sounds like looking in
 right direction but wrong solution.
Date: Mon, 15 Jul 2013 13:52:38 +1000
Message-ID: <CANA3KFXwM=sFy7=8EX9AHNxwAsnMW07YegC5rBASDv_Mroq2OQ@mail.gmail.com>
References: <CANA3KFV6LmfKYUo305Fo2Yv_0kJGSSa7OjnGi8BMb+0Ys9e8NA@mail.gmail.com>
	<20130715032551.GA3046@ac100>
	<CANA3KFWdKbrpZDHHsqKeh-vugK7NjJ1xrFcXyYSRaKn0mUYewg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        bh=G1excxn33DfeVVj0ia6Wyt8PF92xeNluZJZluoGtCYA=;
        b=aTktTFBW4JAPfvFgE4sFGWeLo/uiqCoxB1jo/t4uBj6r1d/LaQgPt2MTHWylhEHPB2
         Z5VFdqM2ZRl7AZiE7buISTtHfJE0IvMu7iLjgUycR+HmasT3/6ty97X999+4iV0FBYPi
         a7O1pj5gWVX7SqL3E4lCE7BNudVg5g1XG0vCJPaFFzVcTKaIreQjrN7TY8wJWrACEj4x
         tFB0atfmFP2V3MKL3aa7GeXMtc+9OK9pae0AlydKR0i6PD8ct0HgOLvgJdmKwK7tB3vW
         kUep7pbPdfewjdLh3kvpZqq2mno9mKi/mLINukfWSoT7acJSk6S8NX1qyitMl2p2Oe0w
         C5Ww==
In-Reply-To: <CANA3KFWdKbrpZDHHsqKeh-vugK7NjJ1xrFcXyYSRaKn0mUYewg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Sorry everyone I forgot Plain text this from google.   vger and its
hate of html.


On Mon, Jul 15, 2013 at 1:47 PM, Peter Dolding <oiaohm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> I followed the Maintainers File.  https://www.kernel.org/doc/linux/MAINTAINERS
> CONTROL GROUPS (CGROUPS)
> M: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> M: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> L: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> S: Maintained
> F: include/linux/cgroup*
> F: kernel/cgroup*
> F: mm/*cgroup*
>
>
> Apparently by your response this might be a bit out of date.  I just read lwm and Tejun Heo is not even as a main maintainer.  Listed as a sub part maintainer.   By the maintainers file discussions should be in containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org where I sent this.
>
> Tejun Heo please inform if this is still correct.  Its either update this or tell lwn.net to get your title correct in future.
>
> Serge I am trying to follow policy that is why I posted here in the first place.
>
> On Mon, Jul 15, 2013 at 1:25 PM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Hi Peter,
>>
>> Interesting topic.
>>
>> I think this issue is best discussed on the cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> mailing list.
>>
>> -serge
>>
>> Quoting Peter Dolding (oiaohm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
>> > NUMA is where the fun starts.   If I wish to adjust a group of processes
>> > bound only to a NUMA group of cpus.   It should not be required to disrupt
>> > other cpus.
>> >
>> > Init system controlling the cgroups is also sounding trouble.   Why we
>> > don't want to write like 1 000 000 different interfaces to talk to cgroups.
>> >
>> > Items like chromuim browser might wish to use cgroups in future to lets say
>> > contain flash.
>> >
>> > Best solution to the problems  not a library or in the init system its a
>> > form of userspace driver.
>> >
>> > The userspace driver has the permissions to alter and change cgroups and
>> > possible no right todo anything else in final form.
>> >
>> > Why not part of the init binary.   Lets say you have 1000 processors.
>> > And for some reason you are running something that tweaking cgroups a
>> > lot.   You don't want to stall all 1000 processes if it not required.
>> > Single process could cause this.   What ever in in change of the cgroups
>> > has to be massively multi threaded.    Also has to be changeable based on
>> > NUMA requirements of the system at times.   You don't want to have to be
>> > editing the core of init system or reboot the system just to change the
>> > cgroup management system to be more compatible with current hardware.  This
>> > is again why userspace driver.  You can stop the driver and start another
>> > one if required.   While still maintaining the rule of only 1 active at any
>> > 1 time.  If someone can load a kernel driver any how the can cause hell.
>> >
>> > Single process is not going to work because this will require stopping all
>> > cpus.   What is required is single processes/theads.
>> >
>> > Going the userspace driver solution emulation of the old cgroup system
>> > could be pushed into userspace.   So removing old code from the core and
>> > allow rejecting of hazard changes to be applied to the old method without
>> > having to update kernel every time.
>> >
>> > If there is an requirement to change the interface in future its less
>> > problem.
>> >
>> > If kbus (kernel dbus) was already done I would be tempted to place this as
>> > a default feature on the kbus.   This would not be dependant on any
>> > particular init system.
>> >
>> > Since kbus is not ready creating a text device to receive messages for now
>> > would be a suitable solution in my eyes.
>> >
>> > Peter Dolding
>> > _______________________________________________
>> > Containers mailing list
>> > Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>> > https://lists.linuxfoundation.org/mailman/listinfo/containers
>
>
