From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 thread mode
Date: Wed, 10 Jan 2018 23:18:48 +0100
Message-ID: <704d0cd5-0bab-f876-a09c-9d60e9d2ef93@gmail.com>
References: <b2d54ae2-62db-7402-ed99-7a0e72f90ff4@gmail.com>
 <20180109211000.GT3668920@devbig577.frc2.facebook.com>
 <5c9ea5dd-12dc-99d6-7905-40fdbc34e6ae@gmail.com>
 <20180110144708.GC3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=im9JH+XrreEMZPL1ao49RtqcxlUqIK+o3eBUA0duy8k=;
        b=XbjMWMoNftfauuaaJohMvZmA0+BnXCCV6eq+Eba6/7UpFQRkhVGuIg2iFM/nVNmVKu
         gab/rm6hRuCy/g9JZrBsEbhrV+E/s683+FFIDmueIOPT1Q2raXFru6FDGjOgYOMhFRhy
         sSFvY2UNPASlJL+kUMMby2UVwX2X51WDfnKot2eqNTlBdOSC2KDD8OTNowLoEVU1EX+0
         pk/v9w1OAQR2Qbv5k4ViEtpRBH9IxMqtaUn1eeyNtuCxqfB9lst3dPsas6//ramr2TvA
         wW9qel4QVnz2BUVz0BkMh6AhU4hsrwJWCb8abLvl2AYbZPxNxZx/l1lOSwDZdq260wO7
         WqKQ==
In-Reply-To: <20180110144708.GC3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Lauro Venancio <lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello Tejun,

On 01/10/2018 03:47 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 09, 2018 at 11:54:03PM +0100, Michael Kerrisk (man-pages) wrote:
>> One more thing. I added the following sentence to the text:
>>
>>        The  cgroup.threads file is writable only for the cgroups inside a
>>        threaded subtree.
>>
>> Can you confirm that that is correct, please.
> 
> The only extra restriction is that the domain cgroup must be the same
> for the source and destination, which is true for the entire threaded
> subtree (the threaded domain).  As each domain cgroup is its own
> unique domain, cgroup.threads in them would only allow migrating to
> self which is a noop; otherwise, it'd return -EOPNOTSUPP.

Ahh yes. Now I understand. I made the description of the containment
rules for cgroup.threads more explicit in the text:

       As with writing to cgroup.procs, some containment rules apply when
       writing to the cgroup.threads file:

       *  The  writer  must  have  write permission on the cgroup.threads
          file in the destination cgroup.

       *  The writer must have write permission on the cgroup.procs  file
          in  the  common ancestor of the source and destination cgroups.
          (In some cases, the common ancestor may be the source or desti‐
          nation cgroup itself.)

       *  The source and destination cgroups must be in the same threaded
          subtree.  (Outside a threaded subtree, an  attempt  to  move  a
          thread by writing its thread ID to the cgroup.threads in a dif‐
          ferent domain cgroup fails with the error EOPNOTSUPP.)

Okay? (I realize that the last bullet point is a rather different way of
formulating your idea that "the only extra restriction is that the domain
cgroup must be the same for the source and destination". But I think the
reformulation is easier to understand, no?)

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
