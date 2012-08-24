From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/10] cgroup: net_cls: Use empty task_cls_classid()
 when !CONFIG_NET_CLS(_MODULE)
Date: Fri, 24 Aug 2012 16:22:07 -0700
Message-ID: <20120824232207.GP21325@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-2-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=RrQ8SXzmI/P/GykxvH+ApqA6c18Jt1oPKYtRlraZ108=;
        b=u5bv6pXfeUb7L7O8GV7CaZ9TryF6nBDjOL9P/tG6uZBIfoDTu/AP32w+xACcNkc63l
         fQ6QkazJt88HN8OTK3Pdt2QdZF9zhIdRU/sCDpF0vHKn2gywbKFZ9BWnR9Hzd+dO0gre
         YPdShU1v9Cc9KGMJM4Z2o7PegwZfSDsx0vvX/IDYQsPEyP4grzFIGdY+VLWSE963twlw
         smfLtiDf+9Wz1tdS1Opnp+CZZqTEgx8I8+ArNVfI0/dX6eWDAcKpOc41h7DxxM8sPMin
         anhKbsQbq2gjZ2iKei8p+dL1cx/HDwBf5K/vshSPeU+YbOI11Rz3QiD3yQ68Wz2l6FQW
         Assg==
Content-Disposition: inline
In-Reply-To: <1345816904-21745-2-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Fri, Aug 24, 2012 at 04:01:35PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>

How about,

	When CONFIG_NET_CLS_CGROUP is N, task_cls_classid() doesn't
	have any user but the module version still gets defined.  Move
	it inside IS_MODULE(CONFIG_NET_CLS_CGROUP).

Thanks.

-- 
tejun
