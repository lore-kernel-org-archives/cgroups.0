From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Patch v2] cgroup: pretty format /proc/cgroups
Date: Tue, 16 Nov 2021 19:00:17 +0100
Message-ID: <20211116180013.GA8884@blackbody.suse.cz>
References: <20211115011253.20778-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1637085618; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kyoKspNHubmntuojoiakxQgRvVcpyVRSO96mR7W75T8=;
        b=G81YlzInUuiguuUMv+tpmWuHcUzfjsXqHA4ntdGsvok9VtuKuBH8WpeDevTBES3TIbZIEv
        W+7Piog+eR4vlS8lxgUEK4FUCyFPgAy8rKcyVT8W+0xA6dCb7DNxBzqU80kLUDbyTMZVsJ
        5J8w1MDLjqyA3T8c66GQdlfzTekB8YE=
Content-Disposition: inline
In-Reply-To: <20211115011253.20778-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

On Mon, Nov 15, 2021 at 01:12:53AM +0000, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Let's align the title and value. After this patch, it looks like this.

For machines this change may come as a surprise (so better not change
it).

For humans (for instance column from util-linux)

$ column -t /proc/cgroups
#subsys_name  hierarchy  num_cgroups  enabled
cpuset        11         2            1
cpu           4          9            1
cpuacct       4          9            1
...

Michal
