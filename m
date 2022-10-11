From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] memcg rstat flushing optimization
Date: Mon, 10 Oct 2022 14:19:56 -1000
Message-ID: <Y0S2rPSfpCf2AMod@slm.duckdns.org>
References: <CAJD7tkZQ+L5N7FmuBAXcg_2Lgyky7m=fkkBaUChr7ufVMHss=A@mail.gmail.com>
 <Yz2xDq0jo1WZNblz@slm.duckdns.org>
 <CAJD7tkawcrpmacguvyWVK952KtD-tP+wc2peHEjyMHesdM1o0Q@mail.gmail.com>
 <Yz3CH7caP7H/C3gL@slm.duckdns.org>
 <CAJD7tkY8gNNaPneAVFDYcWN9irUvE4ZFW=Hv=5898cWFG1p7rg@mail.gmail.com>
 <Yz3LYoxhvGW/b9yz@slm.duckdns.org>
 <CAJD7tkZOw9hrc0jKYqYW1ysGZNjSVDgjhCyownBRmpS+UUCP3A@mail.gmail.com>
 <CAJD7tkZZuDwGHDjAsOde0VjDm9YcKWnWUGHg43q79hcffZH5Xw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nGoDydYwFqmdmKnzszjtdksfmEzjuo68M+fcbC8JTZY=;
        b=QPrMaTYMX+LHlEAtR3315wlbrXxpmZ1K7YcQlmqqnIpk31rj6HUOZ1Ffg9aT5fLggb
         1O90ZeenAkme/4IkAJdUtxWVMSkl+HmXS5wHZJBQa8GjCXGegDBILU63HFPUhc8hK01G
         BW0LjruEDo5XihSvmvg4K4Po75yhE8+8/cmXTAOKsXPTAU1LLm1unGLLLHafwVTiE9BX
         dx4+X/eqosgRmoe0CnEIPGp+WMFt+IrtKiIOi6ZreiN1Jcplfw7K9z0+9DOelRiOKIGY
         VzQ4pAKqsew/a2wz5RvyLOdw6bqVkw7LDGUKqQvas9j9At4bnxn7g1iEIF/sCGWZsyhp
         5goQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJD7tkZZuDwGHDjAsOde0VjDm9YcKWnWUGHg43q79hcffZH5Xw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Oct 10, 2022 at 05:15:33PM -0700, Yosry Ahmed wrote:
> Any thoughts here, Tejun or anyone?

I'm having a bit of hard time imagining how things would look like without
code and I think we'd need inputs from mm folks re. the tradeoff between
information timeliness and overhead.

Thanks.

-- 
tejun
