From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup.c: add helper __cset_cgroup_from_root to cleanup
 duplicated codes
Date: Thu, 16 Jun 2022 09:35:09 -1000
Message-ID: <YquF7TzuCjqP8aGZ@slm.duckdns.org>
References: <20220616103830.197458-1-linf@wangsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a4KSlJmtWZkjiLfN9g3so1P7qbrnH5UxDi6TOibKZrg=;
        b=pTI+QTB9FI8Yf2Lnf49gZQgDsuzRXp2tqdWSqdZaO3ef+cvD0oHeUJiaZ+6C2Pve3y
         gEJ3Q3vGopGnx8wzqSe8eBoEej89TmAy4RS9Lir82ibduS4MvW6pMe0UjsHPebCh4Na9
         6QvGYjrJ8B7zmkZap+DXhQF4/62bkYyQLchUis/jHLymP8zQtjbnluu5K+weZ0uoZNdm
         dLo9r45NKoe4TD/1MECXonhVHlYDqLag4sD7UGLzttnJk+tTt7XO9nf8clTh0wCXbPIN
         RjpZC1h8LlUbKx2i4Awvn1E1q+0F4+nRsrNuhYE6ylsPjIMnTJbgupQkSYuJTCKPdN9n
         EtFw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220616103830.197458-1-linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 16, 2022 at 06:38:30PM +0800, Lin Feng wrote:
> No funtionality change, but save us some lines.
> 
> Signed-off-by: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.20.

Thanks.

-- 
tejun
