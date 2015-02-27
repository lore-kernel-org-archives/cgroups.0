From: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 13:45:09 -0800
Message-ID: <CAAAKZwvuR2X7EEZz+UWRCGYajaJQ+VzXYfDEq6EQnssv9+6FJQ@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org> <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org> <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
 <20150227174503.GM3964@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        bh=613NaX5YrW0DaJJgRVJSMEa8dL8OxZ0w+fYtgEPT20U=;
        b=T0sIXQ92+F8wGVdjhNX5f5gNOnahlM5CMenboOBG3le2yl1zh2k/Ud+szWnan3nYVU
         +MKkfftIob+4EaEd6DhExdAnnvQ6oY8VNkdifbaBsf68DbKkmUuGmjFpytmiYzfBj/e+
         O/t/n+QxrUv6T27gClGcf1/6ofcntbY4f0sI+INmsNg1wifCHrTcu+YeQqAhFmYmczds
         9qj/THzZ3faxw9ZYKH6eDzdQ0m2ZlG1d5fum1JBCqur95+olwasgnAeDpqUwK8oiowOt
         E8kRSdUXPhGhrQO6t1KQo3+5wymzMTJFdgIrD/caFbgsWnOx1Eif/Wmr1ysP+kumdMHO
         kBOA==
In-Reply-To: <20150227174503.GM3964-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, mingo <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard <richard-/L3Ra7n9ekc@public.gmane.org>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 27, 2015 at 9:45 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Feb 27, 2015 at 09:25:10AM -0800, Tim Hockin wrote:
>> > In general, I'm pretty strongly against adding controllers for things
>> > which aren't fundamental resources in the system.  What's next?  Open
>> > files?  Pipe buffer?  Number of flocks?  Number of session leaders or
>> > program groups?
>>
>> Yes to some or all of those.  We do exactly this internally and it has
>> greatly added to the stability of our overall container management
>> system.  and while you have been telling everyone to wait for kmemcg,
>> we have had an extra 3+ years of stability.
>
> Yeah, good job.  I totally get why kernel part of memory consumption
> needs protection.  I'm not arguing against that at all.

You keep shifting the focus to be about memory, but that's not what
people are asking for.  You're letting the desire for a perfect
solution (which is years late) block good solutions that exist NOW.

>> > If you want to prevent a certain class of jobs from exhausting a given
>> > resource, protecting that resource is the obvious thing to do.
>>
>> I don't follow your argument - isn't this exactly what this patch set
>> is doing - protecting resources?
>
> If you have proper protection over kernel memory consumption, this is
> completely covered because memory is the fundamental resource here.
> Controlling distribution of those fundamental resources is what
> cgroups are primarily about.

You say that's what cgroups are about, but it's not at all obvious
that you are right.  What users, admins, systems people want is
building blocks that are usable and make sense.  Limiting kernel
memory is NOT the logical building block, here.  It's not something
people can reason about or quantify easily.  if you need to implement
the interfaces in terms of memory, go nuts, but making users think
liek that is just not right.

>> > Wasn't it like a year ago?  Yeah, it's taking longer than everybody
>> > hoped but seriously kmemcg reclaimer just got merged and also did the
>> > new memcg interface which will tie kmemcg and memcg together.
>>
>> By my email it was almost 2 years ago, and that was the second or
>> third incarnation of this patch.
>
> Again, I agree this is taking a while.  Memory people had to retool
> the whole reclamation path to make this work, which is the pattern
> being repeated across the different controllers - we're refactoring a
> lot of infrastructure code so that resource control can integrate with
> the regular operation of the kernel, which BTW is what we should have
> been doing from the beginning.
>
> If your complaint is that this is taking too long, I hear you, and
> there's a certain amount of validity in arguing that upstreaming a
> temporary measure is the better trade-off, but the rationale for nproc
> (or nfds, or virtual memory, whatever) has been pretty weak otherwise.

At least 3 or 4 people have INDEPENDENTLY decided this is what is
causing them pain and tried to fix it and invested the time to send a
patch says that it is actually a thing.  There exists a problem that
you are disallowing to be fixed.  Do you recognize that users are
experiencing pain?  Why do you hate your users? :)

> And as for the different incarnations of this patchset.  Reposting the
> same stuff repeatedly doesn't really change anything.  Why would it?

Because reasonable people might survey the ecosystem and say "humm,
things have changed over the years - isolation has become a pretty
serious topic".  or maybe they hope that you'll finally agree that
fixing the problem NOW is worthwhile, even if the solution is
imperfect, and that a more perfect solution will arrive.

>> >> Something like this is long overdue, IMO, and is still more
>> >> appropriate and obvious than kmemcg anyway.
>> >
>> > Thanks for chiming in again but if you aren't bringing out anything
>> > new to the table (I don't remember you doing that last time either),
>> > I'm not sure why the decision would be different this time.
>>
>> I'm just vocalizing my support for this idea in defense of practical
>> solutions that work NOW instead of "engineering ideals" that never
>> actually arrive.
>>
>> As containers take the server world by storm, stuff like this gets
>> more and more important.
>
> Again, protection of kernel side memory consumption is important.
> There's no question about that.  As for the never-arriving part, well,
> it is arriving.  If you still can't believe, just take a look at the
> code.

Are you willing to put a drop-dead date on it?  If we don't have
kmemcg working well enough to _actually_ bound PID usage and FD usage
by, say, June 1st, will you then accept a patch to this effect?  If
the answer is no, then I have zero faith that it's coming any time
soon - I heard this 2 years ago.  I believed you then.

I see further downthread that you said you'll think about it.  Thank
you.  Just because our use cases are not normal does not mean we're
not valid :)

Tim
