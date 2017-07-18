From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Show control files in cgroup2 root after mount
Date: Tue, 18 Jul 2017 16:12:29 -0400
Message-ID: <20170718201229.GD3365493@devbig577.frc2.facebook.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
 <20170718195148.GC3365493@devbig577.frc2.facebook.com>
 <539870d2-8b85-2f54-61bd-4ba068e75ce0@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wea47tv++VVFzlOP1LLyoQTa36gJaAZeQVttupwGo24=;
        b=jJdvJR/VyIV9ExeOFP6YFrzE/Hq5hpPa9Hf72IFJgULNWqvW6T3cQBfUMawOV1WTpB
         p5Cp9z6rzJcYRUaP5BJ1DEI31wFSy7O0zmHwkJYiYQRL8lxaT34DXunM/f4q4mcj2rT7
         5cbEa/T8gy0XsAqqObJnMPjxgiJDmAkRSebO6uhMBtYuX7gtNLuCjDnLcPX8PYcQIOIQ
         ACMSWutzrJ7ttV+nQJZlfAzHagnYlGe6nDQnspsOzAIhb2TF3/lkGC+g7GieWfuhy3rH
         gke1+3fp7vxuML1dVdzZ9YEU7lodUSsKpYeFjp3iaPU0LXwjIzT2MFGrWxyC7GyOWHE2
         oPTQ==
Content-Disposition: inline
In-Reply-To: <539870d2-8b85-2f54-61bd-4ba068e75ce0-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Jul 18, 2017 at 04:00:45PM -0400, Waiman Long wrote:
> From my own debugging, the controller files (e.g. the debug controller)
> were indirectly populated by the rebind_subsystems() call.
> 
> [    1.628103] css_populate_dir: init subsystem debug
...
> [    1.654975]  cgroup_apply_control_enable+0x103/0x340
> [    1.657719]  cgroup_apply_control+0x1a/0x30
> [    1.658521]  rebind_subsystems+0x18a/0x3b0
...

But there's kernfs_activate() call at the end of rebind_subsystems(),
so if the files were being added there, it should have been activated
there and I can confirm that the files are correctly added / removed
from the cgroup2 root directory when controllers are attached to /
detached from it.

> For the default cgroup2 root, kernfs_activate() was only called at the
> beginning in cgroup_init() with only the base cgroup files added. No
> more call after that until I touched the cgroup.subtree_control file.

Hmm... we're activating at the end of

* cgroup_setup_root()
* rebind_subsystems()
* cgroup_subtree_control_write()
* cgroup_apply_cftypes() after successful addition
* cgroup_mkdir()

I *think* this should cover everything.  Just in case, are you looking
at the mainline kernel?  Can you share how you can reproduce the
issue?

Thanks.

-- 
tejun
