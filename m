From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Date: Mon, 8 Oct 2012 14:58:13 +0200
Message-ID: <CAFTL4hxWhS7xSWTAd0jguTcxoakzZEzdWbTmPRMe1a8u-AwzLw@mail.gmail.com>
References: <20121008020000.GB2575@localhost>
	<20121008020138.GA4188@localhost>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=YhMV5o/icoAD0VFphyzAwzxjAoSEPgX8N6NhWiGpevI=;
        b=rpW+Iby7JDNUHoeK51BSEZSDZKhc2KuOt+iu8T5MFydKCHQw5HsdRd/NBhInHRpm5Z
         u2Uee2DvBzVB1U6uVuS0G/t3POLs3lT9uzPl82ew6oDK/QJLB+3A7vUa8J6TEkJHoZOj
         8zk5gPMyjAqBmvMWNCIpkFFHb/Zkux2Rg9TXvYC+34bB6bcvz514JUQKzYAkGWA14pGc
         bGDsohn98xAsxLbTH5eymUdcjLKLGkBAMjR0ajo+fsL3ScC542tTBMORw/+OafOWyfPC
         i5eFpgMXRDkvxFFfnCb9CtSItqw3mKN+bjR2ShWnUTRLGhouRz8DjidQny/11AFyLG9f
         Gmqw==
In-Reply-To: <20121008020138.GA4188@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

2012/10/8 Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> On Mon, Oct 08, 2012 at 11:00:00AM +0900, Tejun Heo wrote:
>> 7e381b0eb1 ("cgroup: Drop task_lock(parent) on cgroup_fork()") removed
>> task_lock from cgroup_fork citing that current->cgroups can't change
>> due to threadgroup_change locking; however, threadgroup_change locking
>> is used only during CLONE_THREAD forking.  If @current is forking a
>> new process, there's nothing preventing someone else to migrate the
>> parent while forking is in progress and delete the css_set it
>> currently is using.  Am I confused somewhere?
>
> Also, please note that task_lock is likely to be hot on local CPU at
> that point and avoiding it there might not really buy much.

Locks are expensive anyway. And I think cgroup has enough of them in
that hot path that fork is (threadgroup_lock, css_set_lock, ...)
