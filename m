From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/12] kernfs: add function to find kernfs_node without
 increasing ref counter
Date: Mon, 12 Nov 2018 04:28:40 -0800
Message-ID: <20181112122840.GA1429@kroah.com>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
 <20181112095632.69114-2-paolo.valente@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1542025720;
        bh=kucl4q/8e40D4A8W9UZj4JJzE5Vks07LAHce70ttib4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XLBt3LBKUEQgXJ+NeiIwjfArL3fwyD/JmQwATw6Wle9KHp5KLJHS8y+LID0KzvJY2
         ZPSxJfJx7NcdIilkSznbKakrgDLf26ZXZHPHsaG8jKWDCTunuO3hU6ZoxUgKZIXE7J
         oHhG7PheQFHHqHPS9CftGwCZBaBVePndi1vsGUyM=
Content-Disposition: inline
In-Reply-To: <20181112095632.69114-2-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>

On Mon, Nov 12, 2018 at 10:56:21AM +0100, Paolo Valente wrote:
> From: Angelo Ruocco <angeloruocco90@gmail.com>
> 
> The kernfs pseudo file system doesn't export any function to only find
> a node by name, without also getting a reference on it.
> But in some cases it is useful to just locate a kernfs node, while
> using it or not depends on some other condition.
> 
> This commit adds a function to just look for a node, without getting
> a reference on it.

Eeek, that sounds really bad.  So you save off a pointer to something,
and have no idea if that pointer now really is valid or not?  It can
instantly disappear right afterwards.

This feels wrong, what is the problem of having a properly reference
counted object passed back to you that you have to create a dangerous
function like this?

greg k-h
