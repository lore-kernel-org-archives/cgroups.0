From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: Show control files in cgroup2 root after mount
Date: Tue, 18 Jul 2017 17:06:58 -0400
Message-ID: <20170718210658.GF3365493@devbig577.frc2.facebook.com>
References: <1500406336-29512-1-git-send-email-longman@redhat.com>
 <20170718195148.GC3365493@devbig577.frc2.facebook.com>
 <539870d2-8b85-2f54-61bd-4ba068e75ce0@redhat.com>
 <20170718201229.GD3365493@devbig577.frc2.facebook.com>
 <255cc198-2c10-af76-98ca-086807d11540@redhat.com>
 <20170718205009.GE3365493@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=StBcs/nAxlXljhXX0xUKEvnQ6P6ozIxXK+oPItE7VG8=;
        b=oLrX6IBtp4PCpQDE/phT+9Ux8Nnd3Mm0Tg6A7sB9jaAPE5Gp4uZ+UHK+KZSlq1Rr1C
         3VtfqS+Q/AHd29GPaZyL7czB8eLFgYf7YppHtZW0FIVpKCNziS3oP+qBsDgWDJWo8msr
         fvhhC6StSVFvewJ/L3v9YHBNsu0u+s+0Sp3LEiie7lRl3xmanb+1GqgrEUDb2VnXsamL
         ii/6L+AQGcFNipWeX9Eknx8WdWntsOpckq8eORs1CSLps5O2FYcwPtO0zsJVtBeGIDFf
         /TIfVTDTLmNR9t7xVK9k8rjEi4LvtZ7hcEJnUfzZaFpOnCqrzOTV63Tuqtqb4kZlV141
         Pklg==
Content-Disposition: inline
In-Reply-To: <20170718205009.GE3365493@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 18, 2017 at 04:50:10PM -0400, Tejun Heo wrote:
> Heh, I'm really confused.  If I do the same thing, I get the following
> result which makes sense as the files would be activated in
> cgroup_apply_cftypes() when the debug controller is registered during
> boot.
> 
>  # mkdir /cgroup2
>  # mount -t cgroup2 cgroup2 /cgroup2
>  # ls /cgroup2/
>  cgroup.controllers      debug.current_css_set
>  cgroup.procs            debug.current_css_set_cg_links
>  cgroup.subtree_control  debug.current_css_set_refcount
>  cgroup.threads          debug.masks
>  debug.csses             debug.taskcount
>  debug.css_links

Never mind.  I can repro after getting rid of some automatic umounts
from rc.local.  Will find out what went wrong.

Thanks!

-- 
tejun
