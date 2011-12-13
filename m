From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] resource cgroups: remove bogus cast
Date: Tue, 13 Dec 2011 07:44:28 -0800
Message-ID: <20111213154428.GG25802@google.com>
References: <1323119621.3244.1.camel@offbook>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qyZ1viURCe6ZlHJEWeid402pP7n/LxQUqJEyAwuRuQE=;
        b=uthhGuPmwdvt3uoMFIfZDqY084zKHPb5Uqm0wJTRAp2YI+0ybLpLNlPBtQuXDow4Ew
         R/f0x7w0Jz5xGpUeg0sBy+B4EFy54+nQ/7KR6BOTQoTncCdvfDxC8amHbKCVjl3/bLYU
         vvWpt1C6x3NV1XeQqQxUz/OQwhXCL9uZbTU6M=
Content-Disposition: inline
In-Reply-To: <1323119621.3244.1.camel@offbook>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Davidlohr Bueso <dave-mXXj517/zsQ@public.gmane.org>
Cc: Pavel Emelianov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Dec 05, 2011 at 10:13:41PM +0100, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave-mXXj517/zsQ@public.gmane.org>
> 
> The memparse() function already accepts const char * as the parsing string.
> 
> Signed-off-by: Davidlohr Bueso <dave-mXXj517/zsQ@public.gmane.org>

Applied to cgroup/for-3.3 w/ Pavel's Acked-by.  Li Zefan, I committed
w/o your ack as the patch is trivial.  Please scream if you aren't
happy.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
