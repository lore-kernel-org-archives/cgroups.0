From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 13 Apr 2016 15:12:35 -0400
Message-ID: <20160413191235.GA20142@htj.duckdns.org>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160413175736.GC3676@htj.duckdns.org>
 <20160413184639.GA29483@mail.hallyn.com>
 <20160413185033.GH3676@htj.duckdns.org>
 <20160413190152.GA29753@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ozFRTTLOkq5zqnSVSteHlHkmEKg4LuM1LXi6VPDxlrI=;
        b=umCjRfq6gKzyNVQDj7rTi3HN6m984m8JAWLWtE50B04PfaKRROIWi//kUwOkGgHSUx
         I82bn5NAvcrTIPN7YeMmcEOiBirkISVsUpI6qgS2j8mpim0pDtTeGpIWJYi+Zu+xxLxc
         CSLfqFHK6jNhmtxnWrZ8QPCc5meYtmfPTdkhBugJQpFhA30yIiGlFWaqpUP2azN5RGxd
         0gOu0htPs4zFq91DIjmI38Wu5ncygLFdWDQdMFzdGsDMWQzbq6N13oY/oIOARjzwBEmW
         YfCWfNvN39hwgNu8kepXXcMpBe/S6i2xqGhU7PaMXBwwe5mvpDviChKMJ/NYc9eqZLTD
         1AqQ==
Content-Disposition: inline
In-Reply-To: <20160413190152.GA29753-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Apr 13, 2016 at 02:01:52PM -0500, Serge E. Hallyn wrote:
> I don't think so - we could be in a cgroup namespace but still have
> access only to bind-mounted cgroups.  So we need to compare the
> superblock dentry root field to the nsroot= value.

I see.  No objection then.

Thanks.

-- 
tejun
