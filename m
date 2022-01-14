From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] sched/core: Force idle accounting per cgroup
Date: Fri, 14 Jan 2022 06:39:01 -1000
Message-ID: <YeGnJe+JXlUlPvrH@slm.duckdns.org>
References: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
 <1641894961-9241-4-git-send-email-CruzZhao@linux.alibaba.com>
 <Yd89Lv3VuaaFVm4h@slm.duckdns.org>
 <1cca28c3-c84d-415e-9b33-6687e4ff2cbb@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NvcSGZuMTabYgJIG/cRBMSHew1xOo2ElUfSvmL5LgS8=;
        b=WsfCzOserdaGV51/he50lnmACdXPaqlTCzdAc2zdb7pDME3Hdx2NJVcU6EOfuiKqQi
         2CKsqhifWXdwK5rHD+KfbZSHk2xX50BHOypk3cFHHU4FnbejzphJMphG/U1vSHpy61gS
         lQkpnFt9eGDXTLVQYjCqjRy8DraYdFw1W89Vl9qAMwOS+LGlU+w/9FK6W/a8TvnVFLNx
         elMeTeOd+D1rPdlNStBUrY8u3zsYstlhlaKCxDcT84cO1QN1damwktikxOfn4GM5fprz
         akMSllwzds7V1d+bjeOF6Jsc7rU1AOOwDFDv7ALoV01vgAJPKkE3NnVFq9TnOE22otWm
         HU0A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1cca28c3-c84d-415e-9b33-6687e4ff2cbb-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cruzzhao <cruzzhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 14, 2022 at 07:13:12PM +0800, cruzzhao wrote:
> Thanks for suggestions, I'll try to do this using rstat. BTW, is it ok
> to integrate it with cgroup_base_stat?

Yeah, I don't see a problem at least from cgroup / rstat POV.

Thanks.

-- 
tejun
