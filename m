From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.7-fixes 1/2] Revert "cgroup: Remove
 task_lock() from cgroup_post_fork()"
Date: Fri, 19 Oct 2012 12:38:08 -0700
Message-ID: <20121019193808.GL13370@google.com>
References: <20121008020000.GB2575@localhost>
 <20121019005922.GG13370@google.com>
 <CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OxJ48azkUFPBDEslBG2bKztV/iO+rU4nTJbss0WIy60=;
        b=BnPMQ4tuQctxtEzy6lw/adXgoKSdkjDCnJd6W/PONGseM8O0Tq2yeXmtBqmCBAlIaQ
         PQ603LRbBcF2Vjv+V8PLM/i9NU6NVL8SPRZbd/fmKdHV0+F3kBErN09zX/V7hTyWtDEH
         5bMjlHUtdZHLJ1CG5zOLUe17EWB7JoSwFu5EAUese3iFJhr1yX/Yh5w237aXnvTstCiy
         G0RCxmHbaZtYjjmwHwz6BF5CRtewtFE6fMUZBpwDV2TZfWOKPGMxhNTVXcSB4/6sGsah
         2spu7eSbx9gLjfEyqKRHncYbhz+UdgtyopTHFec3yePxVst51Bh1KVPKpY9SxRr7/4Ib
         EDmA==
Content-Disposition: inline
In-Reply-To: <CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 19, 2012 at 09:35:26AM -0400, Frederic Weisbecker wrote:
> 2012/10/18 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > From d935a5d6832a264ce52f4257e176f4f96cbaf048 Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Date: Thu, 18 Oct 2012 17:40:30 -0700
> >
> > This reverts commit 7e3aa30ac8c904a706518b725c451bb486daaae9.
> >
> > The commit incorrectly assumed that fork path always performed
> > threadgroup_change_begin/end() and depended on that for
> > synchronization against task exit and cgroup migration paths instead
> > of explicitly grabbing task_lock().
> >
> > threadgroup_change is not locked when forking a new process (as
> > opposed to a new thread in the same process) and even if it were it
> > wouldn't be effective as different processes use different threadgroup
> > locks.
> >
> > Revert the incorrect optimization.
> 
> Ok but there is still no good reason to task_lock() there. But the
> comment is indeed wrong,  how about fixing it instead? I can send you
> a patch for that.

For -stable, I think it's better to revert.  If you want to remove
task_lock, let's do it for 3.8.

Thanks.

-- 
tejun
