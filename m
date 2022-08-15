From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Mon, 15 Aug 2022 09:50:30 -1000
Message-ID: <YvqjhqJQi2J8RG3X@slm.duckdns.org>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvprI6ZL8dVWGyBO@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=Di1CBe/l3lFU1XEMEHMD/NMLKrrpGfsfoqHbgdL41rY=;
        b=JuMvrFxcpiKSsluaG1sm5UeOdp2pC3giGOS2OG59Y//fuQbFRfELDeH/pCcBIswiDf
         lZAf9nK/Y2R/Slxxx4YUgrO+F12ef80ywTcQLYTu8qeuofUcBPT7wsZnHVA+pr4+0/Cj
         2tUC4IQVIStZaEDFenvFjtb8mmfyzTXMYIyz/i28Sb2IcML8EkxfwWRAP/3mhdWUdJG5
         VVHotdeDOBc2ap2gYTcc16AbrAOrCJwUGwpW0kqck33YQQZ/msYuYMqPoV3dfpYUAbdG
         l7XZwTBXqp8itTZ6ESNEpnA/05+OnSneaC/vjjcsmmudVYim9hPHM6KvxdLxnmzlWVOM
         Qjxw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YvprI6ZL8dVWGyBO-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

On Mon, Aug 15, 2022 at 11:49:55AM -0400, Johannes Weiner wrote:
> I think it should also add/remove the pressure files when enabling and
> disabling the aggregation, since their contents would be stale and
> misleading.
> 
> Take a look at cgroup_add_dfl_cftypes() and cgroup_rm_cftypes()

The problem with adding cftypes dynamically is that it can fail, which isn't
the end of the world here but still kinda sucks. I think what we actually
wanna do is hiding and unhiding while keeping all the data structures in
place which is needed somewhere else anyway.

Thanks.

-- 
tejun
