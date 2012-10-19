From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.7-fixes 1/2] Revert "cgroup: Remove
 task_lock() from cgroup_post_fork()"
Date: Fri, 19 Oct 2012 15:44:20 -0400
Message-ID: <CAFTL4hwQ6Ntn5GJwj=jiO2p3GdwhEMp0MyR8dgUj_Lx0U4kNqg@mail.gmail.com>
References: <20121008020000.GB2575@localhost>
	<20121019005922.GG13370@google.com>
	<CAFTL4hz82==b3ioSMhbKzh0CN1ivR7RQMKKMFFWu5PHPjg=Bfg@mail.gmail.com>
	<20121019193808.GL13370@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=9uv5A8v4wiudWrhEJfQ+q3itAodpoLhHi+jorEQ0wqk=;
        b=PJPsazfUGLd0gP+oS+6+Ip2VJKxuhWDNFK/QU0k8cEvoIjc7gbcgSx8AsvBvhSPFqW
         VBiDB9IrpMwT6WbZmz63Cxbx2NbOxaxTgC5mwJJDkf01t+rqUpGmMgurpbfCjTbhcgqp
         rz+9a7NbHRx9ZOQDDZ6wEnGFB/x3RM+1OOcCq8LuQN5ibCb5nfY6PizAX7lHs+hCra5N
         ipSZ/yo1SxcUT7eebQ3iWAolVZFcA3j+nmlsGL3ZmHeGdnXzSqlsHxYv5iiXJcP1LQIq
         p2a/2sZe3KAzvCIggp0+e99k6H55N8eHdnnnq2qvzWmFr+E61yDe+0H9bVbkjQBbp8SB
         sbag==
In-Reply-To: <20121019193808.GL13370-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

2012/10/19 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> On Fri, Oct 19, 2012 at 09:35:26AM -0400, Frederic Weisbecker wrote:
>> 2012/10/18 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
>> > From d935a5d6832a264ce52f4257e176f4f96cbaf048 Mon Sep 17 00:00:00 2001
>> > From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> > Date: Thu, 18 Oct 2012 17:40:30 -0700
>> >
>> > This reverts commit 7e3aa30ac8c904a706518b725c451bb486daaae9.
>> >
>> > The commit incorrectly assumed that fork path always performed
>> > threadgroup_change_begin/end() and depended on that for
>> > synchronization against task exit and cgroup migration paths instead
>> > of explicitly grabbing task_lock().
>> >
>> > threadgroup_change is not locked when forking a new process (as
>> > opposed to a new thread in the same process) and even if it were it
>> > wouldn't be effective as different processes use different threadgroup
>> > locks.
>> >
>> > Revert the incorrect optimization.
>>
>> Ok but there is still no good reason to task_lock() there. But the
>> comment is indeed wrong,  how about fixing it instead? I can send you
>> a patch for that.
>
> For -stable, I think it's better to revert.  If you want to remove
> task_lock, let's do it for 3.8.

I don't think that a wrong comment justifies a patch to stable.
