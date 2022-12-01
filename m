From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Thu, 1 Dec 2022 10:02:05 +0100
Message-ID: <Y4htjRAX1v7ZzC/z@dhcp22.suse.cz>
References: <E5A5BCC3-460E-4E81-8DD3-88B4A2868285@didiglobal.com>
 <5019F6D4-D341-4A5E-BAA1-1359A090114A@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669885325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLNRgcULxl39VgjFJbWNAjDoQ3yDDlm/yFmMG9HhK6M=;
        b=Ave28KB7tNiE9ZkiI7R4ytVUUUAZgkBbdNR7IQHcXtu89ZpGOoODAgfa8xscLtJtg0hMJJ
        6gquAn4cxI2y631J5knFx5hUq5LZS8Udhl8vNAHpi6IWv8yq74McDglEEoEtre9bBwt6TB
        9OFPwbsrQMhymA6Fhqf+pMPYOfRnQhE=
Content-Disposition: inline
In-Reply-To: <5019F6D4-D341-4A5E-BAA1-1359A090114A-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Cc: "roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Tao pilgrim <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ran.xiaokai-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org" <ran.xiaokai-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu 01-12-22 07:49:04, 程垲涛 Chengkaitao Cheng wrote:
> At 2022-12-01 07:29:11, "Roman Gushchin" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
[...]
> >The problem is that the decision which process(es) to kill or preserve
> >is individual to a specific workload (and can be even time-dependent
> >for a given workload). 
> 
> It is correct to kill a process with high workload, but it may not be the 
> most appropriate. I think the specific process to kill needs to be decided 
> by the user. I think it is the original intention of score_adj design.

I guess what Roman tries to say here is that there is no obviously _correct_
oom victim candidate. Well, except for a very narrow situation when
there is a memory leak that consumes most of the memory over time. But
that is really hard to identify by the oom selection algorithm in
general.
 
> >So it's really hard to come up with an in-kernel
> >mechanism which is at the same time flexible enough to work for the majority
> >of users and reliable enough to serve as the last oom resort measure (which
> >is the basic goal of the kernel oom killer).
> >
> Our goal is to find a method that is less intrusive to the existing 
> mechanisms of the kernel, and find a more reasonable supplement 
> or alternative to the limitations of score_adj.
> 
> >Previously the consensus was to keep the in-kernel oom killer dumb and reliable
> >and implement complex policies in userspace (e.g. systemd-oomd etc).
> >
> >Is there a reason why such approach can't work in your case?
> 
> I think that as kernel developers, we should try our best to provide 
> users with simpler and more powerful interfaces. It is clear that the 
> current oom score mechanism has many limitations. Users need to 
> do a lot of timed loop detection in order to complete work similar 
> to the oom score mechanism, or develop a new mechanism just to 
> skip the imperfect oom score mechanism. This is an inefficient and 
> forced behavior

You are right that it makes sense to address typical usecases in the
kernel if that is possible. But oom victim selection is really hard
without a deeper understanding of the actual workload. The more clever
we try to be the more corner cases we can produce. Please note that this
has proven to be the case in the long oom development history. We used
to sacrifice child processes over a large process to preserve work or
prefer younger processes. Both those strategies led to problems.

Memcg protection based mechanism sounds like an interesting idea because
it mimics a reclaim protection scheme but I am a bit sceptical it will
be practically useful. Most for 2 reasons. a) memory reclaim protection
can be dynamically tuned because on reclaim/refault/psi metrics. oom
events are rare and mostly a failure situation. This limits any feedback
based approach IMHO. b) Hierarchical nature of the protection will make
it quite hard to configure properly with predictable outcome.

-- 
Michal Hocko
SUSE Labs
