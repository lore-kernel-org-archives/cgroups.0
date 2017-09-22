From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.14] cgroup, sched: cgroup2 basic resource
 accounting
Date: Fri, 22 Sep 2017 11:05:30 -0700
Message-ID: <20170922180530.GG828415@devbig577.frc2.facebook.com>
References: <20170811163754.3939102-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jZB7BlO5h8jQ9xxvR6721qQb2tWOZe1uEC+MY0z5qRU=;
        b=WatvbIkGLFsHtOocaI+2J1d6oiw2QW1Dk7jhxuYzbFd1fAAfDg5lcZDmyRpOdU/Ffu
         nMgdyEqTRzZz07WtdG0hqvCFXYD0ZGtPLi6yCdCeAEWiaUDKfE0f/nefPck6Tq3ksmW7
         x87ooLdamIzfmihoW3fVexlyYxPqDVkjX8Au2+4dkiDz4yzHWP3qaD3hYpZyb5vSyp3e
         44jpcM9AEPMqF+SXqJhw1dz3QTEz/I1h090q/u1ib7JsqE20vT7uZ80ZZ883jXdoBzyp
         D/q58Gk3dEpVKMQMnDCOgSZQxdKkWUx+AgByR2vpnzeI6U5knBuazuZ0MjUMe+U15P8s
         2ozw==
Content-Disposition: inline
In-Reply-To: <20170811163754.3939102-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

Peter, ping?

Thanks.

-- 
tejun
