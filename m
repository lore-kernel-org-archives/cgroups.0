From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
Date: Thu, 3 Apr 2014 13:02:45 -0700
Message-ID: <CA+55aFw+jFdmmi6eZ6+RpLM9heyowfXsZxb6Y91GNkPU677PmA@mail.gmail.com>
References: <20140403164911.GE24119@htj.dyndns.org>
	<CA+55aFy1dm_CoTv+tihQ+m54G3gR9siOngurHsuKf9W3k1sKKw@mail.gmail.com>
	<CA+55aFwBm202pchEH9A6vbJVdar9-T35pBF44cCt7FNjmno9sQ@mail.gmail.com>
	<CAOS58YMckmoCocguf9BC_Wxbn3D2Rx3MArhgozO9qCj4g=5aDw@mail.gmail.com>
	<CA+55aFw2+VKojzoF2aDaruOMKHikTO8J0HeK9DoDLZr+HqTWbg@mail.gmail.com>
	<20140403194335.GC2472@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=a3O2k7nYeb//wz3+OcufAXbmefcQEwdZlxWWr3P8lSM=;
        b=yI5c55fGPsLkK9PF+Z24wD72iDJPaX4yiOsx4HDemkms0N7kUWUS4awzy8k7kl8gkh
         y7VIt1oNGrx9KWRkLhZIhLHDgo6t9W1Q/tpBBqkejxBf6aXd7s0jS+UGIDARKoZ+9mFw
         48wwPBblReGCS5wI4l8YP8981vv5uPvDlIhcLFjjzs/bqkijZ1Rq/zwAgm8LEYr4baex
         HtXw8xNmrSDOI8FTWvZ1KRoYJwtHPpR5y6kYLYtsxvSoiOfFI7COGp+kQ0y+o+uxUow+
         gWMrw8e7uLlDGz9vK6LbKI/4tTPoM+b14SP4FUx/WyVup7TP9FbfCWAUTCasb1VucFiU
         kURg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=a3O2k7nYeb//wz3+OcufAXbmefcQEwdZlxWWr3P8lSM=;
        b=Y5O1SovMcx1W5KWxgTB0Ei5RoZbro52tOMsZRkivr9NBfPd1eNFA4RQ3PVEl7tkloP
         5P56H9oeY3FG89liHXS79+DYMJSwLqt1AzY9oOxPlHOBy1GIMiX6/P0YJhGR/WpA2ABe
         CuIBE85mybJ0gGi3arjIR+O8Fc3J9iS19ktqs=
In-Reply-To: <20140403194335.GC2472-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 3, 2014 at 12:43 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Ah, I remembered the other way around.  We could leak cgroup_root
> reference, not the other way around.  cgroup_mount() can be called
> multiple times for the same sb and we inc cgroup_root's ref each time
> but cgroup_kill_sb() only happens when the sb is released, so if we do
> the following,

Oh, Christ, I see what you are talking about.

That interface is all kinds of crazy.

> The cgroup_root should be destroyed but it isn't, I think.  We'd need
> to bump cgroup_root's refcnt only when a new sb is created.  It's
> kinda ugly.  Hmmm...

Ok, so I guess we can use that "new_sb_created" thing, and I'll redo
my merge resolution to reflect that. I do find this incredibly ugly.

              Linus
