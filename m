From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] [v2] blkcg: add plugging support for punt bio
Date: Thu, 10 Sep 2020 09:56:57 -0600
Message-ID: <2bf5a5c3-1f1f-6ed1-8871-6e9d3e7b80d4@kernel.dk>
References: <20200910061506.45704-1-tian.xianting@h3c.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lw00I39tMMHoHHOPSgKttYErvt005RuGUQAb9q20a8A=;
        b=bITux9EFWpfNdlM5j2+5LAzN74905Ih29yvwShF2RYD0rdrq4WVzARSbVJuvSmQPWY
         j+to5gM/LtwviynJuV6Xw/wsJke0MBYGFTvqAsfHMn62ENDQNHKZLFd0IqeGy/YXQAkv
         VzQea9i8kja5dzDE6N1RmEiA7mq7G6VZefYJanQOq9PYYyXW+7SVTKtT7DLY3JQQ6Yaf
         +LznXIrys7f2IeFYvBnmS1Ki0TO452S54+EFTgcsHoySCF2Om2MslpGe1shaUybTvJ4Z
         NYXD4pbGxmghN4rFbQnUMh+SSZHjhXFnidMaDDjLyfrIe/7fFBBzJAix6vpXnIjh1sFh
         cB7Q==
In-Reply-To: <20200910061506.45704-1-tian.xianting@h3c.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Xianting Tian <tian.xianting@h3c.com>, tj@kernel.org
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

Applied, thanks.

-- 
Jens Axboe

