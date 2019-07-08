From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: simplify code for cgroup_subtree_control_write()
Date: Mon, 8 Jul 2019 07:41:21 -0700
Message-ID: <20190708144121.GA657710@devbig004.ftw2.facebook.com>
References: <20190708130132.5582-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kXUN90sDFULd4qRU/R3KEOn/usuVWjJoGJ35nR0nQ18=;
        b=Xl9uEj6Og+rO1HLpisU7MOQS4uv+UWSEBNNTBNCnDepQBNXTF8mBQpk9jo/3wdKibZ
         CtZ5kQkMen21+OKQuJ+PCew8yXZuL5r+BgvKpLxdZM9mmLPQ+IYG6A+qUCJCGIEZ8tnH
         reW7Nkw1QthoOFm1CoYBce4mMtko7w8uWB1P05mMGNTOsZXKHk1cluXKkadnDTJGwCBm
         IGzeblqdEzm5X4MFpL3O715NYXJ49/og3rViPEBVtXDCIra2D+aJBBXOv9Wf8sSq/MwJ
         Z+c7nb/En3PazH06XUDEysCWZsK/YpFDRy6/xAUpmjPARQnRlTG5Jc/8fnHOcuzk4zWR
         REOg==
Content-Disposition: inline
In-Reply-To: <20190708130132.5582-1-rocking@whu.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peng Wang <rocking@whu.edu.cn>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jul 08, 2019 at 09:01:32PM +0800, Peng Wang wrote:
> Process "enable" and "disable" earlier to simplify code.

I don't think this is correct and even if it were the value of this
change is close to none, so nack on this one.

Thanks.

-- 
tejun
