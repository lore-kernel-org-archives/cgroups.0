From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] cgroup/cpuset: v2 optimization
Date: Mon, 14 Nov 2022 11:46:30 -1000
Message-ID: <Y3K3NoZkPecICr/Z@slm.duckdns.org>
References: <20221112221939.1272764-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=taPjPZOHgyTR/UHrmegaCgYgAMt1HfCmx5v3wHZ6oYA=;
        b=miZ3R7+rKsoSQdxCi3ClLd+R+sUuBv/d8D2zNnsSp4J/0qqHSeLjg/OLOWIfJiAfiQ
         n513Q67ZtWC6tbiMUcMUbfGivhIsz0CXgn8fK5oeExaXDQo4V9SDU7V5Qeph7RV2U6M3
         ytc9B839D1XNiYJhj+SwxeJLv8k3lRK3dLgULbjX1G4LkXQFR8lSOJt25BSvDjF2jomY
         8NKF8vmuUK2gxuBKSmpKjz1npYJ1KtNxZV9jvbsTtOokF1iY4hUyJ0QaaZvzKeVRqdmc
         dk+oeWdeyP7iz5Y3MTNxtd8ji3ajB22mcyx7S/IBemIxWZ7Xfpr/iQPh9BvoFHD6de8R
         xbsQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221112221939.1272764-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On Sat, Nov 12, 2022 at 05:19:37PM -0500, Waiman Long wrote:
> This patchset contains 2 patches to optimize out unneeded works when
> running on a cgroup v2 environment.
> 
> Waiman Long (2):
>   cgroup/cpuset: Skip spread flags update on v2
>   cgroup/cpuset: Optimize cpuset_attach() on v2

Applied 1-2 to cgroup/for-6.2.

Thanks.

-- 
tejun
