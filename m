From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup1: don't call release_agent when it is ""
Date: Wed, 4 Mar 2020 11:54:05 -0500
Message-ID: <20200304165405.GI189690@mtj.thefacebook.com>
References: <20200219190129.6899-1-tycho@tycho.ws>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c88Dz2GMYmBaIJfWXLGPh6kIgnpIJOOvRiVNkjl0F5E=;
        b=PrTpbleqZjdc5H+btD7PF3LTHDcueQrwRgAVlPZdUuc+ZYH14SyBvd9/LxxSkDELvJ
         71YSsAm+kuGWjtBbs5qpMqAFEdI05FCAe8lkx3YlMdrXoPGItoqFoab+/mRuS6Pr3dCa
         9PPlaypFNsA5jw4c7XZjFxaM/v2Ne3vjxe3u2Ox2f6hoAxy9l9Ebs8Lvzoc3gPH0fJW7
         M4HeM3dOw1FJ6w2M3o4h6MpZ7tMYNCLBB2+eZkep5tDwsWkxpLeVMbFVoOx1VdTYkseT
         MBAn+E3KpPYWD7T4+/HD8d0pGB/xEp8LNdSo04BT9z+mUBYC7pulu3ubejpjDf97Te5P
         LgcA==
Content-Disposition: inline
In-Reply-To: <20200219190129.6899-1-tycho-E0fblnxP3wo@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 19, 2020 at 12:01:29PM -0700, Tycho Andersen wrote:
> Older (and maybe current) versions of systemd set release_agent to "" when
> shutting down, but do not set notify_on_release to 0.
> 
> Since 64e90a8acb85 ("Introduce STATIC_USERMODEHELPER to mediate
> call_usermodehelper()"), we filter out such calls when the user mode helper
> path is "". However, when used in conjunction with an actual (i.e. non "")
> STATIC_USERMODEHELPER, the path is never "", so the real usermode helper
> will be called with argv[0] == "".
> 
> Let's avoid this by not invoking the release_agent when it is "".
> 
> Signed-off-by: Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>

Applied to cgroup/for-5.6-fixes.

Thanks.

-- 
tejun
