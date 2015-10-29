From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4] cgroup: fix race condition around
 termination check in css_task_iter_next()
Date: Thu, 29 Oct 2015 12:02:17 +0900
Message-ID: <20151029030217.GC27115@mtj.duckdns.org>
References: <20151027084504.GB8783@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=axIDa/pIbh6MaEJcDeArwwYYjUhsqpmVwUxvS3vETnU=;
        b=MFMntAy7F8Yr0Q33nsItGybITe7ZVaYD+dqFWL6Mf7xoBIxRIoHXyAJLA3XadwAq/q
         5qygyyLja5ai+D2jHSatfbjEQniEgMupiKFxQ68zm32sNIJK610f8ou0xOEHHFzuQX4N
         NXeHAX+UbnZmaUIPH3wktNXM+G8W2g4cDTdWpTDZFcvVT9FxR6n7juJcUkuLc+fR/CsO
         RkgJjdLd4f9wjDbrrTHV+YqBOagckoCESn50qPu+Ffnvs9wY26mUHE7UOiluW2b3XpYk
         /P+Rn6IwBx9CuunsCpak6t7Iu/fR3fgtJ61indMtHM3OqxGZjWdLSoLfizSuHX36bzSJ
         3dag==
Content-Disposition: inline
In-Reply-To: <20151027084504.GB8783-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Oct 27, 2015 at 05:45:04PM +0900, Tejun Heo wrote:
> css_task_iter_next() checked @it->cur_task before grabbing
> css_set_lock and assumed that the result won't change afterwards;
> however, tasks could leave the cgroup being iterated terminating the
> iterator before css_task_lock is acquired.  If this happens,
> css_task_iter_next() tries to calculate the current task from NULL
> cg_list pointer leading to the following oops.

Applied to cgroup/for-4.4.  Thanks.

-- 
tejun
