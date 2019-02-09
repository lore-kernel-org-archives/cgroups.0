From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [RFC PATCH] blkcg: prevent priority inversion problem during
 sync()
Date: Sat, 9 Feb 2019 14:52:31 +0100
Message-ID: <20190209135231.GA1910@xps-13>
References: <20190209120633.GA2506@xps-13>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a1FxRbJ08wKgp4Co0znQWeKyAEWRpt3r5CDQgl/lzA4=;
        b=ho854t0VeE6vkAj0xsMCBVg+GmgJHVfw5OjfuHOJNNggl2sV7EERA8YSfPVlbMvOI/
         8VfPfvbCOdKdg1UTWHM/i0jDat3tgSYv0ewqUWVbUABw4sOc26cXz78V1kDZdl0FeXcU
         fUUbDB73SdMwb9ZQit//tkf/yJmMy+BsmPYc5egWKEuM9+cJW5rYCz/vmSeWAyyx8Fsk
         hc27LyFIpXFFNT7f/0lYIbAdpujM488pot5HUf31+3kyX5gkm3JvloV91OtiSEWmXl4a
         S+ls75NLMEcJxwYPKh92JNiCRLHdMp4QjFpU7eGPGle1WxcJM7BvMOUeEOWjSkya9ZGO
         1TGw==
Content-Disposition: inline
In-Reply-To: <20190209120633.GA2506@xps-13>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>
Cc: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Dennis Zhou <dennis@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sat, Feb 09, 2019 at 01:06:33PM +0100, Andrea Righi wrote:
...
> +/**
> + * blkcg_wb_waiters_on_bdi - check for writeback waiters on a block device
> + * @bdi: block device to check
> + *
> + * Return true if any other blkcg is waiting for writeback on the target block
> + * device, false otherwise.
> + */
> +bool blkcg_wb_waiters_on_bdi(struct backing_dev_info *bdi)
> +{
> +	struct blkcg *blkcg, *curr_blkcg;
> +	bool ret = false;
> +
> +	if (unlikely(!bdi))
> +		return false;
> +
> +	rcu_read_lock();
> +	curr_blkcg = css_to_blkcg(task_css(current, io_cgrp_id));

Sorry, the logic is messed up here. We shouldn't get curr_blkcg from the
current task, because during writeback throttling the context is
obviously not the current task.

I'll post a new patch soon.

> +	list_for_each_entry_rcu(blkcg, &bdi->cgwb_waiters, cgwb_wait_node)
> +		if (blkcg != curr_blkcg) {
> +			ret = true;
> +			break;
> +		}
> +	rcu_read_unlock();
> +
> +	return ret;
> +}

-Andrea
