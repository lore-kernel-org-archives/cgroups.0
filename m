From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Tue, 9 Apr 2013 14:11:52 -0700
Message-ID: <20130409211152.GO6186@mtj.dyndns.org>
References: <20130406012159.GA17159@mtj.dyndns.org>
 <20130409095024.GI25576@redhat.com>
 <20130409193851.GJ6186@mtj.dyndns.org>
 <20130409194640.GK6186@mtj.dyndns.org>
 <20130409210422.GA31120@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=QYmaQoaKeh5xHPRYtADM8L7O+QEs5wwbgA5I4oj3xMQ=;
        b=e8WBdOwDiyQ6Eoqb74Wjwo1Y6C0IHy8SpM/ZgJctkR63UGQldC+XkyUaI6Ge9Yk/vm
         csoGgBOKT1QLweyrBpTwHRGnUXQT2cDwvvSbc0LIZOhpxkneZ2QpsJeY54FV3B2fs5Y4
         zouVNidsDlIWMtO1Fz77HZ7+MxnkWC/L3A/s2Nf+ZVh8O8FzjVQKEWu31yT0cOACNguV
         wA9R32Ye1dWdvATV9lMf93K4lH9gOw8HjudkdryTqQpJH9m1nYdYgo3V28dxnEFNdQsa
         Nbd9x3gwRh+3frT+0Hqo1pOx9qH+5J/0Ae3h8poSJEfVegRGUpD8f6Th22h2KzO1W61o
         ZAuw==
Content-Disposition: inline
In-Reply-To: <20130409210422.GA31120@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Serge.

On Tue, Apr 09, 2013 at 04:04:22PM -0500, Serge Hallyn wrote:
> So for instance if there is a dbus call saying "please create cgroup
> /x with (some constraints) and put $$ into it", "something" in the
> container can convert that into "please create cgroup /lxc/c1/x
> and put (host_uid($$)) into it" and pass that to the host's (or
> parent container's) "something".

Yeap, definitely.  It shouldn't be difficult to make it transparent to
individual consumers.  It would actually be far easier to achieve that
with userland agent which knows what's going on in the middle.

> So perhaps it is best if the container monitor, living in the parent
> namespaces, opens a socket '@cgroup_monitor' in the container
> namespace (through setns), listens for container-userpsace requests
> there, and passes them on to the host's monitor (which hopefully
> also listens on '@cgroup_monitor', @ being '\0').  Note that my
> mentino of converting pids requires a new kernel feature which we
> don't currently have (but have wanted for a long time).

Yeah, details may change but in principle something like that.

Thanks.

-- 
tejun
