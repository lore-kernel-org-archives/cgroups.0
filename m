From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 00/10] cgroup: Assign subsystem IDs during compile
 time
Date: Fri, 24 Aug 2012 16:15:28 -0700
Message-ID: <20120824231528.GO21325@google.com>
References: <1345816904-21745-1-git-send-email-wagi@monom.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1S9zmHlqWxjNIE4FQZjMYhWPl3+5TDhQA+A7SaATdYE=;
        b=JdhzkRh41j1uabhotDWobwewyVum8ay9FRvnR6NTPtnoj5OXp9g3XqYMySBwqmOTb/
         nhJBOJiR2N0ZygCSrX/clkD2f+OQMTsJCqwueEGSW2TUEyO++TG5zRRoaObrfIP+gCTw
         uyb5T1KrZ4SREKCrpKK4p8zxTDApxAH2gvVbQxtEIDgsB7jfTSLGuP0NLqylcKvANZUO
         l6A9WqC8w97q9+a6+lRoDgb5acEXV0bJl+6uLEm4cWXW6Bsz0+7xQGBUkqiuAzF6VerS
         0YR/OSjhqgAzU/6LcxmvMHgtKO0e3Pdvxfjy4y7e8Lj/M+BgVvNzIbyNVayiLQ7mOfiX
         WVvQ==
Content-Disposition: inline
In-Reply-To: <1345816904-21745-1-git-send-email-wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Jamal Hadi Salim <jhs-jkUAjuhPggJWk0Htik3J/w@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

Hello, Daniel.

On Fri, Aug 24, 2012 at 04:01:34PM +0200, Daniel Wagner wrote:
> CGROUP_BUILTIN_SUBSYS_COUNT is also gone in this version.  This time I
> trade space for speed. Some extra cycles are spend to identify the
> modules in the for loops, e.g.

There's no point in optimizing either space or speed here.  It's not a
hot path by any stretch of imagination.  Please focus on making it
simple.

Thanks.

-- 
tejun
