From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: an argument for keeping oom_control in cgroups v2
Date: Mon, 22 Aug 2022 17:22:53 -1000
Message-ID: <YwRIDTmZJflhKP2n@slm.duckdns.org>
References: <20220822120402.GA20333@foursquare.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=bNUjpvmBAwk/P6cxUtt2FxYhiH7UbJpC/KjVw1DvQyI=;
        b=B7f2yea+67/amPKu9MkN+JDwqA7oNEV79q8FkfFvZ0xqT50fhXDcyeSXhgTlWBgy6w
         9L4N/tzPn0fpr2+Kx7w49c/7NcH5ODp/W3ikw69fE5L1NqOLb+ud07nMnkppJqRJmMH2
         rfuPCeEwa+8hQSBi6SA8NPyLNwZyugqOpEV1gk/EM5Hmgnlv3yj9oKA1H1T3PpMoScX+
         ShAqm7m5uyQvgxz4B/dSPKNMx+maxPVijuQ3v+wIz8AL6opDzVy4u+LrkyJT+x42klPA
         hWTCpak7q8y8Yo9PmvX9mazXRV4qwqYnh5ORzGo900NeIG2AVcNAvKMeW8go0OAAnRSo
         T5UQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220822120402.GA20333-4/nNOD19pEMY+eTVAdjFZg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Frey <cdfrey-4/nNOD19pEMY+eTVAdjFZg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

(cc'ing memcg folks for visiblity)

On Mon, Aug 22, 2022 at 08:04:02AM -0400, Chris Frey wrote:
> In cgroups v1 we had:
> 
> 	memory.soft_limit_in_bytes
> 	memory.limit_in_bytes
> 	memory.memsw.limit_in_bytes
> 	memory.oom_control
> 
> Using these features, we could achieve:
> 
> 	- cause programs that were memory hungry to suffer performance, but
> 	  not stop (soft limit)
> 
> 	- cause programs to swap before the system actually ran out of memory
> 	  (limit)
> 
> 	- cause programs to be OOM-killed if they used too much swap
> 	  (memsw.limit...)
> 
> 	- cause programs to halt instead of get killed (oom_control)
> 
> That last feature is something I haven't seen duplicated in the settings
> for cgroups v2.  In terms of handling a truly non-malicious memory hungry
> program, it is a feature that has no equal, because the user may require
> time to free up memory elsewhere before allocating more to the program,
> and he may not want the performance degredation, nor the loss of work,
> that comes from the other options.
> 
> Is there a reason why it wasn't included in v2?  Is there hope that it will
> come back?

memcg folks will have better answers but the short answer is that the kernel
really doesn't like giving control of a task stuck with an arbitrary
backtrace to userspace, and that kernel OOM detection often is way too late,
so cgroup2 instead goes for enabling userspace-drive OOM detection and
handling through PSI. The following doc has some information on it.

 https://facebookmicrosites.github.io/resctl-demo-website/docs/demo_docs/res_protection/oomd-daemon

FYI, systemd already has its own oomd implementation in systemd-oomd.

Thanks.

-- 
tejun
