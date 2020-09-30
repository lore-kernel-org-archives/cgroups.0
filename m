From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup: Zero sized write should be no-op
Date: Wed, 30 Sep 2020 18:03:57 +0200
Message-ID: <20200930160357.GA25838@blackbody.suse.cz>
References: <20200928131013.3816044-1-jouni.roivas@tuxera.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601481842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nTUDG960FYM7UmGMMfoADRNhufXM+zoM+0CfxkIAuN4=;
        b=jMw29Cny/jePBucqingAkX8GAPZHCpRNT8+h3vG0c5eM5M5YwQ9spOvuZn0PXZVWjAUztu
        ymXJawkp479YHaR/HuXBOkSttyMsWvQd8EDmzKEvDsjwcd8pYyG+VEB+n/o8ybdwogXWs4
        y6s11IvL47u1aDJcZCCJgEwMgmpp794=
Content-Disposition: inline
In-Reply-To: <20200928131013.3816044-1-jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Jouni.

On Mon, Sep 28, 2020 at 04:10:13PM +0300, Jouni Roivas <jouni.roivas-yrGDUoBaLx3QT0dZR+AlfA@public.gmane.org> wrote:
> Do not report failure on zero sized writes, and handle them as no-op.
This is a user visible change (in the case of a single write(2)), OTOH,
`man write` says:
> If count is zero and fd refers to a file other than a regular file,
> the results are not specified.


> @@ -3682,6 +3700,9 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
>  	struct cgroup_subsys_state *css;
>  	int ret;
>  
> +	if (!nbytes)
> +		return 0;
> +
>  	/*
>  	 * If namespaces are delegation boundaries, disallow writes to
>  	 * files in an non-init namespace root from inside the namespace
Shouldn't just this guard be sufficient? 

Michal
