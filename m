From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH linux-next] cgroup: use strscpy() is more robust and safer
Date: Fri, 23 Sep 2022 17:27:22 -1000
Message-ID: <Yy55GrBte6cqY21I@slm.duckdns.org>
References: <20220921093517.230745-1-ye.xingchen@zte.com.cn>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=u6G2g0hsb0gnt4B0UTc0XIJN5inGwACRWvwc4rYVrzY=;
        b=b0RXQ2cuaKFf7211zJWOmrMfykhMB0XiamXF4V9zMyH/g907vyZKG4VVCkxZcT/kyT
         Lajvonmk8YXfkUzQPSvI5UutVayH0CT/1KSe/dFWtT2LeMubNwTmt308w2skhBF2ys7h
         SYN4oOq3H+cSpcauHR9P+eb5L7QCvIfpfKwF/RQIAdFETzHhKWefeUoVO0yCj+6yt5y2
         5hkA6BJnqynJz11dehAtpNY4bIyKjAY/LPd1wtE3eHUnBZtxfofmLh3t1XpuXqr8tBEM
         Lsduy2Ri1cyvLmuu0TXvUnHhYXI0zDOz7l+h4e7xgIJnZJEVg0/vmlisOmx3ad7IGWAf
         BiyQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220921093517.230745-1-ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

On Wed, Sep 21, 2022 at 09:35:17AM +0000, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>
> 
> The implementation of strscpy() is more robust and safer.
> 
> That's now the recommended way to copy NUL terminated strings.
> 
> Signed-off-by: ye xingchen <ye.xingchen-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org>

Applied to cgroup/for-6.1.

Thanks.

-- 
tejun
