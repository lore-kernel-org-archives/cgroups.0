From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.15] cgroup_freezer: document freezer_fork()
 subtleties
Date: Tue, 25 Feb 2014 10:05:22 -0500
Message-ID: <20140225150522.GD26788@htj.dyndns.org>
References: <20140212210759.GF26809@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8NEOCc1y4W5zuAGTM95/KkxH+i9/+D7oDogqC3lByWg=;
        b=JIkPNxcq5ZLs/VbCbxtGKsHoBDQnAE0ADfkerpHNQt3X8rbiw+hyUCPmSuc+F4T75R
         gIKwFQ98ZuNXlED+uAvxTJxGiC0A5nkywwqJv5jttK0ut6zAycRcYQyRpCpn8GF0loMQ
         q9QhGEzE3NBvyWZ9TrX0bJcO5CsBvXj+x/k89LZNzBAQnvcwGbr8UXtUZAiQYdxyit64
         Ga1nKtZBw02eVveuK0lFR6ymoPkl2xFQpK8a1kftTQkjNvCj1jMFKmwfLAihok07gUmH
         5OMa08UIiHDlHyZzdXh16lKYdUtapVGD+iVIN1sjAFLN0ENV4s/TOSp8xW+kFWqMn5CO
         suRA==
Content-Disposition: inline
In-Reply-To: <20140212210759.GF26809-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 12, 2014 at 04:07:59PM -0500, Tejun Heo wrote:
> cgroup_subsys->fork() callback is special in that it's called outside
> the usual cgroup locking and may race with on-going migration.
> freezer_fork() currently doesn't consider such race condition;
> however, it is still correct thanks to the fact that freeze_task() may
> be called spuriously.
> 
> This is quite subtle.  Let's explain what's going on and add test to
> detect racing and losing to task migration and skip freeze_task() in
> such cases for documentation.
> 
> This doesn't make any behavior difference meaningful to userland.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>

Applied to cgroup/for-3.15.

Thanks.

-- 
tejun
