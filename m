From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Mon, 11 Dec 2017 07:32:58 -0800
Message-ID: <20171211153258.GI2421075@devbig577.frc2.facebook.com>
References: <CANaxB-zT+sz=z1FFk5npnwMySdfKCBZDkM+P+=JXDkCXbh=rCw@mail.gmail.com>
 <1511868946-23959-1-git-send-email-prsood@codeaurora.org>
 <623f214b-8b9a-f967-7a3d-ca9c06151267@codeaurora.org>
 <20171204202219.GF2421075@devbig577.frc2.facebook.com>
 <20171204225825.GP2421075@devbig577.frc2.facebook.com>
 <20171204230117.GF20227@worktop.programming.kicks-ass.net>
 <4e63b5e9-1696-910f-16ac-4d4d7eb98725@codeaurora.org>
 <40968aea-cd73-5ce4-d559-962d91e315c5@codeaurora.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WhlO/sEYEbRIi1Sec4410oomOqSi17srk7d455yZBV0=;
        b=EMafBbIHVRQk+SVGwraotpOdYcThgq7Oq3LGLR7ji0qpPFMlU7y2Dzi70VBLChZyN7
         +DELTAEaV1rcNONSvnPP3azDpVEAe+0hGmWq3XzWP/MS5GvVOv6zKo9LYD8lkk4C1nnO
         0115cmsESPFV/K3Sn4jbFpV6lDJiGxefiEuBU0IdTHiqTivY566C5G8hjIL3gWW0yKUQ
         EBOsmJBjZ/8P7t9h7mdg+3q2uIxJxyDsokzPQ0wWSXlkGFiBKgRNAnfJnwsWnJ10MI+X
         rIP5IsJkUafDoa1X9LosQOBxENLhMYtN7GwKlHeVDsHWkvy/naFXnKXy5jwF1jQ+u1Wn
         x+QA==
Content-Disposition: inline
In-Reply-To: <40968aea-cd73-5ce4-d559-962d91e315c5-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

Hello, Prateek.

On Fri, Dec 08, 2017 at 05:15:55PM +0530, Prateek Sood wrote:
> There is one deadlock issue during cgroup migration from cpu
> hotplug path when a task T is being moved from source to
> destination cgroup.
> 
> kworker/0:0
> cpuset_hotplug_workfn()
>    cpuset_hotplug_update_tasks()
>       hotplug_update_tasks_legacy()
>         remove_tasks_in_empty_cpuset()
>           cgroup_transfer_tasks() // stuck in iterator loop
>             cgroup_migrate()
>               cgroup_migrate_add_task()
> 
> In cgroup_migrate_add_task() it checks for PF_EXITING flag of task T.
> Task T will not migrate to destination cgroup. css_task_iter_start()
> will keep pointing to task T in loop waiting for task T cg_list node
> to be removed.

Heh, that's a bug in cgroup_transfer_tasks() which happened because I
forgot to update when we changed how we handle exiting tasks.  The
right thing to do here is making cgroup_transfer_tasks() repeat iff
there were a valid migration target which didn't get transferred.

Thanks.

-- 
tejun
