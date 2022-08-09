From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Tue, 9 Aug 2022 07:48:25 -1000
Message-ID: <YvKd6dezPM6UxfD/@slm.duckdns.org>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=/XUPB7pFtOYoycuDFEn5/QlUZ8HX8U8F4NCHS3GlZ7g=;
        b=dOcme2W1j/Uj3R0nK4UZMD3vQw2hi9QP65Jf9hr81ak1O5nQdws8mUGWTL8HQdc+gg
         UWconUCrj6/RmOCE0LuNalZirs5SvMS145tEpaAzf14sSPs9cSP7Emus3F69WuxT11Z+
         +wmLOudmwzEVGJAqPsf4GyM1LWDbAVIeJniXeFhztGunhkV1LAggp/q5CDteqJdMNlDR
         TsJtPdNNK5LAkqSFNl0y1F4R5BMzxNO434/qEF2a0/lCjQ5Z+MV/lt5KFCYCZM2PdpCQ
         Qm62LlwZGKWPuyxRTnq7xne4qYO14uTvxkoMYfmewxkRLH1UlJX0yJ4pTKmih1/QLOWG
         5ECQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220808110341.15799-10-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

On Mon, Aug 08, 2022 at 07:03:40PM +0800, Chengming Zhou wrote:
> So this patch introduce a per-cgroup PSI stats disable/re-enable
> interface "cgroup.psi", which is a read-write single value file that
> allowed values are "0" and "1", the defaults is "1" so per-cgroup
> PSI stats is enabled by default.

Given that the knobs are named {cpu|memory|io}.pressure, I wonder whether
"cgroup.psi" is the best name. Also, it doesn't convey that it's the
enable/disable knob. I think it needs a better name.

Thanks.

-- 
tejun
