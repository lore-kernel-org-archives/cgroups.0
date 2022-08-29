From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: data-race in cgroup_get_tree / proc_cgroup_show
Date: Mon, 29 Aug 2022 09:27:41 +0200
Message-ID: <20220829072741.tsxfgjp75lywzlgn@wittgenstein>
References: <CAEHB249jcoG=sMGLUgqw3Yf+SjZ7ZkUfF_M+WcyQGCAe77o2kA@mail.gmail.com>
 <20220819072256.fn7ctciefy4fc4cu@wittgenstein>
 <CALbthtdFY+GHTzGH9OujzqpOtWZAqsU3MAsjv5OpwZUW6gVa7A@mail.gmail.com>
 <YwuySgH4j6h2CGvk@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661758068;
        bh=QBKOCoTZ6XZgyyunpEAs68DUjO/2pOPpwNeRHbtxvMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJSIQ1Lb0E3HGCPjCT7ITuT8fzC+A8MCwrjZcRnWMOD+YktvB5KCIL8TykwxdnzH/
         eQWB73STnszdOdUhX4Ms1V+BX/Bfv3bcAx8CJIKy7t50xRUVMlCSKX+vW1kiaZr8Ff
         VyCY5IIh/V7Qjsaoz+tR5LWuWcuWNTt982UTYJ7r2WA+P8AVuPT0kBnNuavGCL5Zpn
         5vUvTPNLUdXSN2jL2grMBfMqxR+/a2SRYxOciy148qfBNdAyUMFpU9p6wXJ6Cvhn3n
         IQ3sDiffpSGTrX3SxDpuNBPJIXOzvd+gaiqwJbaMN3mm25zVWyyo24gJuSw+7i5WRq
         Sst1GXxFliyQQ==
Content-Disposition: inline
In-Reply-To: <YwuySgH4j6h2CGvk-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Gabriel Ryan <gabe-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, Abhishek Shah <abhishek.shah-WLbs8XpHrcb2fBVCVOL8/A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org

On Sun, Aug 28, 2022 at 08:22:02AM -1000, Tejun Heo wrote:
> On Mon, Aug 22, 2022 at 01:04:58PM -0400, Gabriel Ryan wrote:
> > Hi Christian,
> > 
> > We ran a quick test and confirm your suggestion would eliminate the
> > data race alert we observed. If the data race is benign (and it
> > appears to be), using WRITE_ONCE(cgrp_dfl_visible, true) instead of
> > cmpxchg in cgroup_get_tree() would probably also be ok.
> 
> I don't see how the data race can lead to anything but would the following
> work?

Yep. You can take my,
Reviewed-by: Christian Brauner (Microsoft) <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
when you turn it into a patch.
