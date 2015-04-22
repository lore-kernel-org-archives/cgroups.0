From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 1/4] cgroups: use bitmask to filter for_each_subsys
Date: Wed, 22 Apr 2015 11:30:02 -0400
Message-ID: <20150422153002.GB10738@htj.duckdns.org>
References: <1429446154-10660-1-git-send-email-cyphar@cyphar.com>
 <1429446154-10660-2-git-send-email-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=atfxtqWFQ39tYjQ4kdqXTYLjEgIPGNA8Ygp8wyrStsQ=;
        b=0uoRWjl4VRxjRtHndVw2sA4cWbHeW1I37do5TcwnUiZLmcq1+DUSnYo/+74PwQWqlC
         F3Nkj+TB4xluqlvZTZbAwH9fJ/VmBOvnDtioB5b5DhCGyyPl7XJx6zuIJu6HbqSYgRuY
         cXE1h1x7sn7MHiyavaPk8pCnOu+w9rq53ptBYvjGPb+AHexAQ0oPmeTYpfPdidDqudyv
         zZDgXLcTtQM1QVKZcV3GZbd2awOl37qQuaD3YQKI/MT/i4fegTvjcAW9R6O10HYMms1I
         UWSsSwgkCumwyqE6Twu5NSqmyohnKWWEbQwKfW9AG6yDCTWOVwotlv4JJIfI6DFbSFEQ
         Foow==
Content-Disposition: inline
In-Reply-To: <1429446154-10660-2-git-send-email-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, fweisbec@gmail.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Ooh, just one more thing.

On Sun, Apr 19, 2015 at 10:22:31PM +1000, Aleksa Sarai wrote:
> +/**
> + * for_each_subsys_which - filter for_each_subsys with a bitmask
> + * @ss_mask: the bitmask
> + * @ss: the iteration cursor
> + * @ssid: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
> + *
> + * The block will only run for cases where the ssid-th bit (1 << ssid) of
> + * mask is set to 1.
> + */
> +#define for_each_subsys_which(ss_mask, ss, ssid) \
> +	for_each_subsys((ss), (ssid)) \
> +		if ((ss_mask) & (1 << (ssid)))
> +

This isn't completely consistent but we tend to put the cursors in
front of what's being iterated.  e.g.

	for_each_css(css, ssid, cgrp)
	for_each_set_bit(bit, addr, size)

Following the pattern, for_each_subsys_which() prolly should do

	for_each_subsys_which(ss, ssid, ss_mask)

rather than the other way around.

Thanks.

-- 
tejun
