From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 07/10] cgroup: net_cls: Simplify ifdef logic
Date: Fri, 24 Aug 2012 16:39:34 -0700
Message-ID: <20120824233934.GU21325@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
 <1345816904-21745-8-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wz4jS/tWCogsDxOAzUybijg1Hyigxak1UwNEvudEdzM=;
        b=O8w8/zyRM9nh3bJzpzFHNXevR/h+ROdjbs/WNvuM/78ZRZz6Z4aoF1choF90Y1a92e
         bYdy9hiYuKMbj7OI21DxLs4LJA1aQuJQWlSl0R4hcOMMqAd8bApttmS1Uw1iwWM5KLcb
         ncxz7avYShI9KOdPOILgWzf9h6WRmZ3ln/R4Ce8Xbb0rs3SN172GwOHLPyWvHfN1f3+r
         +xAPvb41U8DibVL/yYUn6qkW22yVK7mMA+LZAqZZzkmP299z5OKXBBCtGMcROIeLGNS9
         WNimJUZclc7xITc+Am3NZ9+iNi4/xGX0iiTpkn4YgJLm0l+HQPaRt9rLn9/PDta242gd
         Fu9A==
Content-Disposition: inline
In-Reply-To: <1345816904-21745-8-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

On Fri, Aug 24, 2012 at 04:01:41PM +0200, Daniel Wagner wrote:
> From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>

I suppose this is equivalent conversion?  Maybe it would be nice to
note that in patch description?

Thanks.

-- 
tejun
