From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Tue, 9 Jan 2018 13:07:22 -0800
Message-ID: <20180109210722.GS3668920@devbig577.frc2.facebook.com>
References: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
 <20180108141450.GP3668920@devbig577.frc2.facebook.com>
 <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Es5arYpq4kyTzpNMcJoF46amnce7spyvT7gMX5wLM5Y=;
        b=D6W2cx5T3VsvQZlVnaHdizCK809q0H1WCuQv+jjOjNIWslpb9ACa0RRkkLzNJr9vDi
         fZ/eo2h7GjM/8PCd/GqSlc4zRnBpPWc0EyPmt+8egpW6bgConQYdT8urMyIoK3JMW3tX
         2hAD/E3Nt1FDBD3wa+21sC5cJYEPK5Zt/L0GKxV/h3mwbCovaHoA5f2+GThEHMi/WN3f
         /Aee/Gw192PXunjgZIvGe/wOADzvwai/+sDzDQaYwBFWJgd5wT34BLP3kEDqbHiu1tRP
         fxfLJYXn0THGHu4Tn3BfP2YbnsCdDizBMJVK4Ag7Q04OGeHt6bA6Z/2Kr/99EV2CiNCG
         XnpQ==
Content-Disposition: inline
In-Reply-To: <6c9fdaee-739f-164d-d04e-fb3a7319db90-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Hello,

On Tue, Jan 09, 2018 at 12:27:58AM +0100, Michael Kerrisk (man-pages) wrote:
> >>        /dlgt_grp/cgroup.subtree_control
> >>               Making this file owned by  the  delegatee  is  optional.
> >>               Doing  so  means that that the delegatee can enable con‐
> >>               trollers  (that  are  present  in  /dlgt_grp/cgroup.con‐
> >>               trollers)  in order to further redistribute resources at
> >>               lower levels in  the  subtree.   As  an  alternative  to
> >>               changing the ownership of this file, the delegater might
> >>               instead add selected controllers to this file.
> > 
> > I'm not sure how useful it is to describe this to be optional.  In the
> > same sense, cgroup.procs would be optional too as the delegatee can
> > take control from its first children.  Users of course can choose to
> > do mix and match as they see fit but outside of the defined model,
> > there can be surprises - e.g. nsdelegate or some future delegation
> > aware feature can behave differently.  I think it'd be better to keep
> > it simple - either a subtree is delegated or not.
> 
> So, I changed that piece to:
> 
>        /dlgt_grp/cgroup.subtree_control
>               Changing the ownership of this file  means  that  that  the
>               delegatee  can  enable  controllers  (that  are  present in
>               /dlgt_grp/cgroup.controllers) in order  to  further  redis‐
>               tribute  resources  at lower levels in the subtree.  (As an
>               alternative to changing the ownership  of  this  file,  the
>               delegater  might  instead  add selected controllers to this
>               file.)
> 
> Okay?

I haven't thought much about not giving out cgroup.subtree_control
when delegating.  It's probably okay but there can be surprises -
e.g. systemd or other agent failing to init resource control because
it failed to write to subtree_control at root.

Also, given that the recommended way to delegate is now chown all
files in the /sys/kernel/cgroup/delegate file it's a bit weird to
single out subtree_control.

That said, not necessarily an objection.  I'm just not sure about it.

> > Roman recently added /sys/kernel/cgroup/delegate and
> > /sys/kernel/cgroup/features.  The former contains newline separated
> > list of cgroup files which should be chowned on delegation (in
> > addition to the directory itself) and the latter contains optional
> > features (currently only nsdelegate).  
> 
> Oh -- and this reminds that I've been meaning to ask you for a while
> now: could you please (please please please) CC all cgroup interface
> changes to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (and prod others to do so
> please). There have been many of these changes in recent times
> (addition of new v2 controllers, thread mode, nsdelegate, the
> changes that Roman made that you refer to above), and they really
> all should have been CCed to linux-api@. It's often the only (easy)
> way that I have to discover changes that should be documented in
> the manual pages. And there are many other groups that are also
> interested in tracking kernel-user-space interface changes; see 
> https://www.kernel.org/doc/man-pages/linux-api-ml.html

Sorry about having not added them before.  Will try to.  Please feel
free to scream at me if I forget.

> > Also, if nsdelegate is enabled, both the source and destination
> > cgroups must be visible (cgroup namespace-wise) to the writer.
> 
> I added the following:
> 
>        *  If  the  cgroup  v2  filesystem was mounted with the nsdelegate
>           option, the writer must be able to see the source and  destina‐
>           tion cgroup from its cgroup namespace.
> 
> Okay?

Yeah, thanks.

-- 
tejun
