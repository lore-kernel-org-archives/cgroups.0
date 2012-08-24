From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/10] cgroup: net_prio: Protect access to
 task_netprioidx() when built as module
Date: Fri, 24 Aug 2012 16:26:50 -0700
Message-ID: <20120824232650.GR21325@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-5-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4WhEO5CVOSLKt32iw97LmyQrJfFLjERUtRf5jd8Ncvg=;
        b=Ao11dN3VhJuZYVJbZTakcAi48cr6FxhcI5jhbUoJmpGUGFM46M0i7bFa6eHtjxyDnV
         JrpW34UD5gnRYdggx6iL7dl7TYToz2ETGLiOYiPtErCH5WGyLKDllqak6A7fmfLuSJJ6
         LVxwphRzjYUj7NED9sUUnICqM2Ksk/H+qB9Xdcgy/GK/nReHI+926DTGVP6bqSK2qwDO
         YPUeubMkEIimdOj9AvvPR7psihCZrM42Js1poPmH1TwjacElCKsrp3av6oYxEXxyH5hO
         st2F6+/1tMhJ36wL+smnzM/Nqvu0lTkKSA7JxCVclmt0jiRUr4YA2iF/awjiiMVU2LaI
         x3Bg==
Content-Disposition: inline
In-Reply-To: <1345816904-21745-5-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Fri, Aug 24, 2012 at 04:01:38PM +0200, Daniel Wagner wrote:
> +#if IS_MODULE(CONFIG_NETPRIO_CGROUP)
> +	static_key_slow_dec(&cgroup_netprio_enabled);
> +	rcu_barrier();

Ditto as patch 3.

-- 
tejun
