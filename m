From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] misc_cgroup: use a counter to count the number of
 failures
Date: Thu, 9 Sep 2021 17:01:46 +0200
Message-ID: <20210909150146.GA18171@blackbody.suse.cz>
References: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu@tencent.com>
 <20210824164423.GA11859@blackbody.suse.cz>
 <YSVDwc/1sEmXdOK9@slm.duckdns.org>
 <4ed67493-e595-e002-69f9-1f53662ba189@gmail.com>
 <20210826112954.GD4520@blackbody.suse.cz>
 <49057879-92a9-958a-ac30-057ceabd1b7f@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631199707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7YDXHPzZgNhxK+JqlG9HXkSUyEV8IJc2b4TuXsz5yH0=;
        b=kRRhZmQ3mqVSek9+0O4cHQ+rYzMVNOxaruVMvb1v75PP9GurRgzsXJuC+mknsmdvE8YkvW
        Zb3LnQ3XGdB56U8spoEpjD4a2QLYTxaQiq0o27yIjFzfZdz3biJUxxSO3DHXksyCYs62PA
        HwqjlBP1xSO36QTsp9qKWvwqz6leJmo=
Content-Disposition: inline
In-Reply-To: <49057879-92a9-958a-ac30-057ceabd1b7f-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi.

On Wed, Sep 08, 2021 at 01:29:18PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I have sentout misc_cgroup events and events.local related patches.
> I want to make corresponding changes to pids cgroup by the way. Do
> you think it is ok?

The pids controller is longer out there, so some changes should be more
careful (e.g. I wouldn't drop the log message).

Also, you can base it on [1] (there should be just missing the
.local/hierarchical event files separation).

HTH,
Michal

[1] https://lore.kernel.org/lkml/20200205134426.10570-1-mkoutny-IBi9RG/b67k@public.gmane.org/
