From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove hierarchy_mutex
Date: Thu, 7 Jun 2012 11:33:02 +0900
Message-ID: <20120607023302.GH21357@google.com>
References: <4FCC5792.8010203@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BKmX0nNeL8iSyjBIDSj41bUqJ1J6RW+qSoJz8KXhw+4=;
        b=R5yR4lvnK2G/hkDHV5gmEVOEIMlQ/dWHqfmKhToIsd+A7qyE77yvBgY0duoIza/LQX
         r42Un8GaX7UOCKpiDZpar+cxHpjRdnV+2wrQm13ZJCLGRcJM3/Oo6zspYlRSNxy3dAYv
         QaHvrHcw4m/WGTcsYtczefmdq8Ew2gNKUCHP0fThreUxsz73HTXBkVRlnP+rURsuq6eE
         0cH3yXm9AS0mljKQislB+t1jWe0EQ38qNwH8Fu+7Xt6wCbGzDuo5EN0ho49NCHKpsNuc
         EVtqLTU9zmYgv8+2Vbe5yVwTLBmZ9Z7znF5akWHvXYoDgOmh+3DpsFGtTvN8c/SzV4hq
         KP5A==
Content-Disposition: inline
In-Reply-To: <4FCC5792.8010203-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jun 04, 2012 at 02:37:06PM +0800, Li Zefan wrote:
> It was introduced for memcg to iterate cgroup hierarchy without
> holding cgroup_mutex, but soon after that it was replaced with
> a lockless way in memcg.
> 
> No one used hierarchy_mutex since that, so remove it.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.6.  Thanks.

-- 
tejun
