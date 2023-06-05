From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fixed the cset refcnt leak when fork() failed
Date: Mon, 5 Jun 2023 11:38:45 -1000
Message-ID: <ZH5V5S5InM6b1iK7@slm.duckdns.org>
References: <20230605130444.1421-1-zoucao@kuaishou.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686001127; x=1688593127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5pGqWwqQ5KPSrbDc5xd4FA01+FepvTerJM42ML5MoMQ=;
        b=nRyW0hhDZTfCvxSPTJDii7pUm7m0UfNlz52xzqH/Ya7UPueAxRK0Uou40EdrNBMiCi
         Hinczjj7Coajh3hhMGRNJ3S1eDX5Z5WXp9pYEhmMaUW7lkw4m1pxtt/z55sfYrbrD2Ri
         OJnVzn5PY2Q57bilmau5NsYtQDrqpQv0zLf1j37IHi16kXVsjnqYjgefqcdVh36KOek2
         kJDahFarnBOIVWPp3yRIR6n01M5dNBp80BNm0lU/nao1Jyh23f9v11y4GnV7dxbVwFwf
         dQ+isfC6B9v0YFzYwCbYbVvi/Pjqj7/6gg5H3PTWcMLQLmp64ro63sbtvZqv3IwbgsD6
         1wjQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230605130444.1421-1-zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zou Cao <zoucaox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>

On Mon, Jun 05, 2023 at 09:04:44PM +0800, Zou Cao wrote:
> TeamID: B1486294
> 
> when fork, cset will be increased by commit "ef2c41cf38a7", the refcnt will
> be decrease by child exit, but when failed in fork(), this refcnt will
> be lost decrease in cgroup_cancel_fork as follow:
> 
> copy_process
>      |
> cgroup_can_fork    //  increase the css refcount
>   ......
>   spin_lock_irq(&css_set_lock);
>   cset = task_css_setcurrent);
>   get_css_set(cset);
>   spin_unlock_irq&css_set_lock);
>   ......
>      |
> goto cgroup_cancel_fork    // if failed in  copy_process
>      |
> cgroup_cancel_fork  // lost the decrease refcount if flag not CLONE_INTO_CGROUP
> 
> Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
> Signed-off-by: Zou Cao <zoucao-e2CXd7i0PsxWk0Htik3J/w@public.gmane.org>

Is this the same bug fixed by the following commit?

 https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/commit/?h=for-6.4-fixes&id=2bd110339288c18823dcace602b63b0d8627e520

Thanks.

-- 
tejun
