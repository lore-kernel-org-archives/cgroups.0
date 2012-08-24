From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/10] cgroup: net_cls: Merge builtin and module
 version of task_cls_classid()
Date: Fri, 24 Aug 2012 16:41:15 -0700
Message-ID: <20120824234115.GV21325@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-9-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=I9TUEw33PbHdGGivUH+6c4pUxHxisW0aAC0gJw9ItEM=;
        b=zx2KiiyznWrKNnsk4PkNKFLPdQf2pgqrKmg8DorcL8rDQv6X1UdF+SU5TzTTl9DkCJ
         VwbtEU3cju+gJYS5QzPwMT8vyyfiMJV0M5fQ/KWY+IBr/7w8P5pXQCywKDNk8Q7JFyWo
         sElItIuPDg62iPWcEPhcQZ8zQM+3iNSrfd4Y7GYLj4xQ74KrIkphqgMb/rAqKHWMrHDp
         UYXfnQdOj3iPwRaMr8IWw1Xl9JST33Je+w4EQgrUed+GEOTBZg1cK+5yTtiYUCkkjVSV
         Elcp7nZLCBDEVXLhIEOtyHCfLJtSdvpNEPW8hAb+s/E8DMF1e+dwJW/AByFiIgv6mta0
         kUxg==
Content-Disposition: inline
In-Reply-To: <1345816904-21745-9-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Fri, Aug 24, 2012 at 04:01:42PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>

How about,

	Now that all cgroup subsys IDs are constant whether a subsys
	is built-in or modular, there's no reason to have separate
	versions of task_cls_classid().  Unify them.

-- 
tejun
