From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] percpu counter: test module
Date: Sun, 27 Oct 2013 07:18:44 -0400
Message-ID: <20131027111844.GA14934@mtj.dyndns.org>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
 <1382859876-28196-2-git-send-email-gthelen@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=65OsvE2vQL6VPHui5DsYquqYIoLreqEHs0lF1KgPci8=;
        b=Xa8kSSy8LPooSoaqWFXo9bMgfC9jRXeRCaOuDDwhEaEifT3Mmokveqo7JmQ+PAVNBB
         wM/fHJpJb5gQu0KBwCuhQcUUggVRrdXKM2DGoyEkGfIf6NQjamb8WWSFYc6XLeK6sqYz
         KAK+r0V+ge9MFt3MgfzYGpgH3ob3eQqKT77NArTk/dRuC/qi7bUr/BA8GLXzyBCmdnPD
         5sV/SPxPl/kCLmwAaEpsnHQkc7BcaULDQVrgtCVK7q1BszZgQoMFRmA65uUqZZ7GiPG7
         6n3UkME2fo4JNZhLEy4/m/NknUJ6LiPzD9dHrG3YEesINc2BKEstl1Lmm7r9/ug9PYYJ
         33lQ==
Content-Disposition: inline
In-Reply-To: <1382859876-28196-2-git-send-email-gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sun, Oct 27, 2013 at 12:44:34AM -0700, Greg Thelen wrote:
> Tests various percpu operations.
> 
> Enable with CONFIG_PERCPU_TEST=m.
> 
> Signed-off-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
