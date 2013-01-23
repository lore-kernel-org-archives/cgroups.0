From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: don't grab mutex in rcu callback
Date: Wed, 23 Jan 2013 13:39:12 -0500
Message-ID: <20130123183911.GK17632@redhat.com>
References: <1358961426-8482-1-git-send-email-jerry.snitselaar@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1358961426-8482-1-git-send-email-jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jerry Snitselaar <jerry.snitselaar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 23, 2013 at 10:17:06AM -0700, Jerry Snitselaar wrote:
> commit 103a197 "security/device_cgroup: lock assert fails in
> dev_exception_clean()" grabs devcgroup_mutex to fix assert failure,
> but mutex can't be grabbed in rcu callback. Since there shouldn't be
> any other references when css_free is called, mutex isn't needed for
> list cleanup in devcgroup_css_free().

Acked-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Aristeu
