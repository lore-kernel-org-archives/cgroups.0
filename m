From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: minor optimization around the usage of
 cur_tasks_head
Date: Wed, 26 Jan 2022 16:54:37 +0100
Message-ID: <20220126155437.GD2516@blackbody.suse.cz>
References: <20220126141705.6497-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643212478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JhMXk/ivkidpxAK5AccyfBh1ZU8l7X1indTMMcc/0QM=;
        b=EK4opr1HdQbMlUngugC9CHY4DDnOmc7BYv0V+FHex/muEUvopf0YP9cdoY7OID6sO8UPQY
        oQK1xmn5BTnjXTulR0Ig6qcO1re1Ui3R2+3xtSRsj9LI8WX98qYrgzs3HjRD4Kl4n7JrOo
        AmjkXticwheVEG3Ek/p0CCdHartfmDw=
Content-Disposition: inline
In-Reply-To: <20220126141705.6497-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello Yafang.

On Wed, Jan 26, 2022 at 02:17:05PM +0000, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> As the usage of cur_tasks_head is within the function
> css_task_iter_advance(), we can make it as a local variable. That could
> make it more clear and easier to understand. Another benefit is we don't
> need to carry it in css_task_iter.

It looks correct. When refactoring in the sake of understandibility
(disputable :), wouldn't it be better to avoid the double-pointer arg
passed into css_task_iter_advance_css_set() and just return the new
cur_tasks_head (the input value doesn't seem relevant)?

Thanks,
Michal
