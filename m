From: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 09:25:10 -0800
Message-ID: <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org> <54F09E62.8000007@gmail.com> <20150227170640.GK3964@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        bh=p/x4/sx+Fqh9MX8qHeS44I+vO6SR55QBS8zgw8Syhes=;
        b=RJmcwShZni+l1Zg32BGp1gI/d34x3vTH5SNwn9zruYcomQ9eyNsGJ5Y+T0B1ZBdXiT
         wgUJVSAU1HT/FQyOve52YXYtORebiFBnDJLiUwY8/43XDmoescQpJ62lyewHJfsRaxbr
         270IH7w0ig1YczK4tJIDRhbb6EfbrSAMsNW91RZOhBz6dGJuTTYhGkkFNmlyaTFTYlB2
         HKTTL6OpAAMWRbi7mXxooerhTCePVvRt9dxcIO3F2Sl73lqAhu0Q7Ycr1IIEnI2vbGxK
         GoovVASLd8a6jsIHm6TU1EQ6JCuSzFEKai6+YGDZc/EI1KBRgDG091QPiT/Wm/r2ewuy
         bmdw==
In-Reply-To: <20150227170640.GK3964-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 27, 2015 at 9:06 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Fri, Feb 27, 2015 at 11:42:10AM -0500, Austin S Hemmelgarn wrote:
>> Kernel memory consumption isn't the only valid reason to want to limit the
>> number of processes in a cgroup.  Limiting the number of processes is very
>> useful to ensure that a program is working correctly (for example, the NTP
>> daemon should (usually) have an _exact_ number of children if it is
>> functioning correctly, and rpcbind shouldn't (AFAIK) ever have _any_
>> children), to prevent PID number exhaustion, to head off DoS attacks against
>> forking network servers before they get to the point of causing kmem
>> exhaustion, and to limit the number of processes in a cgroup that uses lots
>> of kernel memory very infrequently.
>
> All the use cases you're listing are extremely niche and can be
> trivially achieved without introducing another cgroup controller.  Not
> only that, they're actually pretty silly.  Let's say NTP daemon is
> misbehaving (or its code changed w/o you knowing or there are corner
> cases which trigger extremely infrequently).  What do you exactly
> achieve by rejecting its fork call?  It's just adding another
> variation to the misbehavior.  It was misbehaving before and would now
> be continuing to misbehave after a failed fork.
>
> In general, I'm pretty strongly against adding controllers for things
> which aren't fundamental resources in the system.  What's next?  Open
> files?  Pipe buffer?  Number of flocks?  Number of session leaders or
> program groups?

Yes to some or all of those.  We do exactly this internally and it has
greatly added to the stability of our overall container management
system.  and while you have been telling everyone to wait for kmemcg,
we have had an extra 3+ years of stability.

> If you want to prevent a certain class of jobs from exhausting a given
> resource, protecting that resource is the obvious thing to do.

I don't follow your argument - isn't this exactly what this patch set
is doing - protecting resources?

> Wasn't it like a year ago?  Yeah, it's taking longer than everybody
> hoped but seriously kmemcg reclaimer just got merged and also did the
> new memcg interface which will tie kmemcg and memcg together.

By my email it was almost 2 years ago, and that was the second or
third incarnation of this patch.

>> Something like this is long overdue, IMO, and is still more
>> appropriate and obvious than kmemcg anyway.
>
> Thanks for chiming in again but if you aren't bringing out anything
> new to the table (I don't remember you doing that last time either),
> I'm not sure why the decision would be different this time.

I'm just vocalizing my support for this idea in defense of practical
solutions that work NOW instead of "engineering ideals" that never
actually arrive.

As containers take the server world by storm, stuff like this gets
more and more important.

Tim
