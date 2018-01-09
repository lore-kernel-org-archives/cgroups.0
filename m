From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cgroups(7): documenting cgroups v2 thread mode
Date: Tue, 9 Jan 2018 23:52:57 +0100
Message-ID: <79c80f45-1290-c096-c384-6379b56d9239@gmail.com>
References: <b2d54ae2-62db-7402-ed99-7a0e72f90ff4@gmail.com>
 <20180109211000.GT3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yR94/5tKkpZd5fzNSZFAyfMubiCOFFWnc1rtDkL9Mo8=;
        b=tT+FsjfG84Qqcgpci1Rd2fc1xU7ceGVtWyeP8ZpPGaAoD/9E8LLYqon4CVKNDjvbWx
         mcAODxLNg7ZM1BVVw1QBLs3SAoIWva8da1MbkEgsUYnoCzVZL1KfbA7VkZARMoi/S+1r
         NT1lcsFkfrJ94QTphOIUgLV1Lt53vPwU+V9PQyb3FvAxTNLT2IJJBvOPZnVkZGjacq9s
         9E8oBt2BAVsqhlueQ5yhoM0hONCh8pXLvufqcPnS5fIE6px5ifyJptLJJYB9G2UTvy0+
         UvWqAUYId2PAkg2Mm63B6JDUK1Q0kwovtdXLUDFUXQqswAvF7XefvFa6jEagqJibrkn7
         Rpkw==
In-Reply-To: <20180109211000.GT3668920-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Lauro Venancio <lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 01/09/2018 10:10 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jan 02, 2018 at 07:24:01PM +0100, Michael Kerrisk (man-pages) wrote:
>>        2. We write the string "threaded" to each of the domain invalid
>>           cgroups  under  y,  in  order  to  convert  them to the type
>>           threaded.  As a consequence of this step, all threads  under
>>           the  threaded  root  now  have  the  type  threaded  and the
>>           threaded subtree is now fully usable.   The  requirement  to
>>           write  "threaded"  to each of these cgroups is somewhat cum‐
>>           bersome, but allows for possible future  extensions  to  the
>>           thread-mode model.
>>
>>           ┌─────────────────────────────────────────────────────┐
>>           │FIXME                                                │
>>           ├─────────────────────────────────────────────────────┤
>>           │Re  the preceding paragraphs... Are there other rea‐ │
>>           │sosn  for  the  (cumbersome)  requirement  to  write │
>>           │'threaded'  to  each of the cgroup.type files in the │
>>           │threaded subtrees? Tejun Heo mentioned  the  follow‐ │
>>           │ing:                                                 │
>>           │                                                     │
>>           │    Consistency w/ the cgroups right under the root  │
>>           │    cgroup.  Because they can be both domains and    │
>>           │    threadroots, we can't switch the children over   │
>>           │    to thread mode automatically.  Doing that for    │
>>           │    cgroups further down in the hierarchy would be   │
>>           │    really inconsistent.                             │
>>           │                                                     │
>>           │But,  it's  not  clear  to  me  how  "Doing that for │
>>           │cgroups further  down  in  the  hierarchy  would  be │
>>           │really inconsistent", since in the current implemen‐ │
>>           │tation, those same thread groups  are  converted  to │
>>           │"domain invalid" type.  What am I missing?           │
>>           └─────────────────────────────────────────────────────┘
> 
> Yeah, I was confused with an earlier varient where we were marking
> threaded domains instead of threaded roots.  It's mostly about future
> extensibility (especially as Waiman was proposing related changes
> there) and not doing things automatically / recursively if possible.

Okay.

> Looks good to me.

Thanks for the review.

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
