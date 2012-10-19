From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Date: Thu, 18 Oct 2012 17:38:35 -0700
Message-ID: <20121019003835.GE13370@google.com>
References: <20121008020000.GB2575@localhost>
 <CAFTL4hzXWtzp7megsCAEuak5=_2SWmp9age-+wrpyQAU4BRZ0w@mail.gmail.com>
 <20121016193341.GD16166@google.com>
 <CAFTL4hzo_w7HTgC9ApTk113X8WdZSpV+D+VSEe=604YEJFmKsg@mail.gmail.com>
 <20121018200705.GG13370@google.com>
 <CAFTL4hy7g4e11OUOyoihrEU8hiVgZoV1=141UtUpj9a72SNs_Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eTk3L9JwO/0D22ocx5QYNXoi9RZnE3C9NNWzJJbTzF8=;
        b=wRewKOMAVg2Fi5sKzxpLRv18HxVP+MnOUKwqegYihqjl8F0wDu2m1r5EAAzynX/ByR
         ieTO/a0Xn4TKRkLXXZKZdrRCO0r4SKeOVxyjXYu1ASLTMGGeiomyRrkk5x+hEmtL1LiS
         vgrn9nCpbG2wkXWZDimVf9ac9LJEV7E5U7h86YLoKAoesERp3hTgFf6cDs8BXNoty8bb
         fTHPtB0Za0By6LdS890oCVutBeGfGGnpXJIodO+N5+h4QuDymQhmpKgQ4kXEw7n6f0Md
         7u+hvmPLunVeWmTq2UnQwGc3cDV3Qal0pAqiFuzgdwjBpufcuefoiLllAc+LAmc15+Qy
         oHAg==
Content-Disposition: inline
In-Reply-To: <CAFTL4hy7g4e11OUOyoihrEU8hiVgZoV1=141UtUpj9a72SNs_Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Frederic.

On Thu, Oct 18, 2012 at 10:53:47PM +0200, Frederic Weisbecker wrote:
> > For now, I'll revert the patches and cc stable.  Let's think about
> > improving it later.
> 
> Ok for reverting in cgroup_fork(). Is it necessary for the
> cgroup_post_fork() thing? I don't immediately see any race involved
> there.

Even if there isn't an actual race, the comment is dead wrong.  I'm
reverting the following three patches.  Let's try again later.

  7e381b0eb1 ("cgroup: Drop task_lock(parent) on cgroup_fork()")
  7e3aa30ac8 ("cgroup: Remove task_lock() from cgroup_post_fork()")
  c84cdf75cc ("cgroup: Remove unnecessary task_lock before fetching css_set on migration")

Thanks.

-- 
tejun
