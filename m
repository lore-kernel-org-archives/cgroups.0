From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH] Documentation: cpuset: Fix 'cpuset.tasks' -> 'tasks'
Date: Fri, 13 Jan 2017 11:05:16 -0700
Message-ID: <20170113110516.2a819340@lwn.net>
References: <9dd9adef5fe4ae283d0510204f556b4390e5a897.1484259596.git.wking@tremily.us>
        <20170113102742.686b785c@lwn.net>
        <20170113174434.GO10810@odin.tremily.us>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170113174434.GO10810-q4NCUed9G3sTnwFZoN752g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 13 Jan 2017 09:44:34 -0800
"W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org> wrote:

> > So I'll confess that I don't understand this change.  All of the
> > control files are referred to as cpuset.whatever in this document;
> > why should this one, in particular, be different?  
> 
> 'tasks' is part of the generic cgroup tooling, so it doesn't get the
> cpuset prefix:

Duh, of course.  Got more coffee now and applied it, thanks.

jon
