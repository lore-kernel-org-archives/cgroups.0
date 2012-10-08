From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Date: Mon, 8 Oct 2012 15:57:52 +0900
Message-ID: <20121008065752.GA5931@localhost>
References: <20121008020000.GB2575@localhost>
 <20121008020138.GA4188@localhost>
 <507268AA.8050509@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0txKvZclusWiZEmww33On82N6DQqsDxEVIEtiopcg7k=;
        b=yUaqog5GEntZKjF7BGSL251I9TCSuzjTXHO6xcWQiZ16qNCfi4aphRXkw9R05I9lQv
         pVEmHXEuolM0pZ/lzNkyZ3xELrf+3/ffedH5xVBNC5riC52v/p53AM26N8TFVROVjibo
         e+XRdvW9W3QdTKyG3Lfb8YV8Im4Mq0HbQYSADcEUtYQRSwE/atOtUAdFltkmS/Fa33VM
         e4NCac71BN9BEo3wGcN2UwYaOXU7uckry4nVH9512hjLJHiTR0x1UCle0719UtYh1u/B
         OmQVLKCwK6sGcBEyLZtE4dRf/KWQzCmztNa8Ce4OlpxD0SeuV6p7KnwArItVg+GtgBuR
         4nyw==
Content-Disposition: inline
In-Reply-To: <507268AA.8050509-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Li, Frederic.

On Mon, Oct 08, 2012 at 01:46:18PM +0800, Li Zefan wrote:
> You're right. threadgroup lock is held unconditionally in attach_task_py_pid(),
> but it's held only for CLONE_THREAD in fork path, which I guess I overlooked
> when reviewing the patch.
> 
> > Also, please note that task_lock is likely to be hot on local CPU at
> > that point and avoiding it there might not really buy much.
> 
> Reverting that commit should be fine.

There are other commits which perform similar optimization

 7e3aa30ac8 ("cgroup: Remove task_lock() from cgroup_post_fork()")
 c84cdf75cc ("cgroup: Remove unnecessary task_lock before fetching css_set on migration")

Are they wrong too?

Thanks.

-- 
tejun
