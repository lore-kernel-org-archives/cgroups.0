From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: return 1 from cgroup.memory __setup()
 handler
Date: Wed, 2 Mar 2022 19:53:00 +0100
Message-ID: <20220302185300.GA19699@blackbody.suse.cz>
References: <20220222005811.10672-1-rdunlap@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646247182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ETq8HlggMKKBEmSfyL4EONAS/CABlZuOFa+QsLe+Wf0=;
        b=c7wRWHji8ylj9sHDg9NDHuzDIlBJ16wywrGqA7MV3iPFIDOmbyfk2fp5AfxGW2aRW4qEQO
        Xl1GPMbT8oIlcw28I2y0Sjf2Vr1YKp8p2ytZDrEbez1r9eZUQArwjQkLuriRYD5lZIswfa
        F52D6RLBu3hZ1GVDeyanclxKTsFDny4=
Content-Disposition: inline
In-Reply-To: <20220222005811.10672-1-rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Igor Zhbanov <i.zhbanov-4G3FwjhnV40EXkLx5dDeUA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Feb 21, 2022 at 04:58:11PM -0800, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> __setup() handlers should return 1 if the command line option is handled
> and 0 if not (or maybe never return 0; it just pollutes init's environment).

Interesting.

> Instead of relying on this '.' quirk, just return 1 to indicate that
> the boot option has been handled.

But your patch would return 1 even when no accepted value was passed,
i.e. is the command line option considered handled in that case?

Did you want to return 1 only when the cgroup.memory= value is
recognized?

Thanks,
Michal
