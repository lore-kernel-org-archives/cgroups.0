From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Tue, 9 Jan 2018 00:27:58 +0100
Message-ID: <6c9fdaee-739f-164d-d04e-fb3a7319db90@gmail.com>
References: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
 <20180108141450.GP3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZMnJRG6RP0OoRetQcE+cj19MPcUHgYhTadpc9eW8HJQ=;
        b=hn/j3jcczpWvfFAvc5sT3V1H4UoqxHdJ7AwjSer2VBoogOVi+baqjvUnNRdWg2uShH
         OsFSOJB88EYcQZyQ2PsI5wKz5K9m/qqPU8S9Bm1b6g7MD8k+Vv7EZzzCsPVBXuhZOuGJ
         dYsXQE4iY+pBqqpDfqrIPDfww2lGF7YfTFkhJS6M9pSzuDb2ndUfUWEOfwXFBNlAgyt6
         mVM8XPCRj5nNHbMsDVjrIyLIOwYEsbxMH4PvvcT19swlHgTDN7ZNkVZflttrimersqog
         XzIiUTPsTJFvFbjFIWDc3iped1+cRoGE+uRfy/JODT8YUiHES9dSKlMv2dk3C8NVDRq/
         5oGA==
In-Reply-To: <20180108141450.GP3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Hello Tejun,

On 01/08/2018 03:14 PM, Tejun Heo wrote:
> Hello, Michael.
> 
> On Tue, Jan 02, 2018 at 07:22:05PM +0100, Michael Kerrisk (man-pages) wrote:
>>        To perform delegation, the delegater makes certain  directories
>>        and  files writable by the delegatee, typically by changing the
>>        ownership of the objects to be the user ID  of  the  delegatee.
>>        Assuming that we want to delegate the hierarchy rooted at (say)
>>        /dlgt_grp and that there are not yet any  child  cgroups  under
>>        that  cgroup,  the ownership of the following is changed to the
>>        user ID of the delegatee:
>>
>>        /dlgt_grp
>>               Changing the ownership of the root of the subtree  means
>>               that  any new cgroups created under the subtree (and the
>>               files they contain) will also be owned by the delegatee.
>>
>>        /dlgt_grp/cgroup.procs
>>               Changing the ownership of this file means that the dele‐
>>               gatee  can move processes into the root of the delegated
>>               subtree.
>>
>>        /dlgt_grp/cgroup.subtree_control
>>               Making this file owned by  the  delegatee  is  optional.
>>               Doing  so  means that that the delegatee can enable con‐
>>               trollers  (that  are  present  in  /dlgt_grp/cgroup.con‐
>>               trollers)  in order to further redistribute resources at
>>               lower levels in  the  subtree.   As  an  alternative  to
>>               changing the ownership of this file, the delegater might
>>               instead add selected controllers to this file.
> 
> I'm not sure how useful it is to describe this to be optional.  In the
> same sense, cgroup.procs would be optional too as the delegatee can
> take control from its first children.  Users of course can choose to
> do mix and match as they see fit but outside of the defined model,
> there can be surprises - e.g. nsdelegate or some future delegation
> aware feature can behave differently.  I think it'd be better to keep
> it simple - either a subtree is delegated or not.

So, I changed that piece to:

       /dlgt_grp/cgroup.subtree_control
              Changing the ownership of this file  means  that  that  the
              delegatee  can  enable  controllers  (that  are  present in
              /dlgt_grp/cgroup.controllers) in order  to  further  redis‐
              tribute  resources  at lower levels in the subtree.  (As an
              alternative to changing the ownership  of  this  file,  the
              delegater  might  instead  add selected controllers to this
              file.)

Okay?

