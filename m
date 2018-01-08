From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 delegation
Date: Mon, 8 Jan 2018 06:14:50 -0800
Message-ID: <20180108141450.GP3668920@devbig577.frc2.facebook.com>
References: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=c1J3BK0FhJqB94eceYpgoRvIa+Xy8AXoriQGGtelJM8=;
        b=nGROwUtuLjc7F70EdTUs4pKoWSXWzyZ7ObNPou6xFLuMroWdCKDBuMU77MdxC3TE+Z
         bQSDHCt5C+EYKDXq3Jw/fsgO18oKKiEkDAOfXOuLJkHdbSwOcRsNly31941nzeE9img2
         OTFtTXpxSdQlS/Nl3niSWta7WCFX+WL5bVSuHZUbZL3PIu0njCjb1fFCmsh/tx7u4F6c
         f7Mc3ws5tOVaXH1BtacTWDaJOhGeihf0IgFzoWraTlJ2zbv8VECwn08aQ0jLfuP3eD7I
         dOKfV7jIIJjiwsW2UpZsExlGWHaBH8MhXXGHR1uqWR3hI6fT1gT8CuYGUefY3edkbkPB
         drww==
Content-Disposition: inline
In-Reply-To: <1ce0a885-94fb-7480-7180-7b873c95b1bb-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Hello, Michael.

On Tue, Jan 02, 2018 at 07:22:05PM +0100, Michael Kerrisk (man-pages) wrote:
>        To perform delegation, the delegater makes certain  directories
>        and  files writable by the delegatee, typically by changing the
>        ownership of the objects to be the user ID  of  the  delegatee.
>        Assuming that we want to delegate the hierarchy rooted at (say)
>        /dlgt_grp and that there are not yet any  child  cgroups  under
>        that  cgroup,  the ownership of the following is changed to the
>        user ID of the delegatee:
> 
>        /dlgt_grp
>               Changing the ownership of the root of the subtree  means
>               that  any new cgroups created under the subtree (and the
>               files they contain) will also be owned by the delegatee.
> 
>        /dlgt_grp/cgroup.procs
>               Changing the ownership of this file means that the dele‐
>               gatee  can move processes into the root of the delegated
>               subtree.
> 
>        /dlgt_grp/cgroup.subtree_control
>               Making this file owned by  the  delegatee  is  optional.
>               Doing  so  means that that the delegatee can enable con‐
>               trollers  (that  are  present  in  /dlgt_grp/cgroup.con‐
>               trollers)  in order to further redistribute resources at
>               lower levels in  the  subtree.   As  an  alternative  to
>               changing the ownership of this file, the delegater might
>               instead add selected controllers to this file.

I'm not sure how useful it is to describe this to be optional.  In the
same sense, cgroup.procs would be optional too as the delegatee can
take control from its first children.  Users of course can choose to
do mix and match as they see fit but outside of the defined model,
there can be surprises - e.g. nsdelegate or some future delegation
aware feature can behave differently.  I think it'd be better to keep
it simple - either a subtree is delegated or not.

>        The delegater should not change the ownership  of  any  of  the
>        controller  interfaces  files  (e.g., pids.max, memory.high) in
>        dlgt_grp.  Those files are used from the next level  above  the
>        delegated  subtree  in  order  to distribute resources into the
>        subtree, and the delegatee should not have permission to change
>        the resources that are distributed into the delegated subtree.

Roman recently added /sys/kernel/cgroup/delegate and
/sys/kernel/cgroup/features.  The former contains newline separated
list of cgroup files which should be chowned on delegation (in
addition to the directory itself) and the latter contains optional
features (currently only nsdelegate).  Roman, can you please update
cgroup-v2.txt accordingly?

The file list was added because the cgroup OOM support added a knob
which belongs to the cgroup itself rather than the parent and we might
have more of those files in the future (not too likely and there won't
be many).

It could be also worthwhile to describe nsdelegate, which prevents
cgroup-namespaced delegatee, which may have the same UID as the
delegator, from writing to interface files in its cgroup root which
belong to the parent.

>        Some delegation containment rules ensure that the delegatee can
>        move processes between cgroups within  the  delegated  subtree,
>        but  can't  move  processes  from outside the delegated subtree
>        into the subtree or vice versa.  A nonprivileged process (i.e.,
>        the  delegatee)  can write the PID of a "target" process into a
>        cgroup.procs file only if all of the following are true:
> 
>        *  The effective  UID  of  the  writer  (i.e.,  the  delegatee)
>           matches  the  real  user  ID or the saved set-user-ID of the
>           target process.

cgroup2 doesn't check the above anymore.

>        *  The writer has write permission on the cgroup.procs file  in
>           the destination cgroup.
> 
>        *  The  writer has write permission on the cgroup.procs file in
>           the common ancestor of the source and  destination  cgroups.
>           (In  some  cases,  the  common ancestor may be the source or
>           destination cgroup itself.)

Also, if nsdelegate is enabled, both the source and destination
cgroups must be visible (cgroup namespace-wise) to the writer.

>           ┌─────────────────────────────────────────────────────┐
>           │FIXME                                                │
>           ├─────────────────────────────────────────────────────┤
>           │Please confirm that the following is correct:        │
>           └─────────────────────────────────────────────────────┘
> 
>        Note: one consequence of these delegation containment rules  is
>        that  the  unprivileged delegatee can't place the first process
>        into the delegated subtree; instead, the delegater  must  place
>        the  first  process (a process owned by the delegatee) into the
>        delegated subtree.

Yeah, that'd be the case.  Seeding of a delegated subtree should be
done by the delegator or before the priviledges are dropped.

Thanks.

-- 
tejun
