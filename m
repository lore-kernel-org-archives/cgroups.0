From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroups: Account for CSS_DEACT_BIAS in __css_put
Date: Fri, 15 Jun 2012 15:20:28 +0800
Message-ID: <4FDAE23C.2020908@huawei.com>
References: <20120614215530.12092.3543.stgit@dungbeetle.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120614215530.12092.3543.stgit-Oz2bD8w/QAX+Wsei8lUk51LMcqb5oVE02SarAXORi/o@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2012/6/15 5:55, Salman Qazi wrote:

> When we fixed the race between atomic_dec and css_refcnt, we missed
> the fact that css_refcnt internally subtracts CSS_DEACT_BIAS to get
> the actual reference count.  This can potentially cause a refcount leak
> if __css_put races with cgroup_clear_css_refs.
> 
> Signed-off-by: Salman Qazi <sqazi-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>


Hope we've got everything right this time!

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