>>        The delegater should not change the ownership  of  any  of  the
>>        controller  interfaces  files  (e.g., pids.max, memory.high) in
>>        dlgt_grp.  Those files are used from the next level  above  the
>>        delegated  subtree  in  order  to distribute resources into the
>>        subtree, and the delegatee should not have permission to change
>>        the resources that are distributed into the delegated subtree.
> 
> Roman recently added /sys/kernel/cgroup/delegate and
> /sys/kernel/cgroup/features.  The former contains newline separated
> list of cgroup files which should be chowned on delegation (in
> addition to the directory itself) and the latter contains optional
> features (currently only nsdelegate).  

Oh -- and this reminds that I've been meaning to ask you for a while
now: could you please (please please please) CC all cgroup interface
changes to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (and prod others to do so
please). There have been many of these changes in recent times
(addition of new v2 controllers, thread mode, nsdelegate, the
changes that Roman made that you refer to above), and they really
all should have been CCed to linux-api@. It's often the only (easy)
way that I have to discover changes that should be documented in
the manual pages. And there are many other groups that are also
interested in tracking kernel-user-space interface changes; see 
https://www.kernel.org/doc/man-pages/linux-api-ml.html

> Roman, can you please update
> cgroup-v2.txt accordingly?

And I've already sent a separate mail re the cgroups(7) changes
relating to /sys/kernel/cgroup/*

> The file list was added because the cgroup OOM support added a knob
> which belongs to the cgroup itself rather than the parent and we might
> have more of those files in the future (not too likely and there won't
> be many).
> 
> It could be also worthwhile to describe nsdelegate, which prevents
> cgroup-namespaced delegatee, which may have the same UID as the
> delegator, from writing to interface files in its cgroup root which
> belong to the parent.

Yes. See my separate mail.

>>        Some delegation containment rules ensure that the delegatee can
>>        move processes between cgroups within  the  delegated  subtree,
>>        but  can't  move  processes  from outside the delegated subtree
>>        into the subtree or vice versa.  A nonprivileged process (i.e.,
>>        the  delegatee)  can write the PID of a "target" process into a
>>        cgroup.procs file only if all of the following are true:
>>
>>        *  The effective  UID  of  the  writer  (i.e.,  the  delegatee)
>>           matches  the  real  user  ID or the saved set-user-ID of the
>>           target process.
> 
> cgroup2 doesn't check the above anymore.

Please please see my request regarding linux-api@ :-)

I see the change was in 4.11, commit 576dd464505fc53d501bb94569db76f220104d28

I rewrote that rule as follows, and moved it to the end of the list (i.e.,
the point XXX below):

       *  Before Linux 4.11: the effective UID of the writer  (i.e.,  the
          delegatee) matches the real user ID or the saved set-user-ID of
          the target process.  (This was a historical requirement  inher‐
          ited  from  cgroups v1 that was later deemed unnecessary, since
          the other rules suffice for containment in cgroups v2.)

>>        *  The writer has write permission on the cgroup.procs file  in
>>           the destination cgroup.
>>
>>        *  The  writer has write permission on the cgroup.procs file in
>>           the common ancestor of the source and  destination  cgroups.
>>           (In  some  cases,  the  common ancestor may be the source or
>>           destination cgroup itself.)
>

> Also, if nsdelegate is enabled, both the source and destination
> cgroups must be visible (cgroup namespace-wise) to the writer.

I added the following:

       *  If  the  cgroup  v2  filesystem was mounted with the nsdelegate
          option, the writer must be able to see the source and  destina‐
          tion cgroup from its cgroup namespace.

Okay?

XXX

> 
>>           ┌─────────────────────────────────────────────────────┐
>>           │FIXME                                                │
>>           ├─────────────────────────────────────────────────────┤
>>           │Please confirm that the following is correct:        │
>>           └─────────────────────────────────────────────────────┘
>>
>>        Note: one consequence of these delegation containment rules  is
>>        that  the  unprivileged delegatee can't place the first process
>>        into the delegated subtree; instead, the delegater  must  place
>>        the  first  process (a process owned by the delegatee) into the
>>        delegated subtree.
> 
> Yeah, that'd be the case.  Seeding of a delegated subtree should be
> done by the delegator or before the priviledges are dropped.

Thanks for the confirmation.

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
