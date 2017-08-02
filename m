From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 2/4] cgroup: implement hierarchy limits
Date: Wed, 2 Aug 2017 11:44:17 -0700
Message-ID: <20170802184416.GK2311718@devbig577.frc2.facebook.com>
References: <20170802165532.22277-1-guro@fb.com>
 <20170802165532.22277-3-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DML40S6RJZiE7HNyMdyIx3VwJpbPjvXnGBIABMLUTAc=;
        b=Hja+dNtbolizb7idLUe6V4aBlI9ZHiCyXc6lhqZih1LVdEF4lfTzJsmQ3V5JI45MHo
         v2VOa9WxPYFuRrc+S6YAf7OrZSkNrqkNQzmelh9iqf59uMmzjnDkhEZaAho1HWL45S9c
         bnb6MZ3ibYhf22GRANMYaYNiVO367Hy8kDoyPAAvFWYeCyY1v8osX17o3CxX6X9hZPzo
         axjTFC4KM0HnhSW+fD51jF8NUFSi3D7mRWoNvFMe286uaBRt8Yrr9gaywDTqied5KZCl
         XbjZtAMxkiiXTuKIqEhrIkACYfgHkcjVSB2gs4lMvnazM728ymbs1CZctKr0s4UDZOCy
         Hj3Q==
Content-Disposition: inline
In-Reply-To: <20170802165532.22277-3-guro-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Roman.

Generally looks good to me.  One minor nit.

On Wed, Aug 02, 2017 at 05:55:30PM +0100, Roman Gushchin wrote:
> +static ssize_t cgroup_max_descendants_write(struct kernfs_open_file *of,
> +					   char *buf, size_t nbytes, loff_t off)
> +{
> +	struct cgroup *cgrp;
> +	int descendants;
> +	ssize_t ret;
> +
> +	buf = strstrip(buf);
> +	if (!strcmp(buf, "max")) {
> +		descendants = INT_MAX;
> +	} else {
> +		ret = kstrtouint(buf, 0, &descendants);
                     ^^^^^^^^^^^
		     shouldn't this be kstrtoint?

Thanks.

-- 
tejun
