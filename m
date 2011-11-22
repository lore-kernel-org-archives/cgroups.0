From: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Date: Tue, 22 Nov 2011 07:39:48 -0800
Message-ID: <20111122153948.GE322@google.com>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
 <20111121230709.GR25776@google.com>
 <4ECB06D2.6060106@cn.fujitsu.com>
 <20111122022118.GT25776@google.com>
 <20111122090522.GA26768@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BHVsgBLz5BnoLTD/VkBaMB5PYI0ZQA59WA1HjsVaIy0=;
        b=kosUuYDtMPPtjJ6UyvFPSUlfEAmBJeYWO+0rVHc2+GN3WlJBjpkPhjTpgXFmFt4FnQ
         64rw2UHurGnKCs/390+cv41ooMfGg5fiaDZnng8l0/QzFNB1ZzRBl11jNYFI6VUDOsXA
         99X+jB/TugKwR1HCXoI9Kif21kh+eH67v+QUQ=
Content-Disposition: inline
In-Reply-To: <20111122090522.GA26768-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Tomasz Buchert <tomasz.buchert-MZpvjPyXg2s@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Michal.

On Tue, Nov 22, 2011 at 10:05:22AM +0100, Michal Hocko wrote:
> I am not sure which BUG_ON you have in mind.
> update_if_frozen:
> 	BUG_ON(nfrozen != ntotal);

Heh, try to put a kthread into the cgroup and freeze it. :)

> From aba1042a96b6e79e0b14e3c397389389c9e2f522 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Date: Wed, 16 Nov 2011 22:38:42 +0100
> Subject: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
> 
> 2d3cbf8b (cgroup_freezer: update_freezer_state() does incorrect state
> transitions) removed is_task_frozen_enough and replaced it with a simple
> frozen call. This, however, breaks freezing for a group with stopped tasks
> because those cannot be frozen and so the group remains in CGROUP_FREEZING
> state (update_if_frozen doesn't count stopped tasks) and never reaches
> CGROUP_FROZEN.
> 
> Let's add is_task_frozen_enough back and use it at the original locations
> (update_if_frozen and try_to_freeze_cgroup). Semantically we consider
> stopped tasks as frozen enough so we should consider both cases when
> testing frozen tasks.
> 
> Testcase:
> mkdir /dev/freezer
> mount -t cgroup -o freezer none /dev/freezer
> mkdir /dev/freezer/foo
> sleep 1h &
> pid=$!
> kill -STOP $pid
> echo $pid > /dev/freezer/foo/tasks
> echo FROZEN > /dev/freezer/foo/freezer.state
> while true
> do
>         cat /dev/freezer/foo/freezer.state
>         [ "`cat /dev/freezer/foo/freezer.state`" = "FROZEN" ] && break
>         sleep 1
> done
> echo OK
> 
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Tomasz Buchert <tomasz.buchert-MZpvjPyXg2s@public.gmane.org>
> Cc: Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>
> Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applying to cgroup/for-3.2-fixes.

Thank you.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
