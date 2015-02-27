From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 12:45:03 -0500
Message-ID: <20150227174503.GM3964@htj.duckdns.org>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/RnbN3c8xFuftlUMPtEXtyb9WN0oFXUOv6r/Fa+fRMU=;
        b=gCNWb9V3e2O3fiyA85ZPoQRLzOueARXt5gCbZ0zn6R6XjxVND16n4aUQINp00qvLpB
         i48dHdVkbEJvyVpqk19Osz/5Pkxqi0ynX0m1+oMExBlOrzl6c4aazAXFmiAFE4KEyZsG
         EIoT5yn/BuJuZ5DRAujN9+S/8OGOpUUXS/nE464FhGXHhhkE11mFAbCvTs7czVDRWsD7
         Ff+Ld0FBE4xpRwQVnyO8u2eNEgUSqVe90qKSekUv/Ah3IchUMOhb0g43WCVRLWSo2kz6
         1o2h9D2T/1qzv/BJDM43lX7XzIvchaE86DETx5uihQCyKt8xJfj7mGFyvI7q8CRKWBgB
         8shQ==
Content-Disposition: inline
In-Reply-To: <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin@hockin.org>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, Li Zefan <lizefan@huawei.com>, mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, richard@nod.at, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Feb 27, 2015 at 09:25:10AM -0800, Tim Hockin wrote:
> > In general, I'm pretty strongly against adding controllers for things
> > which aren't fundamental resources in the system.  What's next?  Open
> > files?  Pipe buffer?  Number of flocks?  Number of session leaders or
> > program groups?
> 
> Yes to some or all of those.  We do exactly this internally and it has
> greatly added to the stability of our overall container management
> system.  and while you have been telling everyone to wait for kmemcg,
> we have had an extra 3+ years of stability.

Yeah, good job.  I totally get why kernel part of memory consumption
needs protection.  I'm not arguing against that at all.

> > If you want to prevent a certain class of jobs from exhausting a given
> > resource, protecting that resource is the obvious thing to do.
> 
> I don't follow your argument - isn't this exactly what this patch set
> is doing - protecting resources?

If you have proper protection over kernel memory consumption, this is
completely covered because memory is the fundamental resource here.
Controlling distribution of those fundamental resources is what
cgroups are primarily about.

> > Wasn't it like a year ago?  Yeah, it's taking longer than everybody
> > hoped but seriously kmemcg reclaimer just got merged and also did the
> > new memcg interface which will tie kmemcg and memcg together.
> 
> By my email it was almost 2 years ago, and that was the second or
> third incarnation of this patch.

Again, I agree this is taking a while.  Memory people had to retool
the whole reclamation path to make this work, which is the pattern
being repeated across the different controllers - we're refactoring a
lot of infrastructure code so that resource control can integrate with
the regular operation of the kernel, which BTW is what we should have
been doing from the beginning.

If your complaint is that this is taking too long, I hear you, and
there's a certain amount of validity in arguing that upstreaming a
temporary measure is the better trade-off, but the rationale for nproc
(or nfds, or virtual memory, whatever) has been pretty weak otherwise.

And as for the different incarnations of this patchset.  Reposting the
same stuff repeatedly doesn't really change anything.  Why would it?

> >> Something like this is long overdue, IMO, and is still more
> >> appropriate and obvious than kmemcg anyway.
> >
> > Thanks for chiming in again but if you aren't bringing out anything
> > new to the table (I don't remember you doing that last time either),
> > I'm not sure why the decision would be different this time.
> 
> I'm just vocalizing my support for this idea in defense of practical
> solutions that work NOW instead of "engineering ideals" that never
> actually arrive.
> 
> As containers take the server world by storm, stuff like this gets
> more and more important.

Again, protection of kernel side memory consumption is important.
There's no question about that.  As for the never-arriving part, well,
it is arriving.  If you still can't believe, just take a look at the
code.

Thanks.

-- 
tejun
