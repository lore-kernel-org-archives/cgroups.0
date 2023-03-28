From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5/7] btrfs, block: move REQ_CGROUP_PUNT to btrfs
Date: Mon, 27 Mar 2023 19:15:11 -0600
Message-ID: <f1b3f0c2-f08a-a432-f0c5-6223a59e671a@kernel.dk>
References: <20230327004954.728797-1-hch@lst.de>
 <20230327004954.728797-6-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679966113; x=1682558113;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zwq4wydL9I093v9hDO3zVwxnC9J0ZcC370MjIqWsDT8=;
        b=4aXydidiJ0gc7rsxJ/Twmo6oHXpvj6XODqgY7UDHkJeLJRsq6y40W37/ZcDksGwZAc
         A7BXYYZww/WmIS5JeLSNicb1HYtNX5E4BjRm8ACtByEhkjCJ9ARbgOcD4/af01hfRL/X
         73P7ZjcuNrHhhdcOJJlOKzxG+9YhoRF2UdL3R+Ol6CJprWIaOhDgSwvj9P9ViC2LIXzB
         vGuC6V//sYYzegzWxHCY0qpLo/W2jl78LaiE3g6VvgIwFElz9WM4eBphtyqshPwZjzT2
         RrI3SIIpLjqG0o0f3Ur2haKngtLQRPgHhAN8u1QzsxyTmcSsuagZ/WXUKES9HL2OZZg9
         YvEg==
Content-Language: en-US
In-Reply-To: <20230327004954.728797-6-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org

On 3/26/23 6:49?PM, Christoph Hellwig wrote:
> REQ_CGROUP_PUNT is a bit annoying as it is hard to follow and adds
> a branch to the bio submission hot path.  To fix this, export
> blkcg_punt_bio_submit and let btrfs call it directly.  Add a new
> REQ_FS_PRIVATE flag for btrfs to indicate to it's own low-level
> bio submission code that a punt to the cgroup submission helper
> is required.

Looks good, and nice to remove more cruft from the generic
submission path:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

