From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup,freezer: hold cpu_hotplug_lock before
 freezer_mutex in freezer_css_{online,offline}()
Date: Mon, 12 Jun 2023 06:43:30 -1000
Message-ID: <ZIdLMv-ayau220Mp@slm.duckdns.org>
References: <000000000000bd448705fda123f5@google.com>
 <000000000000d1565005fda9cef1@google.com>
 <69ab449f-1981-2d53-79fb-b2ac91ea9cef@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686588208; x=1689180208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JSV7+xvV5iYIhAuD/TdxXQ0uoSNJAzoI8nkQ5nx/4IQ=;
        b=fkFecxV1NYBDKnFaAQR3ysyLgpxySSGwCkryf+lKhqEMLobraMIfhY2lKpsijiGcBq
         hLMzGpZ7bKcExpAsP1pfBTE5i1Hgd3Qz7o7Wmt7Osz57lbhf12t49H8hBp0uSOznmVMx
         UVc5tYcZNB7HMDKAv8de2YMuAB8izi78/zWW7GJWj353sDvMfY5czYGqVuS8XIMQkkxd
         5tTrcPsWzHThsCIp5GR2ZTfP4dMUlK+oklC2MII1HRQahBRlSRRhgeWFMXBS4gWWsfDt
         XUUpxX3aMWNtVUKGFN4T8W4LIQxz4aOFSjdyNPCOaqzvwcOq1xLuO6f1/6GV1C2Mbdz8
         eepg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <69ab449f-1981-2d53-79fb-b2ac91ea9cef-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Jun 11, 2023 at 10:48:12PM +0900, Tetsuo Handa wrote:
> syzbot is again reporting circular locking dependency between
> cpu_hotplug_lock and freezer_mutex. Do like what we did with
> commit 57dcd64c7e036299 ("cgroup,freezer: hold cpu_hotplug_lock
> before freezer_mutex").
> 
> Reported-by: syzbot <syzbot+2ab700fe1829880a2ec6-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
> Closes: https://syzkaller.appspot.com/bug?extid=2ab700fe1829880a2ec6
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Tested-by: syzbot <syzbot+2ab700fe1829880a2ec6-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>

Tagged w/ the same stable version as the earlier patch and applied to
cgroup/for-6.4-fixes.

Thanks.

-- 
tejun
