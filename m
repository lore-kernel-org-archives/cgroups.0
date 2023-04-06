From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: Re: [PATCH v2] mm: oom: introduce cpuset oom
Date: Thu, 6 Apr 2023 10:30:32 +0200
Message-ID: <ZC6DKM4LDOVgohpj@dhcp22.suse.cz>
References: <20230404115509.14299-1-ligang.bdlg@bytedance.com>
 <ZCw0sR6IqYa5Es7Q@dhcp22.suse.cz>
 <e444e0ca-a2ff-37f2-1f1a-032b9fd63235@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680769833; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZeNqSzG1mQYY7oNWDAYbyb5M/J1jwCKa4/8IkPcpdUM=;
        b=OPlxBigt/AdMFlXcx2PJ6WGA+wGmXv+bmQ68bYLrqRs9qPOK7s+aRZanCqFOt6YaJT2TwF
        8aA6SU3YOAa/PyBql5sao/cuR4O6pegZ76h3FfogVS0l6vWiB0GDGaniQcocB1/x1ZYhoO
        8q88+KVJd6ZS/KTIGWmMGoiZ1jh/TGE=
Content-Disposition: inline
In-Reply-To: <e444e0ca-a2ff-37f2-1f1a-032b9fd63235-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 06-04-23 11:22:16, Gang Li wrote:
> 
> On 2023/4/4 22:31, Michal Hocko wrote:
> > [CC cpuset people]
> > 
> > The oom report should be explicit about this being CPUSET specific oom
> > handling so unexpected behavior could be nailed down to this change so I
> Yes, the oom message looks like this:
> 
> ```
> [   65.470256] oom-kill:constraint=CONSTRAINT_CPUSET,nodemask=(null),cpuset=test,mems_allowed=0,global_oom,task_memcg=/user.slice/user-0.slice/session-4.scope,task=memkiller,pid=1968,uid=0
> Apr  4 09:08:53 debian kernel: [   65.481992] Out of memory: Killed process
> 1968 (memkiller) total-vm:2099436kB, anon-rss:1971712kB, file-rss:1024kB,
> shmem-rss:0kB, UID:0 pgtables:3904kB oom_score_adj:0
> ```
> 
> 
> > do not see a major concern from the oom POV. Nevertheless it would be
> > still good to consider whether this should be an opt-in behavior. I
> > personally do not see a major problem because most cpuset deployments I
> > have seen tend to be well partitioned so the new behavior makes more
> > sense.
> > 
> 
> Since memcgroup oom is mandatory, cpuset oom should preferably be mandatory
> as well. But we can still consider adding an option to user.
> 
> How about introduce `/proc/sys/vm/oom_in_cpuset`?

As I've said, I do not see any major concern having this behavior
implicit, the behavior makes semantic sense and it is also much more
likely that the selected oom victim will be a better choice than what we
do currently. Especially on properly partitioned systems with large
memory consumers in each partition (cpuset).

That being said, I would just not add any sysctl at this stage and
rather document the decision. If we ever encounter usecase(s) which
would regress based on this change we can introcuce the sysctl later.

-- 
Michal Hocko
SUSE Labs
