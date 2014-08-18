From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: reject cgroup names with '\n'
Date: Mon, 18 Aug 2014 10:20:34 -0400
Message-ID: <20140818142034.GA17668@mtj.dyndns.org>
References: <1408360820-3390-1-git-send-email-alban.crequy@collabora.co.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jPVsgONRBbNz9CGyJfFcligz42eT4ECTTk5u5EAev64=;
        b=y5sJwfmL6DPkDjvmGhAnHoqnjgTdabrgC/AliBv/o+q7I665vtdFCbBc98mAkOo5M/
         KNr2H9xsc+/m4FHXMeiXfVEh8P6zTq/P0Hhj9DfxdT5bXtnr/fdeq7jZICVU9kj2TESM
         +nK3NmoSfH021W/xCjeAVco7HzVIFcwD3nU9oiLF7R4kxP3dUhwZ3BGuo4+YFigvcX/z
         5obpUEyy1VyniHbgswHfMHGQMywiRRqPaFfKqG4IDWXOy/hvIQ2zirLhCm8QGzi/C+Ca
         1Aiw7c1q1EUD/DhyRzG7LHbUBycmCJaXulmugSx4OBy2PYYALdljB5ZChxfXC+OXgmA1
         1vuA==
Content-Disposition: inline
In-Reply-To: <1408360820-3390-1-git-send-email-alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alban Crequy <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Mon, Aug 18, 2014 at 12:20:20PM +0100, Alban Crequy wrote:
> /proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
> allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.
> 
> Signed-off-by: Alban Crequy <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>

Applied to cgroup/for-3.17-fixes w/ stable cc'd.

Thanks!

-- 
tejun
