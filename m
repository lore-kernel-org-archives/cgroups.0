From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v8 4/4] blk-throttle: fix io hung due to configuration
 updates
Date: Tue, 23 Aug 2022 11:41:43 +0200
Message-ID: <20220823094143.GA1729@blackbody.suse.cz>
References: <20220823033130.874230-1-yukuai1@huaweicloud.com>
 <20220823033130.874230-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661247704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yRu5XT+5vnVozy2B9jrgC9j7gnP78QLLHJ2olzlomGw=;
        b=NIFqyjZzrKwd1GfRkh8IWWX10l8YJnEFlnc7qU058Mtuw8PxMdfm/fmgYmPjvcNkYF5WiQ
        /MJuoK1BuB3qpyiSQPcv4eLdWCy2MwvER9mc5Uy5RsveC1YlPxfJtaP7atIzPIxMJpFgWY
        fOAwSXCJ5pTkKtr++8a6uZW6KGmogxI=
Content-Disposition: inline
In-Reply-To: <20220823033130.874230-5-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello.

On Tue, Aug 23, 2022 at 11:31:30AM +0800, Yu Kuai <yukuai1-XF6JlduFytWkHkcT=
6e4Xnw@public.gmane.org> wrote:
> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  block/blk-throttle.c | 58 +++++++++++++++++++++++++++++++++++++++-----
>  block/blk-throttle.h |  9 +++++++
>  2 files changed, 61 insertions(+), 6 deletions(-)

I see v8 is just naming+comments [1] change, calculations remain, so it
can have

Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

[1] I assume dropping of the overflow/signedness is intentional after
previous debate.

