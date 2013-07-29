From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cpuset: get rid of the useless forward declaration
 of cpuset
Date: Mon, 29 Jul 2013 14:13:19 -0400
Message-ID: <20130729181319.GA26076@mtj.dyndns.org>
References: <51F34501.1090608@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=CF7hJw+ozC77Fvc8p8Li2XG3Gxg0qwh7BPiqXWHz5/A=;
        b=L39NkV7mSCCCxzo4skHoGBjmIi4ZUUyXL0Ymw4krwE8BNni9pqHA0Aa5vV4GKaiUMf
         zqMLcQJIvZmgorVe7reVSN4P+8TaVcYCc1lw4GCLubyBQE0K9jwKcHGvYmTWj9unBYhq
         ODGFVhBR3UOGhdkNUuDKnJJSN+lmBTbcBSm0BBlVwIyzMvvaIPy4xik34Y9Tehn2vW+Z
         xZ48NwFVDdXHmtJ3P1sxfbwGhRgzMv2qKoV5OJQZAnzH7Sznn7mUp4OBusPW70sZlXKO
         +fN8SWT6gKsi3UVHG/MBorPAoOQoIAZ+yH3t+JuhlWMj/zT/JTqBR/CCTzwjW0CMttdI
         PSDA==
Content-Disposition: inline
In-Reply-To: <51F34501.1090608-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jul 27, 2013 at 11:56:49AM +0800, Zhao Hongjiang wrote:
> get rid of the useless forward declaration of the struct cpuset cause the 
> below define it.
> 
> Signed-off-by: Zhao Hongjiang <zhaohongjiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
